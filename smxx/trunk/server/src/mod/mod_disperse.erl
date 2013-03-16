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
-define(TIMER,1000 * 2).
-define(SERVER_STATE_HOT,2) .
-define(SERVER_STATE_RECOM,3) .
-define(SERVER_STATE_MAINT,4) .
-define(DOMAIN_NUM,200).
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

%% 接收其它战区的状态更新信息
rpc_server_update(Id, Num) ->
    gen_server:cast(?MODULE, {rpc_server_update, Id, Num}).

rpc_server_update_sc(Id) ->
    gen_server:cast(?MODULE, {rpc_server_update_sc, Id}).

%% 接收场景在线更新信息
rpc_scene_update(SceneInfoList) ->
    gen_server:cast(?MODULE, {rpc_scene_update, SceneInfoList}).


%%更新服务器状态
update_server_state(Server) ->
	gen_server:cast(?MODULE, {update_server_state, Server}) . 
	
update_server_player(ServPlayer) ->
	gen_server:cast(?MODULE, {update_server_player, ServPlayer}) . 

%% 本模块计时器起停，fetch_node_load
timer_handle(Oper,Gateways) ->
    gen_server:cast(?MODULE, {timer_handle, Oper, Gateways}).

stop_server_access(Val) ->
    lists:foreach(fun(N)->rpc:cast(N, mod_disperse, stop_server_access_self, [Val]) end,nodes()).

stop_server_access_self(Val) ->
    gen_server:cast(?MODULE, {stop_server_access, Val}).


