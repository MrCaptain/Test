%%%------------------------------------
%%% @Module     : mod_misc
%%% @Author     : lzz
%%% @Created    : 2011.08.22
%%% @Description: 杂项处理进程
%%%------------------------------------
-module(mod_misc).
-behaviour(gen_server).
-include("common.hrl").
-include("record.hrl").
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-compile(export_all).
-include_lib("stdlib/include/ms_transform.hrl").
%% 定时器1间隔时间(每半小时修改一次强化概率)
-define(TIMER_1, 30*60*1000).
%% 定时器2间隔时间(每24小时)
-define(TIMER_2, 24*3600*1000).

%% 杂项处理进程信息表	
-record(state, {
				   strenRate = 0,  % 当前强化概率
				   strenTime = 0,  % 强化概率最近变更时间
				   strenTrend = 0  % 强化变化趋势 0为向下 1为向上
				  }).

%%%------------------------------------
%%%             接口函数
%%%------------------------------------

start_link() ->      %% 启动服务
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%%动态加载杂项处理进程
get_mod_misc_pid() ->
	ProcessName = mod_misc_process,
	case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true -> 
						Pid;
					false -> 
						start_mod_misc(ProcessName)
				end;
			_ ->
				start_mod_misc(ProcessName)
	end.

%%启动杂项处理模块 (加锁保证全局唯一)
start_mod_misc(ProcessName) ->
	global:set_lock({ProcessName, undefined}),
	ProcessPid =
		case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true -> 
						Pid;
					false -> 
						start_misc()
				end;
			_ ->
				start_misc()
		end,	
	global:del_lock({ProcessName, undefined}),
	ProcessPid.

%%启动杂项处理模块
start_misc() ->
	case supervisor:start_child(
       		game_server_sup, {mod_misc,
            		{mod_misc, start_link,[]},
               		permanent, 10000, supervisor, [mod_misc]}) of
		{ok, Pid} ->
				timer:sleep(1000),
				Pid;
		_ ->
				undefined
	end.

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init([]) ->
    process_flag(trap_exit, true),
	ProcessName = mod_misc_process,		%% 多节点的情况下， 仅启用一个杂项处理进程
 	case misc:register(unique, ProcessName, self()) of
		yes ->
			misc:write_monitor_pid(self(),?MODULE, {}),
			misc:write_system_info(self(), mod_misc, {}),
			
%% 			load_misc_data(),
					
			%%强化概率变化
			Rate = util:rand(50, 100),
			Time = util:unixtime(),
			Trend =
				case Rate of
					50 ->
						1;
					100 ->
						0;
					_ ->
						util:rand(0, 1)
				end,
			State = #state{
						   strenRate = Rate,  % 当前强化概率
						   strenTime = Time,  % 强化概率最近变更时间
						   strenTrend = Trend  % 强化变化趋势 0为向下 1为向上
						  },
	
			erlang:send_after(?TIMER_1, self(), changeRate),
			
			Now = util:unixtime(),
			{Todaymidnight,_} = util:get_midnight_seconds(Now),								%得到今天零时时间
			CostSec = Now - Todaymidnight,													%%今天已过时间
			erlang:send_after(?TIMER_2 - CostSec*1000 - 60*1000, self(), page_leave_sta),  %设置一个统计页面流失率的定时器,23:59分开始
%% 			erlang:send_after(6* 1000, self(), page_leave_sta),								%测试代码
	
			ResTime_t = (Todaymidnight + 24*3600 + 1800 - Now)*1000,
			erlang:send_after(ResTime_t, self(), count_level_leave),
			%% 统计登记流失率
			
