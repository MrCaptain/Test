%%%------------------------------------
%%% @Module  : mod_scene_agent
%%% @Author  : csj
%%% @Created : 2010.11.06
%%% @Description: 场景管理_代理
%%%------------------------------------
-module(mod_scene_agent). 
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
-compile(export_all).

-record(state, {worker_id = 0}).

-define(CLEAR_ONLINE_PLAYER, 10*60*1000).	  %% 每10分钟 对 ets_online 做一次清理

%% ====================================================================
%% External functions
%% ====================================================================
start({SceneAgentProcessName, Worker_id}) ->
    gen_server:start(?MODULE, {SceneAgentProcessName, Worker_id}, []).

start_link({SceneAgentProcessName, Worker_id}) ->
	gen_server:start_link(?MODULE, {SceneAgentProcessName, Worker_id}, []).

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init({SceneAgentProcessName, Worker_id}) ->
    process_flag(trap_exit, true),
	if Worker_id =:= 0 ->
			misc:write_monitor_pid(self(), mod_scene_agent, {?SCENE_WORKER_NUMBER}),
			%% 启动多个场景代理服务进程
			lists:foreach(
				fun(WorkerId) ->
					SceneAgentWorkerName = misc:create_process_name(scene_agent_p, [WorkerId]),
					mod_scene_agent:start({SceneAgentWorkerName, WorkerId}),
					ok
				end,
				lists:seq(1, ?SCENE_WORKER_NUMBER)),
			pg2:create(scene_agent),
			pg2:join(scene_agent, self()),
			erlang:send_after(?CLEAR_ONLINE_PLAYER, self(), {event, clear_online_player});
	   true -> 
		   misc:register(local, tool:to_atom(SceneAgentProcessName), self()),
		   misc:write_monitor_pid(self(),mod_scene_agent_worker, {Worker_id})
	end,
	State= #state{worker_id = Worker_id},	
    {ok, State}.

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
%% 	?DEBUG("mod_scene_agent_apply_call: [~p/~p/~p]", [Module, Method, Args]),	
	Reply  = 
	case (catch apply(Module, Method, Args)) of
		 {'EXIT', Info} ->	
			 ?WARNING_MSG("mod_scene_agent_apply_call error: Module=~p, Method=~p, Reason=~p",[Module, Method,Info]),
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
%%接受请求发送信息到场景,并分发给各代理工
handle_cast({send_to_scene, SceneId, BinData}, State) ->
 %io:format("send_to_scene_1_~p~p~n",[self(),SceneId]),	   
	WorkerId = random:uniform(?SCENE_WORKER_NUMBER),
	SceneAgentWorkerName = misc:create_process_name(scene_agent_p, [WorkerId]),
	gen_server:cast(tool:to_atom(SceneAgentWorkerName), {send_to_local_scene, SceneId, BinData}),
	{noreply, State};

%%@spec 发给消息给同屏的玩家
handle_cast({send_to_same_screen, SceneId, X, Y, BinData,ExceptUId}, State) ->
 %io:format("send_to_scene_1_~p~p~n",[self(),SceneId]),	   
	WorkerId = random:uniform(?SCENE_WORKER_NUMBER),
	SceneAgentWorkerName = misc:create_process_name(scene_agent_p, [WorkerId]),
	gen_server:cast(tool:to_atom(SceneAgentWorkerName), {send_to_local_screen, SceneId, X, Y, BinData,ExceptUId}),
	{noreply, State};


%%接受请求发送信息到场景区域,并分发给各代理工
handle_cast({send_to_scene, SceneId, X, Y, BinData}, State) ->
%% io:format("send_to_scene_2_~p~n",[self()]),	   
	WorkerId = random:uniform(?SCENE_WORKER_NUMBER),
	SceneAgentWorkerName = misc:create_process_name(scene_agent_p, [WorkerId]),
	gen_server:cast(tool:to_atom(SceneAgentWorkerName), {send_to_local_scene, SceneId, X, Y, BinData}),
	{noreply, State};

%%发送信息到本地的场景用户
handle_cast({send_to_local_scene, SceneId, BinData}, State) ->
	lib_send:send_to_local_scene(SceneId, BinData),
 %io:format("            send_to_local_scene_1_~p~n",[self()]),		
	{noreply, State};

%%发送信息到本地的场景用户(区域)
handle_cast({send_to_local_scene, SceneId, X, Y, BinData}, State) ->
	lib_send:send_to_local_scene(SceneId, X, Y, BinData),
%% io:format("            send_to_local_scene_2_~p~n",[self()]),		
	{noreply, State};

%% 当人物移动时候的广播
handle_cast({move_broadcast, SceneId, PlayerPid, X1, Y1, X2, Y2,PlayerId,Ps, MoveBinData, LeaveBinData, EnterBinData}, State) ->
	lib_scene:move_broadcast_node(SceneId, PlayerPid, X1, Y1, X2, Y2,PlayerId,Ps, MoveBinData, LeaveBinData, EnterBinData),
	{noreply, State};

%% 人物位置同步
handle_cast({broadcast_move, Status, OldPosXY, NewPosXY, LeaveBinData, EnterBinData},State) ->
	lib_scene:broadcast_move(Status,OldPosXY,NewPosXY, LeaveBinData, EnterBinData),
	{noreply, State};

