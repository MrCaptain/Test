%%% -------------------------------------------------------------------
%%% Author  :devil 1812338@gmail.com
%%% Description : 
%%%
%%% Created :
%%% -------------------------------------------------------------------
-module(robot_tree).

-behaviour(gen_server).
-compile(export_all).
-include("common.hrl").
-include("record.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

-define(CONFIG_FILE, "../config/gateway.config").

%% 连接网关端口，不读取gateway配置
%% -define(GATEWAY_ADD,"127.0.0.1").  
-define(GATEWAY_ADD,"192.168.51.174"). 
-define(GATEWAY_PORT,7777).

%% %%-----外S服 begin--------
%% -define(GATEWAY_ADD,"s888.cszd.me4399.com").
%% -define(GATEWAY_PORT,4077).
%% %%-----S1服  end --------

-define(ACTION_SPEED_CONTROL, 10).
-define(ACTION_INTERVAL, ?ACTION_SPEED_CONTROL*10*1000).  	% 自动行为最大时间间隔
-define(ACTION_MIN, 1000).									% 自动行为最小时间间隔

-define(TCP_TIMEOUT, 10*1000). 								% 解析协议超时时间
-define(HEART_TIMEOUT, 60*1000). 							% 心跳包超时时间
-define(HEART_TIMEOUT_TIME, 0). 							% 心跳包超时次数
-define(HEADER_LENGTH, 6). %
-define(TCP_OPTS, [
				   binary,
				   {packet, 0}, 		% no packaging
				   {reuseaddr, true}, 	% allow rebind without waiting
				   {nodelay, false},
				   {delay_send, true},
				   {active, false},
				   {exit_on_close, false}
				  ]).

-define(ETS_ROBOT, ets_robot).

-define(CHECK_ROBOT_STATUS, 1*60*1000).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-record(robot, {
				orig_n,		
				acid,	%%account id
				socket,	%%socket
				socket2,
				socket3,
				pid,	%%process id
				x ,		%%x坐标
				y ,		%%y坐标
				scene,
				tox,
				toy,
				hp,
				id,		%% id
				act,	%% 动作
				status,	%% 当前状态
				dstScene,
				tpg,
				fidlist 
			   }).
%%%
%%% API
start1() ->
	start(10000, 500).
start2() ->
	start(10500,500).
start3() ->
	start(11000,500).
start4() ->
	start(11500,500).
start5() ->
	start(12000,500).
start6() ->
	start(12500,500).
start7() ->
	start(13000,500).
start8() ->
	start(13500,500).
start9()-> 
	start(1,500).
start10(Num)->
	start(10000,Num).

start()->
	start1().

%%StartId 起始AccountID
%%Num int 数量
%%Mod 跑步模式 1 ,2
start(StartId,Num)->
	sleep(1000),
	F=fun(N)->
			  io:format("start 1 ~p~n",[N]),
			  sleep(500),
			  robot_tree:start_link(StartId + N)
	  end,
	for(0,Num,F),
	ok.

%%
%%创建 一个ROBOT 进程
start_link(N)->
	case gen_server:start(?MODULE,[N],[]) of
		{ok, Pid}->
			io:format("---------------start ~p finish!----------~n",[N]),
			gen_server:cast(Pid, {start_action});
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
	%% 	io:format("-----init 2----------------------~p~n",[Pid]),
	case login(N, Pid) of
		{ok, Socket, Accid, Id}->
			Scene = 102,
			Robot= #robot{socket=Socket, 
						  acid=list_to_integer(Accid), 
						  id=Id, 
						  pid = Pid,
						  act=run,
						  status=standing,
						  dstScene = Scene,
						  tox=rand(1,40),
						  toy=rand(1,20),
						  orig_n = N,
						  tpg = 1,
						  fidlist = []						 },
			%%登陆成功后开始动作
			{ok,Robot};
		_Error ->
			io:format("--------------------init---------err----~p----~n",[_Error]),
			{stop,normal,{}}
	end.

