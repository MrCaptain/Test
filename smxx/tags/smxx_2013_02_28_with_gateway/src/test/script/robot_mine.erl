%%% -------------------------------------------------------------------
%%% Author  :devil 1812338@gmail.com
%%% Description : 
%%%
%%% Created :
%%% -------------------------------------------------------------------
-module(robot_mine).

-behaviour(gen_server).
-compile(export_all).
-include("common.hrl").
-include("record.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

-define(CONFIG_FILE, "../config/gateway.config").

%% 连接网关端口，不读取gateway配置
-define(GATEWAY_ADD,"127.0.0.1"). 
%% -define(GATEWAY_ADD,"s888.cszd.me4399.com"). 
-define(GATEWAY_PORT,7777).
%% -define(GATEWAY_PORT,4077).

-define(ACTION_SPEED_CONTROL, 10).
-define(ACTION_INTERVAL, ?ACTION_SPEED_CONTROL*10*1000).  	% 自动行为最大时间间隔
-define(ACTION_MIN, 1000).									% 自动行为最小时间间隔

-define(TCP_OPTS, [
        binary,
        {packet, 0}, % no packaging
        {reuseaddr, true}, % allow rebind without waiting
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
		step ,
		scene_id = 0 ,
		copper_id = 0 
    }).
%%%
%%% API

start()-> 
	start(1032,2).				%%1~10 本机上测试
%% 	start(20000,500).		%%版署2服 测试多人副本的机器人

start(Num)->
	start(999,Num).

%%StartId 起始AccountID
%%Num int 数量
start(StartId,Num)->
    sleep(100),
    F=fun(N)->
			io:format("start 1 ~p~n",[N]),
          	sleep(500),
       		start_link(StartId + N)
    end,
    for(0,Num,F),
	ok.

%%创建 一个ROBOT 进程
start_link(N)->
    case gen_server:start(?MODULE,[N],[]) of
        {ok, Pid}->
			io:format("---------------start ~p finish!----------~n",[N]),
			gen_server:cast(Pid, {start_action}),	%由此进入模拟角色动作
			gen_server:cast(Pid, {enter_mine}) ;
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
	case login(N, Pid) of							%先登录(里面先根据N作为帐号ID创建角色)
		{ok, Socket, Accid, Id}->
			Scene = 163,
			
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
							  step = 0
							 },
			%%登陆成功后开始动作
			{ok,Robot};
		_Error ->
			io:format("~n--------------------init---------err----~p----~n",[_Error]),
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
	%%[Gateway_Ip, Gateway_Port] = get_gateway_config(?CONFIG_FILE),
	%%io:format("get_game_server :  ~p/~n",[test]),
	[Gateway_Ip, Gateway_Port] = [?GATEWAY_ADD,?GATEWAY_PORT] ,
    case gen_tcp:connect(Gateway_Ip, Gateway_Port, ?TCP_OPTS, 10000) of
        {ok, Socket}->
			%%io:format("get_game_server connect:  ~p/~n",[Socket]),
			Data = pack(60000, <<>>),
            gen_tcp:send(Socket, Data),
    		try
			case gen_tcp:recv(Socket, ?HEADER_LENGTH) of
				{ok, <<Len:32, 60000:16>>} ->