%% 			io:format("check_________________[~p] ~n", [?TIMER_2 - CostSec*1000]),
			erlang:send_after(?TIMER_2 - CostSec*1000, self(), is_midnight),
			%% 半夜十二点通知客户端
			
			io:format("10.init misc finish!!!\n"),
	 		{ok, State};
		_ ->
			{stop,normal,#state{}}
	end.

%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
%% 统一模块+过程调用(call)
handle_call({apply_call, Module, Method, Args}, _From, State) ->
%%  	%% ?DEBUG("mod_misc__apply_call: [~p/~p]", [Module, Method]),	
	Reply  = 
	case (catch apply(Module, Method, Args)) of
		 {'EXIT', Info} ->	
			 ?WARNING_MSG("mod_misc__apply_call error: Module=~p, Method=~p, Reason=~p",[Module, Method, Info]),
			 error;
		 DataRet -> DataRet
	end,
    {reply, Reply, State};

%%获取现有强化信息
handle_call(get_stren_info, _From, State) ->
	Reply = {State#state.strenRate, State#state.strenTime, State#state.strenTrend},
    {reply, Reply, State};


%%重置现有强化信息（GM命令）
handle_call(gm_change_stren_info, _From, State) ->
	MaxRate =
		if
			State#state.strenRate + 20 > 100 ->
				100;
			true ->
				State#state.strenRate + 20
		end,
	MinRate =
		if
			State#state.strenRate - 20 < 50 ->
				50;
			true ->
				State#state.strenRate - 20
		end,	
	Rate =
		case State#state.strenTrend of
			0 ->
				util:rand(MinRate, State#state.strenRate - 1);
			1 ->
				util:rand(State#state.strenRate + 1, MaxRate)
		end,
%% 	Time = util:unixtime(),
	Trend =
		case Rate of
			50 ->
				1;
			100 ->
				0;
			_ ->
				TmpRank = util:rand(1, 10),
				if
					TmpRank =< 7 andalso State#state.strenTrend =:= 1 ->
						1;
					TmpRank =< 3 andalso State#state.strenTrend =:= 0 ->
						1;
					true ->
						0
				end
		end,
	NewState = #state{
				    strenRate = Rate,  % 当前强化概率
%% 					strenTime = Time,  % 强化概率最近变更时间
					strenTrend = Trend  % 强化变化趋势 0为向下 1为向上
				  },
%% 	io:format("EquipSuit Change:~p~n",[NewState]),
	Reply = {NewState#state.strenRate, NewState#state.strenTime, NewState#state.strenTrend},
    {reply, Reply, NewState};


handle_call(_Request, _From, State) ->
    {reply, State, State}.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
%% 统一模块+过程调用(cast)
handle_cast({apply_cast, Module, Method, Args}, State) ->
%% 	%% ?DEBUG("mod_misc__apply_cast: [~p/~p/~p]", [Module, Method, Args]),	
	case (catch apply(Module, Method, Args)) of
		 {'EXIT', Info} ->	
			 ?WARNING_MSG("mod_misc__apply_cast error: Module=~p, Method=~p, Args =~p, Reason=~p",[Module, Method, Args, Info]),
			 error;
		 _ -> ok
	end,
    {noreply, State};


handle_cast(_Msg, State) ->
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------

handle_info(changeRate, State) ->
	MaxRate =
		if
			State#state.strenRate + 20 > 100 ->
				100;
			true ->
				State#state.strenRate + 20
		end,
	MinRate =
		if
			State#state.strenRate - 20 < 50 ->
				50;
			true ->
				State#state.strenRate - 20
		end,	
	Rate =
		case State#state.strenTrend of
			0 ->
				util:rand(MinRate, State#state.strenRate - 1);
			1 ->
				util:rand(State#state.strenRate + 1, MaxRate)
		end,
	Time = util:unixtime(),
	Trend =
		case Rate of
			50 ->
				1;
			100 ->
				0;
			_ ->
				TmpRank = util:rand(1, 10),
				if
					TmpRank =< 7 andalso State#state.strenTrend =:= 1 ->
						1;
					TmpRank =< 3 andalso State#state.strenTrend =:= 0 ->
						1;
					true ->
						0
				end
		end,
	NewState = #state{
				    strenRate = Rate,  % 当前强化概率
					strenTime = Time,  % 强化概率最近变更时间
					strenTrend = Trend  % 强化变化趋势 0为向下 1为向上
				  },
	erlang:send_after(?TIMER_1, self(), changeRate),
	%%io:format("EquipSuit:~p~n",[NewState]),
  	{noreply, NewState};

handle_info(count_level_leave, State) ->
	count_level_leave(),
	erlang:send_after(24*3600*1000, self(), count_level_leave),
%% 	io:format("Save level leave."),
  	{noreply, State};

%% 半夜十二点处理
handle_info(is_midnight, State) ->
%% 	io:format("Midnight informed............."),
%% 通知客户端
	{ok, BinData} = pt_11:write(11111, is_midnight),
	lib_send:send_to_all(BinData),
%% 半夜12点统计当天活动参与度
	NowTime = util:unixtime(),
	mod_theater_agent:theater_attention_record(NowTime, NowTime - 3600),
%% 	mod_arena_agent:arena_attention_record(NowTime, NowTime - 3600),
	erlang:send_after(24*3600*1000, self(), is_midnight),
	
%% 	save_hunt_data(),
	
	io:format("Midnight. ~n"),
  	{noreply, State};

handle_info(page_leave_sta, State) ->
	_Res = try 
				{{Y,M,D},{_,_,_}} = calendar:local_time(),
				if
					M > 9 ->
						Date1 = integer_to_list(Y)++integer_to_list(M);
					true ->
						Date1 = integer_to_list(Y)++"0"++integer_to_list(M)
				end,
				if
					D > 9 ->
						Date2 = Date1 ++ integer_to_list(D);
					true ->
						Date2 = Date1 ++ "0" ++ integer_to_list(D)
				end,
				
				Date = list_to_integer(Date2),
				[UserNum1] = db_agent:get_Row_count(user),  			%打开游戏页面人数
				[CreateNum1] = db_agent:get_Row_count(stc_create_page),	%打开到注册页面人数
				[RegNum] = db_agent:get_Row_count(player),				%注册角色人数
				
				if
  					CreateNum1 < RegNum ->								%若打开注册页面人数小于注册角色人数，用后者代替打开注册页面人数
						CreateNum = RegNum;
					true ->
						CreateNum = CreateNum1
				end,
			
				if
 					UserNum1 < CreateNum ->								%若打开游戏页面人数小于打开到注册页面人数，用后者代替打开游戏页面人数
						UserNum = CreateNum;
					true ->
						UserNum = UserNum1
				end,
				LoadLeaveNum  = UserNum - CreateNum,					%加载注册流失人数
				RegLeaveNum   = CreateNum - RegNum,						%创建角色离开人数
				TotalLeaveNum = UserNum - RegNum,						%总离开人数
				Data = [Date, UserNum, CreateNum, LoadLeaveNum, RegNum, RegLeaveNum, TotalLeaveNum],
				db_log_agent:log_page_leave(Data),
				erlang:send_after(?TIMER_2, self(), page_leave_sta)		%统计完毕再次设置定时器24小时
%% 				erlang:send_after(6* 1000, self(), page_leave_sta)		%测试代码
			catch
				_Reason ->
					_Reason
			end,
	
  	{noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.


%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, _State) ->

	misc:delete_monitor_pid(self()),
	misc:delete_system_info(self()),
    ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% %%=========================================================================
%% %% 业务处理函数
%% %%=========================================================================

%%获取强化信息
get_stren_info()->
	gen_server:call(mod_misc:get_mod_misc_pid(), get_stren_info).

%%重置现有强化信息（GM命令）
gm_change_stren_info()->
	gen_server:call(mod_misc:get_mod_misc_pid(), gm_change_stren_info).

get_hunt_log() ->
	gen_server:call(mod_misc:get_mod_misc_pid(), get_hunt_log).

update_hunt_log(HuntLog) ->
	gen_server:cast(mod_misc:get_mod_misc_pid(), {update_hunt_log, HuntLog}).

%%php统计处理
count_level_leave() ->
	{{Y,M,D},{_,_,_}} = calendar:local_time(),
	LM = length(integer_to_list(M)),
	if LM < 2 ->
		   ML = integer_to_list(0) ++ integer_to_list(M);
	   true ->
		   ML = integer_to_list(M)
	end,
	LD = length(integer_to_list(D)),
	if  LD < 2 ->
		   DL = integer_to_list(0) ++ integer_to_list(D);
	   true ->
		   DL = integer_to_list(D)
	end,
%% 	io:format("~p",[ML]),
%% 	io:format("~p",[DL]),
	Dt = list_to_integer(integer_to_list(Y)++ML++DL),
	LvList = lists:seq(1,70),
	Now = util:unixtime(),
	F = fun(Lv) ->
		timer:sleep(1*20),
		[All] = ?DB_MODULE:select_count(?SLAVE_POOLID,player,[{lv,Lv}]),
		TimeLimit = Now - 72*3600,
		[Res] = ?DB_MODULE:select_count(?SLAVE_POOLID,player,[{lstm,">=",TimeLimit},{lv,Lv}]),
		?DB_LOG_MODULE:insert(log_count_level_leave,[date,lv,all,res],[Dt,Lv,All,Res])
	end,
	lists:foreach(F, LvList).


%% load_misc_data() ->
%% 	D = ?DB_MODULE:select_row(misc_data, "*", [{type, 1}]),
%% 	case D of
%% 		[] ->
%%             Gl = util:term_to_string([]),
%% 			?DB_MODULE:insert(misc_data,[type,data], [1,Gl]),
%% 			put(misc_hunt_log, []);
%% 		_ ->
%% 			MiscData = list_to_tuple([misc_data | D]),
%% 			Data = util:string_to_term(tool:to_list(MiscData#misc_data.data)),
%% 			put(misc_hunt_log, Data)                
%% 	end.






