%%登录游戏服务器
login(N, Pid)->
	%% 	io:format("-----login----------------------~p~n",[N]),
	case get_game_server() of
		{Ip, Port} ->
			case connect_server(Ip, Port) of
				{ok, Socket}->
					Data = pack(10010, <<9999:16,N:32>>),%%创建角色
					gen_tcp:send(Socket, Data),	
					try
						Ref = async_recv(Socket, ?HEADER_LENGTH, ?TCP_TIMEOUT),
						receive
							{inet_async, Socket, Ref, {ok, <<Len:32, Cmd:16>>}} ->
								BodyLen = Len - ?HEADER_LENGTH,
								case BodyLen > 0 of
									true ->
										Ref1 = async_recv(Socket, BodyLen, ?TCP_TIMEOUT),
										receive
											{inet_async, Socket, Ref1, {ok, Binary}} when Cmd =:= 10010->
												<<AccId:32, PlayerId:32, Bin/binary>> = Binary,
												{_Accname, _} = pt:read_string(Bin),
												handle(login, {AccId, "N"}, Socket),
												spawn_link(fun()->do_parse_packet(Socket, Pid) end),													
												handle(enter_player,{PlayerId},Socket),
												{ok, Socket, integer_to_list(N), PlayerId};
											_Other ->
												gen_tcp:close(Socket),
												error_60
										end;
									false ->
										error_70
								end;					   
							%%用户断开连接或出错
							_Other ->
								io:format("---------------------------------other-----err---------~p~n",[_Other]),
								gen_tcp:close(Socket),
								error_80
						end
					catch
						_:_ -> gen_tcp:close(Socket),
							   error_90
					end;
				_ ->
					error_100
			end;
		_->	error_110
	end.

%% 获取网关服务器参数
get_gateway_config(Config_file)->
	try
		{ok,[L]} = file:consult(Config_file),
		{_, C} = lists:keyfind(gateway, 1, L),
		{_, Mysql_config} = lists:keyfind(tcp_listener, 1, C),
		{_, Ip} = lists:keyfind(ip, 1, Mysql_config),
		{_, Port} = lists:keyfind(port, 1, Mysql_config),
		[Ip, Port]		
	catch
		_:_ -> [?GATEWAY_ADD,?GATEWAY_PORT]
	end.

%%连接网关服务器
get_game_server()->
	[Gateway_Ip, Gateway_Port] = [?GATEWAY_ADD,?GATEWAY_PORT] ,
	case gen_tcp:connect(Gateway_Ip, Gateway_Port, ?TCP_OPTS, 10000) of
		{ok, Socket}->
			Data = pack(60000, <<>>),
			gen_tcp:send(Socket, Data),
			try
				case gen_tcp:recv(Socket, ?HEADER_LENGTH) of
					{ok, <<Len:32, 60000:16>>} ->
						BodyLen = Len - ?HEADER_LENGTH,
						case gen_tcp:recv(Socket, BodyLen, 3000) of
							{ok, <<Bin/binary>>} ->
								<<Rlen:16, RB/binary>> = Bin,
								case Rlen of
									1 ->
										<<Bin1/binary>> = RB,
										{IP, Bin2} = pt:read_string(Bin1),
										<<Port:16, _Num:8>> = Bin2,
										{IP, Port};
									_-> 
										no_gameserver
								end;
							_ ->
								gen_tcp:close(Socket),
								error_10
						end;
					{error, _Reason} ->
						io:format("get_game_server error:~p/~n",[_Reason]),
						gen_tcp:close(Socket),
						error_20
				end
			catch
				_:_ -> gen_tcp:close(Socket),
					   error_30
			end;
		{error,_Reason}->
			io:format("get_game_server--------------error:~p/~n",[_Reason]),
			error_40
	end.

%%连接服务端
connect_server(Ip, Port)->
	gen_tcp:connect(Ip, Port, ?TCP_OPTS, 10000).

%% 接受信息
async_recv(Sock, Length, Timeout) when is_port(Sock) ->
	case prim_inet:async_recv(Sock, Length, Timeout) of
		{error, Reason} -> 	throw({Reason});
		{ok, Res}       ->  Res;
		Res             ->	Res
	end.