%% 					io:format("len: ~p ~n",[Len]),
					BodyLen = Len - ?HEADER_LENGTH,
            		case gen_tcp:recv(Socket, BodyLen, 3000) of
                		{ok, <<Bin/binary>>} ->
							<<Rlen:16, RB/binary>> = Bin,
							case Rlen of
								1 ->
									<<Bin1/binary>> = RB,
									{IP, Bin2} = pt:read_string(Bin1),
									<<Port:16, _Num:8>> = Bin2,
 									%%io:format("get_game_server IP, Port:  /~p/~p/~n",[IP, Port]),
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
	%%io:format("do_parse_packet_0_:/~p/~p/~n",[Socket, Pid]),	
	Ref = async_recv(Socket, ?HEADER_LENGTH, ?HEART_TIMEOUT),
	receive
		{inet_async, Socket, Ref, {ok, <<Len:32, Cmd:16>>}} ->
			%%io:format("do_parse_packet_1_:/~p/~p/~n",[Socket, Pid]),			
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
			%%io:format("do_parse_packet_11_:/~p/~p/~n",[Socket, RecvData]),	
			case RecvData of
				{ok, BinData} ->
					%%io:format("do_parse_packet_CMD_:/~p/~n",[Cmd]),						
					case Cmd of
						13001 ->		%%接收到服务器返回的角色信息													
							%% 							io:format("do_parse_packet_6_:/~p/~p/~n",[Cmd, BinData]),
							<<Scene:32, X:16, Y:16,_Id:32,Hp:32,_Other/binary>> = BinData,			%%取出场景、坐标
							%%			io:format("do_parse_packet_7_:/~p/~n",[[Pid, Cmd, Scene, X, Y, Hp]]),
							%%更新信息
							gen_server:cast(Pid,{upgrade_state_13001, [Scene, X, Y, Hp]}),			%%根据取到的场景、坐标更新本地机器人状态
							ok;
						10007 ->
							<<_Code:16>> = BinData,
							%% 							io:format("do_parse_packet_10007_:/~p/~n",[Code]),
							ok;
						49001 ->
							<<Code:8,SceneId:32,_RestBin/binary>> = BinData,
							io:format("do_parse_packet_49001_:/~p/~p/~n",[Code,SceneId]),
							gen_server:cast(Pid,{upgrade_state_49001, [Code,SceneId]}),			%%更新本地机器人状态
							ok;