start_link(Ip, Port, Node_id,Gateways) ->
    gen_server:start_link({local,?MODULE}, ?MODULE, [Ip, Port, Node_id,Gateways], []).

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init([Ip, Port, ServeId, Gateways]) ->
    
	case ServeId =:= 0 of  
		true ->		%%网关服务器需要创建服务器列表ETS
			net_kernel:monitor_nodes(true) , 
			ets:new(?ETS_SERVER, [{keypos, #server.id}, named_table, public, set]),
			ets:new(server_config,[{keypos, #server_config.id}, named_table, public, set]) ,
			lists:foreach(fun(D) ->
								  ets:new(misc:create_atom(server_player, [D]), [{keypos, #server_player.uid}, named_table, public, set]) 
						  end, lists:seq(1, ?DOMAIN_NUM)) ,  %% 200个大区够用了吧
			erlang:send_after(1000, self(), {event, get_and_call_server}) ,
			erlang:send_after(24*60*60*1000, self(), {event, refresh_server_player}) ;
		false ->	%%非网关服务器，获取自己的负载并上发到中央网关
			erlang:send_after(?TIMER, self(), {fetch_node_load,Gateways})
	end ,
    State = #server{id = ServeId, ip = Ip, port = Port, node = node(), state = ?SERVER_STATE_HOT} ,
    misc:write_monitor_pid(self(),?MODULE, {}),
    {ok, State}.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
%% 根据本服务器信息，更新本服务器服务状态，并广播给其它服务器
%% handle_cast({stop_server_access, Val}, State) ->
%% %%     io:format("stop_server_access__/~p/~n",[[Val, State#server.node, State#server.ip]]),
%%     [ValAtom, ValStr] =
%%         case Val of
%%             _ when is_atom(Val) ->
%%                 [Val, tool:to_list(Val)];
%%             _ when is_list(Val) ->
%%                 [tool:to_atom(Val), Val];
%%             _ ->
%%                 [Val, Val]
%%         end,
%%     if
%%         State#server.node =:= ValAtom orelse State#server.ip =:= ValStr ->
%%             Num = ets:info(?ETS_ONLINE, size),
%%             NewServer =
%%                 #server{
%%                     id = State#server.id,
%%                     node = State#server.node,
%%                     ip = State#server.ip,
%%                     port = State#server.port,
%%                     num = Num,
%%                     stop_access = 1
%%                 },
%%             ets:insert(?ETS_SERVER,    NewServer),
%%             broadcast_server_state_sc(State#server.id),
%%             {noreply, State#server{stop_access = 1}};
%%         true ->
%%             {noreply, State}
%%     end;

%% 更新服务器状态
handle_cast({update_server_state, Server} , State) ->
	case ets:lookup(?ETS_SERVER, Server#server.id) of
		[OldServer|_] when is_record(OldServer,server) ->
			NewServer = OldServer#server{num = Server#server.num, state = Server#server.state} ;
		_ ->
			NewServer = Server#server{num = Server#server.num} 
	end ,
	ets:insert(?ETS_SERVER, NewServer) ,
	spawn(fun() -> db_agent:add_server(NewServer) end ) ,
    {noreply, State};

%% 更新玩家状态
handle_cast({update_server_player, ServPlayer} , State) ->
	EtsName = misc:create_atom(server_player, [ServPlayer#server_player.domain]) ,
	case ets:lookup(EtsName, ServPlayer#server_player.uid) of
		[Player|_] when is_record(Player,server_player) ->
			NewPlayer = Player#server_player{last_login = ServPlayer#server_player.last_login ,
											 career = ServPlayer#server_player.career ,
											 sex = ServPlayer#server_player.sex ,
											 lv = ServPlayer#server_player.lv } ,
			spawn(fun() ->db_agent:update_server_player(NewPlayer) end) ;
		_ ->
			NewPlayer = ServPlayer ,
			spawn(fun() ->db_agent:add_server_player(NewPlayer) end) 
	end ,
	ets:insert(EtsName, NewPlayer) ,
	{noreply, State} ;


%% 其它线人数更新
handle_cast({rpc_server_update, Id, Num} , State) ->
    case ets:lookup(?ETS_SERVER, Id) of
        [S] -> ets:insert(?ETS_SERVER, S#server{num = Num});
        _ -> skip
    end,
    {noreply, State};


%% 本模块计时器起停，fetch_node_load
handle_cast({timer_handle, Oper, Gateways} , State) ->
    case Oper of
        start ->
            misc:cancel_timer(fetch_node_load),
            erlang:send_after(1000, self(), {fetch_node_load,Gateways});
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
%%     ets:insert(?ETS_GET_SCENE, {get_scene, SceneInfoList}),
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
    {reply, State#server.id, State};

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
%% reversion 
handle_info({event, get_and_call_server}, State) ->
	get_server_config() ,
    get_and_call_server(State),
	get_server_player() ,
    {noreply, State};

%% 刷新玩家列表
%% reversion 
handle_info({event, refresh_server_player}, State) ->
	get_server_config() ,
    get_and_call_server(State),
	get_server_player() ,
    {noreply, State}; 

%% 统计当前线路人数并广播给其它线路
%% handle_info(online_num_update, State) ->
%%     case State#server.id of
%%         0 -> skip;
%%         _ ->
%%             Num = ets:info(?ETS_ONLINE, size),
%%             ets:insert(?ETS_SERVER,
%%                 #server{
%%                     id = State#server.id,
%%                     node = State#server.node,
%%                     ip = State#server.ip,
%%                     port = State#server.port,
%%                     num = Num
%%                 }
%%             ),
%%             Servers = server_list(),
%%             broadcast_server_state(Servers, State#server.id, Num)
%%     end,
%%     {noreply, State};

    
%% 获取最低负载服务器，并统计场景人数
handle_info({fetch_node_load,Gateways},State) ->
    %% List包含负载信息以及场景信息
	io:format("~s fetch node load..:~p~n ~n", [misc:time_format(now()),Gateways]),
	PlayerNum = ets:info(?ETS_ONLINE,size) ,
	if
		PlayerNum > 1000 ->
			Sts = ?SERVER_STATE_HOT ;
		true ->
			Sts = ?SERVER_STATE_RECOM 
	end ,
	OpenTime = config:get_opening_time() ,
	Domain = config:get_domain() ,
	Server = State#server{num = PlayerNum, domain = Domain, start_time = OpenTime , state = Sts } ,
	upload_to_gateway(Server,Gateways) ,
    erlang:send_after(?TIMER, self(), {fetch_node_load}),
    {noreply,State};

  
  

%% 处理服务器关闭事件()
handle_info({nodedown, Node}, State) ->
	case ets:match_object(?ETS_SERVER, #server{node = Node, _ = '_'}) of
		[Server|_] ->
			NewServer = Server#server{state = ?SERVER_STATE_MAINT} ,
			ets:insert(?ETS_SERVER, NewServer) ,
			spawn(fun() -> db_agent:add_server(NewServer) end ) ;
		_ ->
			skip
	end ,
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
%% broadcast_to_online_player([], _Level, _Data) -> ok;
%% broadcast_to_online_player([H | T], Level, Data) ->
%%     rpc:cast(H#server.node, lib_send, send_to_local_online_player, [Level, Data]),
%%     broadcast_to_online_player(T, Level, Data).
%% 
%% 


%% 广播当前场景情况给其它线
%% broadcast_server_scene([], _SceneInfoList) -> ok;
%% broadcast_server_scene([H | T], SceneInfoList) ->
%%     rpc:cast(H#server.node, mod_disperse, rpc_scene_update, [SceneInfoList]),
%%     broadcast_server_scene(T, SceneInfoList).




%%加入服务器集群
add_server(Ip, Port, Sid, Node) ->
    db_agent:add_server(Ip, Port, Sid, Node).

%% 安全退出游戏服务器集群
stop_game_server([]) -> ok;
stop_game_server([H | T]) ->
%%     rpc:cast(H#server.node, mod_login, stop_all, []),
    rpc:cast(H#server.node, main, server_stop, []),
    stop_game_server(T).



%% 请求服务器加载基础数据
load_base_data([], _Parm) -> ok;
load_base_data([H | T], Parm) ->
    rpc:cast(H#server.node, mod_kernel, load_base_data, Parm),
    load_base_data(T, Parm).

%%退出服务器集群
del_server(Sid) ->
    db_agent:del_server(Sid).

			
%%获取并通知所有线路信息
%% reversion 
get_and_call_server(_State) ->
	case db_agent:select_all_server() of
		[] ->
			[];
		Server ->
			F = fun(S) ->
						case S#server.state =/= 5 of  % 不是维护的状态的服务器
							true ->
								case net_adm:ping(S#server.node) of
									pong ->
										case S#server.id /= 0 of
											true ->
												ets:insert(?ETS_SERVER, S) ;
											false ->
												ok
										end ;
									pang ->
										del_server(S#server.id)
								end;
							false ->  	%%维护状态也要存入ETS
								ets:insert(?ETS_SERVER, S) 
						end
				end,
			[F(S) || S <- Server]
	end.

%%获取服务器配置信息
get_server_config() ->
	case db_agent:select_server_config() of
		[] ->
			skip ;
		DataList ->
			Fun = fun(ScRcd) ->
						  ets:insert(server_config, ScRcd) 
				  end ,
			lists:foreach(Fun, DataList)
	end .

%%获取服务器用户信息
get_server_player() ->
	case db_agent:select_server_player() of
		[] ->
			skip ;
		DataList ->
			Fun = fun(ServPlayer) ->
						  EtsName = misc:create_atom(server_player, [ServPlayer#server_player.domain]) ,
						  ets:insert(EtsName, ServPlayer) 
				  end ,
			lists:foreach(Fun, DataList)
	end .



%% 获取服务器列表
get_server_list(AccId,_AccName) ->
	ServList = ets:tab2list(?ETS_SERVER) ,
	Fun = fun(Serv) ->
				  Name = get_server_name(Serv#server.id) ,
				  EtsName = misc:create_atom(server_player, [Serv#server.domain]) ,
				  case ets:match_object(EtsName, #server_player{accid = AccId,serv_id = Serv#server.id, _='_'}) of
					  [ServPlayer|_] when is_record(ServPlayer,server_player) ->
						  Nick = ServPlayer#server_player.nick ,
						  Career = ServPlayer#server_player.career ,
						  Sex = ServPlayer#server_player.sex ,
						  Level = ServPlayer#server_player.lv ;
					  _ ->
						  Nick = "" ,
						  Career = 0 ,
						  Sex = 0 ,
						  Level = 0
				  end ,
						  
				  {Serv#server.id,Serv#server.domain,Name,Serv#server.ip,Serv#server.port,Serv#server.state,Career,Sex,Level,Nick}
		  end , 
	lists:reverse(lists:keysort(1, lists:map(Fun, ServList))) .


get_server_name(ServId) ->
	case ets:lookup(server_config, ServId) of
		[SCRcd|_] when is_record(SCRcd,server_config) ->
			SCRcd#server_config.name ;
		_ ->
			[]
	end .


%% 找出负载最小的服务器
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
        Num when Num < 200 -> %% 顺畅
            [4, Num, System_load];
        Num when Num > 200 , Num =< 500 -> %% 良好
            [3, Num, System_load];
        Num when Num > 1000 -> %%爆满
            [2, Num, System_load]
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

%% get_scene_user(_Sid, ?SCENE_COPY_NUMBER + 1, ResList) ->
%%     ResList;
%% get_scene_user(Sid, SubScene, ResList) ->
%%     SceneInfo = lib_scene:get_scene_user(Sid * 100 + SubScene),
%%     get_scene_user(Sid, SubScene + 1, [{Sid * 100 + SubScene, length(SceneInfo)}|ResList]).

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

%%本服务器尝试解析获取进程信息
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



%%上发服务器状态到网关
upload_to_gateway(Server,Gateways)  ->
	Fun = fun(Gateway) ->
				  case net_adm:ping(Gateway) of
					  pong ->
						  %%io:format("=== upload_to_gateway ~p ::: Stop Access. ~n", [Server#server.node]) ,
						  rpc:cast(Gateway, ?MODULE, update_server_state, [Server]) ;
					  pang ->
						  skip
				  end 
		  end ,
	lists:foreach(Fun, Gateways) .
	

%%服务器停机维护
stop_server(ServId) ->
	case ets:match_object(?ETS_SERVER, #server{node = node(), _ = '_'}) of
		[_GWNode|_] ->
			io:format("***not gateway server,cannot excute your operation***", []) ;
		_ ->
			case ets:lookup(ets_server, ServId) of
				[Server|_] when is_record(Server,server) ->
					case net_adm:ping(Server#server.node) of
						pong ->
							rpc:cast(Server#server.node, misc_admin, safe_quit, []) ;
						pang ->
							io:format("***cannot connect to assigned server***", [])
					end ;
				_ ->
					io:format("***not exist assigned server,cannot excute your operation***", [])  
			end 
	end .

			
%%同步玩家信息到中央网关
sync_player_to_gateway(Status) ->
	Gateways = config:get_gateway_node(server) ,
	ServNum = config:get_server_num() ,
	Domain = config:get_domain() ,
	Fun = fun(Gateway) ->
				  case net_adm:ping(Gateway) of
					  pong ->
						  ServPlayer = #server_player{uid = Status#player.id ,
													  accid = Status#player.account_id ,
													  serv_id = ServNum ,
													  domain = Domain ,
													  acc_name = Status#player.account_name ,
													  nick = Status#player.nick ,
													  sex = Status#player.gender ,
													  career = Status#player.career ,
													  lv = Status#player.level ,
													  icon = Status#player.icon ,
													  last_login = util:unixtime()
													  } ,
						  rpc:cast(Gateway, ?MODULE, update_server_player, [ServPlayer]) ;
					  pang ->
						  skip
				  end 
		  end ,
	lists:foreach(Fun, Gateways) .
	








