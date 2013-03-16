%%%------------------------------------
%%% @Module  : mod_scene
%%% @Author  : csj
%%% @Created : 2010.08.24
%%% @Description: 场景管理
%%%------------------------------------
-module(mod_scene). 
-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl"). 
-include("record.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

%% --------------------------------------------------------------------
%% External exports
%% --------------------------------------------------------------------
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-compile([export_all]).

-record(state, {scnid = 0, worker_id = 0}).
-include("debug.hrl").

-define(CLEAR_ONLINE_TIME, 10*60*1000).	  %% 每10分钟 对 ets_online 做一次清理
-define(REVIVE_MONSTER, 5*1000).	  %% 每5秒钟执行一次怪物复活，不必对每个怪物设置一个定时器

%% ====================================================================
%% External functions
%% ====================================================================
start({SceneId, SceneProcessName, Worker_id}) ->
    gen_server:start({local,SceneProcessName}, ?MODULE,{SceneId, SceneProcessName, Worker_id}, []).

start_link(SceneId,SceneProcessName) ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, {SceneId, SceneProcessName, 0}, []) .

start_link({SceneId, SceneProcessName, Worker_id}) ->
    gen_server:start_link({local,SceneProcessName}, ?MODULE, {SceneId, SceneProcessName, Worker_id}, []).

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% 这里子进程是否有必要存在
%% --------------------------------------------------------------------
init({SceneId, SceneProcessName, Worker_id}) ->
	process_flag(trap_exit, true),
	Ret = misc:register(unique, SceneProcessName, self()), 
	if
		Ret == yes ->
			if 
				Worker_id =:= 0 ->
					net_kernel:monitor_nodes(true),
					misc:write_monitor_pid(self(),mod_scene, {SceneId, ?SCENE_WORKER_NUMBER}),
					
					%%分场景的在线用户列表
					EtsName = lib_scene:get_ets_name(SceneId) ,
					ets:new(EtsName, [{keypos,#player.id}, named_table, public, set,{read_concurrency,true}]) ,
			
					lib_scene:load_scene(SceneId),
					lib_mon:load_monster(SceneId),
					lib_mon:save_monster_drops([]),
					
					%%怪物实例ID起始值
					put(monster_id,100) ,
					put(scene_id,SceneId) ,
					%% 启动多个场景服务进程
					lists:foreach(fun(WorkerId) ->
										  SceneWorkerProcessName = misc:create_process_name(scene_p, [SceneId, WorkerId]),
										  start_link({SceneId, SceneWorkerProcessName, WorkerId})
								  end,lists:seq(1, ?SCENE_WORKER_NUMBER)) ,
					
					NowTime = util:longunixtime() ,
					erlang:send_after(?MON_STATE_LOOP_TIME, self(), {'mon_state_manage',NowTime}) ,
					erlang:send_after(?CLEAR_ONLINE_TIME, self(), {event, clear_online_player}) ,
					if
						SceneId rem 10 > 1 ->
							erlang:send_after((37*60*60 - util:get_today_current_second())*1000, self(), {event, stop_idle_scene}) ;
						true ->
							skip
					end ;  		
				
				true -> 
					misc:write_monitor_pid(self(),mod_scene_worker, {SceneId, Worker_id})
			end,
			State= #state{scnid=SceneId, worker_id = Worker_id},	
			{ok, State};
		true ->
			?WARNING_MSG("mod_scene duplicate scenes error: SceneId=~p, WorkerId =~p, Args =~p~n",[SceneId, SceneProcessName, Worker_id]),
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
%% 	?DEBUG("mod_scene_apply_call: [~p/~p/~p]", [Module, Method, Args]),	
	Reply  = 
	case (catch apply(Module, Method, Args)) of
		 {'EXIT', Info} ->	
%% 			 io:format("mod_scene_apply_call error: Module=~p, Method=~p, Reason=~p",[Module, Method,Info]),
			 error;
		 DataRet -> DataRet
	end,
    {reply, Reply, State};

handle_call(_Request, _From, State) ->
    {reply, State, State}.


%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------

%% AerId 攻击方
%% DerId 被击方
%% SkillId 技能ID
%% DerType: 1表示怪, 2表示人
handle_cast({start_player_attack,[AerId, DerId, DerType, SkillId]}, State) ->
	lib_battle:start_player_attack(AerId, DerId, DerType, SkillId),
	{noreply, State};

%% 统一模块+过程调用(cast)
handle_cast({apply_cast, Module, Method, Args}, State) ->
%% 	?DEBUG("mod_scene_apply_cast: [~p/~p/~p]", [Module, Method, Args]),	
	case (catch apply(Module, Method, Args)) of
		 {'EXIT', Info} ->	
%% 			 io:format("mod_scene_apply_cast error: Module=~p, Method=~p, Args =~p, Reason=~p",[Module, Method, Args, Info]),
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
%% 处理节点关闭事件
%% handle_info({nodedown, Node}, State) ->
%% 	try
%% 		if State#state.worker_id =:= 0 ->
%% 				Scene = State#state.scnid,
%% 				lists:foreach(fun(T) ->
%% 					if T#player.other#player_other.node == Node, T#player.scn == Scene  ->
%% 			  				ets:delete(?ETS_ONLINE_SCENE, T#player.id),
%% 				  			{ok, BinData} = pt_12:write(12004, T#player.id),					
%% 							lib_send:send_to_local_scene(Scene, BinData);
%% 					   true -> no_action
%% 					end
%% 				  end, 
%% 				  ets:tab2list(?ETS_ONLINE_SCENE));
%% 	   		true -> no_action
%% 		end
%% 	catch
%% 		_:_ -> error
%% 	end,
%%     {noreply, State};

%%@spec 清除在线玩家
handle_info({event, clear_online_player}, State) ->
	MS = ets:fun2ms(fun(T) when T#player.scene =:= State#state.scnid -> 
							[
							 T#player.id ,
							 T#player.scene ,
							 T#player.other#player_other.pid
							]
					end),
	OnlineList = ets:select(?ETS_ONLINE, MS) ,
	lists:foreach(fun([UId, ScnId, Pid]) ->
						  case misc:is_process_alive(Pid) of
							  false ->
								  db_agent:update_online_flag(UId,0),
								  EtsName = lib_scene:get_ets_name(ScnId) ,
								  ets:delete(EtsName, UId) ,
								  ets:delete(?ETS_ONLINE_SCENE, UId),
								  ets:delete(?ETS_ONLINE, UId);
							  _-> is_alive
						  end
				  end, OnlineList),		  
	erlang:send_after(?CLEAR_ONLINE_TIME, self(), {event, clear_online_player}),
	{noreply, State};

%%@spec 清除空闲场景进程
handle_info({event, stop_idle_scene}, State) ->
	case lib_scene:get_scene_players(State#state.scnid) of
		Players when length(Players) =:= 0 ->
			exit(self(),kill) ;
		_ ->
			erlang:send_after(24*60*60*1000, self(), {event, stop_idle_scene})
	end ,
	{noreply, State};



%%@spec 修改怪物状态
handle_info({'mon_state_manage',NowTime}, State) ->
	%%先清除定时器
	misc:cancel_timer(?MON_STATE_TIMER_KEY) ,
	Flag = lib_mon:refresh_monsters(State#state.scnid,NowTime) ,
	case Flag of
		goon ->
			NextTime = NowTime + ?MON_STATE_LOOP_TIME ,
			put(fresh_time,NextTime) ,
			NextTimer = erlang:send_after(?MON_STATE_LOOP_TIME, self(), {'mon_state_manage',NextTime}) ,
			put(?MON_STATE_TIMER_KEY,NextTimer) ;
		_ ->
			skip
	end ,
	{noreply, State};


handle_info(_Info, State) ->
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, _State) ->
	io:format("~s terminate begined************  [~p]\n",[misc:time_format(now()), mod_scene]),
	misc:delete_monitor_pid(self()),
	io:format("~s terminate finished************  [~p]\n",[misc:time_format(now()), mod_scene]),
    ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% =========================================================================
%%% 业务逻辑处理函数
%% =========================================================================
%%@spec 获取场景主进程PID
get_scene_pid(SceneId) ->
	SceneProcessName = misc:create_process_name(scene_p,[SceneId, 0]),
	{ScenePid, _Worker_Pid} =
		case misc:whereis_name({global, SceneProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true ->
						{Pid, Pid} ;
					false -> 
						global:unregister_name(SceneProcessName),
						exit(Pid,kill),
						start_mod_scene(SceneId, SceneProcessName)
				end;					
			_ ->
				start_mod_scene(SceneId, SceneProcessName)
		end,
	ScenePid .

%%@spec 获取场景工作进程PID
get_worker_pid(SceneId, OldScenePid, PlayerPid) ->
	SceneProcessName = misc:create_process_name(scene_p,[SceneId, 0]),
	{ScenePid, Worker_Pid} =
		case misc:whereis_name({global, SceneProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true ->
						case lib_scene:is_copy_scene(SceneId) of
							true ->
								{Pid, Pid};
							false ->
								WorkerId = random:uniform(?SCENE_WORKER_NUMBER),
								WorkProcessName = misc:create_process_name(scene_p, [SceneId, WorkerId]),
								case misc:whereis_name({global, WorkProcessName}) of
									WPid when is_pid(WPid) ->
										{Pid,WPid} ;
									_ ->
										global:unregister_name(SceneProcessName),
										exit(Pid,kill),
										start_mod_scene(SceneId, SceneProcessName)
								end 
						end;
					false -> 
						global:unregister_name(SceneProcessName),
						exit(Pid,kill),
						start_mod_scene(SceneId, SceneProcessName)
				end;					
			_ ->
				start_mod_scene(SceneId, SceneProcessName)
		end,
	if 
		ScenePid =/= OldScenePid, PlayerPid =/= undefined ->
			gen_server:cast(PlayerPid,{change_pid_scene, ScenePid, SceneId});
		true ->
			no_cast
	end,	
	Worker_Pid.


%%启动场景模块 (加锁保证全局唯一)
start_mod_scene(SceneId, SceneProcessName) ->
	global:set_lock({SceneProcessName, undefined}),
	timer:sleep(1000),
	ScenePid = 
		case misc:whereis_name({global, SceneProcessName}) of		%%延迟后再判断一次是否已经有了场景进程，有则直接用，无才继续启动
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true ->
						case lib_scene:is_copy_scene(SceneId) of
							true ->
								Pid;
							false ->
								WorkerId = random:uniform(?SCENE_WORKER_NUMBER),
								SceneProcess_Name = misc:create_process_name(scene_p, [SceneId, WorkerId]),
								misc:whereis_name({global, SceneProcess_Name})
						end;
					_ ->
						start_scene(SceneId, SceneProcessName, 2)
				end;
			_ ->
				start_scene(SceneId, SceneProcessName, 2)
		end,
	Worker_Pid = ScenePid,
	global:del_lock({SceneProcessName, undefined}),
	{ScenePid, Worker_Pid}.

%%启动场景模块 (不延迟，作为第一次初始化场景之用)
start_mod_scene_nosleep(SceneId, SceneProcessName) ->
 	%%io:format("start_scene:____/~p ~n",[SceneId]),
	global:set_lock({SceneProcessName, undefined}),
	ScenePid = start_scene(SceneId, SceneProcessName,2),
	Worker_Pid = ScenePid,
%% 	io:format("start_scene:____/~p /~p ~n",[SceneId,SceneProcessName]),
	global:del_lock({SceneProcessName, undefined}),
	{ScenePid, Worker_Pid}.

%% 新加启动场景模块，直接放入进程监控树
start_scene(SceneId, SceneProcessName) ->
	case supervisor:start_child(
		   game_server_sup, {mod_scene,
							{mod_scene, start_link,[SceneId, SceneProcessName]},
							permanent, 10000, supervisor, [mod_scene]}) of
		{ok, Pid} ->
			Pid;
		_ ->
			undefined
	end.

%% 启动场景模块
start_scene(SceneId, SceneProcessName, _Source) ->
%%  	io:format("start_scene:____/~p/~p/~p/ ~n",[SceneId, SceneProcessName, _Source]),	
	Pid =
		case start({SceneId, SceneProcessName, 0}) of
			{ok, NewScenePid} ->
				NewScenePid;
			_ ->
				undefined
		end,
	timer:sleep(100),
	case Pid of
		undefined ->
			case misc:whereis_name({global, SceneProcessName}) of
				HasPid when is_pid(HasPid) ->
					case misc:is_process_alive(HasPid) of
						true ->
							case lib_scene:is_copy_scene(SceneId) of
								true ->
									HasPid;
								false ->
									WorkerId = random:uniform(?SCENE_WORKER_NUMBER),
									SceneProcess_Name = misc:create_process_name(scene_p, [SceneId, WorkerId]),
									misc:whereis_name({global, SceneProcess_Name})
							end;
						_ ->
							undefined
					end;
				_ ->
					undefined
			end;
		_ ->
			Pid
	end.

%% %%@spec 增加基础场景的分场景
%% %% BaseScnId  	基础场景ID
%% %% AddNum  		需要增加的分场景数据
%% add_scene(BaseScnId,AddNum) ->
%% 	case lib_scene:add_scene_number(BaseScnId,AddNum) of
%% 		ScnRcd when is_record(ScnRcd, temp_scene) ->
%% 			SubId = ScnRcd#temp_scene.sub_scene_num + 2 ,
%% 			add_single_scene(BaseScnId, SubId, AddNum) ;
%% 		_ ->
%% 			skip
%% 	end .
%% %% 启动单个场景
%% add_single_scene(_Sid, _SubId, 0) ->
%% 	skip;
%% add_single_scene(Sid, SubId, Left) ->
%% 	SceneId = Sid * 100 + SubId,
%% 	SceneProcessName = misc:create_process_name(scene_p,[SceneId, 0]),
%% 	start_mod_scene_nosleep(SceneId, SceneProcessName), 
%% 	add_single_scene(Sid, SubId + 1, Left - 1).
%% 	
%% %%@spec 清楚没有玩家的子场景
%% %% BaseScnId  	基础场景ID
%% clear_scene(BaseScnId) ->
%% 	case lib_scene:get_scene_tmpl(BaseScnId) of
%% 		ScnRcd when is_record(ScnRcd,temp_scene) ->
%% 			MaxNum = ScnRcd#temp_scene.sub_scene_num + 1 ;
%% 		_ ->
%% 			ScnRcd = [] ,
%% 			MaxNum = 1
%% 	end ,
%% 	clear_scene(BaseScnId,MaxNum,0,ScnRcd) .
%% clear_scene(_BaseScnId,1,Num,ScnRcd) ->
%% 	if
%% 		is_record(ScnRcd,temp_scene) ->
%% 			NewScnRcd = ScnRcd#temp_scene{sub_scene_num = ScnRcd#temp_scene.sub_scene_num - Num} ,
%% 			ets:insert(temp_scene, NewScnRcd) ;
%% 		true ->
%% 			skip
%% 	end ;
%% clear_scene(BaseScnId,Left,Num,ScnRcd) ->
%% 	SceneId = BaseScnId * 100 + Left,
%% 	SceneProcessName = misc:create_process_name(scene_p,[SceneId, 0]) ,
%% 	case lib_scene:get_scene_players(SceneId) of
%% 		PlayerList when length(PlayerList) =:= 0 ->
%% 			case misc:whereis_name({global, SceneProcessName}) of
%% 				Pid when is_pid(Pid) ->
%% 					case misc:is_process_alive(Pid) of
%% 						true ->
%% 							exit(Pid,kill) ;
%% 						false ->
%% 							skip
%% 					end;
%% 				_ ->
%% 					skip
%% 			end;
%% 		_ ->
%% 			skip
%% 	end ,
%% 	clear_scene(BaseScnId,Left-1,Num+1,ScnRcd).

	
									  
	
	
%% 根据基本ID批量启动场景模块
start_scene_by_baseId(BaseScbId, NodeId) ->
	SubScnNum = lib_scene:get_sub_scene_number(BaseScbId) ,
	start_scene_one(BaseScbId, NodeId, SubScnNum+1).

%% 启动单个场景
start_scene_one(_Sid, _NodeId, 0) ->
	skip;
start_scene_one(Sid, NodeId, SubId) ->
	SceneId = Sid * 100 + SubId,
	SceneProcessName = misc:create_process_name(scene_p,[SceneId, 0]),
	start_mod_scene_nosleep(SceneId, SceneProcessName), 
	start_scene_one(Sid, NodeId, SubId - 1).



%% 同步场景用户状态
update_player(Status) ->
	try  
		gen_server:cast(get_scene_pid(Status#player.scene), 
				 {apply_cast, lib_scene, save_scene_player, [Status]})	
	catch
		_:_ -> fail
	end.
%% 
%%同步场景用户状态- key-value 形式
update_player_info_fields(Status,ValueList) ->
	try  
		gen_server:cast(get_scene_pid(Status#player.scene), 
				 {apply_cast,lib_scene,update_player_info_fields,[Status#player.id,ValueList]})	
	catch
		_:_ -> fail
	end.


%% 发起战斗
%% AerId 攻击方
%% DerId 被击方
%% SkillId 技能ID
%% DerType: 1表示怪, 2表示人
start_player_attack(ScenePid, AerId, DerId, DerType, SkillId) ->
	gen_server:cast(ScenePid, {start_player_attack,[AerId, DerId, DerType, SkillId]}).




%% @spec 玩家进入场景
enter_scene(SceneId,Status,X,Y) ->
	try  
		PidScene = get_scene_pid(SceneId) ,
		PlayerOther = Status#player.other#player_other{pid_scene = PidScene} ,
		BattleAttr = Status#player.battle_attr#battle_attr{x=X, y=Y} ,
		NewPlayer = Status#player{scene = SceneId,other = PlayerOther,battle_attr = BattleAttr} ,
		gen_server:cast(PidScene, {apply_cast, lib_scene, enter_scene, [NewPlayer]}) ,
		{ok,NewPlayer}
	catch
		_:_ -> []
	end.

%% @spec 用户退出场景
leave_scene(SceneId,Pid_scene, PlayerId) ->
	try  
		gen_server:cast(Pid_scene, {apply_cast, lib_scene, leave_scene, [PlayerId,SceneId]})
	catch
		_:_ -> 
			fail
	end.



%% 同步玩家的目的位置
update_postion(PIdScene,Status,DestX,DestY) ->
	try  
		gen_server:cast(PIdScene, {apply_cast, lib_scene, update_postion, [Status,DestX,DestY]})
	catch
		_:_ -> 
			fail
	end.
  	

%%用户进入联盟场景
enter_scene_union(Pid_scene, Status) ->
	try  
		gen_server:cast(Pid_scene, {apply_cast, lib_scene, enter_scene_union, [Status]})
	catch
		_:_ -> fail
	end.	

%%玩家拾取物品
pick_drop(PIdScene, MonId, GoodsId, PosX, PosY) ->
	try 
		case gen_server:call(PIdScene,{apply_call, lib_scene, pick_drop, [MonId, GoodsId, PosX, PosY]}) of
			error -> 
				[0,[]] ;
			Data ->
				Data
		end
	catch
		_:_Reason -> 
			?DEBUG("12016 pick_drop fail for the reason:[~p]",[_Reason]),
			[0,0]  
	end.



	
	