%% 						12005 ->
%% 							<<Code:8,_RestBin/binary>> = BinData,
%% 							io:format("do_parse_packet_12005_:/~p/~n",[Code]),
%% 							gen_server:cast(Pid,{upgrade_state_12005,[Code]}),	 
%% 							ok ;
%% 						49005 ->
%% 							<<Code:8,_RestBin/binary>> = BinData,
%% 							io:format("do_parse_packet_49005_:/~p/~n",[Code]),
%% 							gen_server:cast(Pid,{upgrade_state_49005, [Code]}),			%%更新本地机器人状态
%% 							ok;
						49004 ->
							<<Code:8,_RestBin/binary>> = BinData,
							io:format("do_parse_packet_49004_:/~p/~n",[Code]),
							gen_server:cast(Pid,{upgrade_state_49004, [Code]}),			%%更新本地机器人状态
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
    handle(State#robot.act, a, State#robot.socket),			%%根据机器人当前的动作进入相应动作
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
		%%socket2 进程
		%%spawn_link(fun()->handle(start_child_socket,{State,2},c) end),
		%%socket3 进程
		%%spawn_link(fun()->handle(start_child_socket,{State,3},c) end),
		Pid= self(),
		%%io:format("      start_action  1: /~p/,~n",[Pid]),
		spawn_link(fun()-> ai(Pid) end),  %%临时取消
		handle(chat,"-全功能",State#robot.socket),
		handle(chat,"-开场景",State#robot.socket),
		handle(chat,"-充值 1000000",State#robot.socket),
		handle(chat,"-加经验 10000000000",State#robot.socket),

		handle(enter_scene,State#robot.dstScene, State#robot.socket),			%%去场景
		{noreply, State};
	   true -> 
		   io:format("      start_action  stop_1: /~p/,~n",[State]),
		   {stop, normal, State}
	end;

handle_cast({enter_mine},State) ->
	gen_tcp:send(State#robot.socket,  pack(49001, <<>>)),
%% 	NewState = State#robot{status = enter_mine} ,
	{noreply, State};

  
handle_cast({set_auto_draw},State) ->
	gen_tcp:send(State#robot.socket,  pack(49005, <<1:8>>)),
%% 	NewState = State#robot{status = set_auto_draw} ,
	{noreply, State};

handle_cast({enter_scene},State) ->
	SceneId = State#robot.scene_id ,
	gen_tcp:send(State#robot.socket,  pack(12005, <<SceneId:32>>)),
%% 	NewState = State#robot{status = set_auto_draw} ,
	{noreply, State};

handle_cast({begin_dig},State) ->
	ScnId = State#robot.scene_id ,
	if ScnId > 1000 ->
		   NewScnId =  ScnId div 100 ;
	   true ->
		   NewScnId = ScnId 
	end ,
	CopperId = NewScnId * 10 + random:uniform(8) ,
	io:format("========={begin_dig}:~p~n",[CopperId]) ,
	gen_tcp:send(State#robot.socket,  pack(49004, <<CopperId:16>>)),
	NewState = State#robot{scene_id = NewScnId, copper_id = CopperId } ,
	{noreply, NewState};



handle_cast({create_team},State) ->
	DGId = random:uniform(7) ,
	gen_tcp:send(State#robot.socket,  pack(35004, <<DGId:8>>)),
	{noreply, State};

handle_cast({check_team},State) ->
	gen_tcp:send(State#robot.socket,  pack(35008, <<>>)),
	{noreply, State};



handle_cast({launch_fight},State) ->
	gen_tcp:send(State#robot.socket,  pack(20003, <<>>)),
	{noreply, State} ;


handle_cast({add_child_socket,N,Socket},State)->
%%	io:format("------------------------add_child_socket----------- ~p~n",[N]),
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
%% io:format("----------upgrade_state--------------------------:~n",[]),
%%	ets:insert(?ETS_ROBOT, NewState),
    {noreply,NewState};

%%向服务器发送获取角色信息的13001指令, 异步接收服务器返回的信息
handle_cast({get_state_13001},State) ->
	handle(get_self_info, a,State#robot.socket),
%%io:format("--------------------------get_state_13001~n",[]),
	{noreply, State};
	
handle_cast({upgrade_state_13001, [Scene, X, Y, Hp]},State) ->
	NewState = State#robot{x=X, y=Y, hp=Hp, scene=Scene},
%% io:format("--------------------------upgrade_state_13001:   ~p ~n",[NewState]), 	
    {noreply, NewState};





%%进入矿区场景
handle_cast({upgrade_state_49001, [Code,ScnId]}, State) ->
	case Code of
		1 ->			%% 进入矿区成功，修改状态
		   NewState = State#robot{status = entered_mine,scene_id = ScnId} ;	
		_ ->
		   NewState = State			%%退回外面去
	end,
    {noreply, NewState};

%%进入矿区场景
handle_cast({upgrade_state_12005,[Code]}, State) ->
	case  Code > 0  of
		true ->
			NewState = State#robot{status = entered_secne} ;
		false ->
			NewState = State 
	end ,
	{noreply, NewState};


%%设置自动提取
handle_cast({upgrade_state_49005, [Code]}, State) ->
	case Code of
		1 ->			%% 进入矿区成功，修改状态
		   NewState = State#robot{status = setted_auto_draw} ; 	
		_ ->
		   NewState = State			%%退回外面去
	end,
    {noreply, NewState};


%%开始挖矿
handle_cast({upgrade_state_49004, [Code]}, State) ->
	case Code of
		1 ->			%% 进入矿区成功，修改状态
		   NewState = State#robot{status = begined_dig} ; 	
		_ ->
		   NewState = State			%%退回外面去
	end,
    {noreply, NewState};


handle_cast({run}, State)->
    State2=State#robot{act=run},
    {noreply,State2};

%%在普通场景活动
handle_cast({out_act}, State)->
    State2=State#robot{act=out_act},
    {noreply,State2};


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
%% io:format("~s_action_random: ~p~n", [misc:time_format(now()), Random_interval]),
	handle_action_random(PlayerId, Socket),
	erlang:send_after(Random_interval, self(), {event, action_random, PlayerId, Socket}),
	{noreply,State};

handle_info('refresh',State)->
	erlang:send_after(10 * 1000, self(), 'refresh') ,
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
%% io:format("----------------------------------------Heart_0_~n"),	
    case gen_tcp:send(Socket, pack(10006, <<>>)) of
		ok ->
%%			io:format("-------iii--------Heart-------iii--------~n"),	
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
%%					io:format("---------------childsocket--connect-ok---------------------~n",[]),
					Accid = State#robot.acid,
					Pid = State#robot.pid,
					Data = pack(10008, <<9999:16,Accid:32,N:8>>),
            		gen_tcp:send(Socket, Data),	
					try
    					Ref = async_recv(Socket, ?HEADER_LENGTH, ?TCP_TIMEOUT),
    				receive
        				{inet_async, Socket, Ref, {ok, <<Len:32, Cmd:16>>}} ->
							%%io:format("--------------------------cmd:~p~n",[Cmd]),
            				BodyLen = Len - ?HEADER_LENGTH,
            				case BodyLen > 0 of
                				true ->
                   					Ref1 = async_recv(Socket, BodyLen, ?TCP_TIMEOUT),
                    				receive
                       					{inet_async, Socket, Ref1, {ok, Binary}} when Cmd =:= 10008 ->
											%%io:format("----------------------rev--10008~n",[]),
											<<Code:16,N:8>> = Binary,
												%%io:format("----------------------rev--10008:~p~n",[Code]),
												if
													Code == 1 ->
														%%spawn_link(fun()->do_parse_packet(Socket, Pid) end),
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

%%====================普通操作相关 begin==========================
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
%%玩家列表
handle(list_player, _, Socket) ->
%%     io:format("      client send: list_player ~n"),
    gen_tcp:send(Socket, pack(10002, <<1:16>>)),
    ok;
%%选择角色进入
handle(enter_player, {PlayerId}, Socket) ->
    gen_tcp:send(Socket, pack(10004, <<9999:16,PlayerId:32>>)),	
	
	gen_tcp:send(Socket, pack(12002, <<>>)),	
	%%erlang:send_after(random:uniform(?ACTION_INTERVAL)+1000, self(), {event, action_random, PlayerId, Socket}),	
    ok;
%%跑步
handle(run,a,Socket)->
    X=util:rand(15,45),
    Y=util:rand(15,45),
    gen_tcp:send(Socket, pack(12001, <<X:16,Y:16>>));
%%ai模式跑步
handle(run, {X,Y, SX, SY}, Socket) ->
	%%io:format("----running:[~p][~p]~n",[X,Y]),
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
%%获取其他玩家信息
handle(get_player_info,Id,Socket)->
    gen_tcp:send(Socket,  pack(13004, <<Id:16>>));

%%向服务器发送13001指令, 获取自己信息
handle(get_self_info, _ ,Socket)->
    gen_tcp:send(Socket,  pack(13001, <<1:16>>));    %%可不发内容, 服务器不取内容

%%向服务器发送41010指令, 获取宠物信息
handle(get_pet_info, {PlayerId}, Socket)->
    gen_tcp:send(Socket,  pack(41010, <<PlayerId:32>>));    

%%向服务器发送56001指令, 获取竞技信息
handle(get_theater_info, _ ,Socket)->
    gen_tcp:send(Socket,  pack(56001, <<>>));    	%%不发内容

%%复活
handle(revive, _, Socket)->
	gen_tcp:send(Socket, pack(20004, <<3:8>>)),
    Action = tool:to_binary("-加血 100000"),
	ActionLen= byte_size(Action),
	Data = <<ActionLen:16, Action/binary>>,
    Packet =  pack(11020, Data),	
	gen_tcp:send(Socket, Packet);

%%====================普通操作相关  end ==========================

handle(Handle, Data, Socket) ->
    io:format("handle error: /~p/~p/~n", [Handle, Data]),
    {reply, handle_no_match, Socket}.

%%玩家列表
read(<<L:32, 10002:16, Num:16, Bin/binary>>) ->
    io:format("client read: ~p ~p ~p~n", [L, 10002, Num]),
    F = fun(Bin1) ->
        <<Id:32, S:16, C:16, Sex:16, Lv:16, Bin2/binary>> = Bin1,
        {Name, Rest} = read_string(Bin2),
        io:format("player list: Id=~p Status=~p Pro=~p Sex=~p Lv=~p Name=~p~n", [Id, S, C, Sex, Lv, Name]),
        Rest
    end,
    for(0, Num, F, Bin),
    io:format("player list end.~n");

read(<<L:32, Cmd:16>>) ->
    io:format("client read: ~p ~p~n", [L, Cmd]);
read(<<L:32, Cmd:16, Status:16>>) ->
    io:format("client read: ~p ~p ~p~n", [L, Cmd, Status]);
read(<<L:32, Cmd:16, Bin/binary>>) ->
    io:format("client read: ~p ~p ~p~n", [L, Cmd, Bin]);
read(Bin) ->
    io:format("client rec: ~p~n", [Bin]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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
	%%io:format("start ai  ~p.~n",[Pid]),
	%%更新信息
	gen_server:cast(Pid,{get_state_13001}),
	Random_interval = random:uniform(6000)+3000,
	sleep(Random_interval),	
	State=gen_server:call(Pid,{get_state}),
	io:format("robot status !~p~n",[State#robot.status]),
	case State#robot.status of
		standing ->			%%当前状态是站着
			if State#robot.step == 0 ->						   
				   Tox = rand(5,20),
				   Toy = rand(10,20),
				   New_step = 1;
			   true ->
				   Tox = rand(20,40),
				   Toy = rand(10,20),
				   New_step = 0					
			end,
			State2=State#robot{tox=Tox,toy=Toy,step=New_step,status=running},	%%换个目的坐标, 状态改为跑
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
		entered_mine ->		%%已经进入到了矿区场景
			gen_server:cast(State#robot.pid,{begin_dig}) ;
%% 			gen_server:cast(State#robot.pid,{enter_scene}) ,
%% 			gen_server:cast(State#robot.pid,{set_auto_draw}) ;
%% 		setted_auto_draw ->
%% 			gen_server:cast(State#robot.pid,{begin_dig}) ;
		begined_dig	->
			erlang:send_after(10 * 1000, self(), 'refresh') ; 
		launch_fight ->
			gen_server:cast(State#robot.pid,{launch_fight}) ;			%%发起战斗
		_->
			io:format("robot status error!~p~n",[State#robot.status])
	end ,
	%%io:format("-------------------------------------------ai-end---~n",[]),
	ai(Pid).

pack(Cmd, Data) ->
    L = byte_size(Data) + ?HEADER_LENGTH,
    <<L:32, Cmd:16, Data/binary>>.

%%================辅助函数  begin============================
rand(Same, Same) -> Same;
rand(Min, Max) ->
    M = Min - 1,
	if
		Max - M =< 0 ->
			0;
		true ->
			random:uniform(Max - M) + M
	end.

%%从返回的宠物信息中，折出宠物ID, 组成 Res列表返回
decodeString41010(0, _Bin, Res) ->
	Res;
decodeString41010(_Size, <<>>, Res) ->
	Res;
decodeString41010(Size, Bin, Res) ->
	<<PetId:32,_Uid:32, Bin1/binary>> = Bin,
	{_Con,Bin2} = read_string(Bin1),				%%拆分字符串及剩下的字符串
    <<_Status:8,_PetTypeId:32,_Icon:32, _Rename_count:16, _Quality:8, _Race:8, _Career:8, _Level:8,
		_Rela:32, _Exp:32, _Exp_limit:32, _Hp:32, _MaxHp:32, 
				   _Pwr:16, _Tech:16, _Mgc:16, _GrowPwr:16, _GrowTec:16, _GrowMgc:16,
				   _Pwn:32, _Tcn:32, _Mgn:32, _NeedPwr:32, _NeedTec:32, _NeedMgc:32,
				   _Skill:32, _TalentId:16, _TalentId1:16,
	  _SoulNum:32, _SoulLv1:8, _SoulLv2:8, _CrossingLv:16, RestBin/binary>> =  Bin2,	%%RestBin是下一个记录的字符串
	
    if PetId > 0 ->
		   Res1 = Res ++[PetId];
       true ->
		   Res1 = Res
     end,
    decodeString41010(Size-1, RestBin, Res1).


%%从返回的队伍信息二进制串中，折出可加入的队伍ID, 组成 Res列表返回
parse_team_bin(<<>>,DataList) ->
	DataList ;
parse_team_bin(DataBin,DataList) ->
	<<TeamId:32, DgId:8, Bin1/binary>> = DataBin ,
	{_TeamName,Bin2} = read_string(Bin1) ,				
	{_CaptainName,Bin3} = read_string(Bin2) ,
	<<_LeaderLV:8,CurNum:8,_MaxNum:8,RestBin/binary>> = Bin3 ,
	case CurNum < 3 of 
		true ->
			NewDataList = [{TeamId,DgId}] ++ DataList ;
		false ->
			NewDataList = DataList 
	end ,
	parse_team_bin(RestBin,NewDataList) .

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

getNowTime() ->
	{{_Y,_M,_D},{H,Min,S}} = erlang:localtime(),
    H*3600+Min*60+S.
%%================辅助函数  end============================

get_scene() ->
[
10101,
10201,
10301,
10401
].
