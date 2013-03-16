%%%------------------------------------
%%% @Module  : mod_disperse
%%% @Author  : csj
%%% @Created : 2010.10.05
%%% @Description: 游戏服务器路由器
%%%------------------------------------
-module(mod_disperse).
-behaviour(gen_server).
-compile(export_all).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-include("record.hrl").
-define(TIMER,1000 * 5).
-record(state, {
        id,
        ip,
        port,
        node,
        stop_access = 0
    }
).

%% ====================================================================
%% 对外函数
%% ====================================================================

%% 查询当前战区ID号
%% 返回:int()
server_id() ->
    gen_server:call(?MODULE, get_server_id).

%% 获取所有战区的列表(不包括当前战区)
%% 返回:[#server{} | ...]
server_list() ->
    ets:tab2list(?ETS_SERVER).

%% 接收其它战区的加入信息
rpc_server_add(Id, Node, Ip, Port) ->
    gen_server:cast(?MODULE, {rpc_server_add, Id, Node, Ip, Port}).

%% 接收其它战区的状态更新信息
rpc_server_update(Id, Num) ->
    gen_server:cast(?MODULE, {rpc_server_update, Id, Num}).

rpc_server_update_sc(Id) ->
    gen_server:cast(?MODULE, {rpc_server_update_sc, Id}).

%% 接收场景在线更新信息
rpc_scene_update(SceneInfoList) ->
    gen_server:cast(?MODULE, {rpc_scene_update, SceneInfoList}).

%% 场景插旗
add_flag(FlagInfo) ->
    gen_server:cast(?MODULE, {rpc_add_flag, FlagInfo}).

%% 场景撤销插
delete_flag(GuildId) ->
    gen_server:cast(?MODULE, {rpc_delete_flag, GuildId}).

%% 本模块效率测试，测试内容可变
mod_test() ->
    gen_server:cast(?MODULE, {mod_test}).

%% 本模块计时器起停，fetch_node_load
timer_handle(Oper) ->
    gen_server:cast(?MODULE, {timer_handle, Oper}).

stop_server_access(Val) ->
    lists:foreach(fun(N)->rpc:cast(N, mod_disperse, stop_server_access_self, [Val]) end,nodes()).

stop_server_access_self(Val) ->
    gen_server:cast(?MODULE, {stop_server_access, Val}).

%% 广播到所有线路
send_to_all(Data) ->
    Servers = server_list(),
    broadcast_to_world(Servers, Data).

start_link(Ip, Port, Node_id) ->
    gen_server:start_link({local,?MODULE}, ?MODULE, [Ip, Port, Node_id], []).

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init([Ip, Port, Node_id]) ->
    net_kernel:monitor_nodes(true), 
    ets:new(?ETS_SERVER, [{keypos, #server.id}, named_table, public, set]),
    State = #state{id = Node_id, ip = Ip, port = Port, node = node(), stop_access = 0},
    add_server([State#state.ip, State#state.port, State#state.id, State#state.node]),
    %% 存储连接的服务器
    ets:new(?ETS_GET_SERVER,[named_table,public,set]),
    ets:new(?ETS_GET_SCENE,[named_table,public,set]),
    erlang:send_after(100, self(), {event, get_and_call_server}),
    misc:write_monitor_pid(self(),?MODULE, {}),
    %if
    %    Node_id rem 20 =:= 0 ->
            %%获取系统负载，并获取所有场景的在线玩家
            erlang:send_after(1000, self(), {fetch_node_load}),
    %    true ->
    %        skip
    %end,
    {ok, State}.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
%% 新线加入
handle_cast({rpc_server_add, Id, Node, Ip, Port}, State) ->
    case Id of
        0 -> skip;
        _ ->
            ets:insert(?ETS_SERVER, #server{id = Id, node = Node, ip = Ip, port = Port, stop_access = 0})
    end,
    {noreply, State};

%% 根据本节点信息，更新本节点服务状态，并广播给其它节点
handle_cast({stop_server_access, Val}, State) ->
    io:format("stop_server_access__/~p/~n",[[Val, State#state.node, State#state.ip]]),
    [ValAtom, ValStr] =
        case Val of
            _ when is_atom(Val) ->
                [Val, tool:to_list(Val)];
            _ when is_list(Val) ->
                [tool:to_atom(Val), Val];
            _ ->
                [Val, Val]
        end,
    if
        State#state.node =:= ValAtom orelse State#state.ip =:= ValStr ->
            Num = ets:info(?ETS_ONLINE, size),
            NewServer =
                #server{
                    id = State#state.id,
                    node = State#state.node,
                    ip = State#state.ip,
                    port = State#state.port,
                    num = Num,
                    stop_access = 1
                },
            ets:insert(?ETS_SERVER,    NewServer),
            broadcast_server_state_sc(State#state.id),
            {noreply, State#state{stop_access = 1}};
        true ->
            {noreply, State}
    end;

%% 其它线人数更新
handle_cast({rpc_server_update, Id, Num} , State) ->
    case ets:lookup(?ETS_SERVER, Id) of
        [S] -> ets:insert(?ETS_SERVER, S#server{num = Num});
        _ -> skip
    end,
    {noreply, State};

%% 本模块效率测试，测试内容可变
handle_cast({mod_test} , State) ->
    %% List包含负载信息以及场景信息
    List =
        case server_list() of
            [] -> [];
            Server ->
                F = fun(S) ->
                        [{ServerState, OnlineNum, System_load}, SceneOnlineList] =
                                case rpc:call(S#server.node, mod_disperse, online_scene_state, []) of
                                    {badrpc, _} ->
                                        [{4, 0, 9999999999},[{0,0}]];
                                    [{ServerState1, OnlineNum1, System_load1}, SceneOnlineList1] ->
                                        case S#server.stop_access of
                                            1 ->
                                                [{4, 0, 9999999999}, SceneOnlineList1];
                                            _ ->
                                                [{ServerState1, OnlineNum1, System_load1}, SceneOnlineList1]
                                        end;
                                    _ ->
                                        [{4, 0, 9999999999},[{0,0}]]
                                end,
                        [{S#server.id, S#server.ip, S#server.port, ServerState, OnlineNum, System_load}] ++ SceneOnlineList
                    end,
                lists:flatten([F(S) || S <- Server])
        end,
    io:format("fetch_node_load_0000000 ~p~n",[getlist]),
    %% 把负载信息和场景信息分成两个列表
    Fdiv = fun(ElemState) ->
                   case ElemState of
                        {_, _} ->
                            false;
                        _ ->
                            true
                    end
            end,
    {ServerInfoList, SceneStateList} = lists:partition(Fdiv, List),
    io:format("ServerStateList_1  ~p~n",[ServerInfoList]),
%%     io:format("SceneStateList_1  ~p~n",[SceneStateList]),
    %%服务器负载信息处理
    Server_member_list = lists:map(fun({_, _, _, _, Num, _}) -> Num end, ServerInfoList),
    Online_count = lists:sum(Server_member_list),
    List1 = lists:filter(fun({_,_,_,_,_,S1})-> S1 < 900000000 end, ServerInfoList),
    io:format("fetch_node_load ~p~n",[List1]),
    Low = find_game_server_minimum(List1, Online_count),
    case length(Low) > 0 of
        true ->
            ets:insert(?ETS_GET_SERVER, {get_list,Low});
        false ->
            skip
    end,
    %%场景信息处处理
    SceneInfoList = lists:foldl(fun count_scene_online_num/2, [], SceneStateList),
    ets:insert(?ETS_GET_SCENE, {get_scene, SceneInfoList}),
    Servers = server_list(),
    broadcast_server_scene(Servers, SceneInfoList),
    {noreply, State};

%% 本模块计时器起停，fetch_node_load
handle_cast({timer_handle, Oper} , State) ->
    case Oper of
        start ->
            misc:cancel_timer(fetch_node_load),
            erlang:send_after(1000, self(), {fetch_node_load});
        stop ->
            misc:cancel_timer(fetch_node_load);
        _ ->
            ok
    end,
    {noreply, State};

%% 其它线状态更新
handle_cast({rpc_server_update_sc, Id} , State) ->
    case ets:lookup(?ETS_SERVER, Id) of
        [S] -> ets:insert(?ETS_SERVER, S#server{stop_access = 1});
        _ -> skip
    end,
    {noreply, State};

%% 场景在线情况更新
handle_cast({rpc_scene_update, SceneInfoList} , State) ->
%%     ?PRINT("rpc_scene_update ~p~n", [upup]),
    ets:insert(?ETS_GET_SCENE, {get_scene, SceneInfoList}),
    {noreply, State};

%% 场景旗帜情况更新
handle_cast({rpc_add_flag, FlagInfo} , State) ->
%%     io:format("rpc_add_flag ~p~n",[FlagInfo]),
    ets:insert(?ETS_SCENE_NPC, FlagInfo),
    {noreply, State};

%% 场景旗帜撤销
handle_cast({rpc_delete_flag, GuildId} , State) ->
%%     io:format("rpc_delete_flag ~p~n",[GuildId]),
    ets:delete(?ETS_SCENE_NPC, GuildId),
    {noreply, State};


handle_cast(_R , State) ->
    {noreply, State}.

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
%% 获取战区ID号 
handle_call(get_server_id, _From, State) ->
    {reply, State#state.id, State};

%% 获取服务器列表
handle_call('get_server_list',_From,State) ->
    {reply,ok,State};

handle_call(_R , _FROM, State) ->
    {reply, ok, State}.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
%% 获取并通知当前所有线路
handle_info({event, get_and_call_server}, State) ->
    get_and_call_server(State),
    {noreply, State};

%% 统计当前线路人数并广播给其它线路
handle_info(online_num_update, State) ->
    case State#state.id of
        0 -> skip;
        _ ->
            Num = ets:info(?ETS_ONLINE, size),
            ets:insert(?ETS_SERVER,
                #server{
                    id = State#state.id,
                    node = State#state.node,
                    ip = State#state.ip,
                    port = State#state.port,
                    num = Num
                }
            ),
            Servers = server_list(),
            broadcast_server_state(Servers, State#state.id, Num)
    end,
    {noreply, State};

%% 获取最低负载节点，并统计场景人数
handle_info({fetch_node_load},State) ->
    %% List包含负载信息以及场景信息
    List =
        case server_list() of
            [] -> [];
            Server ->
                F = fun(S) ->
                            [{ServerState, OnlineNum, System_load}, SceneOnlineList] =
                                case rpc:call(S#server.node, mod_disperse, online_scene_state, []) of
                                    {badrpc, _} ->
                                        [{4, 0, 9999999999},[{0,0}]];
                                    [{ServerState1, OnlineNum1, System_load1}, SceneOnlineList1] ->
                                        case S#server.stop_access of
                                            1 ->
                                                [{4, 0, 9999999999}, SceneOnlineList1];
                                            _ ->
                                                [{ServerState1, OnlineNum1, System_load1}, SceneOnlineList1]
                                        end;
                                    _ ->
                                        [{4, 0, 9999999999},[{0,0}]]
                                end,
                        [{S#server.id, S#server.ip, S#server.port, ServerState, OnlineNum, System_load}] ++ SceneOnlineList
                    end,
                lists:flatten([F(S) || S <- Server])
        end,
    %% 把负载信息和场景信息分成两个列表
    Fdiv = fun(ElemState) ->
                   case ElemState of
                        {_, _} ->
                            false;
                        _ ->
                            true
                    end
            end,
    {ServerInfoList, SceneStateList} = lists:partition(Fdiv, List),
    %%服务器负载信息处理
    Server_member_list = lists:map(fun({_, _, _, _, Num, _}) -> Num end, ServerInfoList),
    Online_count = lists:sum(Server_member_list),
    List1 = lists:filter(fun({_,_,_,_,_,S1})-> S1 < 900000000 end, ServerInfoList),
    Low = find_game_server_minimum(List1, Online_count),
    case length(Low) > 0 of
        true ->
            ets:insert(?ETS_GET_SERVER, {get_list,Low});
        false ->
            skip
    end,
    %%场景信息处处理
    SceneInfoList = lists:foldl(fun count_scene_online_num/2, [], SceneStateList),
    ets:insert(?ETS_GET_SCENE, {get_scene, SceneInfoList}),
    Servers = server_list(),
    broadcast_server_scene(Servers, SceneInfoList),
    erlang:send_after(?TIMER, self(), {fetch_node_load}),
    {noreply,State};
    
%% 处理新节点加入事件
handle_info({nodeup, Node}, State) ->
    try
        rpc:cast(Node, mod_disperse, rpc_server_add, 
                 [State#state.id, State#state.node, State#state.ip, State#state.port]),
        ok
    catch
        _:_ -> 
            skip
    end,
    {noreply, State};

%% 处理节点关闭事件
handle_info({nodedown, Node}, State) ->
    %% 检查是否战区节点，并做相应处理
    case ets:match_object(?ETS_SERVER, #server{node = Node, _ = '_'}) of
        [_Z] ->
            ets:match_delete(?ETS_SERVER, #server{node = Node, _ = '_'});
        _ ->
            skip
    end,
    {noreply, State};

handle_info(_Reason, State) ->
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_R, State) ->
    io:format("~s terminate begined************  [~p]\n",[misc:time_format(now()), mod_disperse]),
    misc:delete_monitor_pid(self()),
    io:format("~s terminate finished************  [~p]\n",[misc:time_format(now()), mod_disperse]),
    {ok, State}.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra)->
    {ok, State}.


%% ----------------------- 私有函数 ---------------------------------
%% 发送给指定联盟之外的联盟成员
broadcast_to_except_guild([], _GuildId, _Data) -> ok ;
broadcast_to_except_guild([H | T], GuildId, Data) ->
    rpc:cast(H#server.node, lib_send, send_to_local_except_guild, [GuildId, Data]),
    broadcast_to_except_guild(T, GuildId, Data).

%% 发送给指定的联盟成员
broadcast_to_assigned_guild([], _GuildId, _Data) -> ok ;
broadcast_to_assigned_guild([H | T], GuildId, Data) ->
    rpc:cast(H#server.node, lib_send, send_to_local_assigned_guild, [GuildId, Data]),
    broadcast_to_assigned_guild(T, GuildId, Data).

%% 广播给不同级别的联盟成员(盟主，元老，长老，盟众)
broadcast_to_guild_member([], _Who, _Bin) -> ok ;
broadcast_to_guild_member([H | T], Who, Data) ->
    rpc:cast(H#server.node, lib_send, send_to_local_guild_member, [Who, Data]),
    broadcast_to_guild_member(T, Who, Data).


%% 广播到其它节点的一定级别的在线玩家
broadcast_to_opened_player([], _FuncNum, _Data) -> ok;
broadcast_to_opened_player([H | T], FuncNum, Data) ->
    rpc:cast(H#server.node, lib_send, send_to_local_opened_player, [FuncNum, Data]),
    broadcast_to_opened_player(T, FuncNum, Data).


broadcast_to_online_player([], _Level, _Data) -> ok;
broadcast_to_online_player([H | T], Level, Data) ->
    rpc:cast(H#server.node, lib_send, send_to_local_online_player, [Level, Data]),
    broadcast_to_online_player(T, Level, Data).

%% 广播到其它节点的一定级别的在线玩家,除了指定的UID
broadcast_to_online_player_except([], _Level, _Data,_UID) -> ok;
broadcast_to_online_player_except([H | T], Level, Data, UId) ->
    rpc:cast(H#server.node, lib_send, send_to_local_online_player_except, [Level, Data, UId]),
    broadcast_to_online_player_except(T, Level, Data,UId).

%% 广播到其它节点的世界频道
broadcast_to_world([], _Data) -> ok;
broadcast_to_world([H | T], Data) ->
    rpc:cast(H#server.node, lib_send, send_to_local_all, [Data]),
    broadcast_to_world(T, Data).

%% 广播到其它节点的部落频道
broadcast_to_realm([], _Realm, _Data) -> ok;
broadcast_to_realm([H | T], Realm, Data) ->
    rpc:cast(H#server.node, lib_send, send_to_local_realm, [Realm, Data]),
    broadcast_to_realm(T, Realm, Data).

%% 广播当前在线给其它线
broadcast_server_state([], _Id, _Num) -> ok;
broadcast_server_state([H | T], Id, Num) ->
    rpc:cast(H#server.node, mod_disperse, rpc_server_update, [Id, Num]),
    broadcast_server_state(T, Id, Num).

%% 广播当前场景情况给其它线
broadcast_server_scene([], _SceneInfoList) -> ok;
broadcast_server_scene([H | T], SceneInfoList) ->
    rpc:cast(H#server.node, mod_disperse, rpc_scene_update, [SceneInfoList]),
    broadcast_server_scene(T, SceneInfoList).

%% 广播当前在线给其它线
broadcast_server_state_sc(Id) ->
    lists:foreach(fun(N)->rpc:cast(N,mod_disperse,rpc_server_update_sc,[Id]) end,nodes()).

%% 广播新旗帜给其它线
broadcast_new_flag([], _NewFlag) -> ok;
broadcast_new_flag([H | T], NewFlag) ->
    rpc:cast(H#server.node, mod_disperse, add_flag, [NewFlag]),
    broadcast_new_flag(T, NewFlag).

%% 清除旗帜给其它线
broadcast_cls_flag([], _GuildId) -> ok;
broadcast_cls_flag([H | T], GuildId) ->
    rpc:cast(H#server.node, mod_disperse, delete_flag, [GuildId]),
    broadcast_cls_flag(T, GuildId).

%%加入服务器集群
add_server([Ip, Port, Sid, Node]) ->
    db_agent:add_server([Ip, Port, Sid, Node]).

%% 安全退出游戏服务器集群
stop_game_server([]) -> ok;
stop_game_server([H | T]) ->
%%     rpc:cast(H#server.node, mod_login, stop_all, []),
    rpc:cast(H#server.node, csj, server_stop, []),
    stop_game_server(T).

%% 请求节点加载基础数据
load_base_data([], _Parm) -> ok;
load_base_data([H | T], Parm) ->
    rpc:cast(H#server.node, mod_kernel, load_base_data, Parm),
    load_base_data(T, Parm).

  %%退出服务器集群
del_server(Sid) ->
    db_agent:del_server(Sid).

%%获取并通知所有线路信息
get_and_call_server(State) ->
    case db_agent:select_all_server() of
        [] ->
            [];
        Server ->
            F = fun([Id, Ip, Port, Node, _, _]) ->
                    Node1 = list_to_atom(binary_to_list(Node)),
                    Ip1 = binary_to_list(Ip),
                    case Id /= State#state.id of  % 自己不写入和不通知
                        true ->
                            case net_adm:ping(Node1) of
                                pong ->
                                    case Id /= 0 of
                                        true ->
                                            ets:insert(?ETS_SERVER,
                                                #server{
                                                    id = Id,
                                                    node = Node1,
                                                    ip = Ip1,
                                                    port = Port
                                                }
                                            );
                                        false ->
                                            ok
                                    end,
                                     %% 通知已有的线路加入当前线路的节点，包括线路0网关 
                                    try
                                    rpc:cast(Node1, mod_disperse, rpc_server_add, [State#state.id, State#state.node, State#state.ip, State#state.port])
                                    catch
                                        _:_ -> error
                                    end;
                                pang ->
                                    del_server(Id)
                            end;
                        false ->
                            ok
                    end
                end,
            [F(S) || S <- Server]
    end.


%% 获取服务器列表
get_server_list() ->
    case ets:match(?ETS_GET_SERVER,{get_list,'$1'}) of
        [LS] ->
            case length(LS) > 0 of
                true  -> hd(LS);
                false -> LS
            end;
        [] -> []
    end.

%% 找出负载最小的节点
find_game_server_minimum(L, Online_count) ->
    if length(L) == 0 -> [];
       true -> 
           NL = lists:sort(fun({_,_,_,_,_,S1},{_,_,_,_,_,S2}) -> S1 < S2 end, L),
           [{Id, Ip, Port, State, _Num, System_Status}|_] = NL,
           [{Id, Ip, Port, State, Online_count, System_Status}]
    end.

%% 在线状况  + 场景在线信息
online_scene_state() ->
    {Num, System_load} = get_system_load(),
    %SceneOnlineList = scene_online_num(),
    SceneOnlineList = [],
    State = 1, %临时预留标识
    [{State, Num, System_load}, SceneOnlineList].

%% 在线状况 (无场景在线信息)
online_state() ->
    System_load = get_system_load(),
    case ets:info(?ETS_ONLINE, size) of
        undefined ->
            [0, 0, 0];
        Num when Num < 200 -> %顺畅
            [1, Num, System_load];
        Num when Num > 200 , Num < 500 -> %正常
            [2, Num, System_load];
        Num when Num > 500 , Num < 800 -> %繁忙
            [3, Num, System_load];
        Num when Num > 800 -> %爆满
            [4, Num, System_load]
    end.

%% 查询邻近等级的在线玩家
close_level_players(PlayerId,PlayerLv,FloatLv,MinLv) ->
    lib_scene:close_level_players(PlayerId,PlayerLv,FloatLv,MinLv).


%% % 场景人数（外部php调用）
%% scene_online_num_php()->
%%     BaseScenes = ets:tab2list(?ETS_BASE_SCENE),
%% %%     io:format("base sceneinfo~p~n", [BaseScenes]),
%%     F = fun(Sinfo,SceneInfoList) ->
%% %%                 io:format("sinid493 ~p~n", [Sinfo#ets_scene.sid]),
%%                 SceneInfo = lib_scene:get_scene_user(Sinfo#ets_scene.sid),
%% %%                 io:format("sceneinfo495 ~p~n", [SceneInfo]),
%%                 [{Sinfo#ets_scene.sid,Sinfo#ets_scene.name,length(SceneInfo)}|SceneInfoList]
%%         end,
%%     lists:foldl(F, [], BaseScenes).

%% % 场景人数
%% scene_online_num()->
%%     BaseScenes = ets:tab2list(?ETS_BASE_SCENE),
%%     F = fun(Sinfo,SceneInfoList) ->
%%                 get_scene_user(Sinfo#ets_scene.sid, 1, []) ++ SceneInfoList
%%         end,
%%     lists:foldl(F, [], BaseScenes).

get_scene_user(_Sid, ?SCENE_COPY_NUMBER + 1, ResList) ->
    ResList;
get_scene_user(Sid, SubScene, ResList) ->
    SceneInfo = lib_scene:get_scene_user(Sid * 100 + SubScene),
    get_scene_user(Sid, SubScene + 1, [{Sid * 100 + SubScene, length(SceneInfo)}|ResList]).

get_system_load() ->
	Load_fact = 10,  %% 全局进程负载权重
	Load_fact_more = 20,  %% 全局进程负载权重2
	If_mod_guild =	
		    case ets:match(?ETS_MONITOR_PID,{'$1', mod_guild ,'$3'}) of
				[[_GuildPid, _]] -> Load_fact;
				_ -> 0									
			end,	

	If_mod_sale =	
		    case ets:match(?ETS_MONITOR_PID,{'$1', mod_sale ,'$3'}) of
				[[_SalePid, _]] -> Load_fact;
				_ -> 0
			end,

	If_mod_rank =	
		    case ets:match(?ETS_MONITOR_PID,{'$1', mod_rank ,'$3'}) of
				[[_RankPid, _]] -> Load_fact;
				_ -> 0
			end,

	If_mod_misc =	
		    case ets:match(?ETS_MONITOR_PID,{'$1', mod_misc ,'$3'}) of
				[[_delayerPid, _]] -> Load_fact;
				_ -> 0
			end,	
	
	If_mod_master_apprentice = 
		    case ets:match(?ETS_MONITOR_PID,{'$1', mod_master_apprentice ,'$3'}) of
				[[_MasterPid, _]] -> Load_fact;
				_ -> 0
			end,

	If_mod_shop = 
		    case ets:match(?ETS_MONITOR_PID,{'$1', mod_shop ,'$3'}) of
				[[_ShopPid, _]] -> Load_fact;
				_ -> 0
			end,	
	
	If_mod_kernel = 
		    case ets:match(?ETS_MONITOR_PID,{'$1', mod_kernel ,'$3'}) of
				[[_KernelPid, {Val}]] -> Val;
				_ -> 0
			end,
	
	If_mod_analytics = 
		    case ets:match(?ETS_MONITOR_PID,{'$1', dungeon_analytics ,'$3'}) of
				[[_AnalyticsPid, _]] -> Load_fact;
				_ -> 0
			end,	

%% 	If_mod_vip = 
%% 		    case ets:match(?ETS_MONITOR_PID,{'$1', vip ,'$3'}) of
%% 				[[_VipPid, _]] -> Load_fact;
%% 				_ -> 0
%% 			end,
	
	If_mod_consign = 
		    case ets:match(?ETS_MONITOR_PID,{'$1', consign ,'$3'}) of
				[[_CconsignPid, _]] -> Load_fact;
				_ -> 0
			end,

	If_mod_carry = 
		    case ets:match(?ETS_MONITOR_PID,{'$1', carry ,'$3'}) of
				[[_CcarryPid, _]] -> Load_fact_more;
				_ -> 0
			end,	

	If_mod_arena = 
		    case ets:match(?ETS_MONITOR_PID,{'$1', arena ,'$3'}) of
				[[_AarenaPid, _]] -> Load_fact_more;
				_ -> 0
			end,
	
	If_mod_ore_sup = 
		    case ets:match(?ETS_MONITOR_PID,{'$1', ore_sup ,'$3'}) of
				[[_Oore_supPid, _]] -> Load_fact_more;
				_ -> 0
			end,
	
	If_mod_answer = 
		    case ets:match(?ETS_MONITOR_PID,{'$1', answer ,'$3'}) of
				[[_AanswerPid, _]] -> Load_fact;
				_ -> 0
			end,
	
%% 	ScenePlayerCount = ets:info(?ETS_ONLINE_SCENE, size),
	ConnectionCount = ets:info(?ETS_ONLINE, size),
	%%+ If_mod_vip
	Mod_load = If_mod_guild + If_mod_sale + If_mod_rank + If_mod_misc + If_mod_master_apprentice + If_mod_shop + If_mod_kernel + If_mod_analytics + If_mod_consign + If_mod_carry + If_mod_arena + If_mod_ore_sup + If_mod_answer,
%% 	game_timer:cpu_time() + Mod_load + ScenePlayerCount/100.
	{ConnectionCount,
	 round(game_timer:cpu_time() + Mod_load + ConnectionCount/10)}.

dsp_node_status(NodeName) ->
	io:format("~p :::: CpuTime:~p  Connections:~p ~n",
					[NodeName, game_timer:cpu_time(), ets:info(?ETS_ONLINE, size)]).

sc_status() ->
   	case server_list() of
        [] -> [];
        Server ->
            F = fun(S) ->
					case S#server.stop_access of
						1 ->
							io:format("~p ::: Stop Access. ~n", [S#server.node]);
						_ ->
							io:format("~p ::: Could Access..... ~n", [S#server.node])
					end
              end,
            [F(S) || S <- Server]
    end.

get_nodes_cmq(Type)->
	A = lists:foldl( 
		  fun(P, Acc0) -> 
				 case Type of
					 1 ->
						[{P, 
						  	erlang:process_info(P), 
							erlang:process_info(P, reductions) }
						| Acc0] ;
					 2 ->
						 [{P,
							erlang:process_info(P, registered_name), 
							erlang:process_info(P, memory)}
						| Acc0] ;
					 3 ->
						 [{P, 
							erlang:process_info(P, registered_name), 
							erlang:process_info(P, message_queue_len)} 
						| Acc0] 
				 end
			end, 
		  [], 
		  erlang:processes()
		),
	%%B = io_lib:format("~p", [A]),
	A.

%%本节点尝试解析获取进程信息
get_process_info(Pid_list) ->
	try
		Pid = list_to_pid(Pid_list),
		Pinfo = process_info(Pid),
		%%file:write_file("info.txt", io_lib:format("~p", Pinfo)),
		Pinfo
	catch
		_:E ->
			E
	end.

%%统计场景人数
count_scene_online_num({SceneId, Num},CountInfo) ->
	case lists:keysearch(SceneId, 1, CountInfo) of
		false ->
			[{SceneId, Num}|CountInfo];
		{value,{_sceneid, Total}} ->
			lists:keyreplace(SceneId, 1, CountInfo,{SceneId, Num+Total})
	end.














