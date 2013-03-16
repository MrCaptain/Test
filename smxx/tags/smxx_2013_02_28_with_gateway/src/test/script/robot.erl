%%% -------------------------------------------------------------------
%%% Author:
%%% Description : 
%%% Created :
%%% -------------------------------------------------------------------
-module(robot).

-behaviour(gen_server).
-compile(export_all).
-include("common.hrl").
-include("record.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

-define(CONFIG_FILE, "../config/gateway.config").

%% %% 连接网关端口，不读取gateway配置
%% -define(GATEWAY_ADD,"127.0.0.1"). 
%% %% -define(GATEWAY_ADD,"192.168.51.175"). 
%% -define(GATEWAY_PORT,7788).

-define(SERVER_ADD,"192.168.51.129"). 
-define(SERVER_PORT,7788).

-define(ACTION_SPEED_CONTROL, 10).
-define(ACTION_INTERVAL, ?ACTION_SPEED_CONTROL*1000).  % 自动行为最大时间间隔
-define(ACTION_MIN, 3000).    % 自动行为最小时间间隔

-define(TCP_OPTS, [
        binary,
        {packet, 0}, % no packaging
        {reuseaddr, true}, % allow rebind without waiting
        {nodelay, false},
        {delay_send, true},
        {active, false},
        {exit_on_close, false}
    ]).


-define(debug,1).
%% 断言以及打印调试信息宏
-ifdef(debug).
    -define(TRACE(Str), io:format(Str)).
    -define(TRACE(Str, Args), io:format(Str, Args)).
    % unicode版
    -define(TRACE_W(Str), io:format("~ts", [list_to_binary(io_lib:format(Str, []))])).
    -define(TRACE_W(Str, Args), io:format("~ts", [list_to_binary(io_lib:format(Str, Args))])).
-else.
    -define(TRACE(Str), void).
    -define(TRACE(Str, Args), void).

    -define(TRACE_W(Str), void).
    -define(TRACE_W(Str, Args), void).
-endif.

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-record(robot, {
        orig_n,    
        login,
        acid,      %%account id
        socket,    %%socket
        socket2,
        socket3,
        pid,    %%process id
        x ,        %%x坐标
        y ,        %%y坐标
        scene,
        tox,
        toy,
        hp,
        id,     %% id
        act,    %% 动作
        status, %% 当前状态
        dstScene,
        step,
        frda, %% 好友信息
        bkda, %% 黑名单信息,
        sgda %% 陌生人信息         
    }).
%%%
%%% API

start()->
    start(20, 1),
    ok.

%%StartId 起始AccountID
%%Num int 数量
%%Mod 跑步模式 1 ,2
start(StartId, Num)->
    sleep(100),
    F=fun(N)->
%%          ?TRACE("start robot-~p~n",[N]),
         sleep(200),
         robot:start_link(StartId + N)
    end,
    for(0,Num,F),
    ok.

 
%%创建 一个ROBOT 进程
start_link(N)->
    case gen_server:start(?MODULE,[N],[]) of
        {ok, _Pid}->
            ?TRACE("--robot~p start finish!-~n",[N]);
            %gen_server:cast(Pid, {start_action});
        _->
            fail
    end.

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
%%初始化玩家数据
init([N]) ->
    process_flag(trap_exit,true),
    Pid = self(),
    case login(N, Pid) of
        {ok, Socket}->
            Scene = 10101,
            Robot= #robot{socket = Socket, 
                          login = 0,
                          acid = N, 
                          id = 0, 
                          pid = Pid,
                          act = none,
                          status = none,
                          scene = Scene,
                          dstScene = Scene,
                          tox = rand(1,40),
                          toy = rand(1,20),
                          orig_n = N,
                          step = 0,
                          frda = [], %% 好友信息
                          bkda = [], %% 黑名单信息,
                          sgda = []%% 陌生人信息    
                         },
            %%登陆成功后开始动作
            {ok,Robot};
        _Error ->
            ?TRACE("init: error, reason: ~p~n",[_Error]),
            {stop, normal, {}}
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
handle_call({get_state},_From,State)->
    {reply,State,State};

handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_cast({login_ok, _Code}, State) ->
    ?TRACE("login successful~n"),
    NewState = State#robot{login = 1},
    {noreply, NewState};

handle_cast(login_failed, State)->
    ?TRACE("login failed~n"),
    {stop, normal, State};

