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

-define(CLEAR_ONLINE_PLAYER, 10*60*1000).	  %% 每10分钟 对 ets_online 做一次清理

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
					
					lib_scene:load_scene(SceneId),
					misc:write_monitor_pid(self(),mod_scene, {SceneId, ?SCENE_WORKER_NUMBER}),
					%% 启动多个场景服务进程
					lists:foreach(fun(WorkerId) ->
										  SceneWorkerProcessName = misc:create_process_name(scene_p, [SceneId, WorkerId]),
										  
										  mod_scene:start_link({SceneId, SceneWorkerProcessName, WorkerId})
								  end,lists:seq(1, ?SCENE_WORKER_NUMBER)),
					erlang:send_after(?CLEAR_ONLINE_PLAYER, self(), {event, clear_online_player}) ;
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
			 ?WARNING_MSG("mod_scene_apply_call error: Module=~p, Method=~p, Reason=~p",[Module, Method,Info]),
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
%% 统一模块+过程调用(cast)
handle_cast({apply_cast, Module, Method, Args}, State) ->
%% 	?DEBUG("mod_scene_apply_cast: [~p/~p/~p]", [Module, Method, Args]),	
	case (catch apply(Module, Method, Args)) of
		 {'EXIT', Info} ->	
			 ?WARNING_MSG("mod_scene_apply_cast error: Module=~p, Method=~p, Args =~p, Reason=~p",[Module, Method, Args, Info]),
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


handle_info({event, clear_online_player}, State) ->
	MS = ets:fun2ms(fun(T) when T#player.scene =:= State#state.scnid -> 
					 [
					  T#player.id,
					  T#player.other#player_other.pid,
					  T#player.other#player_other.node
					 ]
					end),
