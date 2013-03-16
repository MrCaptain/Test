%%%-----------------------------------
%%% @Module  : mod_dungeon
%%% @Author  : csj
%%% @Created : 2010.10.05
%%% @Description: 副本
%%%-----------------------------------
-module(mod_dungeon).
-behaviour(gen_server).

%% 		临时处理
%% 
%% 
%% %% Include files
%% -include("common.hrl").
%% -include("record.hrl").
%% -include_lib("stdlib/include/ms_transform.hrl").
%% 
%% %% External exports
%% -compile([export_all]).
%% 
%% %% gen_server callbacks
%% -export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
%% 
%% -record(state, {
%% 	dungeon_scene_id = 0,					%% 副本唯一id
%% 	scene_id = 0,							%% 场景原始id	
%%     pid_team = 0,							%% 队伍进程Pid
%%     dungeon_role_list = [],   				%% 副本服务器内玩家列表
%%     dungeon_scene_requirement_list = [], 	%% 副本场景激活条件
%%     dungeon_scene_list =[],    				%% 副本服务器所拥有的场景
%% 	boss_number = 0							%% 本副本内BOSS个数
%% }).
%% 
%% -record(dungeon_role,  {id, pid}).
%% -record(dungeon_scene, {id, did, sid, enable=true, tip = <<>>}).
%% 
%% %% 定时器1间隔时间(定时检查角色进程, 如果不在线，则送出副本)
%% -define(TIMER_1, 10*60*1000).
%% 
%% %% ----------------------- 对外接口 ---------------------------------
%% %% 进入副本
%% check_enter(SceneResId, SceneType, ScPid) ->
%% 	case catch gen:call(ScPid, '$gen_call', {check_enter, SceneResId, SceneType}, 5000) of
%% 		{'EXIT', _Reason} ->
%% 			{false, <<"系统繁忙，请稍候重试！">>};
%% 		{ok, Result} ->
%% 			Result
%% 	end.
%% 
%% %% 创建副本进程，由lib_scene调用
%% start(Pid_team, From, SceneId, RoleList) ->
%%     {ok, Pid_dungeon} = gen_server:start(?MODULE, [Pid_team, SceneId, RoleList], []),
%%     [spawn(fun()->clear(Player_Pid_dungeon)end) || {_Id, _Player_Pid, Player_Pid_dungeon} <- RoleList],
%%     [spawn(fun()->mod_player:set_dungeon(Rpid, Pid_dungeon)end) || {_, Rpid, _} <- RoleList, Rpid =/= From],
%%     {ok, Pid_dungeon}.
%% 
%% %% 主动加入新的角色
%% join(Pid_dungeon, PlayerInfo) ->
%% 	%%call进程已经有处理 modify hzj
%% 	%%[_Sceneid, _PlayerId, _Player_Pid, Player_Pid_dungeon] = PlayerInfo,
%%     %%clear(Player_Pid_dungeon),
%%     case misc:is_process_alive(Pid_dungeon) of
%%         false -> false;
%%         true -> gen_server:call(Pid_dungeon, {join, PlayerInfo})
%%     end.
%% 
%% %% 从副本清除角色(Type=0, 则不回调设置)
%% quit(Pid_dungeon, Rid, Type) ->
%%     case misc:is_process_alive(Pid_dungeon) of
%%         false -> false;
%%         true -> Pid_dungeon ! {quit, Rid, Type}
%%     end.
%% 
%% %% 清除副本进程
%% clear(Pid_dungeon) ->
%%     case misc:is_process_alive(Pid_dungeon) of
%%         false -> false;
%%         true -> Pid_dungeon ! role_clear
%%     end.
%% 
%% %% 设置副本的pid_team
%% set_team_pid(Pid_dungeon, Pid_team) ->
%%     case misc:is_process_alive(Pid_dungeon) of
%%         false -> false;
%%         true -> Pid_dungeon ! {set_team, Pid_team}
%%     end.	
%%   
%% %% 获取玩家所在副本的外场景
%% get_outside_scene(SceneId) ->
%%     case get_dungeon_id(lib_scene:get_res_id(SceneId)) of
%%         0 -> false;  %% 不在副本场景
%%         Did ->  %% 将传送出副本
%%             DD = data_agent:dungeon_get(Did),
%%             [Did, DD#dungeon.out]
%%     end.
%% 
%% %% 副本杀怪
%% kill_mon(Scene, Pid_dungeon, MonIdList) ->
%%             case misc:is_process_alive(Pid_dungeon) of
%%                 false -> ok; %% TODO 异常暂时不处理
%%                 true -> Pid_dungeon ! {kill_mon, Scene, MonIdList}
%%     end.
%% 
%% %% 副本杀怪
%% check_alive(Pid_dungeon, Num) ->
%% 	case misc:is_process_alive(Pid_dungeon) of
%% 		false -> ok; %% TODO 异常暂时不处理
%% 		true -> Pid_dungeon ! {check_alive, Num}
%%     end.
%% 
%% %% 创建副本场景
%% create_dungeon_scene(SceneId, _SceneType, State) ->
%% 	 %% 获取唯一副本场景id
%%     UniqueId = get_unique_dungeon_id(SceneId),
%% 	
%% 	SceneProcessName = misc:create_process_name(scene_p, [UniqueId, 0]),
%% 	misc:register(global, SceneProcessName, self()),
%% 	
%%     lib_scene:copy_scene(UniqueId, SceneId),  %% 复制场景
%% 	MS = ets:fun2ms(fun(T) when (T#ets_mon.type =:= 3 orelse T#ets_mon.type =:= 5), T#ets_mon.scn =:= UniqueId ->
%% 							T
%% 					end),		
%% 	L = ets:select(?ETS_SCENE_MON, MS),	
%% 	Boss_number = length(L),				%% 本副本内BOSS个数
%%     F = fun(DS) ->
%%         case DS#dungeon_scene.sid =:= SceneId of
%%             true -> DS#dungeon_scene{id = UniqueId};
%%             false -> DS
%%         end
%%     end,
%%     NewState = State#state{boss_number = Boss_number,
%% 						   dungeon_scene_id = UniqueId,
%% 						   dungeon_scene_list = [F(X)|| X <- State#state.dungeon_scene_list]},    %% 更新副本场景的唯一id
%% 	
%% 	misc:write_monitor_pid(self(),?MODULE, {SceneId}),
%%     {UniqueId, NewState}.
%% 
%% %% 组织副本的基础数据
%% get_dungeon_data([], Dungeon_scene_requirement, Dungeon_scene) ->
%%     {Dungeon_scene_requirement, Dungeon_scene};
%% get_dungeon_data(Dungeon_id_list, Dungeon_scene_requirement, Dungeon_scene) ->
%%     [Dungeon_id | NewDungeon_id_list] = Dungeon_id_list,
%%     Dungeon = data_agent:dungeon_get(Dungeon_id),
%%     Dungeon_scene_0 = [#dungeon_scene{id=0, did=Dungeon_id, sid=Sid, enable=Enable, tip=Msg} 
%% 						|| {Sid, Enable, Msg} <- Dungeon#dungeon.scn],
%%     get_dungeon_data(NewDungeon_id_list, 
%% 					 Dungeon_scene_requirement ++ Dungeon#dungeon.requirement, 
%% 					 Dungeon_scene ++ Dungeon_scene_0).
%% 
%% %% 获取副本信息
%% get_info(UniqueId) ->
%% 	SceneProcessName = misc:create_process_name(scene_p, [UniqueId, 0]),
%% 	case misc:whereis_name({global, SceneProcessName}) of
%% 		Pid when is_pid(Pid) ->	
%% 			gen_server:call(Pid, {info});
%% 		_-> no_alive
%% 	end.
%% 
%% %% ------------------------- 服务器内部实现 ---------------------------------
%% %% --------------------------------------------------------------------
%% %% Function: init/1
%% %% Description: Initiates the server
%% %% Returns: {ok, State}          |
%% %%          {ok, State, Timeout} |
%% %%          ignore               |
%% %%          {stop, Reason}
%% %% --------------------------------------------------------------------
%% init([Pid_team, SceneId, RoleList]) ->
%%     Role_list = [#dungeon_role{id=Role_id, pid=Role_pid} || {Role_id, Role_pid, _Player_Pid_dungeon} <- RoleList],
%%     {Dungeon_scene_requirement_list, Dungeon_scene_list} = 
%% 		get_dungeon_data([SceneId], [], []),
%%     State = #state{
%% 		scene_id = SceneId,
%%         pid_team = Pid_team,
%%         dungeon_role_list = Role_list,
%%         dungeon_scene_requirement_list = Dungeon_scene_requirement_list,
%%         dungeon_scene_list = Dungeon_scene_list
%%     },
%% 	erlang:send_after(?TIMER_1, self(), check_role_pid),
%% 	misc:write_monitor_pid(self(),?MODULE, {State}),
%%     {ok, State}.
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
%% %%检查进入副本
%% handle_call({check_enter, SceneResId, SceneType}, _From, State) ->   %% 这里的SceneId是数据库的里的场景id，不是唯一id
%%     case lists:keyfind(SceneResId, 4, State#state.dungeon_scene_list) of
%%         false ->
%%             {reply, {false, <<"没有这个副本场景">>}, State};   %%没有这个副本场景
%%         Dungeon_scene ->
%%             case Dungeon_scene#dungeon_scene.enable of
%%                 false ->
%%                     {reply, {false, Dungeon_scene#dungeon_scene.tip}, State};    %%还没被激活
%%                 true ->
%%                     {SceneUniqueId, NewState} = 
%% 									case Dungeon_scene#dungeon_scene.id =/= 0 of
%%                         				true -> 
%% 											{Dungeon_scene#dungeon_scene.id, State};   %%场景已经加载过
%%                         				_ -> 
%% 											create_dungeon_scene(SceneResId, SceneType, State)
%%                     				end,
%% 					misc:write_monitor_pid(self(),?MODULE, {NewState}),
%%                     {reply, {true, SceneUniqueId}, NewState}
%%             end
%%     end;
%% 
%% %% 加入副本服务
%% handle_call({join, PlayerInfo}, _From, State) ->
%% 	[_Sceneid, PlayerId, Player_Pid, Player_Pid_dungeon] = PlayerInfo,
%%     clear(Player_Pid_dungeon),  %% 清除上个副本服务进程
%%     case lists:keyfind(PlayerId, 2, State#state.dungeon_role_list) of
%%         false -> 
%%             NewRL = State#state.dungeon_role_list ++ [#dungeon_role{id = PlayerId, pid = Player_Pid}],
%% 			NewState = State#state{dungeon_role_list = NewRL},
%% 			misc:write_monitor_pid(self(),?MODULE, {NewState}),
%%             {reply, true, NewState};
%% 		_ -> 
%% 			{reply, true, State}
%%     end;
%% 
%% %% 初始化时，如在副本，则加入副本服务
%% handle_call({join_init, PlayerInfo}, _From, State) ->
%% 	[PlayerId, Player_Pid] = PlayerInfo,
%%     case lists:keyfind(PlayerId, 2, State#state.dungeon_role_list) of
%%         false -> 
%%             Rl = State#state.dungeon_role_list;
%% 		_ -> 
%% 			Rl = lists:keydelete(PlayerId, 2, State#state.dungeon_role_list)
%%     end,
%%     NewRL = Rl ++ [#dungeon_role{id = PlayerId, pid = Player_Pid}],
%% 	NewState = State#state{dungeon_role_list = NewRL},
%% 	misc:write_monitor_pid(self(),?MODULE, {NewState}),
%% 	{reply, true, NewState};
%% 
%% %% 获取副本信息
%% handle_call({info}, _From, State) ->
%% 	{reply, State, State};
%% 
%% %% 获取副本场景ID
%% handle_call({info_id}, _From, State) ->
%% 	{reply, State#state.scene_id, State};
%% 
%% %% 统一模块+过程调用(call)
%% handle_call({apply_call, Module, Method, Args}, _From, State) ->
%% %% %% ?DEBUG("mod_dungeon_apply_call: [~p/~p/~p]", [Module, Method, Args]),	
%% 	Reply  = 
%% 	case (catch apply(Module, Method, Args)) of
%% 		 {'EXIT', Info} ->	
%% 			 ?WARNING_MSG("mod_dungeon_apply_call error: Module=~p, Method=~p, Reason=~p",[Module, Method,Info]),
%% 			 error;
%% 		 DataRet -> DataRet
%% 	end,
%%     {reply, Reply, State};
%% 
%% handle_call(_Request, _From, State) ->
%%     {noreply, State}.
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
%% %% 	%% ?DEBUG("mod_dungeon_apply_cast: [~p/~p/~p]", [Module, Method, Args]),	
%% 	case (catch apply(Module, Method, Args)) of
%% 		 {'EXIT', Info} ->	
%% 			 ?WARNING_MSG("mod_dungeon_apply_cast error: Module=~p, Method=~p, Args =~p, Reason=~p",[Module, Method, Args, Info]),
%% 			 error;
%% 		 _ -> ok
%% 	end,
%%     {noreply, State};
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
%% %% 在副本里创建队伍，需要设置到副本进程
%% handle_info({set_team, Pid_team}, State) ->
%% 	NewState = State#state{pid_team = Pid_team},
%%   	{noreply, NewState};
%% 
%% %% 接收杀怪事件
%% handle_info({kill_mon, EventSceneId, MonIdList}, State) ->
%% %% 判断杀的怪是否有用
%% %% io:format("kill_mon:  ~p~n",[[EventSceneId, NpcIdList, State]]),	
%%     case lists:keyfind(EventSceneId, 2, State#state.dungeon_scene_list) of
%%         false -> {noreply, State};    %% 没有这个场景id
%%         _ ->
%% 			Kill_boss = lists:map(fun(MonId) ->
%% 								case ets:lookup(?ETS_BASE_MON, MonId) of
%% 									[] -> 0;
%% 									[Mon] ->
%% 										if Mon#ets_mon.type =:=3 orelse Mon#ets_mon.type =:=5 ->
%% 											   1;
%% 										   true -> 0
%% 										end
%% 								end
%% 						   end, 
%% 						   MonIdList),
%%             {NewDSRL, UpdateScene} = event_action(State#state.dungeon_scene_requirement_list, [], MonIdList, []),
%%             EnableScene = get_enable(UpdateScene, [], NewDSRL),
%%             NewState_1 = enable_action(EnableScene, State#state{dungeon_scene_requirement_list = NewDSRL}),
%% 			Kill_boss_number = lists:sum(Kill_boss),
%% 			Alive_boss_number = NewState_1#state.boss_number - Kill_boss_number,
%% 			NewState_2 = NewState_1#state{boss_number = Alive_boss_number},
%% 			misc:write_monitor_pid(self(),?MODULE, {NewState_2}),
%% %%	2010.11.15: 副本最后一个BOSS被击杀后, 不再进入1分钟倒计时。			
%% %% %% io:format("kill_mon_1_~p~n",[[Alive_boss_number, NewState_1]]),			
%% %% 			if Alive_boss_number =< 0 andalso State#state.boss_number > 0  ->	
%% %% %% io:format("kill_mon_2_~p~n",[[Alive_boss_number, NewState_1]]),				   
%% %% 				   erlang:send_after(1*60*1000, self(), {kill_self}),
%% %% 				   ok;
%% %% 			   true ->
%% %% 				   exist_boss
%% %% 			end,
%%             {noreply, NewState_2}
%%     end;
%% 
%% %% handle_info({kill_self}, State) ->
%% %%     F = fun(RX) -> 
%% %% 				case misc:is_process_alive(RX#dungeon_role.pid) of	
%% %%                 	true -> 
%% %%                     	send_out(RX#dungeon_role.pid, State#state.scene_id);
%% %% 					_-> offline   %% 不在线	
%% %%             	end				
%% %% 		end,
%% %%     [F(R)|| R <- State#state.dungeon_role_list],	
%% %% 	{stop, normal, State};
%% 
%% %% 将指定玩家传出副本
%% handle_info({quit, Rid, Type}, State) ->
%% %% io:format("dungeon_quit:/~p/ ~n", [length(State#state.dungeon_role_list)]),	
%%     case lists:keyfind(Rid, 2, State#state.dungeon_role_list) of
%%         false -> {noreply, State};
%%         Role ->
%% 			if Type > 0 ->
%% 				case misc:is_process_alive(Role#dungeon_role.pid) of
%%                 	true ->
%%                     	send_out(Role#dungeon_role.pid, State#state.scene_id);
%% 					_-> offline   %% 不在线	
%%             	end;
%% 			   true -> no_action
%% 			end,
%% 			NewState = State#state{dungeon_role_list = lists:keydelete(Rid, 2, State#state.dungeon_role_list)},
%% 			misc:write_monitor_pid(self(),?MODULE, {NewState}),
%%             {noreply, NewState}			
%%     end;
%% 
%% %% 清除角色, 关闭副本服务进程
%% handle_info(role_clear, State) ->
%% %% io:format("role_clear_0_~p ~n",[State#state.pid_team]),
%% 	case misc:is_process_alive(State#state.pid_team) of
%%         true -> %% 有组队
%% %% io:format("role_clear_1_~p ~n",[State#state.dungeon_role_list]),			
%%             case length(State#state.dungeon_role_list) >= 1 of  %% 判断副本是否没有人了
%%                 true ->
%% 					erlang:send_after(300, self(), {check_alive, 0}),
%%                     {noreply, State};
%%                 false ->
%%                     [spawn(fun()->lib_scene:clear_scene(Ds#dungeon_scene.id)end)|| 
%% 					   				Ds <- State#state.dungeon_scene_list, Ds#dungeon_scene.id =/= 0],
%% 					gen_server:cast(State#state.pid_team, {clear_dungeon}),
%%                     {stop, normal, State}
%%             end;
%%         false ->
%% %% io:format("role_clear_2_~p ~n",[State]),		
%% 			%% 非队伍副本，则需要清除相关 副本场景信息
%%             [spawn(fun()->lib_scene:clear_scene(Ds#dungeon_scene.id)end)|| 
%% 			   						Ds <- State#state.dungeon_scene_list, Ds#dungeon_scene.id =/= 0],
%%             {stop, normal, State}
%%     end;
%% 
%% %% 定时检查角色进程, 如果不在线，则送出副本
%% handle_info(check_role_pid, State) ->
%% 	NewRoleList = lists:filter(fun(Role)-> 
%% 									misc:is_process_alive(Role#dungeon_role.pid) 
%% 							   end, 
%% 				  			   State#state.dungeon_role_list),
%% 	case length(NewRoleList) >= 1 of
%% 		 true -> 
%% %% 			io:format("~s Here_check_dungeon.~n",[misc:time_format(now())]),			 
%% 			erlang:send_after(?TIMER_1, self(), check_role_pid),
%% 			NewState = State#state{dungeon_role_list = NewRoleList},
%% 			misc:write_monitor_pid(self(),?MODULE, {NewState}),
%% 			{noreply, NewState};			 
%% 		 _ -> %% 没有角色啦，则 清除副本
%% 			case misc:is_process_alive(State#state.pid_team) of
%%         		true -> %% 有组队, 通知队伍进程	
%% 					gen_server:cast(State#state.pid_team, {clear_dungeon});
%% 				_ -> no_action
%% 			end,
%% 			[spawn(fun()->lib_scene:clear_scene(Ds#dungeon_scene.id)end)||
%% 			   Ds <- State#state.dungeon_scene_list, Ds#dungeon_scene.id =/= 0],
%% 			{stop, normal, State}
%% 	end;
%% 
%% handle_info({check_alive, Num}, State) ->
%% 	NewRoleList = lists:filter(fun(Role)-> 
%% 									misc:is_process_alive(Role#dungeon_role.pid) 
%% 							   end, 
%% 				  			   State#state.dungeon_role_list),
%% 	case length(NewRoleList) > Num of
%% 		 true -> 
%% %% 			io:format("~s Here_check_dungeon.~n",[misc:time_format(now())]),			 
%% 			{noreply, State};			 
%% 		 _ -> %% 除了离线的人，没有其它队员在副本里
%% 			case misc:is_process_alive(State#state.pid_team) of
%%         		true -> %% 有组队, 通知队伍进程	
%% 					gen_server:cast(State#state.pid_team, {clear_dungeon});
%% 				_ -> no_action
%% 			end,
%% 			[spawn(fun()->lib_scene:clear_scene(Ds#dungeon_scene.id)end)||
%% 			   Ds <- State#state.dungeon_scene_list, Ds#dungeon_scene.id =/= 0],			
%% 			{stop, normal, State}
%% 	end;	
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
%% %% io:format("dungeon_exit ~n"),	
%% 	misc:delete_monitor_pid(self()),	
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
%% %% -----------------------------私有方法--------------------------------
%% %% 传送出副本
%% send_out(Pid, SceneId)  ->
%% 	Dungeon_data = data_agent:dungeon_get(SceneId), 
%% 	[NextSenceId, X, Y] = Dungeon_data#dungeon.out,
%% 	gen_server:cast(Pid, {send_out_dungeon, [NextSenceId, X, Y]}).
%% 
%% %% 类似格式： [[451, false, kill_mon, 30031, 10, 0],[452, false, kill_mon, 30032, 1, 0]]
%% event_action([], Req, _, Result) -> {Req, Result};
%% event_action(undefined, Req, _, Result) -> {Req, Result};
%% event_action([[EnableSceneResId, false, kill_mon, MonId, Num, NowNum] | T ], Req, Param, Result)->
%%     MonList = Param,
%%     case length([X||X <- MonList, MonId =:= X]) of
%%         0 -> event_action(T, [[EnableSceneResId, false, kill_mon, MonId, Num, NowNum] | Req], Param, Result);
%%         FightNum ->
%%             case NowNum + FightNum >= Num of
%%                 true -> 
%% 					event_action(T, [[EnableSceneResId, true, kill_mon, MonId, Num, Num] | Req], Param, lists:umerge(Result, [EnableSceneResId]));
%%                 false -> 
%% 					event_action(T, [[EnableSceneResId, false, kill_mon, MonId, Num, NowNum + FightNum] | Req], Param, lists:umerge(Result, [EnableSceneResId]))
%%             end
%%     end;
%% %% 丢弃异常和已完成的
%% event_action([_ | T], Req, Param, Result) ->
%%     event_action(T, Req, Param, Result).
%% 
%% get_enable([], Result, _) -> Result;
%% get_enable(undefined, Result, _) -> Result;
%% get_enable([SceneId | T ], Result, DSRL) ->
%%     case length([0 || [EnableSceneResId, Fin | _ ] <- DSRL, EnableSceneResId =:= SceneId, Fin =:= false]) =:= 0 of
%%         false -> get_enable(T, Result, DSRL);
%%         true -> get_enable(T, [SceneId | Result], DSRL)
%%     end.
%% 
%% enable_action([], State) -> State;
%% enable_action(undefined, State) -> State;
%% enable_action([SceneId | T], State) ->
%%     case lists:keyfind(SceneId, 4, State#state.dungeon_scene_list) of
%%         false -> enable_action(T, State);%%这里属于异常
%%         DS -> %% TODO 广播场景已激活
%%             NewDSL = lists:keyreplace(SceneId, 4, State#state.dungeon_scene_list, DS#dungeon_scene{enable = true}),
%%             enable_action(T, State#state{dungeon_scene_list = NewDSL})
%%     end.
%% 
%% %% 获取唯一副本场景id
%% get_unique_dungeon_id(SceneId) ->
%% 	case ?DB_MODULE of
%% 		db_mysql ->
%% 			gen_server:call(mod_rank:get_mod_rank_pid(), {dungeon_auto_id, SceneId});
%% 		_ ->
%% 			db_agent:get_unique_dungeon_id(SceneId)
%% 	end.
%% 
%% %% 用场景资源获取副本id
%% get_dungeon_id(SceneResId) ->
%%     F = fun(Dungeon_id, P) ->
%%         Dungeon = data_agent:dungeon_get(Dungeon_id),
%% 		 case lists:keyfind(SceneResId, 1, Dungeon#dungeon.scn) of
%%            		false -> P;
%%            		_ -> Dungeon_id
%%         end
%%     end,
%%     lists:foldl(F, 0, data_agent:dungeon_get_id_list()).
%% 
%% 