%% 当人物移动时候的广播
handle_cast({move_broadcast_union, SceneId, Un, X1, Y1,PlayerId,Ps, MoveBinData}, State) ->
	lib_scene:move_broadcast_node_union(SceneId, Un, X1, Y1, PlayerId,Ps, MoveBinData),
	{noreply, State};

%% 复活进入场景
handle_cast({revive_to_scene, PlayerPid, PlayerId, ReviveType, Scene1, X1, Y1, Scene2, X2, Y2, Bin12003}, State) ->
	lib_scene:revive_to_scene_node(PlayerPid, PlayerId, ReviveType, Scene1, X1, Y1, Scene2, X2, Y2, Bin12003),
	{noreply, State};

handle_cast({send_to_base, SceneId, BinData}, State) ->
	WorkerId = random:uniform(?SCENE_WORKER_NUMBER),
	SceneAgentWorkerName = misc:create_process_name(scene_agent_p, [WorkerId]),
	gen_server:cast(tool:to_atom(SceneAgentWorkerName), {send_to_base_scene, SceneId, BinData}),
	{noreply, State};

handle_cast({send_to_base_scene, SceneId, BinData}, State) ->
%%  	io:format("send_to_base_scene_~p~p~n",[self(), SceneId]),	   
	lib_send:send_to_base_scene(SceneId, BinData),
	{noreply, State};

%% 统一模块+过程调用(cast)
handle_cast({apply_cast, Module, Method, Args}, State) ->
%% 	?DEBUG("mod_scene_agent_apply_cast: [~p/~p/~p]", [Module, Method, Args]),	
	case (catch apply(Module, Method, Args)) of
		 {'EXIT', Info} ->	
			 ?WARNING_MSG("mod_scene_agent_apply_cast error: Module=~p, Method=~p, Args =~p, Reason=~p",[Module, Method, Args, Info]),
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
handle_info({event, clear_online_player}, State) ->
	MS = ets:fun2ms(fun(T) -> 
					 [
					  T#player.id,
					  T#player.other#player_other.pid,
					  T#player.other#player_other.socket
					 ]
					end),
	L = ets:select(?ETS_ONLINE, MS),
	lists:foreach(fun([Id, Pid, Socket]) ->
					case erlang:is_process_alive(Pid) of
						false ->
							gen_tcp:close(Socket),
							mod_player:delete_player_ets(Id),
%% 							ets:delete(?ETS_ONLINE_SCENE, Id),
							ets:delete(?ETS_ONLINE, Id);
						_-> is_alive
					end
				end,
			L),		  
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
	io:format("~s terminate begined************  [~p]\n",[misc:time_format(now()), mod_scene_agent]),
	misc:delete_monitor_pid(self()),
	io:format("~s terminate finished************  [~p]\n",[misc:time_format(now()), mod_scene_agent]),
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
%% 发送数据到某一场景 
send_to_scene(SceneId, BinData)->
	[gen_server:cast(Pid, {send_to_scene, SceneId, BinData}) || Pid <- misc:pg2_get_members(scene_agent)].

%% 发送数据到某一场景同一屏幕
send_to_same_screen(SceneId, X, Y, BinData,ExceptUId)->
	[gen_server:cast(Pid, {send_to_same_screen, SceneId, BinData, X, Y, BinData,ExceptUId}) || Pid <- misc:pg2_get_members(scene_agent)].

%% 不再区域广播
%% 发送数据到某一场景区域
send_to_area_scene(SceneId, X, Y, BinData) ->
	[gen_server:cast(Pid, {send_to_scene, SceneId, X, Y, BinData}) || Pid <- misc:pg2_get_members(scene_agent)].

%%当人物或者怪物移动时候的广播
move_broadcast(SceneId, PlayerPid, X1, Y1, X2, Y2,PlayerId,Ps, MoveBinData, LeaveBinData, EnterBinData) ->
	[gen_server:cast(Pid, {move_broadcast, SceneId, PlayerPid, X1, Y1, X2, Y2,PlayerId,Ps, MoveBinData, LeaveBinData, EnterBinData}) || Pid <- misc:pg2_get_members(scene_agent)].

%%当人物移动的时候广播
broadcast_move(Status, OldPosXY,NewPosXY, LeaveBinData, EnterBinData) ->
	[gen_server:cast(Pid, {move_broadcast, Status, OldPosXY,NewPosXY, LeaveBinData, EnterBinData}) || Pid <- misc:pg2_get_members(scene_agent)].


%%当人物在联盟场景移动时候的广播
move_broadcast_union(SceneId, Un, X1, Y1,PlayerId,Ps, MoveBinData) ->
	[gen_server:cast(Pid, {move_broadcast_union, SceneId,Un, X1, Y1, PlayerId,Ps, MoveBinData}) || Pid <- misc:pg2_get_members(scene_agent)].

send_to_base_scene(SceneId, ScnBin) ->
	[gen_server:cast(Pid, {send_to_base, SceneId, ScnBin}) || Pid <- misc:pg2_get_members(scene_agent)].

%% %% 复活进入场景
%% revive_to_scene(Pid_player, PlayerId, ReviveType, Scene1, X1, Y1, Scene2, X2, Y2, Bin12003) ->
%% 	[gen_server:cast(Pid, {revive_to_scene, Pid_player, PlayerId, ReviveType, Scene1, X1, Y1, Scene2, X2, Y2, Bin12003}) || Pid <- misc:pg2_get_members(scene_agent)].