%% 	lists:foreach(fun([Id, Pid, Node]) ->
%% 					case misc:is_process_alive(Pid) of
%% 						false ->
%% 							db_agent:update_online_flag(Id,0),
%% 							?WARNING_MSG("clear_online_player_/scene:~p/player_id:~p/pid:~p/node:~p/~n", 
%% 								 [State#state.scnid, Id, Pid, Node]),						
%% 							ets:delete(?ETS_ONLINE_SCENE, Id),
%% 							ets:delete(?ETS_ONLINE, Id);
%% 						_-> is_alive
%% 					end
%% 				end,
%% 			L),		  
	erlang:send_after(?CLEAR_ONLINE_PLAYER, self(), {event, clear_online_player}),
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
%%@spec 随机获取子场景ID,子场景ID下不必再有工作进程
get_scene_pid(SceneId) ->
	SubId = random:uniform(?SCENE_COPY_NUMBER) ,
	SubScnId = SceneId*100 + SubId ,
	SceneProcessName = misc:create_process_name(scene_p,[SubScnId, 0]),
	{ScenePid, _Worker_Pid} =
		case misc:whereis_name({global, SceneProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true ->
						case lib_scene:is_copy_scene(SceneId) of
							true ->
								{Pid, Pid};
                            false ->
                                WorkerId = random:uniform(?SCENE_WORKER_NUMBER),
                                SceneProcess_Name = misc:create_process_name(scene_p, [SceneId, WorkerId]),
                                {Pid, misc:whereis_name({global, SceneProcess_Name})}
						end;
					false -> 
						global:unregister_name(SceneProcessName),
						exit(Pid,kill),
						start_mod_scene_nosleep(SubScnId, SceneProcessName)
				end;					
			_ ->
				start_mod_scene_nosleep(SubScnId, SceneProcessName)
		end,
	{SubScnId,ScenePid}.


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
%% 	ScenePid = start_scene(SceneId, SceneProcessName, 2),
	Worker_Pid = ScenePid,
	global:del_lock({SceneProcessName, undefined}),
	{ScenePid, Worker_Pid}.

%%启动场景模块 (不延迟，作为第一次初始化场景之用)
start_mod_scene_nosleep(SceneId, SceneProcessName) ->
 	%%io:format("start_scene:____/~p ~n",[SceneId]),
	global:set_lock({SceneProcessName, undefined}),
	ScenePid = start_scene(SceneId, SceneProcessName,2),
	Worker_Pid = ScenePid,
	io:format("start_scene:____/~p /~p ~n",[SceneId,SceneProcessName]),
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
%% 	io:format("start_scene:____/~p/~p/~p/ ~n",[SceneId, SceneProcessName, _Source]),	
	Pid =
		case mod_scene:start({SceneId, SceneProcessName, 0}) of
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

%% 根据基本ID批量启动场景模块
start_scene_by_baseId(Sid, NodeId) ->
	start_scene_one(Sid, NodeId, 1).

%% 启动单个场景
start_scene_one(_Sid, _NodeId, ?SCENE_COPY_NUMBER + 1) ->
	skip;
start_scene_one(Sid, NodeId, SubId) ->
%% 	case SubId rem 5 =:= NodeId rem 5 of
%% 		true ->
%% 			SceneId = Sid * 100 + SubId,
%% 			SceneProcessName = misc:create_process_name(scene_p,[SceneId, 0]),
%% 			start_mod_scene_nosleep(SceneId, SceneProcessName);
%% 		_ ->
%% 			skip
%% 	end,
	SceneId = Sid * 100 + SubId,
	SceneProcessName = misc:create_process_name(scene_p,[SceneId, 0]),
	start_mod_scene_nosleep(SceneId, SceneProcessName), 
	start_scene_one(Sid, NodeId, SubId + 1).

%% 获取某一场景的所有Npc
get_scene_ele(SceneId) ->
	try  
%% io:format("get_scene_pid_9_ /~p/ ~n",[SceneId]),		
		gen_server:call(mod_scene:get_scene_pid(SceneId, undefined, undefined), 
				 {apply_call, lib_scene, get_scene_ele, [SceneId]})			
	catch
		_:_ -> []
	end.

%% %% 寻找一个唯一编码为UniqueId的npc
%% find_npc(UniqueId, SceneId) ->
%% 	try  
%% %% io:format("get_scene_pid_10_ /~p/ ~n",[SceneId]),		
%% 		gen_server:call(mod_scene:get_scene_pid(SceneId, undefined, undefined), 
%% 				 {apply_call, lib_npc, get_npc, [UniqueId, SceneId]})			
%% 	catch
%% 		_:_ -> []
%% 	end.
%% 
%% %% 获得NPC唯一id
%% get_npc_unique_id(NpcId, SceneId) ->
%% 	try  
%% %% io:format("get_scene_pid_11_ /~p/ ~n",[SceneId]),		
%% 		gen_server:call(mod_scene:get_scene_pid(SceneId, undefined, undefined), 
%% 				 {apply_call, lib_npc, get_unique_id, [NpcId, SceneId]})			
%% 	catch
%% 		_:_ -> 0
%% 	end.

%% %% 在场景中， 放置一个掉落物
%% put_mon_drop_in_scene(PidScene, DropInfo) ->
%% 	try 
%% 		gen_server:cast(PidScene, {apply_cast, ets, insert, [?ETS_GOODS_DROP, DropInfo]})	
%% 	catch
%% 		_:_ -> {fail, no_drop}
%% 	end.
%% 
%% %% 在场景中， 获取一个掉落物
%% get_mon_drop_in_scene(PidScene, DropId) ->
%% 	try 
%% 		gen_server:call(PidScene, {apply_call, goods_util, get_ets_info, [?ETS_GOODS_DROP, DropId]}, 2000)	
%% 	catch
%% 		_:_ -> {fail, no_drop}
%% 	end.
%% 
%% %% 在场景中，删除一个掉落物
%% del_mon_drop_in_scene(PidScene, DropId) ->
%% 	try 
%% 		gen_server:cast(PidScene, {apply_cast, ets, delete, [?ETS_GOODS_DROP, DropId]})	
%% 	catch
%% 		_:_ -> {fail, no_drop}
%% 	end.

%% %% 玩家复活
%% revive_to_scene(Status, ReviveType) ->
%% 	try  
%% %% io:format("get_scene_pid_12_ /~p/ ~n",[Status#player.scn]),			
%% 		gen_server:call(mod_scene:get_scene_pid(Status#player.scn, 
%% 															   Status#player.other#player_other.pid_scene, 
%% 															   Status#player.other#player_other.pid), 
%% 				 {apply_call, lib_scene, revive_to_scene, [Status, ReviveType]})			
%% 	catch
%% 		_:_ -> fail
%% 	end.	

%%同步场景用户状态
%% update_player(Status) ->
%% 	try  
%% 		gen_server:cast(mod_scene:get_scene_pid(Status#player.scn, 
%% 															   Status#player.other#player_other.pid_scene, 
%% 															   Status#player.other#player_other.pid), 
%% 				 {apply_cast, ets, insert, [?ETS_ONLINE_SCENE, Status]})	
%% 	catch
%% 		_:_ -> fail
%% 	end.
%% 
%% %%同步场景用户状态- key-value 形式
%% update_player_info_fields(Status,ValueList) ->
%% 	try  
%% 		gen_server:cast(mod_scene:get_scene_pid(Status#player.scn, 
%% 															   Status#player.other#player_other.pid_scene, 
%% 															   Status#player.other#player_other.pid), 
%% 				 {apply_cast,lib_scene,update_player_info_fields,[Status#player.id,ValueList]})	
%% 	catch
%% 		_:_ -> fail
%% 	end.
%% 更新玩家的坐标信息
%% update_player_position(Player) ->
%% 	try  
%% 		gen_server:cast(mod_scene:get_scene_pid(Player#player.scn, 
%% 				Player#player.other#player_other.pid_scene, Player#player.other#player_other.pid), 
%% 					{apply_cast, lib_scene, update_player_position, [Player#player.id, Player#player.x, Player#player.y, Player#player.stts]})	
%% 	catch
%% 		_:_ -> fail
%% 	end.

%% 获取场景基本信息
get_scene_info(SceneId, Pid_scene, Pid_player, X, Y, PlayerId) ->
	try  
		ScenePid = mod_scene:get_scene_pid(SceneId, Pid_scene, Pid_player), 
		Ret = gen_server:call(ScenePid, {apply_call, lib_scene, get_scene_info, [SceneId, X, Y, PlayerId]}),
		%io:format("~s mod_player_start_get_scene_info[~p][~p]\n",[misc:time_format(now()), Ret, ScenePid]),
		{ok, ScenePid, Ret}
	catch
		_:_ -> []
	end.

%% @spec 玩家进入场景
enter_scene(BaseScene,Status) ->
	try  
		{SubScnId,ScenePid} = mod_scene:get_scene_pid(BaseScene) ,
		PlayerOther = Status#player.other#player_other{pid_scene = ScenePid} ,
		NewPlayer = Status#player{scene = SubScnId,other=PlayerOther} ,
		ets:insert(?ETS_ONLINE, NewPlayer) ,
		gen_server:cast(ScenePid, {apply_cast, lib_scene, enter_scene, [SubScnId,ScenePid,Status]}) ,
		{ok,ScenePid,SubScnId,NewPlayer}
	catch
		_:_ -> []
	end.

%% @spec 用户退出场景
leave_scene(Pid_scene, PlayerId) ->
	try  
		gen_server:cast(Pid_scene, {apply_cast, lib_scene, leave_scene, [PlayerId]})
	catch
		_:_ -> 
			fail
	end.


%% 获取场景元素(玩家，NPC，怪物)
get_scene_elem(PIdScene, SceneId) ->
	try  
		gen_server:call(PIdScene, {apply_call, lib_scene, get_scene_elem, [SceneId]})
	catch
		_:_ -> [[],[],[]]
	end.

%% 同步玩家的目的位置
update_postion(PIdScene,Status,DestX,DestY) ->
	try  
		gen_server:cast(PIdScene, {apply_cast, lib_scene, update_postion, [Status,DestX,DestY]})
	catch
		_:_ -> 
			fail
	end.
  	
%%用户进入场景
%% enter_scene(Pid_scene, Status) ->
%% 	%%io:format("~s enter_scene********************[~p][~p]\n",[misc:time_format(now()), Pid_scene, Status]),
%% 	try  
%% %% 		case get(player_mnt_sts) of
%% %% 			{1, MntIconId} ->   %%有坐骑，将坐骑ID转换为坐骑形象ID
%% %% 				Status1 = Status#player{mnt = MntIconId};
%% %% 			_R ->
%% %% 				Status1 = Status#player{mnt = 0}
%% %% 		end,
%% 		gen_server:cast(Pid_scene, {apply_cast, lib_scene, enter_scene, [Status]})
%% 	catch
%% 		_:_ -> fail
%% 	end.	

	

%%用户进入联盟场景
enter_scene_union(Pid_scene, Status) ->
	try  
		gen_server:cast(Pid_scene, {apply_cast, lib_scene, enter_scene_union, [Status]})
	catch
		_:_ -> fail
	end.	

%%进入场景条件检查
%% check_enter(Status, SceneId) ->
%% 	try  
%% %% io:format("get_scene_pid_19_ /~p/ ~n",[SceneId]),		
%% 		gen_server:call(mod_scene:get_scene_pid(Status#player.scn, 
%% 															   Status#player.other#player_other.pid_scene, 
%% 															   Status#player.other#player_other.pid), 
%% 				 {apply_call, lib_scene, check_enter, [Status, SceneId]})			
%% 	catch
%% 		_:_ -> fail
%% 	end.