%%接收来自服务器的数据 - 登陆后进入游戏逻辑
%%Socket：socket id
%%Client: client记录
do_parse_packet(Socket, Pid) ->
	Ref = async_recv(Socket, ?HEADER_LENGTH, ?HEART_TIMEOUT),
	receive
		{inet_async, Socket, Ref, {ok, <<Len:32, Cmd:16>>}} ->
			BodyLen = Len - ?HEADER_LENGTH,
			RecvData = 
				case BodyLen > 0 of
					true ->
						Ref1 = async_recv(Socket, BodyLen, ?TCP_TIMEOUT),
						receive
							{inet_async, Socket, Ref1, {ok, Binary}} ->
								{ok, Binary};
							Other ->
								{fail, Other}
						end;
					false ->
						{ok, <<>>}
				end,
			case RecvData of
				{ok, BinData} ->
					case Cmd of
						13001 ->
							<<Scene:32, X:16, Y:16,_Id:32,Hp:32,_Other/binary>> = BinData,
							%%更新信息
							gen_server:cast(Pid,{upgrade_state_13001, [Scene, X, Y, Hp]}),
							ok;
%% 						12001 ->		%%对场景跑动的玩家加好友
%% 							<<_X:8, _Y:8, _SX:8, _SY:8, HisUid:32>> = BinData,
%% 							Rand = rand(1,10),
%% 							if
%% 								Rand > 5 ->
%% 									gen_server:cast(Pid,{upgrade_state_12001, [HisUid]});
%% 								true ->
%% 									ok
%% 							end;
						12003 ->		%%对进入场景的玩家加好友
							<<_X:8, _Y:8, HisUid:32, _Other/binary>> = BinData,
							gen_server:cast(Pid,{upgrade_state_12003, [HisUid]}),
							ok;
						18001 ->		%%对好友请求同意加好友
							<<NumLen:16, Records/binary>> = BinData,
							if 
								NumLen > 0 ->
									decode_18001(NumLen,Records,Socket),
									ok;
								true ->
									ok
							end;
						42010 ->		%%解析42010圣树好友列表协议
							case BinData of
								<<TotalPage:8, _B/binary>> ->
									FriendsIdList = parse_42010(BinData),
									gen_server:cast(Pid,{upgrade_state_42010, [TotalPage, FriendsIdList]});
								_ ->
									skip
							end,
							ok;
						_ -> no_action
					end,
					do_parse_packet(Socket, Pid);
				{fail, _} ->
					io:format("do_parse_packet_1_ fail:/~p/~p/~n",[Socket, Pid]),						
					gen_tcp:close(Socket),
					gen_server:cast(Pid,{stop, socket_error_1})
			end;
		%%超时处理
		{inet_async, Socket, Ref, {error,timeout}} ->
			io:format("do_parse_packet_2_timeout:/~p/~p/~n",[Socket, Pid]),			 
			gen_tcp:close(Socket),
			gen_server:cast(Pid,{stop, socket_error_2});
		%%用户断开连接或出错
		Reason ->
			io:format("do_parse_packet_3_Reason:/~p/~p/~n",[Socket, Reason]),			
			gen_tcp:close(Socket),
			gen_server:cast(Pid,{stop, socket_error_3})
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
handle_call({act},_From,State)->
	%%act有跑步run或者静止undefined
	handle(State#robot.act, a, State#robot.socket),
	{reply,ok,State};

handle_call({get_state},_From,State)->
	{reply,State,State};

handle_call({get_socket},_From,State)->
	Reply=State#robot.socket,
	{reply,Reply,State};

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
handle_cast({start_action}, State)->
	if is_port(State#robot.socket) ->
		   
		   %%io:format("      start_action  : /~p/,~n",[State]),
		   %%心跳进程
		   spawn_link(fun()->handle(heart, a , State#robot.socket) end),
		   Pid= self(),
		   if
			   is_pid(Pid) ->
				   handle(chat,"-加经验 100000000",State#robot.socket),
				   sleep(1000),
				   handle(chat,"-全功能",State#robot.socket),
				   sleep(1000),
				   handle(enter_scene,State#robot.dstScene, State#robot.socket),			%%去场景
				   spawn_link(fun()-> ai(Pid) end),
				   {noreply, State};
			   true ->
				   io:format("      start_action  stop_1: /~p/,~n",[State]),
				   {stop, normal, State}
		   end;
	   true -> 
		   io:format("      start_action  stop_1: /~p/,~n",[State]),
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
				io:format(" start_child_socket err : /~p/,~n",[State]),
				State
		end,
	{noreply,NewState};

handle_cast({upgrade_state, NewState},_State) ->
	{noreply,NewState};

%%对场景跑动的玩家加好友
handle_cast({upgrade_state_12001, [HisUid]}, State) ->
	if
		HisUid =/= State#robot.id ->
			case lists:member(HisUid, State#robot.fidlist) of
				false ->
					gen_tcp:send(State#robot.socket,  pack(58001, <<HisUid:32>>));
				true ->
					skip
			end;
		true ->
			skip
	end,
	{noreply, State};

%%对进入场景的玩家加好友
handle_cast({upgrade_state_12003, [HisUid]}, State) ->
	if
		HisUid =/= State#robot.id andalso is_number(HisUid) ->
			case lists:member(HisUid, State#robot.fidlist) of
				false ->
					gen_tcp:send(State#robot.socket,  pack(58001, <<HisUid:32>>));
				true ->
					skip
			end;
		true ->
			skip
	end,
	{noreply, State};

handle_cast({get_state_13001},State) ->
	handle(get_self_info, a,State#robot.socket),
	{noreply, State};

handle_cast({upgrade_state_13001, [Scene, X, Y, Hp]},State) ->
	NewState = State#robot{x=X, y=Y, hp=Hp, scene=Scene},
	{noreply, NewState};

handle_cast({upgrade_state_42010, [TotalPage, FriendsIdList]},State) ->
	if
		TotalPage > 0 ->
			NewState = State#robot{tpg=TotalPage, fidlist=FriendsIdList};
		true ->
			NewState = State
	end,
	{noreply, NewState};

handle_cast({stop, Reason},State)->
	io:format("      ~s_quit_2: /~p/~p/~p/,~n",[misc:time_format(now()), State#robot.acid, State#robot.id, Reason]),	
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
	io:format("      ~s_quit_3: /~p/~p/~p/,~n",[misc:time_format(now()), State#robot.acid, State#robot.id, Reason]),
	{stop, normal, State};

handle_info({event, action_random, PlayerId, Socket},State) ->
	Random_interval = random:uniform(?ACTION_INTERVAL) + ?ACTION_MIN,
	handle_action_random(PlayerId, Socket),
	erlang:send_after(Random_interval, self(), {event, action_random, PlayerId, Socket}),
	{noreply,State};

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
	io:format(" ----------terminate-----------~s_quit_4: /~p/~p/~p/,~n",[misc:time_format(now()), State#robot.acid, State#robot.id, Reason]),
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
%% 随机事件处理
handle_action_random(PlayerId, Socket) ->
	Actions = [chat1, others],
	Action = lists:nth(random:uniform(length(Actions)), Actions),
	Module = list_to_atom(lists:concat(["robot_",Action])),
	catch Module:handle(PlayerId, Socket),
	ok.
  

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

%%子socket链接
handle(start_child_socket,{State,N},_) ->
	sleep(5000),
	case get_game_server() of
		{Ip, Port} ->
			case connect_server(Ip, Port-N*100) of
				{ok, Socket}->
					Accid = State#robot.acid,
					Pid = State#robot.pid,
					Data = pack(10008, <<9999:16,Accid:32,N:8>>),
					gen_tcp:send(Socket, Data),	
					try
						Ref = async_recv(Socket, ?HEADER_LENGTH, ?TCP_TIMEOUT),
						receive
							{inet_async, Socket, Ref, {ok, <<Len:32, Cmd:16>>}} ->
								BodyLen = Len - ?HEADER_LENGTH,
								case BodyLen > 0 of
									true ->
										Ref1 = async_recv(Socket, BodyLen, ?TCP_TIMEOUT),
										receive
											{inet_async, Socket, Ref1, {ok, Binary}} when Cmd =:= 10008 ->
												<<Code:16,N:8>> = Binary,
												if
													Code == 1 ->
														gen_server:cast(Pid,{add_child_socket,N,Socket}),
														{ok, N};
													true ->
														error_50
												end;
											Other ->
												io:format("---------------child-----------cmd--other:~p~n",[Other]),
												gen_tcp:close(Socket),
												error_60
										end;
									false ->
										error_70
								end;					   
							%%用户断开连接或出错
							Other ->
								io:format("---------------------child------------other-----err---------~p~n",[Other]),
								gen_tcp:close(Socket),
								error_80
						end
					catch
						_:_ -> gen_tcp:close(Socket),
							   error_90
					end;
				_ ->
					error_100
			end;
		_->	error_110
	end;

%%登陆
handle(login, {Accid, AccName}, Socket) ->
	AccStamp = 1273027133,
	Tick = integer_to_list(Accid) ++ AccName ++ integer_to_list(AccStamp) ++ ?TICKET,
	TickMd5 = util:md5(Tick),
	TickMd5Bin = list_to_binary(TickMd5),
	AccNameLen = byte_size(list_to_binary(AccName)),
	AccNameBin = list_to_binary(AccName),
	Data = <<9999:16, Accid:32, AccStamp:32, AccNameLen:16, AccNameBin/binary, 32:16, TickMd5Bin/binary>>,
	gen_tcp:send(Socket, pack(10000, Data)),
	ok;

%%选择角色进入
handle(enter_player, {PlayerId}, Socket) ->
	gen_tcp:send(Socket, pack(10004, <<9999:16,PlayerId:32>>)),	
	
	gen_tcp:send(Socket, pack(12002, <<>>)),	
	ok;

%%ai模式跑步
handle(run, {X,Y, SX, SY}, Socket) ->
	gen_tcp:send(Socket,  pack(12001, <<X:8, Y:8, SX:8, SY:8>>));

%%进入场景
handle(enter_scene,Sid, Socket) ->
	gen_tcp:send(Socket,  pack(12005, <<Sid:32>>)),
	gen_tcp:send(Socket, pack(12002, <<>>));				%%换场景还要发送12002加载场景, 不然看不到角色的。

%%聊天
handle(chat,Data,Socket)->
	Bin=list_to_binary(Data),
	_L=byte_size(Bin) + ?HEADER_LENGTH,
	L = byte_size(Bin),
	gen_tcp:send(Socket,  pack(11010, <<L:16,Bin/binary>>));
%%静止
handle(undefined,a,_Socket)->
	ok;

%%获取自己信息
handle(get_self_info, _ ,Socket)->
	gen_tcp:send(Socket,  pack(13001, <<1:16>>));

%%查询圣树好友
handle(tree_friends, Page,  Socket) ->
	gen_tcp:send(Socket,  pack(42010, <<Page:8>>));
	
%%采圣树果实
handle(pick_tree, _,  Socket) ->
	gen_tcp:send(Socket,  pack(42013, <<1:8>>));

%%给圣树注灵
handle(water_tree, HisUid,  Socket) ->
	gen_tcp:send(Socket,  pack(42014, <<HisUid:32>>));

handle(Handle, Data, Socket) ->
	io:format("handle error: /~p/~p/~n", [Handle, Data]),
	{reply, handle_no_match, Socket}.


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
	timer:sleep(N * 1000).


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
            io:format("ping ~p error.~n",[Node]);
        pong ->
            io:format("ping ~p success.~n",[Node]);
        Error->
            io:format("error: ~p ~n",[Error])
    end.

do_act(Pid)->
    State=gen_server:call(Pid,{get_state}),
    handle(State#robot.act,a,State#robot.socket),
    sleep(20000),
    do_act(Pid).

%%根据机器人状态进行动作
ai(Pid)->
	%%更新信息
	gen_server:cast(Pid,{get_state_13001}),
	Random_interval = random:uniform(6000)+3000,
	sleep(Random_interval),	
	State=gen_server:call(Pid,{get_state}),
	case State#robot.status of
		standing ->			%%当前状态是站着
			Tox = rand(5,40),
			Toy = rand(10,20),
			if
				State#robot.fidlist =:= [] ->
					handle(tree_friends, 1, State#robot.socket),						%%查询圣树好友
					sleep(5000);
				true ->
					skip
			end,
 			if
 				State#robot.fidlist =/= [] ->
 					RandIndex = random:uniform(length(State#robot.fidlist)),
 					HisUid = lists:nth(RandIndex, State#robot.fidlist),
					FidList = [Fid||Fid<-State#robot.fidlist, Fid =/= HisUid],
 					handle(water_tree, HisUid,  State#robot.socket),					%%给好友的圣树注灵
					sleep(5000);
 				true ->
					FidList = [],
					handle(chat,"-retree",State#robot.socket),							%%恢复圣树次数
					sleep(5000),
					handle(pick_tree, State#robot.id,  State#robot.socket),				%%采圣树果实
					sleep(5000),
					handle(water_tree, State#robot.id,  State#robot.socket),			%%给自己的圣树注灵
					sleep(5000)
 			end,
			State2=State#robot{tox=Tox,toy=Toy,status=running, fidlist=FidList},%%换个目的坐标, 状态改为跑
			gen_server:cast(State#robot.pid,{upgrade_state,State2});			%%更新机器人状态
		running ->			%%当前状态是跑
			if State#robot.x =/= State#robot.tox orelse State#robot.y =/=State#robot.toy ->	%%当前坐标不等于目的坐标
				   handle(run,{State#robot.x,State#robot.y, State#robot.tox,State#robot.toy},State#robot.socket),
				   Random_interval2 = round(abs(State#robot.tox - State#robot.x) / 3)* 1000,
				   sleep(Random_interval2),
				   handle(run,{State#robot.tox,State#robot.toy, State#robot.tox,State#robot.toy},State#robot.socket);		
			   true ->
				   State2=State#robot{status=standing},						%%到达目的地, 换个状态为站
				   gen_server:cast(State#robot.pid,{upgrade_state,State2})	%%更新机器人状态
			end;
		_->
			State2=State#robot{status=standing},						%%到达目的地, 换个状态为站
			gen_server:cast(State#robot.pid,{upgrade_state,State2})		%%更新机器人状态
	end,
	ai(Pid).

pack(Cmd, Data) ->
	L = byte_size(Data) + ?HEADER_LENGTH,
	<<L:32, Cmd:16, Data/binary>>.


rand(Same, Same) -> Same;
rand(Min, Max) ->
	M = Min - 1,
	if
		Max - M =< 0 ->
			0;
		true ->
			random:uniform(Max - M) + M
	end.


%%协议解析处理函数函数
decode_18001(Num,R,Socket) ->
	if
		Num > 0 ->
			<<Nid:32,Type:8,CntBin/binary>> = R,
			{_Con,RsetBin} = read_string(CntBin),
			<<OtherId:32,NexBin/binary>> = RsetBin,
			if 
				Type == 4 ->
					gen_tcp:send(Socket,  pack(58003, <<OtherId:32,0:8,Nid:32>>));
				true ->
					ok
			end,
			decode_18001(Num-1,NexBin,Socket);
		true ->
			ok
	end.

%%解析42010圣树好友列表协议
parse_42010(BinData) ->
	case BinData of
		<<_TotalPage:8, _CurPage:8, _FriendsTotalNum:16, LenData:16, PageBinData/binary>> ->
			if
				LenData > 0 ->
					parse_42010_content(PageBinData, LenData, []);
				true ->
					[]
			end;
		_ ->
			[]
	end.

%%解析42010圣树好友列表协议内容，得到好友ID列表
parse_42010_content(PageBinData, Len, FIdList) ->
	if
		Len > 0 ->
			<<PlayerId:32, BinData/binary>> = PageBinData,
			{_, BinData1} = read_string(BinData),
			<<_Crr:8,_Coh:32, _Sex:8, _Online:8, CanWater:8, BinData2/binary>> = BinData1,
			if
				CanWater =:= 1 ->
					parse_42010_content(BinData2, Len-1, [PlayerId|FIdList]);
				true ->
					parse_42010_content(BinData2, Len-1, FIdList)
			end;
		true ->
			FIdList
	end.
