%%%------------------------------------
%%% @Module  : mod_guild
%%% @Author  : csj
%%% @Created : 2010.10.05
%%% @Description: 联盟处理 
%%%------------------------------------
-module(mod_guild).
-behaviour(gen_server).
-include("common.hrl").
-include("record.hrl").
-compile(export_all).

%% %%=========================================================================
%% %% 一些定义
%% %%=========================================================================
%% 
%% 
%% -record(state, {worker_id = 0}).
%% 
%% %% 定时器1间隔时间
%% -define(TIMER_1, 10*1000).
%% -define(TIMER_RESET_RANK, 22*60*60).
%% 
%% %%=========================================================================
%% %% 接口函数
%% %%=========================================================================
%% %% start_link([ProcessName, Worker_id]) ->
%% %%     gen_server:start_link({local, ?MODULE}, ?MODULE, [ProcessName, Worker_id], []).
%% start_link([ProcessName, Worker_id]) ->
%%     gen_server:start_link(?MODULE, [ProcessName, Worker_id], []).
%% 
%% start([ProcessName, Worker_id]) ->
%%     gen_server:start(?MODULE, [ProcessName, Worker_id], []).
%% 
%% stop() ->
%%     gen_server:call(?MODULE, stop).
%% 
%% %%获取联盟主进程 
%% get_main_mod_guild_pid() ->
%% 	ProcessName = misc:create_process_name(guild_p, [0]),
%% 	case misc:whereis_name({global, ProcessName}) of
%% 			Pid when is_pid(Pid) ->
%% 				case misc:is_process_alive(Pid) of
%% 					true ->
%% 						Pid;
%% 					false -> 
%% 						start_mod_guild(ProcessName)
%% 				end;
%% 			_ ->
%% 				start_mod_guild(ProcessName)
%% 	end.
%% 
%% %%动态加载联盟处理进程 
%% get_mod_guild_pid() ->
%% 	ProcessName = misc:create_process_name(guild_p, [0]),
%% 	case misc:whereis_name({global, ProcessName}) of
%% 			Pid when is_pid(Pid) ->
%% 				case misc:is_process_alive(Pid) of
%% 					true ->
%% 						WorkerId = random:uniform(?GUILD_WORKER_NUMBER),
%% 						ProcessName_1 = misc:create_process_name(guild_p, [WorkerId]),
%%  						case misc:whereis_name({global, ProcessName_1}) of
%% 							Pid1 when is_pid(Pid1) ->
%% 								Pid1;
%% 							_ ->
%% 								get_mod_guild_pid_1(1)
%% 						end;
%% 					false -> 
%% 						start_mod_guild(ProcessName)
%% 				end;
%% 			_ ->
%% 				start_mod_guild(ProcessName)
%% 	end.
%% 
%% get_mod_guild_pid_1(Num) ->	
%% 	WorkerId = random:uniform(?GUILD_WORKER_NUMBER),
%% 	ProcessName_1 = misc:create_process_name(guild_p, [WorkerId]),
%% 	
%% 	case misc:whereis_name({global, ProcessName_1}) of
%% 		Pid1 when is_pid(Pid1) ->							
%% 			Pid1;
%% 		_ ->
%% 			%% 重启子进程
%% 			mod_guild:start_link([ProcessName_1, WorkerId]),
%% 			if Num >= 100 ->
%% 				   undefined;
%% 			   true ->
%% 				   get_mod_guild_pid_1(Num + 1)
%% 			end
%% 	end.
%% 
%% 
%% %%启动联盟监控模块 (加锁保证全局唯一)
%% start_mod_guild(ProcessName) ->
%% 	%%io:format("~s start_mod_guild[~p] \n ",[misc:time_format(now()), ProcessName]),
%% 	global:set_lock({ProcessName, undefined}),	
%% 	ProcessPid =
%% 		case misc:whereis_name({global, ProcessName}) of
%% 			Pid when is_pid(Pid) ->
%% 				case misc:is_process_alive(Pid) of
%% 					true -> 
%% 						WorkerId = random:uniform(?GUILD_WORKER_NUMBER),
%% 						ProcessName_1 = misc:create_process_name(guild_p, [WorkerId]),
%%  						misc:whereis_name({global, ProcessName_1});						
%% 					false -> 
%% 						start_guild(ProcessName)
%% 				end;
%% 			_ ->
%% 				start_guild(ProcessName)
%% 		end,	
%% 	global:del_lock({ProcessName, undefined}),
%% %% 	io:format("~s start_mod_guild[~p] \n ",[misc:time_format(now()), ProcessPid]),
%% 	ProcessPid.
%% 
%% %%启动联盟监控树模块
%% start_guild(ProcessName) ->
%% 	case supervisor:start_child(
%%        		game_server_sup, {mod_guild,
%%             		{mod_guild, start_link,[[ProcessName, 0]]},
%%                		permanent, 10000, supervisor, [mod_guild]}) of
%% 		{ok, Pid} ->
%% 				Pid;
%% 		_ ->
%% 				undefined
%% 	end.
%% 
%% %% --------------------------------------------------------------------
%% %% Function: init/1
%% %% Description: Initiates the server
%% %% Returns: {ok, State}          |
%% %%          {ok, State, Timeout} |
%% %%          ignore               |
%% %%          {stop, Reason}
%% %% --------------------------------------------------------------------
%% init([ProcessName, Worker_id]) ->
%% 	process_flag(trap_exit, true),
%% 	case misc:register(unique, ProcessName, self()) of%% 多节点的情况下， 仅在一个节点启用联盟处理进程
%% 		yes ->
%% 			if Worker_id =:= 0 ->	
%% 				   NowTime = util:get_today_current_second() ,
%% 				   %% 				io:format("1.Init mod_guild finish1!!!~n"),
%% 				   ets:new(?ETS_GUILD, [{keypos,#ets_guild.id}, named_table, public, set]),               	%%联盟
%% 				   ets:new(?ETS_GUILD_MEMBER, [{keypos,#ets_guild_member.id}, named_table, public, set]), 	%%联盟成员
%% 				   ets:new(?ETS_GUILD_APPLY, [{keypos,#ets_guild_apply.id}, named_table, public, set]),   	%%联盟申请
%% 				   ets:new(?ETS_GUILD_INVITE, [{keypos,#ets_guild_invite.id}, named_table, public, set]), 	%%联盟邀请
%% 				   ets:new(flag_rank_today, [{keypos, #flag_rank_today.gid}, named_table, public, set]),  	
%% 				   ets:new(flag_rank_yesterday, [{keypos, #flag_rank_yesterday.gid}, named_table, public, set]), 
%% 				   
%% 				   io:format("1.Init mod_guild finish2!!!~n"),
%% 				   %% 加载所有联盟并且对应加载升级记录
%% 				   lib_guild_inner:load_all_guild(),
%% 				   %%加载所有的联盟技能属性
%% 				   %%lib_guild_inner:load_all_guild_skills_attribute(),
%% 				   %%加载联盟日志，加载最近三天的日志，三天前的日志即可删除
%% 				   lib_guild_inner:load_all_guild_log(),	
%% 				   lib_guild_inner:load_all_member_skill(),
%% 				   %%io:format("1.Init mod_guild finish2!!!~n"),
%% 				   %%加载联盟仓库(仅初始化表)
%% 				   %%lib_guild_warehouse:init_guild_warehouse(),
%% 				   %%加载联盟高级技能
%% 				   %%lib_guild_weal:load_all_guild_h_skills(),
%% 				   %% 			io:format("ok!!!!!!!!!\n"),
%% 				   %% 				io:format("1.Init mod_guild finish3!!!~n"),
%% 				   %% 定时处理
%% 				   erlang:send_after(?TIMER_1, self(), {event, timer_1_action, 0}),
%% 				   
%% 				   %% 				erlang:send_after(600 * 1000, self(), {event, timer_2_guild_sit, 0}),
%% 				   misc:write_monitor_pid(self(),?MODULE, {?GUILD_WORKER_NUMBER}),
%% 				   misc:write_system_info(self(), mod_guild, {}),	
%% 				   %% 启动多个场景服务进程
%% 				   lib_guild_inner:load_flag_rank() ,
%% 				   case NowTime > ?TIMER_RESET_RANK of
%% 					   true ->
%% 						   LeftTime = 24*60*60 - NowTime + ?TIMER_RESET_RANK ;
%% 					   false ->
%% 						   LeftTime = ?TIMER_RESET_RANK - NowTime 
%% 				   end ,
%% 				   erlang:send_after(LeftTime*1000 , self() , 'reset_rank'),
%% 				   lists:foreach(
%% 					 fun(WorkerId) ->
%% 							 ProcessName_1 = misc:create_process_name(guild_p, [WorkerId]),
%% 							 mod_guild:start_link([ProcessName_1, WorkerId])
%% 					 end,
%% 					 lists:seq(1, ?GUILD_WORKER_NUMBER));			
%% 			   true -> 
%% 				   misc:write_monitor_pid(self(), mod_guild_worker, {Worker_id})
%% 			end,
%% 			State= #state{worker_id = Worker_id},
%% 			{ok, State};
%% 		_ ->
%% 			{stop,normal,#state{}}
%% 	end.
%% 		
%% 
%% %% --------------------------------------------------------------------
%% %% Function: handle_call/3
%% %% Description: Handling call messages
%% %% Returns: {reply, Reply, State}          |
%% %%          {reply, Reply, State, Timeout} |
%% %%          {noreply, State}               |
%% %%          {noreply, State, Timeout}      |
%% %%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%% %%          {stop, Reason, State}            (terminate/2 is called)
%% %% --------------------------------------------------------------------
%% %% 统一模块+过程调用(call)
%% handle_call({apply_call, Module, Method, Args}, _From, State) ->
%%   %%	%% ?DEBUG("*****  mod_guild__apply_call: [~p,~p]   *****", [Module, Method]),	
%% 	Reply  = 
%% 	case (catch apply(Module, Method, Args)) of
%% 		 {'EXIT', Info} ->	
%% 			 ?WARNING_MSG("mod_guild__apply_call error: Module=~p, Method=~p, Reason=~p",[Module, Method,Info]),
%% 			 error;
%% 		 DataRet -> DataRet
%% 	end,
%%     {reply, Reply, State};
%% %%获取帮派成员的相关信息
%% handle_call({'get_guild_member_info', [GuildId, _PlayerId]}, _From, State) ->
%% 	Result = 
%% 		case lib_guild_inner:get_guild(GuildId) of
%% 			[] ->
%% 				{0,0};
%% 			Guild ->
%% %% 				case lib_guild_inner:get_guild_member_by_guildandplayer_id(GuildId, PlayerId) of
%% %% 					[] ->
%% %% 						{0, 0};
%% %% 					GuildMember ->
%% 						{Guild#ets_guild.lv, 0}
%% %% 				end
%% 		end,
%% 	{reply, Result, State};
%% 
%% handle_call(_Request, _From, State) ->
%%     {reply, State, State}.
%% 
%% %% --------------------------------------------------------------------
%% %% Function: handle_cast/2
%% %% Description: Handling cast messages
%% %% Returns: {noreply, State}          |
%% %%          {noreply, State, Timeout} |
%% %%          {stop, Reason, State}            (terminate/2 is called)
%% %% --------------------------------------------------------------------
%% %% 统一模块+过程调用(cast)
%% handle_cast({apply_cast, Module, Method, Args}, State) ->
%%  	%% ?DEBUG("*****   mod_guild__apply_cast: [~p,~p]   *****", [Module, Method]),	
%% 	case (catch apply(Module, Method, Args)) of
%% 		 {'EXIT', Info} ->	
%% 			 ?WARNING_MSG("mod_guild__apply_cast error: Module=~p, Method=~p, Reason=~p",[Module, Method, Info]),
%% 			 error;
%% 		 _ -> ok
%% 	end,
%%     {noreply, State};
%% 
%% %%神战结束后处理
%% handle_cast({'UPDATE_SKYRUSH_INFO', GFeats,MFeats,NowTime}, State) ->
%% 	lib_skyrush:handle_gfeats(GFeats, MFeats, NowTime),
%% 	lib_skyrush:handle_mfeats(MFeats, NowTime),
%% %% 	RankList = lib_skyrush:rank_guild_member_feats(),
%% %% 	{ok, Data39021} = pt_39:write(39021, [RankList]),%%全场景的人通知
%% %% 	spawn(fun() -> mod_scene_agent:send_to_scene(?SKY_RUSH_SCENE_ID, Data39021) end),
%% 	{noreply, State};
%% 
%% 
%% 
%% %%GM命令用于增加联盟经验
%% handle_cast({'update_guild_info', NewGuild}, Status) ->
%% 	lib_guild_inner:update_guild(NewGuild),
%% 	{noreply, Status};
%% 
%% %%增加联盟贡献度 InfoList = [{playerid, devo_value},...] 
%% handle_cast({'add_guild_devo', GuildId, InfoList}, Status) ->
%% 	if 
%% 		GuildId =/= 0 ->
%% 			lib_guild:add_guild_devo(GuildId, InfoList);
%% 		true ->
%% 			skip
%% 	end,
%% 	
%% 	{noreply, Status};
%% 
%% %%增加联盟贡献度、联盟玉牌 InfoList = [{playerid, devo_value, jade_value},...]
%% handle_cast({'add_guild_devo_jade', GuildId, InfoList}, Status) ->
%% 	if 
%% 		GuildId =/= 0 ->
%% 			lib_guild:add_guild_devo_jade(GuildId, InfoList);
%% 		true ->
%% 			skip
%% 	end,
%% 	{noreply, Status};
%% 
%% %%联盟任务
%% handle_cast({'guild_task_devo', PlayerId, PlayerDevo, GuildDevo, GuildFund, Jade}, Status) ->
%% 	lib_guild:guild_task_devo(PlayerId, PlayerDevo, GuildDevo, GuildFund, Jade),
%% 	{noreply, Status};
%% 
%% %%更新玩家的联盟玉牌
%% handle_cast({'update_guild_member_jade', GuildId, Uid, Jade, Kind, Type, ExchangeTid}, Status) ->
%% 	lib_guild:update_guild_member_jade(GuildId, Uid, Jade, Kind, Type, ExchangeTid),
%% 	{noreply, Status};
%% 
%% %% handle_cast({'kill_guild_boss', Data}, Status) ->
%% %% 	[GuildId, MonName] = Data, 
%% %% 	case lib_guild_inner:get_guild(GuildId) of
%% %% 		[] ->
%% %% 			skip;
%% %% 		Guild ->
%% %% 			GuildName = Guild#ets_guild.name,
%% %% 			Msg = io_lib:format("在 <font color='#FEDB4F'>[~s]</font></a> 联盟成员的一轮猛攻之下，<font color='#FEDB4F'>[~s]</font>缓缓地倒下了。",[GuildName, MonName]),
%% %% 			spawn(lib_chat, broadcast_sys_msg, [1, Msg]),
%% %% 			NewGuild = Guild#ets_guild{boss_sv = 0},
%% %% 			ValueList = [{boss_sv, 0}],
%% %% 			FieldList = [{id, GuildId}],
%% %% 			db_agent:update_kill_guild_boss(ValueList, FieldList),
%% %% 			lib_guild_inner:update_guild(NewGuild)
%% %% 	end,
%% %% 	{noreply, Status};
%% 	
%% handle_cast(_Msg, State) ->
%%     {noreply, State}.
%% 
%% %% --------------------------------------------------------------------
%% %% Function: handle_info/2
%% %% Description: Handling all non call/cast messages
%% %% Returns: {noreply, State}          |
%% %%          {noreply, State, Timeout} |
%% %%          {stop, Reason, State}            (terminate/2 is called)
%% %% --------------------------------------------------------------------
%% handle_info({event, timer_1_action, _Type}, State) ->
%% %%     io:format("guild upgrade! check \n", []),
%% 	%%NewType = lib_skyrush:start_skyrush(Type),
%%  	NewType = 0,
%% 	handle_timer_action(),
%% 	erlang:send_after(?TIMER_1, self(), {event, timer_1_action, NewType}),
%% 	{noreply, State};
%% 
%% handle_info({event, timer_2_guild_sit, _Type}, State) ->
%% 	List = lib_guild_inner:get_sit_guilds(),
%% 	%io:format("~s timer_2_guild_sit [~p] \n ",[misc:time_format(now()), List]),
%% 
%% 	if
%% 		List =:= [] ->
%% 			ok;
%% 		true ->
%% 			lists:foreach(fun(Elem) -> lib_guild_sit:int_guild_sit(Elem) end, List)
%% 	end,
%% 	
%% 	{noreply, State};
%% 
%% handle_info('reset_rank', State) ->
%% 	lib_guildh:reset_rank() ,
%% 	erlang:send_after(24*60*60*1000 , self() , 'reset_rank') ,
%% 	{noreply, State};
%% 
%% handle_info({event, accuse_chief_action, GuildId},State) ->
%% 	%%io:format("~s accuse_chief_action [~p] \n ",[misc:time_format(now()), GuildId]),
%% 	lib_guild:handle_accuse_chief_action(GuildId),
%% 	{noreply, State};
%% 
%% handle_info({finish_sit, GuildId, SceneID, Pos}, State) ->
%% 	%%io:format("~s finish_sit [~p] \n ",[misc:time_format(now()), GuildId]),
%% 	lib_guild_sit:cls_scene_pos(SceneID, Pos),
%% %% 	ets:delete(?ETS_SCENE_NPC, GuildId),
%% 	Servers = mod_disperse:server_list(),
%% 	mod_disperse:broadcast_cls_flag(Servers, GuildId),
%% 	mod_disperse:delete_flag(GuildId),
%% 	{ok, ScnBin} = pt_40:write(40053, [0, Pos, []]),
%% 	mod_scene_agent:send_to_base_scene(SceneID, ScnBin),
%% 	lib_guild_sit:send_guild_sit(0, SceneID, 0, GuildId),
%% 	{noreply, State};
%% 
%% 
%% handle_info(_Info, State) ->
%%     {noreply, State}.
%% 
%% %% --------------------------------------------------------------------
%% %% Function: terminate/2
%% %% Description: Shutdown the server
%% %% Returns: any (ignored by gen_server)
%% %% --------------------------------------------------------------------
%% terminate(_Reason, _State) ->
%% 	io:format("~s terminate [~p] \n ",[misc:time_format(now()), _Reason]),
%% 	misc:delete_monitor_pid(self()),
%% 	misc:delete_system_info(self()),
%%     ok.
%% 
%% %% --------------------------------------------------------------------
%% %% Func: code_change/3
%% %% Purpose: Convert process state when code is changed
%% %% Returns: {ok, NewState}
%% %% --------------------------------------------------------------------
%% code_change(_OldVsn, State, _Extra) ->
%%     {ok, State}.
%% 
%% %%=========================================================================
%% %% 业务处理函数
%% %%=========================================================================
%% %% -----------------------------------------------------------------
%% %% 定时处理事务
%% %% -----------------------------------------------------------------
%% handle_timer_action() ->
%%     {{Year, Month, Day}, {Hour, Min, Sec}} = calendar:local_time(),
%% 	%%做联盟升级处理
%% 	%%lib_guild_inner:handle_guild_upgrade_record(),
%%     % 每天凌晨4点到6点，且隔30分钟收取一次
%% 	% 星期几
%%     Week  = calendar:day_of_the_week(Year, Month, Day),	
%% 	
%% 	%% 进行联盟维护
%% 	if 
%% 		((Hour == 0) and (Min =< 1) and (Sec < 30)) ->
%% 			lib_guild_inner:defend_all_guild(),
%% 			lib_guild_inner:check_leader_logon(),			
%% 			
%% 			if 
%% 				Sec < 11 ->
%% 					lib_guild_inner:check_reward_to_guild();
%% 				true -> ok
%% 			end;
%% 		true ->
%% 			ok
%% 	end,
%% 	
%%     if  
%% 		((Week == 1) and (Hour == 0) and (Min == 1) and (Sec < 30)) -> %% 联盟排名
%% 		%%((Min == 1) and (Sec < 12)) ->
%% 			lib_guild_inner:rank_guild_member();
%% 		((Hour == 0) and (Min == 1) and (Sec < 30)) ->
%% 			lib_guild_inner:delete_guild_all_apply(); %% 每天0点清理联盟申请
%% 		((Hour >= 4) and (Hour =< 6)) ->
%% 			%%lib_guild_inner:handle_daily_consume(),		%% 处理收取每日联盟消耗
%% 			lib_guild_inner:delete_extra_log_guild();		%%清理过期的联盟日志（三天前）
%%         true ->
%%             no_action
%%     end.
%% 
%% 
%% %% -----------------------------------------------------------------
%% %% 40001 创建联盟
%% %% -----------------------------------------------------------------
%% create_guild(Status, [GuildName, GuildNotice]) ->	
%% 	CreateCoin = data_guild:get_guild_config(create_coin, []),	%% 获取创建联盟所需铜钱
%% 	if 
%% 		Status#player.unid /= 0 -> [2, 0];																%% 是否已经加入/创建了联盟
%% 		Status#player.lv =< 0 -> [3,0];				%%?CREATE_GUILD_LV					%% 等级是否满足条件
%% 		CreateCoin > Status#player.coin -> [4,0];									%% 有无足够铜钱
%% %% 		Status#player.gold < 30 -> [9, 0]; %% 元宝不足
%% 		Status#player.viplv < 1 -> [10, 0]; %% 不是Vip
%% 		true ->
%% 			case lib_words_ver:words_ver(GuildName) of
%% 				false -> [8,0];%% 含有非法字符
%% 				_ ->						
%% 					case lib_guild:validata_name(GuildName, 1, 12) of     %% 最长20字符
%% 						false -> [6,0];
%% 						true ->							
%% 							case lib_words_ver:words_ver(GuildNotice) of   %%功能内容
%% 								false -> [11,0];
%% 								true ->									
%% 									case lib_guild:validata_name(GuildNotice, 1, 280) of     %%功能长度
%% 										false -> [9,0];
%% 										true ->
%% 											ForceAtt = lib_player:force_att(Status),
%% 											
%% 											try
%% 												case gen_server:call(mod_guild:get_mod_guild_pid(),
%% 																	 {apply_call, lib_guild, create_guild,
%% 																	  [Status#player.unid,
%% 																	   Status#player.lv,
%% 																	   Status#player.coin,
%% 																	   Status#player.id,
%% 																	   Status#player.nick,
%% 																	   Status#player.lstm,
%% 																	   Status#player.other#player_other.pid,
%% 																	   [GuildName, GuildNotice, Status#player.sex, Status#player.crr, ForceAtt]
%% 																	  ]})	of
%% 													error -> 
%% 														io:format("~s mod_create_guild error[~p] \n ",[misc:time_format(now()), test]),
%% 														[0, 0];
%% 													Data ->
%% 														io:format("~s mod_create_guild seccus [~p]\n ",[misc:time_format(now()), Data]),
%% 														Data
%% 												end
%% 											catch
%% 												_:_Reason ->
%% 													%%?DEBUG("40001 create_guild for the reason:[~p]",[_Reason]),
%% 													io:format("~s mod_create_guild the reason [~p]\n ",[misc:time_format(now()), _Reason]),
%% 													[0, 0]
%% 											end
%% 									end
%% 							end
%% 					end
%% 			end
%% 	end.
%% 
%% %% -----------------------------------------------------------------
%% %% 40002 解散联盟
%% %% -----------------------------------------------------------------
%% confirm_disband_guild(Status, [GuildId, QuitTime]) ->	
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild, confirm_disband_guild, 
%% 						 [Status#player.id,
%% 						  Status#player.nick,
%% 						  Status#player.unid, 
%% 						  Status#player.un,
%% 						  Status#player.upst, 
%% 						  [GuildId, QuitTime]]})	of
%% 			 error -> 
%% 				 0;
%% 			 Data -> 
%% 				 Data
%% 		end		
%% 	catch
%% 		_:_Reason -> 
%% 			0
%% 	end.
%% 
%% %% -----------------------------------------------------------------
%% %% 40004 申请加入联盟
%% %% -----------------------------------------------------------------
%% apply_join_guild(Status, [GuildId]) ->
%% 	ForceAtt = lib_player:force_att(Status),
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild, apply_join_guild, 
%% 						 [	Status#player.id,
%% 							Status#player.nick,
%% 							Status#player.unid,
%% 							Status#player.camp,
%% 							Status#player.lv,
%% 							Status#player.uqlt,
%% 							Status#player.other#player_other.pid,
%% 							Status#player.sex,
%% 							0,
%% 							Status#player.crr,
%% 						  	[GuildId, ForceAtt]]})	of
%% 			 error -> 
%% 				 [0];
%% 			 Data ->
%% 				 Data
%% 		end		
%% 	catch
%% 		_:_Reason -> 
%% 			[0]
%% 	end.
%% 
%% %% -----------------------------------------------------------------
%% %% 40005 撤销加入联盟
%% %% -----------------------------------------------------------------
%% apply_cancel_join(Status, [GuildId]) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild, apply_cancel_join, 
%% 						 [	Status#player.id,
%% 							Status#player.unid,
%% 							Status#player.other#player_other.pid,				
%% 						  	[GuildId]]})	of
%% 			 error -> 
%% 				 [0];
%% 			 Data ->
%% 				 Data
%% 		end		
%% 	catch
%% 		_:_Reason -> 
%% 			[0]
%% 	end.
%% 
%% %% -----------------------------------------------------------------
%% %% 40006 开除帮众
%% %% PlayerId:指定的联盟成员
%% %% -----------------------------------------------------------------
%% kickout_guild(Status, [PlayerId, QuitTime]) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild, kickout_guild, 
%% 						 	[	Status#player.id,
%% 								Status#player.nick,
%% 								Status#player.unid,
%% 								Status#player.upst,
%% 								Status#player.udpid,							 
%% 							 [PlayerId, QuitTime]]}) of
%% 			 error -> 
%% 				 [0, <<>>];
%% 			 Data -> 
%% 				 Data
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			[0, <<>>]
%% 	end.
%% 
%% %% -----------------------------------------------------------------
%% %% 40007 查询个人联盟信息
%% %% -----------------------------------------------------------------
%% guild_member_info(_Status, [PlayerId]) ->	
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild, guild_member_info, [PlayerId]}) of
%% 			 error -> 
%% 				 [0, 0, []];
%% 			 [Ret, GuildLv, MemberInfo] -> 
%% 				 [Ret, GuildLv, MemberInfo]
%% 		end	
%% 	catch
%% 		_:_Reason -> 			
%% 			[0, 0, []]
%% 	end.	
%% 
%% 
%% %% -----------------------------------------------------------------
%% %% 40008 退出联盟
%% %% -----------------------------------------------------------------
%% quit_guild(Status, [QuitTime]) ->
%% 	%%因为涉及到并发问题，此操作专门使用Id号为0的进程执行
%% 	ProcessName = misc:create_process_name(guild_p, [0]),
%% 	GuildPid = 
%% 		case misc:whereis_name({global, ProcessName}) of
%% 			Pid when is_pid(Pid) ->
%% 				case misc:is_process_alive(Pid) of
%% 					true ->
%% 						Pid;
%% 					false ->
%% 						start_mod_guild(ProcessName)
%% 				end;
%% 			_ ->
%% 				start_mod_guild(ProcessName)
%% 		end,
%% 	try 
%% 		case gen_server:call(GuildPid, 
%% 						{apply_call, lib_guild, quit_guild, 
%% 						 	[Status#player.id, 
%% 							 Status#player.nick, 
%% 							 Status#player.unid, 
%% 							 Status#player.upst,							 
%% 							 [QuitTime]]}) of
%% 			 error -> 
%% 				 0;
%% 			 Data -> 
%% 				 Data
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			0
%% 	end.
%% 
%% %% -----------------------------------------------------------------
%% %% 40009 盟主让位
%% %% -----------------------------------------------------------------
%% demise_chief(Status, [PlayerId]) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild, demise_chief, 
%% 						 [Status#player.id, 
%% 						  Status#player.nick, 
%% 						  Status#player.unid, 
%% 						  Status#player.upst,
%% 						  [PlayerId]]})	of
%% 			 error -> 
%% 				 [0, 0, <<>>];
%% 			 Data -> 
%% 				 Data
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			[0, 0, <<>>]
%% 	end.
%% 
%% %% -----------------------------------------------------------------
%% %% 40010 获取联盟列表
%% %% -----------------------------------------------------------------
%% list_guild(Status, [GuildName, MasterName]) ->
%%     %% ?DEBUG("list_guild: realm=[~p], GuildName=[~s], ChiefName = [~s]~n", [Realm, GuildName, ChiefName]),
%% 	if is_record(Status,player) =:= true ->
%% 		   PlayerId = Status#player.id;
%% 	   true -> 
%% 		   PlayerId = 0
%% 	end,
%% 	
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild_inner, get_sort_guild, [PlayerId, GuildName, MasterName, 1]})	of
%% 			 error -> 
%% 				 [0, [], []];
%% 			 [IndexGuilds, ApplyGuildList] -> 
%% 				 %% ?DEBUG("40010 list_guild succeed",[]),
%% 				 [1, IndexGuilds, ApplyGuildList]
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			[0, [], []]
%% 	end.
%% 
%% %% -----------------------------------------------------------------
%% %% 40011 获取成员列表
%% %% -----------------------------------------------------------------
%% list_guild_member(_Status, [GuildId]) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild_inner, get_guild_member_page, [GuildId]})	of
%% 			 error -> 
%% 				 [0, []];
%% 			 Data -> 
%% 				 [1, Data]
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			[0, []]
%% 	end.
%% 
%% get_guild_member_devo(GuildId) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild_inner, get_guild_member_devo, [GuildId]})	of
%% 			 error -> 
%% 				 [0, []];
%% 			 Data -> 
%% 				 [1, Data]
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			[0, []]
%% 	end.
%% 
%% %% -----------------------------------------------------------------
%% %% 获取联盟日志
%% %% -----------------------------------------------------------------
%% get_guild_log(_Status, [GuildId]) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild_inner, get_guild_log, [GuildId]}) of
%% 			error ->
%% 				[];
%% 			Result -> 
%% 				Result
%% 		end			
%% 	catch
%% 		_:_ -> []
%% 	end. 
%% 
%% 
%% %% -----------------------------------------------------------------
%% %% 40013 获取申请列表
%% %% -----------------------------------------------------------------
%% list_guild_apply(_Status, [GuildId]) ->
%% 
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild_inner, get_guild_apply_page, [GuildId]})	of
%% 			 error -> 
%% 				 [0, <<>>];
%% 			 Data -> 
%% 				 Data
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			[0, <<>>]
%% 	end.	
%% 
%% %% -----------------------------------------------------------------
%% %% 40014 获取联盟信息
%% %% -----------------------------------------------------------------
%% get_guild_info(_Status, [GuildId]) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild_inner, get_guild_info, 
%% 						 [GuildId]})	of
%% 			 error -> 
%% 				 [0, {}];
%% 			 Data -> 
%% 				 Data
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			[0, {}]
%% 	end.
%% 
%% %% -----------------------------------------------------------------
%% %% 40015 修改联盟公告
%% %% -----------------------------------------------------------------
%% modify_guild_announce(Status, [GuildId, Flag, Announce]) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild, modify_guild_announce, 
%% 						 [Status#player.unid, 
%% 						  Status#player.upst,
%% 						  [GuildId, Flag, Announce]]})	of
%% 			 error -> 
%% 				 [0];
%% 			 Data -> 
%% 				 Data
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			[0]
%% 	end.
%% 
%% %% -----------------------------------------------------------------
%% %% 40016 捐献钱币
%% %% -----------------------------------------------------------------
%% donate_money(Status, [GuildId, Value, Type]) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_main_mod_guild_pid(), 
%% 						{apply_call, lib_guild, donate_money, 
%% 						 [Status, [GuildId, Value, Type]]})	of
%% 			 error -> 
%% 				 [0, Status];
%% 			 Data -> 
%% 				 Data
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			[0, Status]
%% 	end.
%% 
%% %% -----------------------------------------------------------------
%% %% 40017 联盟升级请求
%% %% -----------------------------------------------------------------
%% guild_upgrade(Status,[GuildId]) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_main_mod_guild_pid(), 
%% 						{apply_call, lib_guild, guild_upgrade, 
%% 						 [Status#player.unid, 
%% 						  Status#player.lv,
%% 						  Status#player.upst,
%% 						  [GuildId]]})	of
%% 			 error -> 
%% 				 [0, 0];
%% 			 Data -> 
%% 				 Data
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			[0, 0]
%% 	end.
%% 
%% %% -----------------------------------------------------------------
%% %% 40018 领取俸禄
%% %% -----------------------------------------------------------------
%% get_member_salary(Status,[]) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild, get_member_salary, 
%% 						 [Status,
%% 						  Status#player.id,
%% 						  Status#player.unid,
%% 						  Status#player.upst 
%% 						  ]})	of
%% 			 error -> 
%% 				 [0, 0, Status];
%% 			 Data -> 
%% 				 Data
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			[0, 0, Status]
%% 	end.
%% 
%% %% -----------------------------------------------------------------
%% %%40019 提升职位
%% %% -----------------------------------------------------------------
%% set_member_post(Status, [GuildId, PlayerId, Post]) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild_inner, set_member_post, 
%% 						 [Status#player.id, 
%% 						  Status#player.nick,
%% 						  Status#player.unid,
%% 						  Status#player.upst,
%% 						  [GuildId, PlayerId, Post]]})	of
%% 			 error -> 
%% 				 [0, <<>>, 0, 0, ""];
%% 			 Data -> 
%% 				 Data
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			[0, <<>>, 0, 0, ""]
%% 	end.
%% 
%% %% -----------------------------------------------------------------
%% %% 40020 批准/拒绝加入联盟
%% %% -----------------------------------------------------------------
%% approve_guild_apply(Status, [PlayerId, Type]) ->
%% 	%%因为涉及到并发问题，此操作专门使用Id号为0的进程执行
%% 	ProcessName = misc:create_process_name(guild_p, [0]),
%% 	GuildPid = 
%% 		case misc:whereis_name({global, ProcessName}) of
%% 			Pid when is_pid(Pid) ->
%% 				case misc:is_process_alive(Pid) of
%% 					true ->
%% 						Pid;
%% 					false ->
%% 						start_mod_guild(ProcessName)
%% 				end;
%% 			_ ->
%% 				start_mod_guild(ProcessName)
%% 		end,
%% 	
%% 	%%io:format("~s mod:approve_guild_apply GuildPid[~p] \n ",[misc:time_format(now()), GuildPid]),
%% 	try 
%% 		case gen_server:call(GuildPid, 
%% 						{apply_call, lib_guild, approve_guild_apply, 
%% 						 	[Status#player.unid, 
%% 							  Status#player.un, 
%% 							  Status#player.upst, 
%% 							 [PlayerId, Type]]}) of
%% 			 error -> 
%% 				 [0, 0];
%% 			 Data -> 
%% 				 Data
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			[0, 0]
%% 	end.
%% 
%% %% 40021弹劾，对应联盟进程Id为12
%% accuse_chief(PlayerId, PlayerName, GuildId, GPosit) ->
%% 	ProcessName = misc:create_process_name(guild_p, [12]),
%% 	GuildPid = 
%% 		case misc:whereis_name({global, ProcessName}) of
%% 			Pid when is_pid(Pid) ->
%% 				case misc:is_process_alive(Pid) of
%% 					true ->
%% 						Pid;
%% 					false ->
%% 						mod_guild:start_mod_guild(ProcessName)
%% 				end;
%% 			_ ->
%% 				mod_guild:start_mod_guild(ProcessName)
%% 		end,
%% 	try 
%% 		case gen_server:call(GuildPid, 
%% 						{apply_call, lib_guild, accuse_chief_inner, 
%% 						 [PlayerId, PlayerName, GuildId, GPosit]})	of
%% 			error -> 
%% 				 [0, 0];
%% 			 [Ret, Time] -> 
%% 				 %%io:format("~s mod:accuse_chief1[~p] \n ",[misc:time_format(now()),[Ret, Time]]),
%% 				 [Ret, Time]
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			[0, 0]
%% 	end.
%% 
%% 
%% %% -----------------------------------------------------------------
%% %% 40022 获取弹劾信息
%% %% -----------------------------------------------------------------
%% get_accuse_info(_Status, [GuildId]) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild_inner, get_accuse_info, 
%% 						 [GuildId]})	of
%% 			 error -> 
%% 				 %% ?DEBUG("40014 get_guild_info error",[]),
%% 				 [0, {},[]];
%% 			 Data -> 
%% 				 Data
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			[0, {}, []]
%% 	end.
%% 
%% %% -----------------------------------------------------------------
%% %% 40023 弹劾操作
%% %% -----------------------------------------------------------------
%% accuse_vote(Status, [GuildId, Operation]) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild, accuse_vote, 
%% 						 [Status#player.id, GuildId, Operation]})	of
%% 			 error -> 
%% 				 [0];
%% 			 Data -> 
%% 				 Data
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			[0]
%% 	end.
%% 
%% %% -----------------------------------------------------------------
%% %%40024 解除职位
%% %% -----------------------------------------------------------------
%% release_member_post(Status, [GuildId, PlayerId, Post]) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild_inner, release_member_post, 
%% 						 [Status#player.id, 
%% 						  Status#player.nick,
%% 						  Status#player.unid,
%% 						  Status#player.upst,
%% 						  [GuildId, PlayerId, Post]]})	of
%% 			 error -> 
%% 				 [0, <<>>, 0, 0, ""];
%% 			 Data -> 
%% 				 Data
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			[0, <<>>, 0, 0, ""]
%% 	end.
%% 
%% %% -----------------------------------------------------------------
%% %% 40025 联盟商店信息
%% %% -----------------------------------------------------------------
%% get_guild_shop_info(Status, [PlayerId]) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild, get_guild_shop_log, 
%% 						 [PlayerId, Status#player.unid]})	of
%% 			 error -> 
%% 				 [0, [], []];
%% 			 Data -> 				 
%% 				 [ShopList, Member] = Data,
%% 				 GuildShop = lib_guild:get_guild_shop(PlayerId, Member#ets_guild_member.lv),
%% 				 [1, GuildShop, ShopList]
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			[0, [], []]
%% 	end.	
%% 
%% %% 购买联盟商店物品
%% pay_guild_shop(Status, [GoodsTypeId, Cell]) ->
%% 	[Result, GoodsList, Price, ReDevo] = lib_guild:pay_guild_shop(Status, [GoodsTypeId, Cell]),
%% 	if 
%% 		Result =:= 1 ->
%% 			try 
%% 				case gen_server:call(mod_guild:get_mod_guild_pid(),
%% 									 {apply_call, lib_guild, add_guild_shop_log,
%% 									  [Status#player.id, Status#player.nick, GoodsTypeId, Status#player.unid, Price]})	of
%% 					error ->
%% 						skip;
%% 					_Data ->
%% 						ok
%% 				end
%% 			catch
%% 				_:_Reason ->
%% 					skip
%% 			end,
%% 			
%% 			[Result, ReDevo, GoodsList];
%% 		true ->
%% 			[Result, ReDevo, []]
%% 	end.
%% 
%% %% -----------------------------------------------------------------
%% %% 40029 邀请加入联盟
%% %% -----------------------------------------------------------------
%% guild_invite_player(Status, [PlayerId]) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild, guild_invite_player, 
%% 						 [	Status#player.id,
%% 							Status#player.nick,							
%% 							Status#player.unid,
%% 							Status#player.upst,							
%% 							Status#player.other#player_other.pid,							
%% 						  	[PlayerId]]})	of
%% 			 error -> 
%% 				 0;
%% 			 Ret ->
%% 				 Ret
%% 		end		
%% 	catch
%% 		_:_Reason -> 
%% 			0
%% 	end.
%% 
%% %% -----------------------------------------------------------------
%% %% 40030 处理邀请加入联盟
%% %% -----------------------------------------------------------------
%% response_guild_invite(Status, [Type, GuildId]) ->
%% 	%%io:format("~s mod:approve_guild_apply [~p/~p] \n ",[misc:time_format(now()), PlayerId, Type]),
%% 	%%因为涉及到并发问题，此操作专门使用Id号为0的进程执行
%% 	ProcessName = misc:create_process_name(guild_p, [0]),
%% 	GuildPid = 
%% 		case misc:whereis_name({global, ProcessName}) of
%% 			Pid when is_pid(Pid) ->
%% 				case misc:is_process_alive(Pid) of
%% 					true ->
%% 						Pid;
%% 					false ->
%% 						start_mod_guild(ProcessName)
%% 				end;
%% 			_ ->
%% 				start_mod_guild(ProcessName)
%% 		end,
%% 	
%% 	ForceAtt = lib_player:force_att(Status),
%% 	try 
%% 		case gen_server:call(GuildPid, 
%% 						{apply_call, lib_guild, response_guild_invite, 
%% 						 	[Status, ForceAtt,
%% 							 [Type, GuildId]]}) of
%% 			 error -> 
%% 				 [0, <<>>];
%% 			 Data -> 
%% 				 Data
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			[0, <<>>]
%% 	end.
%% 
%% 
%% %% 联盟战相关接口
%% 
%% %% -----------------------------------------------------------------
%% %% 消耗联盟资金 0 未知错误, 1 成功, 2 你没有加入任何联盟, 3 你不是该联盟成员, 4 联盟不存在, 5联盟资金不足
%% %% -----------------------------------------------------------------
%% cost_fund(Status, [GuildId, Cost]) ->
%%   try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild, cost_fund, 
%% 						 [Status,
%% 						  [GuildId, Cost]]})	of
%% 			 error -> 
%% 				 0;
%% 			 Data -> 
%% 				 Data
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			0
%% 	end.
%% 
%% %% -----------------------------------------------------------------
%% %% 增加联盟资金 0 未知错误, 1 成功, 2 联盟不存在, 3 增加资金不能小于或等于0
%% %% -----------------------------------------------------------------
%% add_fund([GuildId, Fund]) ->
%%   try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild, add_fund, 
%% 						 [[GuildId, Fund]]})	of
%% 			 error -> 
%% 				 0;
%% 			 Data -> 
%% 				 Data
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			0
%% 	end.
%% 
%% %% -----------------------------------------------------------------
%% %% 增加联盟贡献度
%% %% -----------------------------------------------------------------
%% add_devo(GuildId, InfoList) ->
%% 	gen_server:cast(mod_guild:get_mod_guild_pid(), {'add_guild_devo', GuildId, InfoList}).
%% 
%% %% -----------------------------------------------------------------
%% %% 增加联盟贡献度、联盟玉牌
%% %% -----------------------------------------------------------------
%% add_devo_jade(GuildId, InfoList) ->
%% 	gen_server:cast(mod_guild:get_mod_guild_pid(), {'add_guild_devo_jade', GuildId, InfoList}).
%% 
%% %% -----------------------------------------------------------------
%% %% 联盟任务增加个人贡献，联盟资金和联盟繁荣度
%% %% -----------------------------------------------------------------
%% %% 参数 玩家ID，个人贡献，联盟贡献，联盟资金, 联盟玉牌
%% guild_task_devo(PlayerId, PlayerDevo, GuildDevo, GuildFund, Jade) ->
%% 	gen_server:cast(mod_guild:get_mod_guild_pid(), {'guild_task_devo', PlayerId, PlayerDevo, GuildDevo, GuildFund, Jade}).
%% 
%% 
%% %% 获取守护联盟列表
%% get_guard_guild(GuildId) ->
%% 	[Ret, GuildList, _ApplyIdList] = list_guild([], [[], []]),
%% 	
%% 	if 
%% 		Ret =:= 1 ->
%% 			case  GuildId =:= 0 of
%% 				true ->
%% 					Top1GuildList = lists:sublist(lists:keysort(1,GuildList),1) ,
%% 					lists:map(fun({Rank, Guild}) -> 
%% 									  {Rank, Guild#ets_guild.id,Guild#ets_guild.name,Guild#ets_guild.mun,Guild#ets_guild.lv,Guild#ets_guild.flag,0} 
%% 							  end, Top1GuildList) ;
%% 				false ->
%% 					Top1GuildList = [{Rank,Guild} || {Rank,Guild} <- GuildList , Guild#ets_guild.id =:= GuildId ] ,
%% 					lists:map(fun({Rank, Guild}) -> 
%% 									  {Rank, Guild#ets_guild.id,Guild#ets_guild.name,Guild#ets_guild.mun,Guild#ets_guild.lv,Guild#ets_guild.flag,0} 
%% 							  end, Top1GuildList) 
%% 			end ;
%% 		true ->
%% 			[] 
%% 	end .
%% 
%% %% 查询排名前N的联盟
%% get_top_guilds(TopNum) ->
%% 	[Ret, GuildList, _ApplyIdList] = list_guild([], [[], []]),
%% 	
%% 	if 
%% 		Ret =:= 1 ->
%% 			TopList = lists:sublist(lists:keysort(1,GuildList),TopNum) ,
%% 			lists:map(fun({_Rank, Guild}) -> 
%% 					{Guild#ets_guild.id,Guild#ets_guild.name, Guild#ets_guild.lv} 
%% 			end, TopList) ;
%% 		true ->
%% 			[]
%% 	end .
%% 	
%% 
%% 	
%% %% 验证联盟是否存在，若不存在，则返回新的联盟，新的联盟不能是第二个参数里面存在的。
%% validate_guard_guild(GuildId,GuildIDList) ->
%% 	[Ret, GuildList, _ApplyIdList] = list_guild([], [[], []]),
%% 	
%% 	if 
%% 		Ret =:= 1 ->
%% 			Ishas = [{Rank, Guild} || {Rank, Guild} <- GuildList, Guild#ets_guild.id =:= GuildId],
%% 			
%% 			if 
%% 				Ishas =/= [] -> %% 存在
%% 					[{R, G} | _T] = Ishas,
%% 					{0, {R, G#ets_guild.id, G#ets_guild.name, G#ets_guild.mun, G#ets_guild.lv , G#ets_guild.flag,0}};
%% 				true -> %% 不存在
%% 					Other = [{ORank, OGuild} || {ORank, OGuild} <- GuildList, lists:member(OGuild#ets_guild.id, GuildIDList) =:= false],
%% 					if 
%% 						Other =:= [] -> %% 没有符合的
%% 							{2, {0, 0, <<>>,<<>>,0,0,0}};
%% 						true ->
%% 							[{R1, G1} | _T1] = lists:keysort(1, Other),
%% 							{1, {R1, G1#ets_guild.id, G1#ets_guild.name , G1#ets_guild.mun, G1#ets_guild.lv , G1#ets_guild.flag,0}}
%% 					end
%% 			end;
%% 		true -> %% 获取联盟列表信息失败
%% 			{2, {0, 0, <<>>,<<>>,0,0,0}}
%% 	end.
%% 	
%% 	
%% 	
%% 	
%% %% 获取指定联盟ID 的排名
%% %% 传入 [GuildId1, GuildId2...]
%% %% 传出 [{GuildId, Rank}...]
%% get_guild_rank(GuildIdList) ->
%% 	
%% 	[Ret, GuildList, _ApplyIdList] = list_guild([], [[], []]),
%% 	
%% 	if 
%% 		Ret =:= 1 ->
%% 			Records = lists:map(fun({Rank, Guild}) -> 
%% 					case lists:member(Guild#ets_guild.id, GuildIdList) of
%% 						true ->
%% 							{Guild#ets_guild.id, Rank};
%% 						_ ->
%% 							{Guild#ets_guild.id, 0}
%% 					end						
%% 			end, GuildList);
%% 		true ->
%% 			Records = []
%% 	end,
%% 	
%% 	Records1 = [{Gid, Rk} || {Gid, Rk} <- Records, Rk =/= 0],
%% 	RankIds = [Gid1 || {Gid1, _Rk1} <- Records1],
%% 	NoRanks = [{Gid2, 0} || Gid2 <- GuildIdList, lists:member(Gid2, RankIds) =/= true],
%% 	NewRanks = Records1 ++ NoRanks,
%% 	
%% 	NewRanks.
%% 
%% %% -----------------------------------------------------------------
%% %% 40029 修改联盟堂堂名
%% %% -----------------------------------------------------------------
%% modify_udpn(Status, [GuildId, DepartId, DepartName, DepartsNames]) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild, modify_udpn, 
%% 						 [Status#player.unid,
%% 						  Status#player.upst,
%% 						  [GuildId, DepartId, DepartName, DepartsNames]]})	of
%% 			 error -> 
%% 				 %% ?DEBUG("40029 modify_udpn error",[]),
%% 				 [0];
%% 			 Data -> 
%% 				 %% ?DEBUG("40029 modify_udpn succeed:[~p]",[Data]),
%% 				 Data
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			%% ?DEBUG("40029 modify_udpn fail for the reason:[~p]", [_Reason]),
%% 			[0]
%% 	end.
%% 
%% 
%% %% -----------------------------------------------------------------
%% %% 40031 获取联盟技能信息
%% %% -----------------------------------------------------------------
%% get_guild_skills_info(Status, [GuildId]) ->
%% %% 	io:format("get_guild_skill_info"),
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild, get_guild_skills_info, 
%% 						 [Status#player.unid,
%% 						  Status#player.upst,
%% 						  [GuildId]]})	of
%% 			 error -> 
%% 				 %% ?DEBUG("40031 get_guild_skills_info error",[]),
%% 				 [0, []];
%% 			 Data -> 
%% 				%% %% ?DEBUG("40031 get_guild_skills_info succeed:[~p]",[Data]),
%% 				 Data
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			%% ?DEBUG("40031 get_guild_skills_info fail for the reason:[~p]", [_Reason]),
%% 			[0, []]
%% 	end.
%% 
%% 
%% 
%% %% -----------------------------------------------------------------
%% %% 40032 联盟技能升级
%% %% -----------------------------------------------------------------
%% guild_skills_upgrade(Status, [GuildId, SkillId, Level]) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild, guild_skills_upgrade, 
%% 						 [Status#player.unid,
%% 						  Status#player.upst,
%% 						  [GuildId, SkillId, Level]]})	of
%% 			 error -> 
%% 				 %% ?DEBUG("40032 guild_skills_upgrade error",[]),
%% 				 [0, Level];
%% 			 Data -> 
%% 				 %% ?DEBUG("40032 guild_skills_upgrade succeed:[~p]",[Data]),
%% 				 Data
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			%% ?DEBUG("40032 guild_skills_upgrade fail for the reason:[~p]", [_Reason]),
%% 			[0, Level]
%% 	end.
%% 
%% 
%% 
%% %% -----------------------------------------------------------------
%% %% 获取联盟排名信息
%% %% -----------------------------------------------------------------
%% rank_guild() ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_rank, rank_guild, []})	of
%% 			 error -> [];
%% 			 Data -> Data
%% 		end			
%% 	catch
%% 		_:_ -> []
%% 	end.	
%% 
%% %% -----------------------------------------------------------------
%% %% 查询人物相关属性排行(honor), 从联盟里
%% %% -----------------------------------------------------------------
%% query_roles_honor(Realm, Career, Sex, honor) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_rank, query_roles_honor, 
%% 						 [Realm, Career, Sex, honor]}) of
%% 			error ->
%% 				[];
%% 			Result -> 
%% 				Result
%% 		end			
%% 	catch
%% 		_:_ -> []
%% 	end.	
%% 
%% %% -----------------------------------------------------------------
%% %% 角色登录时的联盟处理
%% %% -----------------------------------------------------------------
%% role_login(PlayerId, Level, GuildId, LastLoginTime) ->
%% 
%% 	try 
%% 		gen_server:cast(mod_guild:get_mod_guild_pid(), 
%% 						{apply_cast, lib_guild_inner, role_login, [PlayerId, Level, GuildId, LastLoginTime]})
%% 	catch
%% 		_:_ -> []
%% 	end.
%% 
%% %% -----------------------------------------------------------------
%% %% 角色退出时的联盟处理
%% %% -----------------------------------------------------------------
%% role_logout(PlayerId, ForceAtt) ->
%% 	try 
%% 		gen_server:cast(mod_guild:get_mod_guild_pid(), 
%% 						{apply_cast, lib_guild_inner, role_logout, [PlayerId, ForceAtt]})
%% 	catch
%% 		_:_ -> []
%% 	end.
%% 
%% %% -----------------------------------------------------------------
%% %% 删除角色时的联盟处理
%% %% -----------------------------------------------------------------
%% delete_role(PlayerId) ->
%% 	try 
%% 		gen_server:cast(mod_guild:get_mod_guild_pid(), 
%% 						{apply_cast, lib_guild_inner, delete_role, [PlayerId]})
%% 	catch
%% 		_:_ -> []
%% 	end.
%% 
%% %% -----------------------------------------------------------------
%% %% 更新联盟成员缓存
%% %% -----------------------------------------------------------------
%% role_upgrade(PlayerId, Lv, ForceAtt) ->
%% 	try 
%% 		gen_server:cast(mod_guild:get_mod_guild_pid(), 
%% 						{apply_cast, lib_guild_inner, role_upgrade, [PlayerId, Lv, ForceAtt]})
%% 	catch
%% 		_:_ -> []
%% 	end.
%% 
%% %% -----------------------------------------------------------------
%% %% 联盟建设卡增加帮贡
%% %% -----------------------------------------------------------------
%% add_donation(PlayerId, Contrib) ->
%% 	try 
%% 		gen_server:cast(mod_guild:get_mod_guild_pid(), 
%% 						{apply_cast, lib_guild_inner, add_donation, [PlayerId, Contrib]})
%% 	catch
%% 		_:_ -> []
%% 	end. 
%% 
%% %% -----------------------------------------------------------------
%% %% 获取联盟等级
%% %% -----------------------------------------------------------------
%% get_guild_lev_by_id(GuildId) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild_inner, get_guild_lev_by_id, [GuildId]}) of
%% 			error ->
%% 				[];
%% 			Result -> 
%% 				Result
%% 		end			
%% 	catch
%% 		_:_ -> []
%% 	end. 
%% 
%% 
%% %% -----------------------------------------------------------------
%% %%联盟福利，联盟成员战斗结束后，可额外获得原经验的2%*k
%% %% -----------------------------------------------------------------
%% get_guild_battle_exp(GuildId, ExpBase) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild_inner, get_guild_battle_exp, [GuildId, ExpBase]}) of
%% 			error ->
%% 				ExpBase;
%% 			Result -> 
%% 				Result
%% 		end			
%% 	catch
%% 		_:_ -> ExpBase
%% 	end. 
%% 
%% %% -----------------------------------------------------------------
%% %% 做帮派任务，添加帮派经验，
%% %% -----------------------------------------------------------------
%% increase_guild_exp(PlayerId, GuildId, Exp, Contribute, AddFunds,Type) ->
%% 	%%因为涉及到并发问题，此操作专门使用Id号为0的进程执行
%% 	ProcessName = misc:create_process_name(guild_p, [0]),
%% 	GuildPid = 
%% 		case misc:whereis_name({global, ProcessName}) of
%% 			Pid when is_pid(Pid) ->
%% 				case misc:is_process_alive(Pid) of
%% 					true ->
%% 						Pid;
%% 					false ->
%% 						start_mod_guild(ProcessName)
%% 				end;
%% 			_ ->
%% 				start_mod_guild(ProcessName)
%% 		end,
%% 	try 
%% 		gen_server:cast(GuildPid, {apply_cast, lib_guild, increase_guild_exp, [PlayerId, GuildId, Exp, Contribute, AddFunds,Type]})
%% 	catch
%% 		_:_ -> []
%% 	end.
%% 
%% 
%% %% -----------------------------------------------------------------
%% %% 获取联盟打坐信息
%% %% -----------------------------------------------------------------
%% guild_sit(PidSend, GuildId) ->
%% 	try 
%% 		gen_server:cast(mod_guild:get_main_mod_guild_pid(),
%% 						{apply_cast, lib_guild_sit, get_guild_sit_by_id, [PidSend, GuildId]})		
%% 	catch
%% 		_:_ -> []
%% 	end. 
%% 
%% %% -----------------------------------------------------------------
%% %% 开启联盟打坐
%% %% -----------------------------------------------------------------
%% guild_sit_start(Status, Type, Scene) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_main_mod_guild_pid(), 
%% 						{apply_call, lib_guild_sit, guild_sit_start, 
%% 						 [Status#player.unid, Status#player.upst, Status#player.id, Status#player.nick, Type, Scene]}) of
%% 			error ->
%% 				0;
%% 			Result -> 
%% 				Result
%% 		end			
%% 	catch
%% 		_:_ -> 0
%% 	end.
%% 
%% %% -----------------------------------------------------------------
%% %% 打坐召唤
%% %% -----------------------------------------------------------------
%% guild_sit_call(Status) ->
%% 	try 
%% 		gen_server:cast(mod_guild:get_main_mod_guild_pid(),
%% 						{apply_cast, lib_guild_sit, member_call, 
%% 						 [Status#player.other#player_other.pid_send, 
%% 						  Status#player.unid, Status#player.upst, Status#player.nick]})		
%% 	catch
%% 		_:_ -> error
%% 	end. 
%% 
%% %% -----------------------------------------------------------------
%% %% 参与联盟打坐
%% %% -----------------------------------------------------------------
%% guild_sit_attend(Status, Type) ->
%% 	try 
%% 		gen_server:cast(mod_guild:get_main_mod_guild_pid(),
%% 						{apply_cast, lib_guild_sit, member_sit, 
%% 						 [Status#player.other#player_other.pid_send, Status#player.id,
%% 						  Type, Status#player.scn, Status#player.unid]})		
%% 	catch
%% 		_:_ -> error
%% 	end. 
%% 
%% %% -----------------------------------------------------------------
%% %% 互动游戏
%% %% -----------------------------------------------------------------
%% interactive_sit_member(Status, PlayerId, Type, Ret) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_main_mod_guild_pid(), 
%% 						{apply_call, lib_guild_sit, interactive_sit_member, 
%% 						 [Status#player.id, Status#player.unid, Status#player.lv, Status#player.nick, PlayerId, Type, Ret]}) of
%% 			error ->
%% 				[0, 0, 0];
%% 			Result -> 
%% 				Result
%% 		end			
%% 	catch
%% 		_:_ -> [0, 0, 0]
%% 	end.
%% 
%% delete_member_sit(PlayerId, GuildId) ->
%% 	try 
%% 		gen_server:cast(mod_guild:get_main_mod_guild_pid(),
%% 						{apply_cast, lib_guild_sit, delete_member_sit, 
%% 						 [PlayerId, GuildId]})		
%% 	catch
%% 		_D ->
%% %%             io:format("~s mod_get_guild_sit_info [~p] \n ",[misc:time_format(now()),[_D]]),
%% 			error
%% 	end. 
%% 	
%% %% -----------------------------------------------------------------
%% %% 获取旗帜详细信息
%% %% -----------------------------------------------------------------
%% get_guild_sit_info(Status, GuildName) ->
%% 	try 
%% 		gen_server:cast(mod_guild:get_main_mod_guild_pid(),
%% 						{apply_cast, lib_guild_sit, get_guild_sit_info, 
%% 						 [Status#player.other#player_other.pid_send, Status#player.id,
%% 						  GuildName, Status#player.scn, Status#player.unid]})		
%% 	catch
%% 		_D ->
%% %%             io:format("~s mod_get_guild_sit_info [~p] \n ",[misc:time_format(now()),[_D]]),
%% 			error
%% 	end. 
%% 
%% %%　围观战旗
%% congested_guild_sit(Status, GuildName, Type) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_main_mod_guild_pid(), 
%% 						{apply_call, lib_guild_sit, congested_guild_sit, 
%% 						 [Status#player.id, Status#player.unid, Status#player.lv, Status#player.scn, GuildName, Type]}) of
%% 			error ->
%% 				[0, 0];
%% 			Result -> 
%% 				Result
%% 		end			
%% 	catch
%% 		_:_ -> [0, 0]
%% 	end.
%% 
%% %% 更新玩家的联盟玉牌
%% update_guild_member_jade(GuildId, Uid, Money, Kind, Type, ExchangeTid) ->
%% 	gen_server:cast(mod_guild:get_mod_guild_pid(), {'update_guild_member_jade', GuildId, Uid, Money, Kind, Type, ExchangeTid}).
%% 
%% %% -----------------------------------------------------------------
%% %% 联盟商店兑换商品
%% %% -----------------------------------------------------------------
%% exchange_guild_goods(PlayerStatus, GoodsTid) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild, exchange_guild_goods, [PlayerStatus, GoodsTid]}) of
%% 			 error -> 
%% 				 [0, 0];
%% 			 Data -> 
%% 				 Data
%% 		end	
%% 	catch
%% 		_:_Reason -> 
%% 			[0, 0]
%% 	end.	
%% 
%% %% -----------------------------------------------------------------
%% %% 40061 联盟商店兑换记录
%% %% -----------------------------------------------------------------
%% get_exchange_log(Unid) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild, get_exchange_log, [Unid]}) of
%% 			 error -> 
%% 				 [];
%% 			 Data -> 
%% 				 Data
%% 		end	
%% 	catch
%% 		_:_Reason -> 
%% 			[]
%% 	end.	
%% 	
%% %% -----------------------------------------------------------------
%% %% 40062 联盟称号升级
%% %% -----------------------------------------------------------------
%% upgrade_guild_title(Uid) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild, upgrade_guild_title, [Uid]}) of
%% 			 error -> 
%% 				 [];
%% 			 Data -> 
%% 				 Data
%% 		end	
%% 	catch
%% 		_:_Reason -> 
%% 			[]
%% 	end.
%% 
%% %% -----------------------------------------------------------------
%% %% 40034 联盟称号升级
%% %% -----------------------------------------------------------------
%% get_guild_beast(Status) ->
%% 	if 
%% 		Status#player.unid =:= 0 ->
%% 			[0, 0, 0, []];
%% 		true ->
%% 			try 
%% 				case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 									 {apply_call, lib_guild, get_guild_beast, [Status#player.unid]}) of
%% 					error -> 
%% 						[0, 0, 0, []];
%% 					Data -> 
%% 						Data
%% 				end	
%% 			catch
%% 				_:_Reason -> 
%% 					[0, 0, 0, []]
%% 			end
%% 	end.
%% 
%% %% -----------------------------------------------------------------
%% %% 40035 升级联盟神兽
%% %% -----------------------------------------------------------------
%% upgrade_guild_beast(PlayerId, GuildId) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_main_mod_guild_pid(), 
%% 							 {apply_call, lib_guild, upgrade_guild_beast, [PlayerId, GuildId]}) of
%% 			error -> 
%% 				[0, 0, 0];
%% 			Data -> 
%% 				Data
%% 		end	
%% 	catch
%% 		_:_Reason -> 
%% 			[0, 0, 0]
%% 	end.
%% 
%% %% -----------------------------------------------------------------
%% %% 40036 联盟技能研究
%% %% -----------------------------------------------------------------
%% upgrade_guild_skill(PlayerId, GuildId, SkillId) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_main_mod_guild_pid(), 
%% 							 {apply_call, lib_guild, upgrade_guild_skill, [PlayerId, GuildId, SkillId]}) of
%% 			error -> 
%% 				[0, 0, 0];
%% 			Data -> 
%% 				Data
%% 		end	
%% 	catch
%% 		_:_Reason -> 
%% 			[0, 0, 0]
%% 	end.
%% 
%% %% -----------------------------------------------------------------
%% %% 40037 获取自己的联盟技能信息
%% %% -----------------------------------------------------------------
%% get_member_skill(PlayerId) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 							 {apply_call, lib_guild, get_member_skill, [PlayerId]}) of
%% 			error -> 
%% 				[0, 0, []];
%% 			Data -> 
%% 				Data
%% 		end	
%% 	catch
%% 		_:_Reason -> 
%% 			[0, 0, []]
%% 	end.
%% 
%% upgrade_member_skill(PlayerId, GuildId, SkillId) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 							 {apply_call, lib_guild, upgrade_member_skill, [PlayerId, GuildId, SkillId]}) of
%% 			error -> 
%% 				[0, 0, 0, 0];
%% 			Data -> 
%% 				Data
%% 		end	
%% 	catch
%% 		_:_Reason -> 
%% 			[0, 0, 0, 0]
%% 	end.
%% 
%% get_member_skill_buf(PlayerId) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 							 {apply_call, lib_guild, get_member_skill_buf, [PlayerId]}) of
%% 			error -> 
%% 				[0, []];
%% 			Data -> 
%% 				Data
%% 		end	
%% 	catch
%% 		_:_Reason -> 
%% 			[0, []]
%% 	end.
%% 
%% upgrade_guild_depot(PlayerId, GuildId) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_main_mod_guild_pid(), 
%% 							 {apply_call, lib_guild, upgrade_guild_depot, [PlayerId, GuildId]}) of
%% 			error -> 
%% 				[0, 0, 0];
%% 			Data -> 
%% 				Data
%% 		end	
%% 	catch
%% 		_:_Reason -> 
%% 			[0, 0, 0]
%% 	end.
%% 
%% get_guild_flag_info(PlayerId, GuildId) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 							 {apply_call, lib_guild, get_guild_flag_info, [PlayerId, GuildId]}) of
%% 			error -> 
%% 				[0, 0, 0, 0];
%% 			Data -> 
%% 				Data
%% 		end	
%% 	catch
%% 		_:_Reason -> 
%% 			[0, 0, 0, 0]
%% 	end.
%% 
%% upgrade_guild_flag(Status, Num) ->
%% 	if 
%% 		Status#player.viplv < 1 ->
%% 			Ret = 4;            
%% 		Num < 1 ->
%% 			Ret = 0;
%% 		true ->
%% 			IsEnghGold = goods_util:is_enough_money(Status, Num, gold),
%% 			if
%% 				IsEnghGold =/= true ->
%% 					Ret = 5;
%% 				true -> 
%% 					Ret = 1
%% 			end
%% 	end,
%% 	
%% 	case Ret of
%% 		1 ->
%% 			try 
%% 				case gen_server:call(mod_guild:get_main_mod_guild_pid(), 
%% 									 {apply_call, lib_guild, upgrade_guild_flag, [Status#player.id, Status#player.unid, Num]}) of
%% 					error -> 
%% 						[0, 0, 0, 0, 0, 0];
%% 					Data -> 
%% 						Data
%% 				end	
%% 			catch
%% 				_:_Reason -> 
%% 					[0, 0, 0, 0, 0, 0]
%% 			end;
%% 		_ ->
%% 			[Ret, 0, 0, 0, 0, 0]
%% 	end.
%% 
%% %% -----------------------------------------------------------------
%% %% 获取退盟冷切时间和联盟旗帜buf
%% %% -----------------------------------------------------------------
%% get_guild_flag_buf(PlayerId, GuildId) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 							 {apply_call, lib_guild, get_guild_flag_buf, [PlayerId, GuildId]}) of
%% 			error -> 
%% 				[0, []];
%% 			Data -> 
%% 				Data
%% 		end	
%% 	catch
%% 		_:_Reason -> 
%% 			[0, []]
%% 	end.
%% 
%% %% 获取联盟增加的属性
%% get_guild_add_attr(PlayerId) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 							 {apply_call, lib_guild, get_guild_add_attr, [PlayerId]}) of
%% 			error -> 
%% 				[];
%% 			Data -> 
%% 				Data
%% 		end	
%% 	catch
%% 		_:_Reason -> 
%% 			[]
%% 	end.
%% 
%% %% 获取所有联盟的战力信息
%% %% 返回格式[{联盟总战力,联盟信息}....]
%% %% [{Force, Guild}...]
%% get_guilds_force() ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 							 {apply_call, lib_guild, get_guilds_force, []}) of
%% 			error -> 
%% 				[];
%% 			Data -> 
%% 				Data
%% 		end	
%% 	catch
%% 		_:_Reason -> 
%% 			[]
%% 	end.
%% 
%% get_guild_force(GuildId) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 							 {apply_call, lib_guild, get_guild_force, [GuildId]}) of
%% 			error -> 
%% 				[];
%% 			Data -> 
%% 				Data
%% 		end	
%% 	catch
%% 		_:_Reason -> 
%% 			[]
%% 	end.
%% 
%% %% 清联盟CD
%% clear_guild_cd(GuildId) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_main_mod_guild_pid(), 
%% 							 {apply_call, lib_guild, clear_guild_cd, [GuildId]}) of
%% 			error -> 
%% 				0;
%% 			Data -> 
%% 				Data
%% 		end	
%% 	catch
%% 		_:_Reason -> 
%% 			0
%% 	end.
%% 
%% get_guild_level(GuildId) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 							 {apply_call, lib_guild, get_guild_level, [GuildId]}) of
%% 			error -> 
%% 				0;
%% 			Data -> 
%% 				Data
%% 		end	
%% 	catch
%% 		_:_Reason -> 
%% 			0
%% 	end.
%% 
%% 
%% %% @spec 查询旗帜战利品
%% query_grabed_flag(GuildId) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild, query_grabed_flag, [GuildId]})	of
%% 			 error -> 
%% 				 [0, []];
%% 			 Data -> 
%% 				 Data
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			[0, []]
%% 	end.
%% 
%% %% @spec 查询自己旗帜状态
%% query_flag_state(GuildId) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild, query_flag_state, [GuildId]})	of
%% 			 error -> 
%% 				 [0,0,"",0,"",0,0,0,""];
%% 			 Data -> 
%% 				 Data
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			[0,0,"",0,"",0,0,0,""]
%% 	end.
%% 
%% %% @spec 委任守护者
%% auth_guard(UId,GuildId,GUId) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild, auth_guard, [UId,GuildId,GUId]})	of
%% 			 error -> 
%% 				 [0,""];
%% 			 Data -> 
%% 				 Data
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			[0,""]
%% 	end.
%%   
%% %% @spec 联盟排名
%% query_flag_rank(Page) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild, query_flag_rank, [Page]})	of
%% 			 error -> 
%% 				 [];
%% 			 Data -> 
%% 				 Data
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			[]
%% 	end.
%%  
%% %% @spec 查询可使用的技能
%% query_skills(GuildId,UId) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild, query_skills, [GuildId,UId]})	of
%% 			 error -> 
%% 				 [];
%% 			 Data -> 
%% 				 Data
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			[]
%% 	end.
%% 	
%% %% @spec 使用技能
%% pick_skill(GuildId,UId,SkillId) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild, pick_skill, [GuildId,UId,SkillId]})	of
%% 			 error -> 
%% 				 [0,[]];
%% 			 Data -> 
%% 				 Data
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			[0,[]]
%% 	end.	
%% 	
%% %% @spec 抢旗
%% loot_flag(LUId,LGuildId,LBattleRecord,RGuildId) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild, loot_flag, [LUId,LGuildId,LBattleRecord,RGuildId]})	of
%% 			 error -> 
%% 				 [0,[],[],<<>>];
%% 			 Data -> 
%% 				 Data
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			[0,[],[],<<>>]
%% 	end.	
%% 	
%% 	
%% %% @spec 夺旗
%% retake_flag(LUId,LGuildId,LBattleRecord,RGuildId) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild, retake_flag, [LUId,LGuildId,LBattleRecord,RGuildId]})	of
%% 			 error -> 
%% 				 [0,[],<<>>];
%% 			 Data -> 
%% 				 Data
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			[0,[],<<>>]
%% 	end.
%% 	
%% %% @spec 开旗帜容量
%% add_flag_volumn(GuildId,End) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild, add_flag_volumn, [GuildId,End]})	of
%% 			 error -> 
%% 				 [0];
%% 			 Data -> 
%% 				 Data
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			[0]
%% 	end.
%%   
%% %% @spec 查询排行榜
%% query_rank(GuildId,Type) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild, query_rank, [GuildId,Type]})	of
%% 			 error -> 
%% 				 [0,[]];
%% 			 Data -> 
%% 				 Data
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			[0,[]]
%% 	end.
%%   
%%   
%% %% @spec 赎回旗帜
%% redeem_flag(GuildId) ->
%% 	try 
%% 		case gen_server:call(mod_guild:get_mod_guild_pid(), 
%% 						{apply_call, lib_guild, redeem_flag, [GuildId]})	of
%% 			 error -> 
%% 				 [0];
%% 			 Data -> 
%% 				 Data
%% 		end			
%% 	catch
%% 		_:_Reason -> 
%% 			[0]
%% 	end.
%% 	
%% 	
%% 	
%% 	
%% 	
%% 	
%% 	
%% 	
%% 	
%% 	
%% 	
%% 	
%% 	
%% 	
	