handle_cast({playerid, Id}, State)->
    NewState = State#robot{id = Id},
    {noreply, NewState};

handle_cast(enter_ok, State)->
    NewState = State#robot{act = run, status = standing},
    gen_server:cast(self(), {start_action}),
    {noreply, NewState};
    
handle_cast({after_fight,Len,TargetBin}, State)->
	DataList = get_robot_status(Len,TargetBin,[]) ,
	case lists:keyfind(State#robot.id, 1, DataList) of
		{_,CurHp} ->
			case CurHp > 0 of
				true ->
					NewState = State ;
				false ->
					NewState = State#robot{status = dead}
			end ;
		_ ->
			NewState = State
	end ,
    {noreply, NewState};

handle_cast({start_action}, State)->
    if is_port(State#robot.socket) ->
        %%心跳进程
        spawn_link(fun()->handle(heart, a , State#robot.socket) end),
		Pid= self() ,
%% 		?TRACE("=====1 start_action:~p / ~p~n",[self(),State#robot.pid]) ,
		spawn_link(fun()-> ai(Pid) end), 
%% 	   ?TRACE("=====2 start_action:~p / ~p~n",[self(),State#robot.pid]) ,
        {noreply, State};
    true -> 
        ?TRACE("start_action  stop_1: /~p/,~n",[State]),
        {stop, normal, State}
    end;

handle_cast({add_child_socket,N,Socket},State)->
    NewState = 
    if
        is_pid(State#robot.pid) andalso is_port(Socket) ->
            case N of
                2 -> State#robot{socket2 = Socket};
                3 -> State#robot{socket3 = Socket};
                _ -> State
            end;
        true ->
            ?TRACE(" start_child_socket err : /~p/,~n",[State]),
            State
    end,
    {noreply,NewState};

handle_cast({upgrade_state, NewState},_State) ->
    {noreply,NewState};

handle_cast({get_state_13001},State) ->
    handle(get_self_info, a,State#robot.socket),
    {noreply, State};
    
handle_cast({upgrade_state_13001, [Scene, X, Y]},State) ->
    NewState = State#robot{x=X, y=Y,scene=Scene},
	handle(enter_scene, [Scene] ,State#robot.socket),
    {noreply, NewState};

handle_cast({upgrade_state_revive, []},State) ->
    NewState = State#robot{status = standing},
    {noreply, NewState};
  
handle_cast({upgrade_state_13099, [IdLists]},State) ->
    IdLists1 = [[State#robot.id] | IdLists],  
    NewState = State#robot{frda=IdLists1},
    {noreply, NewState};

handle_cast({run}, State)->
    State2=State#robot{act=run},
    {noreply,State2};

handle_cast({stop}, State)->
    State2=State#robot{act=undefined},
    {noreply,State2};

handle_cast({stop, Reason},State)->
    ?TRACE("~s_quit_2: /~p/~p/~p/,~n",[misc:time_format(now()), State#robot.acid, State#robot.id, Reason]),    
    {stop, normal, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_info({stop, Reason},State)->
    ?TRACE("~s ------ robot stop: /~p/~p/~p/,~n",[misc:time_format(now()), State#robot.acid, State#robot.id, Reason]),
    {stop, normal, State};

handle_info(close, State)->
    gen_tcp:close(State#robot.socket),
    {noreply,State};

handle_info(_Info, State) ->
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(Reason, State) ->
    ?TRACE(" ----------terminate-----------~s_quit_4: /~p/~p/~p/,~n",[misc:time_format(now()), State#robot.acid, State#robot.id, Reason]),
    if is_port(State#robot.socket) ->
        gen_tcp:close(State#robot.socket);
        true -> no_socket
    end,
    ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%=========================================================================
%% 业务处理函数
%%=========================================================================
%%登录游戏服务器
login(N, Pid)->
   case connect_server(?SERVER_ADD, ?SERVER_PORT) of
                 {ok, Socket}->
%%                       ?TRACE("~s ---connect to IP:~p Port: ~p  ok...~n",[misc:time_format(now()), ?SERVER_ADD, ?SERVER_PORT]),
                       Accid = N,  
                       AccName = "guest" ++ integer_to_list(Accid),
                       handle(login, {Accid, AccName}, Socket),
                       spawn_link(fun() -> do_parse_packet(Socket, Pid) end),
                       {ok, Socket};
                 _Reason2 ->
                      ?TRACE("Connect to server failed: ~p~n", [_Reason2]),
                      error
             end.

%%连接服务端
connect_server(Ip, Port)->
    gen_tcp:connect(Ip, Port, ?TCP_OPTS, 10000).

%% 接受信息
async_recv(Sock, Length, Timeout) when is_port(Sock) ->
    case prim_inet:async_recv(Sock, Length, Timeout) of
        {error, Reason} ->  throw({Reason});
        {ok, Res}       ->  Res;
        Res             ->  Res
    end.

%%接收来自服务器的数据 - 登陆后进入游戏逻辑
%%Socket：socket id
%%Client: client记录
do_parse_packet(Socket, Pid) ->
    Ref = async_recv(Socket, ?HEADER_LENGTH, ?HEART_TIMEOUT),
    receive
        {inet_async, Socket, Ref, {ok, <<Len:16, Cmd:16>>}} ->
%%             ?TRACE("receive command:  ~p, length: ~p ", [Cmd, Len]),
            BodyLen = Len - ?HEADER_LENGTH,
            RecvData = 
            case BodyLen > 0 of
                true ->
                    Ref1 = async_recv(Socket, BodyLen, ?TCP_TIMEOUT),
                    receive
                       {inet_async, Socket, Ref1, {ok, Binary}} ->
%%                             ?TRACE("Data:  ~p~n", [Binary]),
                            {ok, Binary};
                       Other ->
                            ?TRACE("Data recv Error:  ~p~n", [Other]),
                            {fail, Other}
                    end;
                false ->
                    {ok, <<>>}
            end,
            case RecvData of
                {ok, BinData} ->
                    case Cmd of
                       10000 -> 
                            <<Code:8, _Bin1/binary>> = BinData,
                            case Code of
                                0 ->
                                    gen_server:cast(Pid, {login_ok, 0}),
                                    <<_:32, PlayerId:64, _Bin2/binary>> = _Bin1,
                                    handle(enter_player, {PlayerId}, Socket),
                                    ok;
                                1 ->
                                    <<Accid:32, _Bin2/binary>> = _Bin1,
                                    gen_server:cast(Pid, {login_ok, 1}),
                                    handle(select_role, Accid, Socket),
                                    ok;
                                _ ->
                                    gen_server:cast(Pid, login_failed),
                                    ?TRACE("login failed: Code: ~p~n", [Code]),
                                    failed
                            end;
                        10003 ->
                            <<Code:8, PlayerId:64, _Bin/binary>> = BinData,
%%                             ?TRACE("10003: Code: ~p PlayerId~p~n", [Code, PlayerId]),
                            if Code =:= 1 ->
                                handle(enter_player, {PlayerId}, Socket),
                                gen_server:cast(Pid, {playerid, PlayerId});
                            true ->
                                gen_server:cast(Pid, {stop})
                            end;
                        10004 ->
                            <<Code:8, _Bin/binary>> = BinData,
                            if 
								Code =/= 0 ->
									%% 选择玩家信息以进入场景
                                	gen_server:cast(Pid, {get_state_13001}) ;
                           		true ->
                                	gen_server:cast(Pid, {stop})
                            end;
                        13001 ->
                            <<_Uid:64,_Gender:8,_Level:8,_Career:8,_Speed:8,SceneId:16,X:8,Y:8,_Other/binary>> = BinData,
                            %%更新信息
                            gen_server:cast(Pid,{upgrade_state_13001, [SceneId,X,Y]}),
                            ok;
						12001 ->
							<<SceneId:16, _Other/binary>> = BinData,
							if
								SceneId > 0 ->
									%% 在场景中走路
									gen_server:cast(Pid,enter_ok); 
								true ->
									gen_server:cast(Pid, {stop})
							end ,
							ok ;
						12002 ->
							ok ;
						20003 -> 	%%人物被攻击
%% 							?TRACE("==20003 ~p~n",[BinData]) ,
							<<_Id1:32, _Hp1:32, _Mp1:32, _Sid1:32, _Slv1:8, _X1:8, _Y1:8, DLen:16,TarBin/binary>> = BinData,
							gen_server:cast(Pid,{after_fight,DLen,TarBin}) ,
							ok ; 
						12020 ->
							<<Code:8, _Other/binary>> = BinData ,
							case Code of
								1 ->
									gen_server:cast(Pid,{upgrade_state_revive, []}) ;
								_ ->
									gen_server:cast(Pid, {stop})
							end ,
							ok ;
                        10007 ->
                            <<Code:8>> = BinData,
							?TRACE("==10007 ~p~n",[Code]) ,
                            ok;
                        _ -> 
                            no_action
                    end,
                    do_parse_packet(Socket, Pid);
                {fail, _} ->
                    ?TRACE("do_parse_packet recv data failed:/~p/~p/~n~p~n",[Socket, Pid, RecvData]),                        
                    gen_tcp:close(Socket),
                    gen_server:cast(Pid,{stop, socket_error_1})
            end;
         %%超时处理
         {inet_async, Socket, Ref, {error,timeout}} ->
             ?TRACE("do_parse_packet timeout:/~p/~p/~n",[Socket, Pid]),
             do_parse_packet(Socket, Pid);
        %%用户断开连接或出错
        Reason ->
            ?TRACE("do_parse_packet: Error Reason:/~p/~p/~n",[Socket, Reason]),            
            gen_tcp:close(Socket),
            gen_server:cast(Pid,{stop, socket_error_3})
    end.

%% 随机事件处理
handle_action_random(PlayerId, Socket) ->
    Actions = [chat],
    Action = lists:nth(random:uniform(length(Actions)), Actions),
    Module = list_to_atom(lists:concat(["robot_",Action])),
    catch Module:handle(PlayerId, Socket),
    ok.

handle_action_friend(State) ->
    Socket = State#robot.socket,
    Friend = State#robot.frda,
    
    case Friend of
        [] -> 
            gen_tcp:send(Socket,  pack(13099, <<40:8, 200:8>>)),
            State;
        _ ->
            Index = random:uniform(length(Friend)),
            PlayerId = lists:nth(Index, Friend),
            Fri = lists:delete(PlayerId, Friend),
            Actions = [friend],
            Action = lists:nth(random:uniform(length(Actions)), Actions),
            Module = list_to_atom(lists:concat(["robot_",Action])),
            catch Module:handle(PlayerId, Socket),
            State#robot{frda = Fri}
    end.
    
%%游戏相关操作%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%心跳包
handle(heart, _, Socket) ->
    case gen_tcp:send(Socket, pack(10006, <<>>)) of
        ok ->
            sleep(24*1000),
            handle(heart, a, Socket);
        _ ->
            error
    end;


%%登陆
handle(login, {Accid, AccName}, Socket) ->
    ?TRACE("sending login request entry socket: ~p  ~p  ~p~n", [Accid, AccName, Socket]),
    AccStamp = 1273027133,
    Tick = integer_to_list(Accid) ++ AccName ++ integer_to_list(AccStamp) ++ ?TICKET,
    TickMd5 = util:md5(Tick),
    TickMd5Bin = list_to_binary(TickMd5),
    TLen = byte_size(TickMd5Bin),
    AccNameLen = byte_size(list_to_binary(AccName)),
    AccNameBin = list_to_binary(AccName),
    Data = <<9999:16, Accid:32, AccStamp:32, AccNameLen:16, AccNameBin/binary, TLen:16, TickMd5Bin/binary>>,
    ?TRACE("sending login request: ~p  ~p~n", [Accid, AccName]),
    gen_tcp:send(Socket, pack(10000, Data)),
    ok;

%%玩家列表
handle(list_player, _, Socket) ->
    gen_tcp:send(Socket, pack(10002, <<1:16>>)),
    ok;

%%选择角色进入
handle(select_role, Accid, Socket) ->
    NickName = "GUEST-" ++ integer_to_list(Accid),
    NameBin = list_to_binary(NickName),
    TLen = byte_size(NameBin),
    gen_tcp:send(Socket, pack(10003, <<9999:16, 1:8, 1:8, TLen:16, NameBin/binary>>)),    
    ok;

%%选择角色进入
handle(enter_player, {PlayerId}, Socket) ->
%% 	Posx = random:uniform(30) ,
%% 	Posy = random:uniform(20) ,
    gen_tcp:send(Socket, pack(10004, <<9999:16, PlayerId:64, 30:8, 20:8>>)),    
    ok;

%%跑步
handle(run,{DestX,DestY},Socket)->
    gen_tcp:send(Socket, pack(12011, <<DestX:8,DestY:8>>));

%%跑步
handle(broad_path,{DestX,DestY,Path},Socket)->
	Len = length(Path) ,
	Fun = fun({X,Y}) ->
				  <<X:8,Y:8>> 
		  end ,
	MoveBin  = tool:to_binary([Fun(M) || M <- Path]),
    gen_tcp:send(Socket, pack(12010, <<DestX:8,DestY:8,Len:16,MoveBin/binary>>));



%%ai模式跑步
handle(run, {X,Y, SX, SY}, Socket) ->
    ?TRACE("----running:[~p][~p]~n",[X,Y]),
    gen_tcp:send(Socket,  pack(12001, <<X:8, Y:8, SX:8, SY:8>>));

%%进入场景
handle(enter_scene,[SceneId], Socket) ->
	Posx = random:uniform(30) ,
	Posy = random:uniform(20) ,
    gen_tcp:send(Socket,  pack(12001, <<SceneId:16,Posx:8,Posy:8>>)) ;

%% 聊天模块
handle(chat1, PlayerId, Socket) ->
    Actions = [chat],
    Action = lists:nth(random:uniform(length(Actions)), Actions),
    Module = list_to_atom(lists:concat(["robot_",Action])),
    catch Module:handle(PlayerId, Socket),
    ok;

%%聊天
handle(chat,Data,Socket)->
    Bin=list_to_binary(Data),
    L = byte_size(Bin),
    gen_tcp:send(Socket,  pack(11010, <<L:16,Bin/binary>>));

%%静止
handle(undefined,a,_Socket)->
    ok;
%%获取其他玩家信息
handle(get_player_info,Id,Socket)->
    gen_tcp:send(Socket,  pack(13004, <<Id:16>>));

%%获取自己信息
handle(get_self_info, _ ,Socket)->
    ?TRACE("get_self_info: sending 13001~n"),
    gen_tcp:send(Socket,  pack(13001, <<>>));

%%原地复活
handle(revive, _, Socket)->
%%     gen_tcp:send(Socket, pack(20004, <<3:8>>)),
%%     Action = tool:to_binary("-加血 100000"),
%%     ActionLen= byte_size(Action),
%%     Data = <<ActionLen:16, Action/binary>>,
%%     Packet =  pack(11020, Data),    
%%     gen_tcp:send(Socket, Packet);
	   gen_tcp:send(Socket, pack(12020, <<>>)) ;

handle(Handle, Data, Socket) ->
    ?TRACE("handle error: /~p/~p/~n", [Handle, Data]),
    {reply, handle_no_match, Socket}.

%%玩家列表
read(<<L:32, 10002:16, Num:16, Bin/binary>>) ->
    ?TRACE("client read: ~p ~p ~p~n", [L, 10002, Num]),
    F = fun(Bin1) ->
        <<Id:32, S:16, C:16, Sex:16, Lv:16, Bin2/binary>> = Bin1,
        {Name, Rest} = read_string(Bin2),
        ?TRACE("player list: Id=~p Status=~p Pro=~p Sex=~p Lv=~p Name=~p~n", [Id, S, C, Sex, Lv, Name]),
        Rest
    end,
    for(0, Num, F, Bin),
    ?TRACE("player list end.~n");

read(<<L:32, Cmd:16>>) ->
    ?TRACE("client read: ~p ~p~n", [L, Cmd]);
read(<<L:32, Cmd:16, Status:16>>) ->
    ?TRACE("client read: ~p ~p ~p~n", [L, Cmd, Status]);
read(<<L:32, Cmd:16, Bin/binary>>) ->
    ?TRACE("client read: ~p ~p ~p~n", [L, Cmd, Bin]);
read(Bin) ->
    ?TRACE("client rec: ~p~n", [Bin]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%辅助函数
%%读取字符串
read_string(Bin) ->
    case Bin of
        <<Len:16, Bin1/binary>> ->
            case Bin1 of
                <<Str:Len/binary-unit:8, Rest/binary>> ->
                    {binary_to_list(Str), Rest};
                _R1 ->
                    {[],<<>>}
            end;
        _R1 ->
            {[],<<>>}
    end.

random_sleep(T) ->
    N = random:uniform(T),
    timer:sleep(N * 100).


sleep(T) ->
    receive
    after T -> ok
    end.

for(Max, Max, _F) ->
    [];
for(Min, Max, F) ->
    [F(Min) | for(Min+1, Max, F)].

for(Max, Max, _F, X) ->
    X;
for(Min, Max, F, X) ->
    F(X),
    for(Min+1, Max, F, X).

sleep_send({T, S}) ->
    receive
    after T -> handle(run, a, S)
    end.

get_pid(Name)->
    case whereis(Name) of
        undefined ->
            err;
        Pid->Pid
    end.

ping(Node)->
    case net_adm:ping(Node) of
        pang ->
            ?TRACE("ping ~p error.~n",[Node]);
        pong ->
            ?TRACE("ping ~p success.~n",[Node]);
        Error->
            ?TRACE("error: ~p ~n",[Error])
    end.

get_robot_status(0,_TargetBin,DataList) ->
	DataList ;
get_robot_status(Len,TargetBin,DataList) ->
	<<_:8,UId:64,CurHp:32,_:32,_:32,_:32,_:8,OtherBin/binary>> = TargetBin ,
	NewDataList = DataList ++ [{UId,CurHp}] , 
	get_robot_status(Len-1,OtherBin,NewDataList) . 
	

%%根据机器人状态进行动作
ai(Pid)->
	%%更新信息
%% 	gen_server:cast(Pid,{get_state_13001}),
	Random_interval = random:uniform(1000)+100,
	sleep(Random_interval),    
	State=gen_server:call(Pid,{get_state}),
	case State#robot.act of
		run ->
			case State#robot.status of
				standing ->
					DestX = random:uniform(30) ,
					DestY = random:uniform(30) ,
%% 					?TRACE("====ai(Pid) ~p~n",[[Pid,DestX,DestY]]) ,
					Path = make_move_path(State#robot.x,State#robot.y,DestX,DestY,[]) ,
					handle(broad_path,{DestX,DestY, Path++[{DestX,DestY}]},State#robot.socket),
					State2=State#robot{tox=DestX,toy=DestY,step=Path,status=running},
					gen_server:cast(State#robot.pid,{upgrade_state,State2}) ;
				running ->
					if State#robot.step =/= [] ->    %%当前坐标不等于目的坐标
					       [{NextX,NextY}|LeftPath] = State#robot.step ,
						   handle(run,{NextX,NextY},State#robot.socket) ,
						   State2=State#robot{x=NextX,y=NextY,step=LeftPath,status=running} ,
						   gen_server:cast(State#robot.pid,{upgrade_state,State2}) ;
					   true ->
						   State2=State#robot{status=standing},                        %%到达目的地, 换个状态为站
						   gen_server:cast(State#robot.pid,{upgrade_state,State2})    %%更新机器人状态
					end;
				dead ->
					handle(revive,a,State#robot.socket) ;    %%让其复活
				_->
					?TRACE("robot status error!~n")
			end ;
		undefined ->
			ok
	end,
	ai(Pid).

pack(Cmd, Data) ->
    L = byte_size(Data) + ?HEADER_LENGTH,
    <<L:16, Cmd:16, Data/binary>>.


rand(Same, Same) -> Same;
rand(Min, Max) ->
    M = Min - 1,
    if
        Max - M =< 0 ->
            0;
        true ->
            random:uniform(Max - M) + M
    end.


%%@spec 获取怪物追击路径
make_move_path(StartX,StartY,EndX,EndY,Path) ->
	if
		StartX =:= EndX andalso StartY =:= EndY ->
			Path ;
		StartX =:= EndX ->
			NextX = StartX ,
			NextY = make_next_step(StartY,EndY) ,
			NewPath = Path ++ [{NextX,NextY}] ,
			make_move_path(NextX,NextY,EndX,EndY,NewPath) ;
		StartY =:= EndY ->
			NextX = make_next_step(StartX,EndX) ,
			NextY = EndY ,
			NewPath = Path ++ [{NextX,NextY}] ,
			make_move_path(NextX,NextY,EndX,EndY,NewPath) ;
		true ->
			NextX = make_next_step(StartX,EndX) ,
			NextY = make_next_step(StartY,EndY)  ,
			NewPath = Path ++ [{NextX,NextY}] ,
			make_move_path(NextX,NextY,EndX,EndY,NewPath) 
	end .
make_next_step(Current,Target) ->
	if Current > Target ->
		   if Current - Target > 1 ->
				  Current - 1;
			  true ->
				  Target
		   end;
	   true ->
		   if Target - Current > 1 ->
				  Current + 1;
			  true ->
				  Target
		   end
	end.
