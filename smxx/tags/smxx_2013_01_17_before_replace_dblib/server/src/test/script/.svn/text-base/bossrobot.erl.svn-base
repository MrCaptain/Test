%%% -------------------------------------------------------------------
%%% Author  :devil 1812338@gmail.com
%%% Description : 
%%%
%%% Created :
%%% -------------------------------------------------------------------
-module(bossrobot).

-behaviour(gen_server).
-compile(export_all).
-include("common.hrl").
-include("record.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

-define(CONFIG_FILE, "../config/gateway.config").

%% 连接网关端口，不读取gateway配置
%-define(GATEWAY_ADD,"127.0.0.1"). 
-define(GATEWAY_ADD,"192.168.51.174"). 
-define(GATEWAY_PORT,7777).

%% %%-----版署2服 begin--------
%% -define(GATEWAY_ADD,"121.10.140.118"). 
%% -define(GATEWAY_PORT,8877).
%% %%-----版署2服  end --------

%%-----S0外服 begin--------
%% -define(GATEWAY_ADD,"s0.cszd.my4399.com"). 
%% -define(GATEWAY_PORT,7777).
%%-----S0外服  end --------

-define(ACTION_SPEED_CONTROL, 10).
-define(ACTION_INTERVAL, ?ACTION_SPEED_CONTROL*10*1000).  % 自动行为最大时间间隔
-define(ACTION_MIN, 1000).	% 自动行为最小时间间隔

-define(TCP_TIMEOUT, 5000). % 解析协议超时时间
-define(HEART_TIMEOUT, 60*1000). % 心跳包超时时间
-define(HEART_TIMEOUT_TIME, 0). % 心跳包超时次数
-define(HEADER_LENGTH, 6). %
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
-record(bossrobot, {
		orig_n,		
        acid,	%%account id
        socket,	%%socket
		socket2,
		socket3,
        pid,	%%process id
        x ,		%%x坐标
        y ,		%%y坐标
        scene,
		dstScene,
        tox,
        toy,
        hp,
        id,		%% id
        act,	%% 动作
        status,	%% 当前状态
		step,
		inside,    %%1：在活动中，0：外面
		useRatio, 	%%是否用概率启用某些动作、功能, 默认不用
		bossId,   	%%BOSS ID,默认是BOSS ID 10001
		defenderId, 	%%守护者ID 默认为0
		fightObjId,	%%战斗对象D, 默认是BOSS ID 10001
		fightObjType,  %%战斗对象类型
		whichSide,   %%0：挑战方，1：守护方
		bossX,			%%boss的X坐标
		bossY,			%%boss的Y坐标
		freeTimes,		%%免费复活次数
		curCredit,		%%当前积分
		usedCredit		%%已用积分
				   
    }).
%%%
%%% API
start1() ->
	start(10000,200).
start2() ->
	start(10200,200).
start3() ->
	start(10400,200).
start4() ->
	start(10600,50).
start5() ->
	start(10700,50).
start6() ->
	start(10800,1000).
start7() ->
	start(11000,1000).
start8() ->
	start(12000,1000).

start1_mod2() ->
	start(20000,200,1).
start2_mod2() ->
	start(20200,200,1).
start3_mod2() ->
	start(20400,200,1).
start4_mod2() ->
	start(20600,50,1).
start5_mod2() ->
	start(20700,50,1).
start6_mod2() ->
	start(20800,1000,1).
start7_mod2() ->
	start(21000,1000,1).
start8_mod2() ->
	start(22000,1000,1).


start()->
%% 	start(1,1).			%%人物BB很强的
%%     start(20000,500).	%%249环境 从20000至 20500
%%     start(20500,500).	%%249环境 从20500至 21000
%%        start(21000,500).	%%249环境 从21000至 21500
	
	start(21500,1000).	%%249环境 从21500至 22000  加了100000元宝，元宝复活
%%     start(22000,500).	%%249环境 从22000至 22500  加了100000元宝，元宝复活
%%  start(22500,500).	%%249环境 从22500至 23000  加了100000元宝，元宝复活
%% start(21500,20).	%%249环境 从21500至 22000  加了100000元宝，元宝复活
	
%%     start(20000,500).           %%版署服 用 人物加 1, 编号20000 到20500
%%     start(20500,500).           %%版署服 用 人物加 1, 编号20500 到21000
%% start(21000,500).           %%版署服 用 人物加 1, 编号21000 到21500

%%     start(31000,400).           %%外服用 人物加 1, 编号20000 到20500
%%     start(20500,500).           %%外服 用 人物加 1, 编号20500 到21000
%% start(21000,500).           %%外服 用 人物加 1, 编号21000 到21500
%% 	start(22000,5).           %%外服 用 人物加 1, 编号22000 到21500

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
	%%lists:map(F, lists:seq(1, Num)),
	%%timer:apply_after(?CHECK_ROBOT_STATUS,  bossrobot, check_robot_status, [{StartId, Num, Mod}]),	
	ok.

%%StartId 起始AccountID
%%Num int 数量
%%1 useRatio置1，从而使用概率
start(StartId,Num, 1)->
    sleep(100),
    F=fun(N)->
			io:format("start 1 ~p~n",[N]),
          	sleep(500),
       		start_link(StartId + N, 1)
    end,
    for(0,Num,F),
	ok.

%%检查机器人状态
%% check_robot_status({StartId, Num, Mod}) ->
%% 	MS = ets:fun2ms(fun(T)-> T end),
%% 	L = ets:select(?ETS_ROBOT, MS),
%% 	lists:foreach(fun(T) ->
%% 					Orig_n = T#bossrobot.orig_n,
%% 					Pid = T#bossrobot.pid,
%% 					case Pid =:= undefined orelse is_process_alive(Pid) =:= false  of
%% 						true -> 
%% %% io:format("check_robot_status:  /~p/~p/~p ~n", [Orig_n, Pid, T]),							
%% 							bossrobot:start_link(Orig_n, Mod),
%% %% 							sleep(100),
%% 							ok;
%% 						_-> is_alive
%% 					end,
%% 					ok
%% 				end,
%% 			L),	
%% 	timer:apply_after(?CHECK_ROBOT_STATUS, 
%% 					  bossrobot, check_robot_status,
%% 					  [{StartId, Num, Mod}]),	
%% 	ok.

%%
%%创建 一个ROBOT 进程
start_link(N)->
    case gen_server:start(?MODULE,[N],[]) of
        {ok, Pid}->
			io:format("---------------start ~p finish!----------~n",[N]),
			gen_server:cast(Pid, {start_action});	%由此进入模拟角色动作
        _->
            fail
    end.

%%创建 一个ROBOT 进程, 并置概率
start_link(N, 1)->
    case gen_server:start(?MODULE,[N, 1],[]) of
        {ok, Pid}->
			io:format("---------------start ~p finish!----------~n",[N]),
			gen_server:cast(Pid, {start_action});	%由此进入模拟角色动作
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
init([N|T]) ->
    process_flag(trap_exit,true),
	Pid = self(),
%% 	io:format("-----init 2----------------------~p~n",[Pid]),
    case login(N, Pid) of							%先登录(里面先根据N作为帐号ID创建角色)
        {ok, Socket, Accid, Id}->
%% 			io:format("~n------login-----------ok------~p----~n",[[Socket, Accid, Id]]),	
%%			io:format("-------------bossrobot:~p~n",[#bossrobot{}]),
%% 			Scene = lists:nth(random:uniform(length(get_scene())), get_scene()),
			Scene = 10301,
			if T =:= [] ->
            	Robot= #bossrobot{socket=Socket, 
							 acid=list_to_integer(Accid), 
							 id=Id, 
							 pid = Pid,
							 act=out_act,   		%%在BOSS场景外面活动
							 status=standing,
							 x = rand(10,45),
							 y = rand(10,20),
						     dstScene = Scene,
							 tox=rand(10,45),
							 toy=rand(10,20),
							 orig_n = N,
							 step = 0,
							 inside = 0,			%%初始在外面
							 useRatio = 0,			%%不使用概率的
							 bossId = 10001,     	%%默认Boss Id
							 defenderId = 0,
							 fightObjId = 10001,
							 fightObjType = 0,
							 whichSide = 0,
							 bossX = 45,		%%一定要置初始值, 服务端不发BOSS位置了
							 bossY = 10,
							 freeTimes = 0,		%%免费复活次数
							 curCredit = 0,		%%当前积分
							 usedCredit = 0		%%已用积分
							 };
			   true ->
				   Robot= #bossrobot{socket=Socket, 
							 acid=list_to_integer(Accid), 
							 id=Id, 
							 pid = Pid,
							 act=out_act,   		%%在BOSS场景外面活动
							 status=standing,
							 x = rand(10,45),
							 y = rand(10,20),
							 dstScene = Scene,
							 tox=rand(10,45),
							 toy=rand(10,20),
							 orig_n = N,
							 step = 0,
							 inside = 0,			%%初始在外面
							 useRatio = 1,			%%使用概率的
							 bossId = 10001,     	%%默认Boss Id
							 defenderId = 0,
							 fightObjId = 10001,
                             fightObjType = 0,
							 whichSide = 0,
							 bossX = 45,		%%一定要置初始值, 服务端不发BOSS位置了
							 bossY = 10,
							 freeTimes = 0,		%%免费复活次数
							 curCredit = 0,		%%当前积分
							 usedCredit = 0		%%已用积分
							 }
			   end,
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
%% 			io:format("Ip:~p, Port:~p~n",[Ip, Port]),
   			 case connect_server(Ip, Port) of
        		{ok, Socket}->
%% 					io:format("-----------------connect-ok---------------------~n",[]),
					Data = pack(10010, <<9999:16,N:32>>),%%创建角色  按照accid创建一个角色，自动分配一个角色(服务器标识为9999时) 
            		gen_tcp:send(Socket, Data),	
					try
    					Ref = async_recv(Socket, ?HEADER_LENGTH, ?TCP_TIMEOUT),
    				receive
        				{inet_async, Socket, Ref, {ok, <<Len:32, Cmd:16>>}} ->
%% 							io:format("--------------------------cmd:~p~n",[Cmd]),
            				BodyLen = Len - ?HEADER_LENGTH,
            				case BodyLen > 0 of
                				true ->
                   					Ref1 = async_recv(Socket, BodyLen, ?TCP_TIMEOUT),
                    				receive
                       					{inet_async, Socket, Ref1, {ok, Binary}} when Cmd =:= 10010->
										
											<<AccId:32, PlayerId:32, Bin/binary>> = Binary,
											
											{_Accname, _} = pt:read_string(Bin),
 											handle(login, {N, "N"}, Socket),   						%%创建成功后登陆
%% 											io:format("----------------Accid:~p --- playerid:~p/~p",[AccId,PlayerId, _Accname]),
											spawn_link(fun()->do_parse_packet(Socket, Pid) end),	%接收来自服务器的数据												
 											handle(enter_player,{PlayerId},Socket),                 %选择角色进入
											{ok, Socket, integer_to_list(N), PlayerId};
										Other ->
											%%io:format("--------------------------cmd--other:~p~n",[Other]),
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
%% 			io:format("get_game_server connect:  ~p/~n",[Socket]),
			Data = pack(60000, <<>>),
            gen_tcp:send(Socket, Data),
    		try
			case gen_tcp:recv(Socket, ?HEADER_LENGTH) of
				{ok, <<Len:32, 60000:16>>} ->
%%  					io:format("len: ~p ~n",[Len]),
					BodyLen = Len - ?HEADER_LENGTH,
            		case gen_tcp:recv(Socket, BodyLen, 3000) of
                		{ok, <<Bin/binary>>} ->
							<<Rlen:16, RB/binary>> = Bin,
							case Rlen of
								1 ->
									<<Bin1/binary>> = RB,
									{IP, Bin2} = pt:read_string(Bin1),
									<<Port:16, _Num:8>> = Bin2,
%%  									io:format("get_game_server IP, Port:  /~p/~p/~n",[IP, Port]),
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
						12001 ->
							<<X:8, Y:8, _SX:8, _SY:8, Id:32>> = BinData,
%% 							io:format("receive 12001, [X:~p, Y:~p, Id:~p~n",[X, Y, Id]),
							gen_server:cast(Pid,{upgrade_state_12001, [X, Y, Id]}),			%%根据取到的场景、坐标更新本地机器人状态
							ok;
						13001 ->		%%接收到服务器返回的角色信息													
%%  						io:format("receive 13001~n"),
							<<Scene:32, X:16, Y:16,_Id:32,Hp:32,_Other/binary>> = BinData,			%%取出场景、坐标
%%  							io:format("receive 13001:~p~n",[[Scene, X, Y]]),
            				%%更新信息
            				gen_server:cast(Pid,{upgrade_state_13001, [Scene, X, Y, Hp]}),			%%根据取到的场景、坐标更新本地机器人状态
							ok;
						10007 ->
%% 							io:format("receive 10007~n"),
							<<_Code:8>> = BinData,
							ok;
						36000 ->		%%接收到世界BOSS邀请
							io:format("receive 36000~n"),
							gen_server:cast(Pid,{upgrade_state_36000}),								%%接收到邀请, 更新本地机器人状态
							ok;
						36001 ->		%%接收到服务器的世界BOSS活动开启信息
							<<Code:8, B1/binary>> = BinData,
							<<BossId:32, B2/binary>> = B1,
							{_Accname, B3} = pt:read_string(B2),
							<<BossLv:8, BossSc:32, _B4/binary>> = B3,
%% 							if 
%% 								Code =:= 1 ->
%% 									<<BossId:32, B2/binary>> = B1,
%% 									{_Accname, B3} = pt:read_string(B2),
%% 									<<BossLv:8, BossSc:32, _B4/binary>> = B3;
%% 								true ->
%% 									BossId = 0,
%% 									BossLv = 0,
%% 									BossSc = 0
%% 							end,
									
%% 							io:format("receive 36001,Code:~p~n", [Code]),
							gen_server:cast(Pid,{upgrade_state_36001, [Code, BossId, BossLv, BossSc]}),						%%接收到世界BOSS活动开启, 更新本地机器人状态
							ok;
%% 						36002 ->		%%角色接受邀请后, 再接收到服务器返回的邀请结果
%% 							io:format("receive 36002~n"),
%% 							<<Code:8>> = BinData,
%% 							gen_server:cast(Pid,{upgrade_state_36002, [Code]}),						%%根据邀请结果, 更新本地机器人状态
%% 							ok;
						36003 ->		%%角色玩家进入活动场景, 再接收到服务器返回的结果
%% 							io:format("receive 36003~n"),
							<<Code:8,_T/binary>> = BinData,
							gen_server:cast(Pid,{upgrade_state_36003, [Code]}),						%%根据返回结果, 更新本地机器人状态
							ok;
%% 						36009 ->		%%在世界BOSS里收到服务器返回玩家的坐标
%% %% 							io:format("receive 36009~n"),
%%  							<<X:8,Y:8,Sx:8,Sy:8, ID:32>> = BinData,
%% %%  							io:format("X:~p, Y:~p, Sx:~p, Sy:~p, ID:~p~n", [X,Y,Sx,Sy, ID]),
%% 							ok;
						36010 ->		%%挑战者收到的战斗奖励结果
%% 							io:format("receive 36010~n"),
							<<Code:8,_T/binary>> = BinData,
							gen_server:cast(Pid,{upgrade_state_36010, [Code]}),						%%根据返回结果, 更新本地机器人状态
							ok;
							
						36016 ->		%%元宝复活后收到服务器返回结果
%% 							io:format("receive 36016~n"),
							<<Code:8>> = BinData,
							gen_server:cast(Pid,{upgrade_state_36016, [Code]}),						%%根据返回结果, 更新本地机器人状态
							ok;
						
%% 						36017 ->		%%BOSS 跑动广播协议 , 这个服务器不发了
%% %% 							io:format("receive 36017~n"),
%% 							<<X:8, Y:8, _T/binary>> = BinData,
%% 							gen_server:cast(Pid,{upgrade_state_36017, [X, Y]}),						%%根据返回结果, 更新本地机器人状态
%% 							ok;
						36099 ->		%%活动结束
%% 							io:format("receive 36099~n"),
							<<Code:8>> = BinData,
							gen_server:cast(Pid,{upgrade_state_36099, [Code]}),						%%根据返回结果, 更新本地机器人状态
							ok;
						36021 ->		%%守护者免费复活
%% 							io:format("receive 36021~n"),
							gen_server:cast(Pid,{upgrade_state_36021, []}),							%%根据返回结果, 更新本地机器人状态
							ok;
						36024 ->		%%收到服务器返回的BOSS ID或守护者ID
%% 							io:format("receive 36024~n"),
							<<Type:8, ObjId:32>> = BinData,
%% 							io:format("receive 36024, Type=~p, ObjId=~p~n",[Type, ObjId]),
							gen_server:cast(Pid,{upgrade_state_36024, [Type,ObjId]}),				%%根据返回结果, 更新本地机器人状态
							ok;
						36027 ->		%%收到服务器返回的守护者积分信息
%% 							io:format("receive 36027~n"),
							<<CurCredit:16, UsedCredit:16>> = BinData,
							%%io:format("receive 36027, CurCredit=~p, UsedCredit=~p~n",[CurCredit, UsedCredit]),
							gen_server:cast(Pid,{upgrade_state_36027, [CurCredit,UsedCredit]}),		%%根据返回结果, 更新本地机器人状态
							ok;
						36028 ->		%%守护者死亡消息
%% 							io:format("receive 36028~n"),
							<<_LeftNim:8, Uid:32, Status:8, FreeTimes:8, _WaitTime:8>> = BinData,
%% 							io:format("receive 36028, Status=~p, FreeTimes=~p~n",[Status, FreeTimes]),
							gen_server:cast(Pid,{upgrade_state_36028, [Uid, Status, FreeTimes]}),		%%根据返回结果, 更新本地机器人状态
							ok;
						36002 ->		%%收到服务器返回的挑战BOSS返回的结果
%% 							io:format("receive 20011~n"),
							<<Res:8, Type:8, _T/binary>> = BinData,
%% 							io:format("receive 20011, Res=~p, Type=~p~n",[Res, Type]),
							if Type =:= 0 ->
								   gen_server:cast(Pid,{upgrade_state_20011, [Res, Type]});		%%根据返回结果, 更新本地机器人状态
							   true ->
								   ok
							end,
							ok;
						20012 ->         %%收到服务器返回的挑战守护者返回的结果
%% 							io:format("receive 20012~n"),
							<<Res:8, Type:8, _T/binary>> = BinData,
%% 							 io:format("receive 20012, Res=~p, Type=~p~n",[Res, Type]),
							if Type =:= 0 ->
								  
								   gen_server:cast(Pid,{upgrade_state_20012, [Res, Type]});		%%根据返回结果, 更新本地机器人状态
							   true ->
								   ok
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
    handle(State#bossrobot.act, a, State#bossrobot.socket),			%%根据机器人当前的动作进入相应动作
    {reply,ok,State};

handle_call({get_state},_From,State)->
    {reply,State,State};

handle_call({get_socket},_From,State)->
    Reply=State#bossrobot.socket,
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
	if is_port(State#bossrobot.socket) ->
%% 		io:format("      start_action  : /~p/,~n",[State]),
        %%心跳进程
        spawn_link(fun()->handle(heart, a , State#bossrobot.socket) end),
		%%socket2 进程
		%%spawn_link(fun()->handle(start_child_socket,{State,2},c) end),
		%%socket3 进程
		%%spawn_link(fun()->handle(start_child_socket,{State,3},c) end),
		Pid= self(),
		%%io:format("      start_action  1: /~p/,~n",[Pid]),
		spawn_link(fun()-> ai(Pid) end),						%%进入模拟动作ai
		
		AddExp = rand(4,10),								%%对一部分玩家加经验, 要一定级别才能成为守护者
		%%AddExp = 6,
%% 		if State#bossrobot.useRatio =:= 0 orelse (State#bossrobot.useRatio =:= 1 andalso AddExp > 5) ->
%% 			handle(chat,"-加经验 12600000",State#bossrobot.socket), %%加人物经验
%% 			handle(chat,"-加金币  100000",State#bossrobot.socket),
			handle(chat,"-加经验   2000000",State#bossrobot.socket), %%加人物经验
 			handle(chat,"-升阵法",State#bossrobot.socket), 	%%加阵法(同时加宠物)
 			handle(chat,"-petexp 1",State#bossrobot.socket),		%%给出战宠物增加经验 
%% %% 		    handle(chat,"-petexp 1850000",State#bossrobot.socket),   %%给出战宠物增加经验 (太高了会很猛的)
%% 			   ok;
%% 		   true ->
%% 			   ok
%% 		end,
 		handle(chat,"-全功能",State#bossrobot.socket),			%%要开全功能才能进世界BOSS,但是用了全功能不能在加经验前, 会出错挂进程的
		
%%  		handle(chat,"-开场景", State#bossrobot.socket),
 		handle(enter_scene,State#bossrobot.dstScene, State#bossrobot.socket),			%%去场景
		
		handle(is_start, {State#bossrobot.acid}, State#bossrobot.socket),		%%查看世界BOSS活动是否开了
		%%io:format("      start_action  2: /~p/,~n",[Pid]),
		{noreply, State};
	   true -> 
%% 		   io:format("      start_action  stop_1: /~p/,~n",[State]),
		   {stop, normal, State}
	end;

handle_cast({add_child_socket,N,Socket},State)->
%%	io:format("------------------------add_child_socket----------- ~p~n",[N]),
	NewState = 
	if
		is_pid(State#bossrobot.pid) andalso is_port(Socket) ->
			case N of
				2 -> State#bossrobot{socket2 = Socket};
				3 -> State#bossrobot{socket3 = Socket};
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

%%向服务器发送获取角色竞技场信息的56001指令, 异步接收服务器返回的信息
handle_cast({get_theater_info_56001},State) ->
	handle(get_theater_info, a,State#bossrobot.socket),
	{noreply, State};

%%向服务器发送获取角色信息的13001指令, 异步接收服务器返回的信息
handle_cast({get_state_13001},State) ->
	handle(get_self_info, a,State#bossrobot.socket),
%%io:format("--------------------------get_state_13001~n",[]),
	{noreply, State};
	
handle_cast({upgrade_state_12001, [X, Y, Id]}, State)->
	if is_integer(X) andalso is_integer(Y) andalso Id =:= State#bossrobot.id ->
		   NewState = State#bossrobot{x=X, y=Y};
	   true ->
		   NewState = State
	end,
	{noreply, NewState};
		
handle_cast({upgrade_state_13001, [Scene, X, Y, Hp]},State) ->
    if State#bossrobot.inside =:= 1 ->
		   NewState = State#bossrobot{hp=Hp, scene=Scene};
	   true ->
		   NewState = State#bossrobot{x=X, y=Y, hp=Hp, scene=Scene}
	end,
%% io:format("--------------------------upgrade_state_13001:   ~p ~n",[NewState]), 	
    {noreply, NewState};

%%接收到世界BOSS邀请后, 更新机器人的动作, 从而进入ai()里面相应的邀请处理逻辑
handle_cast({upgrade_state_36000}, State) ->
	NewState = State#bossrobot{act=to_inviter},
    {noreply, NewState};

%%根据世界BOSS开启, 更新机器人的动作, 从而进入ai()里面相应的邀请处理逻辑
handle_cast({upgrade_state_36001,[Code, BossId, _BossLv, BossSc]}, State) ->
	case Code of
		1 ->	%%开启
			NewState = State#bossrobot{inside=1, act=to_enter, dstScene = BossSc, bossId = BossId};							%%动作改为进入场景中
		_ ->	%%其它情况
			NewState = State#bossrobot{inside=0, act=out_act, status=standing, dstScene = BossSc, bossId = BossId}			%%动作恢复为外面活动
	end,
    {noreply, NewState};

%%根据世界BOSS邀请结果, 更新机器人的动作, 从而进入ai()里面相应的邀请处理逻辑
handle_cast({upgrade_state_36002,[Code]}, State) ->
	case Code of
		1 ->	%%接受成功
			NewState = State#bossrobot{act=out_act,status=standing, whichSide=1};	%%动作恢复为外面活动, 状态改为守护者等待
		_ ->	%%其它情况
			NewState = State#bossrobot{act=out_act,status=standing}				%%动作恢复为外面活动
	end,
    {noreply, NewState};

%%根据服务器返回的进入场景结果, 更新机器人的动作, 从而进入ai()里面相应的邀请处理逻辑
handle_cast({upgrade_state_36003,[Code]}, State) ->
%% 	io:format("upgrade_state_36003:~p~n",[Code]),
	case Code of
		1 ->	%%成功(活动准备阶段)
			case State#bossrobot.whichSide of
				1 ->		%%守护者在进入场景
					NewState = State#bossrobot{inside=1, act=defender_entered, status=waiting};		%%动作改为守护者已进入场景。状态为等待
				_ ->						%%其它
					NewState = State#bossrobot{inside=1, act=entered_boss, status=waiting}		    %%动作改为挑战者已进入场景。状态为等待
			end;
		2 ->	%%活动正式开始
			case State#bossrobot.whichSide of
				1 ->
					NewState = State#bossrobot{inside=1, act=defender_entered, status=standing};	%%动作改为守护者已进入场景。状态为站
				_ ->
					NewState = State#bossrobot{inside=1, act=entered_boss, status=standing}		    %%动作改为挑战者已进入场景。状态为站
			end;
		4 ->	%%已经进入该活动
			NewState = State;		    %%保持原状态
		5 ->	%%挑战者人数已满
			NewState = State#bossrobot{inside=0, act=out_act,status=standing};						%%人满, 动作改为普通场景站
		_ ->	%%其它情况
			NewState = State#bossrobot{inside=0, act=out_act,status=standing}						%动作恢复为外面活动
	end,
	%%io:format("upgrade_state_36003~n"),
    {noreply, NewState};

%%挑战者收到的战斗奖励结果
handle_cast({upgrade_state_36010, [Code]}, State) ->
	case Code of
		1 ->	%%挑战者胜利
			NewState = State#bossrobot{status=to_get_reward};
		_ ->	%%2挑战者失败
			NewState = State#bossrobot{status=to_get_reward}
	end,
    {noreply, NewState};

%%挑战者元宝复活后收到服务器返回结果
handle_cast({upgrade_state_36016, [Code]}, State) ->
	case Code of
		0 ->	%%失败，系统错误
			NewState = State#bossrobot{act=to_quit_boss,status=standing};
		1 ->	%%成功
			NewState = State#bossrobot{status=standing};
		2 ->	%%当前状态不需要复活
			NewState = State#bossrobot{status=runtoboss};
		3 ->	%%元宝不足
			NewState = State#bossrobot{status=waiting};
		_ ->
			NewState = State#bossrobot{act=to_quit_boss,status=standing}
	end,
	 {noreply, NewState};
		
%% %%BOSS 跑动广播协议  这个服务器不发了
%% handle_cast({upgrade_state_36017,[X, Y]}, State) ->
%% 	NewState = State#bossrobot{bossX=X,bossY=Y},							%%更新BOSS X Y坐标
%%     {noreply, NewState};

%%活动结束
handle_cast({upgrade_state_36099,[_Code]}, State) ->
	NewState = State#bossrobot{act=to_quit_boss,status=standing},							%%动作为退出活动
    {noreply, NewState};

%%守护者免费复活
handle_cast({upgrade_state_36021,[Code]}, State) ->
	case Code of
		0 ->	%%失败，系统错误
			NewState = State#bossrobot{act=to_quit_boss,status=standing};				%%动作为退出活动
		1 ->	%%成功
			NewState = State#bossrobot{act=fight, status=waiting};						%%动作为战斗
		2 ->	%%免费复活次数耗尽
			NewState = State#bossrobot{act=dead, status=waiting};						%%动作为挂了
		3 ->	%%守护者不存在
			NewState = State#bossrobot{act=to_quit_boss,status=standing};				%%动作为退出活动
		4 ->	%%当前状态不需要复活
			NewState = State#bossrobot{act=fight, status=waiting};						%%动作为战斗
		_ ->
			NewState = State#bossrobot{act=to_quit_boss,status=standing}				%%动作为退出活动
	end,
    {noreply, NewState};

%%收到服务器返回的BOSS ID或守护者ID
handle_cast({upgrade_state_36024, [Type,ObjId]}, State) ->
	if Type =:= 1 ->
		   NewState = State#bossrobot{defenderId = ObjId,fightObjId = ObjId, fightObjType = Type};	%%更新守护者Id
		true ->
		   NewState = State#bossrobot{bossId = ObjId, fightObjId = ObjId, fightObjType = Type}		%%更新BOSS ID
	end,
    {noreply, NewState};

%%收到服务器返回的守护者积分信息
handle_cast({upgrade_state_36027, [CurCredit,UsedCredit]}, State) ->
	NewState = State#bossrobot{curCredit = CurCredit,usedCredit = UsedCredit},			%%更新积分信息
    {noreply, NewState};

%%收到服务器发的守护者死亡消息
handle_cast({upgrade_state_36028, [Uid,Status, FreeTimes]}, State) ->
	if Uid =:= State#bossrobot.id ->
		   case Status of		%%(0-存活;3-死亡)
			   0 ->
				   NewState = State#bossrobot{freeTimes = FreeTimes};	%%更新免费复活次数
			   3 ->
		   		   NewState = State#bossrobot{status = to_revive_def, freeTimes = FreeTimes};		%%更新免费复活次数、状态为等待复活
			   _ ->
		   		   NewState = State
			end;
	   true ->
		   NewState = State
	end,
    {noreply, NewState};

%%%%收到服务器返回的挑战BOSS返回的结果
handle_cast({upgrade_state_20011, [Res, Type]}, State) ->
	if Res =:= 0 ->			%%返回错误
		case Type of
			1 -> %%冷却时间未到，显示为正在战斗中
		   		NewState = State#bossrobot{status = waiting};									%%更新状态为waiting
			2 -> %%玩家当前状态不可以战斗
				NewState = State#bossrobot{status = waiting};									%%更新状态为waiting
			3 -> %%怪物不存在
				NewState = State#bossrobot{act = waiting};										%%更新为退出
			4 -> %%你不是挑战者
				NewState = State#bossrobot{status = waiting};									%%更新为waiting
			5 -> %%挑战者死亡未复活
				NewState = State#bossrobot{status = to_revive};									%%更新状态为to_revive
			6 -> %%BOSS 已死亡
				NewState = State#bossrobot{act = to_quit_boss};									%%更新状态为to_quit_boss
			_ ->
		   		NewState = State#bossrobot{status = waiting}									%%更新为waiting
		end;
	   true ->				%%返回正常战斗结果
		   case Res of
			   1 ->			%%胜利
				   NewState = State#bossrobot{status = waiting};
			   2 ->
				   NewState = State#bossrobot{status = to_revive};
			   _ ->
				   NewState = State#bossrobot{status = waiting}
		   end
	end,
%% 	io:format("upgrade_state_20011, Res:~p, Type~p, status:~p~n", [Res, Type, State#bossrobot.status]),
   
    {noreply, NewState};

%%收到服务器返回的挑战守护者返回的结果
handle_cast({upgrade_state_20012, [[Res, Type]]}, State) ->
	if Res =:= 0 ->
		   case Type of
			1 -> %%冷却时间未到，显示为正在战斗中
		   		NewState = State#bossrobot{status = waiting};									%%更新状态为waiting
			2 -> %%玩家当前状态不可以战斗
				NewState = State#bossrobot{status = waiting};									%%更新状态为waiting
			3 -> %%怪物不存在
				NewState = State#bossrobot{act=to_quit_boss};									%%更新为to_quit_boss
			4 -> %%你不是挑战者
				NewState = State#bossrobot{status = waiting};									%%更新为waiting
			5 -> %%挑战者死亡未复活
				NewState = State#bossrobot{status = to_revive};									%%更新状态为to_revive
			6 -> %%对方不是守护者
				NewState = State#bossrobot{defenderId = 0, status = waiting, fightObjId = State#bossrobot.bossId, fightObjType = 0};					%%更新状态为waiting
			7 -> %%守护者 已死亡
				NewState = State#bossrobot{defenderId = 0, fightObjId = State#bossrobot.bossId, fightObjType = 0};										%%更新守护者ID为0
			8 -> %%守护者不在线
				NewState = State#bossrobot{defenderId = 0, fightObjId = State#bossrobot.bossId, fightObjType = 0};										%%更新守护者ID为0
			_ ->
		   		NewState = State#bossrobot{status = waiting}									%%更新为waiting
		   end;
		true ->				%%返回正常战斗结果
		   case Res of
			   1 ->			%%胜利
				   NewState = State#bossrobot{status = waiting};
			   2 ->
				   NewState = State#bossrobot{status = to_revive};
			   _ ->
				   NewState = State#bossrobot{status = waiting}
		   end									
	end,
%% 	io:format("upgrade_state_20012, Res:~p, Type~p, status:~p~n", [Res, Type, State#bossrobot.status]),
    {noreply, NewState};

handle_cast({run}, State)->
    State2=State#bossrobot{act=run},
    {noreply,State2};

%%在普通场景活动
handle_cast({out_act}, State)->
    State2=State#bossrobot{act=out_act, status=standing},
    {noreply,State2};

handle_cast({stop}, State)->
    State2=State#bossrobot{act=undefined},
    {noreply,State2};

handle_cast({stop, Reason},State)->
	io:format("      ~s_quit_2: /~p/~p/~p/,~n",[misc:time_format(now()), State#bossrobot.acid, State#bossrobot.id, Reason]),	
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
	io:format("      ~s_quit_3: /~p/~p/~p/,~n",[misc:time_format(now()), State#bossrobot.acid, State#bossrobot.id, Reason]),
	{stop, normal, State};

handle_info({event, action_random, PlayerId, Socket},State) ->
	Random_interval = random:uniform(?ACTION_INTERVAL) + ?ACTION_MIN,
%% io:format("~s_action_random: ~p~n", [misc:time_format(now()), Random_interval]),
	handle_action_random(PlayerId, Socket),
	erlang:send_after(Random_interval, self(), {event, action_random, PlayerId, Socket}),
	{noreply,State};

handle_info(close, State)->
    gen_tcp:close(State#bossrobot.socket),
    {noreply,State};

handle_info(_Info, State) ->
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(Reason, State) ->
io:format(" ----------terminate-----------~s_quit_4: /~p/~p/~p/,~n",[misc:time_format(now()), State#bossrobot.acid, State#bossrobot.id, Reason]),
	if is_port(State#bossrobot.socket) ->
		gen_tcp:close(State#bossrobot.socket);
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
					Accid = State#bossrobot.acid,
					Pid = State#bossrobot.pid,
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
%% 	io:format("-running~n"),
    gen_tcp:send(Socket, pack(12001, <<X:16,Y:16>>));

%%ai模式跑步
handle(run, {X,Y, SX, SY}, Socket) ->
%% 	io:format("----running:[~p][~p]~n",[X,Y]),
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

%%向服务器发送56001指令, 获取竞技信息
handle(get_theater_info, _ ,Socket)->
    gen_tcp:send(Socket,  pack(56001, <<>>));    	%%不发内容

%%复活
handle(revive_mod1, _, Socket)->
	gen_tcp:send(Socket, pack(20004, <<3:8>>)),
    Action = tool:to_binary("-加血 100000"),
	ActionLen= byte_size(Action),
	Data = <<ActionLen:16, Action/binary>>,
    Packet =  pack(11020, Data),	
	gen_tcp:send(Socket, Packet);

%% 世界BOSS相关 begin, 用于发送包到服务器=================================

%%查询活动是否开启
handle(is_start, {_PlayerId}, Socket) ->
    gen_tcp:send(Socket,  pack(36001, <<>>));					%%向服务器发送36001指令

%%接爱邀请
handle(accept_invitation, {_PlayerId}, Socket) ->
    gen_tcp:send(Socket,  pack(36002, <<>>));					%%向服务器发送玩家接受邀请的36002指令

%%进入活动
handle(enter_boss, {_PlayerId}, Socket) ->
%% 	io:format("handle(enter_boss~n"),
	gen_tcp:send(Socket,  pack(12005, <<200:32>>)),
	gen_tcp:send(Socket,  pack(36003, <<>>)),					%%向服务器发送玩家进入活动的36003指令
    gen_tcp:send(Socket, pack(12002, <<>>));				    %%一定要再发12002, 使之加载进场景表
    
	
	

%%退出活动
handle(quit_boss, {_PlayerId}, Socket) ->
	%%io:format("handle(quit_boss~n"),
    gen_tcp:send(Socket,  pack(36004, <<>>)),					%%向服务器发送玩家退出活动的36004指令
	gen_tcp:send(Socket,  pack(12005, <<101:32>>)),
	gen_tcp:send(Socket, pack(12002, <<>>));				    %%一定要再发12002, 使之加载进场景表

%%玩家在活动场景里面跑动(此协议不用了，用场景12的)
handle(run_in_boss, {X,Y, SX, SY}, Socket) ->
%% 	io:format("handle(run_in_boss~n"),
    gen_tcp:send(Socket, pack(36009, <<X:8,Y:8,SX:8,SY:8,20001:32>>));

%%世界BOSS挑战者状态广播
handle(revive,Gold,Socket) ->
	gen_tcp:send(Socket, pack(36016, <<Gold:8>>));				%%发送的参数长度要正确

%%世界BOSS活动中挑战者复活
handle(revive,Gold,Socket) ->
	gen_tcp:send(Socket, pack(36016, <<Gold:8>>));				%%发送的参数长度要正确

%%世界BOSS活动中守护者复活
handle(revive_def, {FreeTimes, LeftCredit}, Socket) ->
	if LeftCredit > 10 ->
		   gen_tcp:send(Socket, pack(36025, <<5:8>>));
	   true ->
		   if FreeTimes > 0 ->
				  gen_tcp:send(Socket, pack(36021, <<>>));
			  true ->
				  UseGold = random:uniform(10),
				  if UseGold > 5 ->
						 gen_tcp:send(Socket, pack(36022, <<>>));
					 true ->
						 ok
				  end
		   end
	end;

%%向服务器发送挑战者战斗指令
handle(fight, {Type, ObjId}, Socket) ->
%% 	io:format("handle(fight,fightObjId:~p~n",[ObjId]),
	if Type =:= 1 andalso is_integer(ObjId) andalso ObjId > 0 ->
		   %%io:format("handle(fight20012,fightObjId:~p~n",[ObjId]),
		   gen_tcp:send(Socket, pack(36002, <<ObjId:32>>));			%%10001是BOSS的ID
	   true ->
		   if is_integer(ObjId) andalso ObjId > 0 ->
				   %%io:format("handle(fight20011,fightObjId:~p~n",[ObjId]),
				  gen_tcp:send(Socket, pack(36002, <<ObjId:32>>));
			  true ->
				  %%io:format("handle(fight20011~n"),
				  gen_tcp:send(Socket, pack(36002, <<10001:32>>))	%%10001是BOSS的固定ID,此处作兼容
		   end
	end;

%%向服务器获取BOSS ID或守护者ID
handle(get_fightObjId, _, Socket) ->							
	gen_tcp:send(Socket, pack(36024, <<>>));					%%向服务器发送获取BossId或守护者Id的36024指令

%%挑战者领取战斗奖励
handle(get_reward, _, Socket) ->
    gen_tcp:send(Socket, pack(36011, <<>>));					%%向服务器发送挑战者领取战斗奖励的36011指令


%%守护者使用技能
handle(use_skill, SkillId, Socket) ->
    gen_tcp:send(Socket, pack(36031, <<SkillId:32>>));			%%向服务器发送守护者使用技能的36025指令

%%守护者获取当前积分
handle(get_credit, _, Socket) ->
    gen_tcp:send(Socket, pack(36027, <<>>));					%%向服务器发送守护者查询积分的36027指令


%% 世界BOSS相关   end==============


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
    handle(State#bossrobot.act,a,State#bossrobot.socket),
    sleep(20000),
    do_act(Pid).

%%根据机器人状态进行动作
ai(Pid)->
	%%io:format("start ai  ~p.~n",[Pid]),
	%%更新信息
	gen_server:cast(Pid,{get_state_13001}),		%%向服务器发送获取角色信息的13001指令
	Random_interval = random:uniform(1000)+3000,
    sleep(Random_interval),						%%等待一随机时间, 让机器人状态得到从服务器返回的最新状态	
    State=gen_server:call(Pid,{get_state}),		%%得到机器人状态
%%     io:format("id~p:, act:~p, status:~p,tox:~p,toy:~p x:~p, y:~p~n",
%% 			  [State#bossrobot.id,State#bossrobot.act,State#bossrobot.status,State#bossrobot.tox,State#bossrobot.toy, State#bossrobot.x,State#bossrobot.y]),
	case State#bossrobot.inside of
		%%%%%%%%%%%%%%%%%%%%%%%世界BOSS 外面  begin %%%%%%%%%%%%%%%%%%%5
        0 ->								%%当前是在世界BOSS外面
			case State#bossrobot.hp > 0 of	%%血大于0
				true ->
					case State#bossrobot.act of
						out_act ->
                    		case State#bossrobot.status of
                        		standing ->			%%当前状态是站着
                            		if State#bossrobot.step == 0 ->						   
								   		Tox = rand(5,20),
								   		Toy = rand(10,20),
								   		New_step = 1;
                               		true ->
								   		Tox = rand(20,40),
								   		Toy = rand(10,20),
                                   		New_step = 0					
                            		end,
                            		State2=State#bossrobot{tox=Tox,toy=Toy,step=New_step,status=running},	%%换个目的坐标, 状态改为跑
                            		gen_server:cast(State#bossrobot.pid,{upgrade_state,State2});			%%更新机器人状态
                        		running ->			%%当前状态是跑
                            		if State#bossrobot.x =/= State#bossrobot.tox orelse State#bossrobot.y =/=State#bossrobot.toy ->	%%当前坐标不等于目的坐标
										   handle(run,{State#bossrobot.x,State#bossrobot.y, State#bossrobot.tox,State#bossrobot.toy},State#bossrobot.socket),
										   Random_interval2 = round(abs(State#bossrobot.tox - State#bossrobot.x) / 4)* 1000,
    									   sleep(Random_interval2),
										   handle(run,{State#bossrobot.tox,State#bossrobot.toy, State#bossrobot.tox,State#bossrobot.toy},State#bossrobot.socket);		
                            		true ->
                                		State2=State#bossrobot{status=standing},						%%到达目的地, 换个状态为站
                                		gen_server:cast(State#bossrobot.pid,{upgrade_state,State2}),	%%更新机器人状态
										handle(is_start,{State#bossrobot.acid},State#bossrobot.socket)  %%向服务器发送活动是否开启的指令
                            		end;
                       	 		_->		%%未知状态
									ok
                    		end;
						to_inviter ->	%%接收到邀请
							AcceptRatio = rand(3,10),
							if State#bossrobot.useRatio =:=0 orelse (State#bossrobot.useRatio =:=1 andalso AcceptRatio > 5) ->	%%选择接受邀请
								   WaitRatio = rand(0, 7),
								   if State#bossrobot.useRatio =:=1 andalso WaitRatio > 5 ->
										  sleep(4*60 * 1000);		%%过了4分钟再接受, 此时邀请已失效
									  true ->
										  ok
								   end,
								   NewState = State#bossrobot{act=out_act, status=standing},						%%状态恢复为在普通场景站着
				  				   gen_server:cast(State#bossrobot.pid,{upgrade_state,NewState}),					%%更新本地机器人状态
							   	   handle(accept_invitation,{State#bossrobot.acid},State#bossrobot.socket);			%%向服务器发送接受邀请的指令
							   true ->							%%选择不接受, 则忽略之
				  				   NewState = State#bossrobot{act=out_act, status=standing},						%%状态恢复为在普通场景站着
				  				   gen_server:cast(State#bossrobot.pid,{upgrade_state,NewState})					%%更新本地机器人状态
						    end;
						_ ->			%%未知动作
							io:format("unknow out_act~n"),
							State2=State#bossrobot{status=standing},						%%换个状态为站
                            gen_server:cast(State#bossrobot.pid,{upgrade_state,State2}),	%%更新机器人状态
							ok
					end;
				false ->	%%血小于0，去复活
					handle(revive_mod1,a,State#bossrobot.socket)
			end;
		%%%%%%%%%%%%%%%%%%%%%%%世界BOSS 外面  end %%%%%%%%%%%%%%%%%%%	
				
		%%%%%%%%%%%%%%%%%%%%%%%世界BOSS 里面  begin %%%%%%%%%%%%%%%%%
		1 ->	%%当前是在世界BOSS里面
			case State#bossrobot.act of
				to_enter ->					%% 进入活动场景中
					case State#bossrobot.whichSide of
						1 ->				%%是等待中的守护者
							NewState=State#bossrobot{act=defender_entering,status=stand,tox=45,toy=10},	%%更新本地机器人动作为defender_entering, 状态为stand、更新目的坐标
            				gen_server:cast(State#bossrobot.pid,{upgrade_state,NewState});				%%更新本地机器人状态
						_ ->							%%其它
							NewState=State#bossrobot{act=entered_boss,status=stand,tox=4,toy=15},		%%更新本地机器人动作为entered_boss, 状态为stand、更新目的坐标
            				gen_server:cast(State#bossrobot.pid,{upgrade_state,NewState})				%%更新本地机器人状态
					end,
					handle(enter_boss,{State#bossrobot.acid},State#bossrobot.socket);					%%向服务器发送进入世界boss场景的指令
				
				defender_entered ->			%% 守护者在活动场景中
					case State#bossrobot.status of
						waiting ->
							case State#bossrobot.hp < 0 of	
								true ->						%%血小于0, 死了
									GoOut = rand(0, 7),
									if GoOut > 5 andalso State#bossrobot.useRatio =:= 1 ->			%%有些选择出去
								   		handle(quit_boss, {State#bossrobot.acid},State#bossrobot.socket),
								  		handle(enter_scene,State#bossrobot.dstScene, State#bossrobot.socket),	%%去原场景
								   		NewState=State#bossrobot{inside=0, act=out_act,status=standing,tox=25,toy=35},	%%更新本地机器人动作为out_act, 状态为standing、更新目的坐标
            					   		gen_server:cast(State#bossrobot.pid,{upgrade_state,NewState});			%%更新本地机器人状态
									   true ->				%%有些选择不出去, 状态不变
						   				ok
									end;
								false ->					%%血大于0, 还没死
									NewState=State#bossrobot{status=standing},	%%更新本地机器人状态为standing
            					   	gen_server:cast(State#bossrobot.pid,{upgrade_state,NewState})
							end;
						standing ->
							handle(revive_def, {State#bossrobot.freeTimes, State#bossrobot.curCredit - State#bossrobot.usedCredit}, State#bossrobot.socket),  %%总是先发复活，防止没收到消息无法复活
							LeftCredit = State#bossrobot.curCredit - State#bossrobot.usedCredit,
							case LeftCredit > 0 of
								true ->
									SkillId = rand(10001, 10002),
									handle(use_skill, SkillId, State#bossrobot.socket);
								false ->
									ok
							end,
							handle(get_credit, a, State#bossrobot.socket),
							
							GoOut = rand(0, 7),
							if GoOut > 5 andalso State#bossrobot.useRatio =:= 1 ->			%%有些选择中途出去
								   handle(quit_boss, {State#bossrobot.acid},State#bossrobot.socket),
								   handle(enter_scene,State#bossrobot.dstScene, State#bossrobot.socket),			%%去原场景
								   NewState=State#bossrobot{inside=0, act=out_act,status=standing,tox=25,toy=35},		%%更新本地机器人动作为out_act, 状态为standing、更新目的坐标
            					   gen_server:cast(State#bossrobot.pid,{upgrade_state,NewState});				%%更新本地机器人状态
							   true ->
						   		   ok				%%有些选择不出去, 状态不变
							end;
						to_revive_def ->
							handle(revive_def, {State#bossrobot.freeTimes, State#bossrobot.curCredit - State#bossrobot.usedCredit}, State#bossrobot.socket),
							NewState=State#bossrobot{status=standing},	%%更新本地机器人状态为standing
            				gen_server:cast(State#bossrobot.pid,{upgrade_state,NewState});
						_ ->
							io:format("unknow defender, act:~p, status:~p~n",[State#bossrobot.act, State#bossrobot.status]),
							ok
					end;
				
				%%%%%%%%%%%%%%%%%%%%%%%挑战者  begin %%%%%%%%%%%%%%%%%%%5
				entered_boss ->							 %% 挑战者在活动场景中
					case State#bossrobot.status of
						waiting ->
							case State#bossrobot.hp > 0 of
								true  ->				%%血大于0，还活着，状态改为站
									GoOut = rand(0,7),
									case GoOut > 5 andalso State#bossrobot.useRatio =:= 1 of
										true ->					%%有些选择中途出去
											handle(quit_boss, {State#bossrobot.acid},State#bossrobot.socket),
											handle(enter_scene,State#bossrobot.dstScene, State#bossrobot.socket),	%%去原场景
											NewState=State#bossrobot{inside=0, act=out_act,status=standing,tox=25,toy=15},
											gen_server:cast(State#bossrobot.pid,{upgrade_state,NewState});
										false ->
											State1=State#bossrobot{status=standing},
											gen_server:cast(State#bossrobot.pid,{upgrade_state,State1})
									end;
								false ->				%%挂了，动作改为待复活
									State1=State#bossrobot{status=to_revive},
									gen_server:cast(State#bossrobot.pid,{upgrade_state,State1})
							end;
						standing ->                      %% 在世界BOSS里面站着，让他跑起来
							SkillId = rand(1, 4),
							handle(use_skill, SkillId, State#bossrobot.socket),
							
						   	New_step = 1,					
							handle(run,{State#bossrobot.tox,State#bossrobot.toy, State#bossrobot.tox,State#bossrobot.toy},State#bossrobot.socket),
							State2=State#bossrobot{step=New_step,status=runtoboss},		%%更新状态为runtoboss、更新目的坐标
							gen_server:cast(State#bossrobot.pid,{upgrade_state,State2});				%%更新机器人状态
						runtoboss ->                   %% 在世界BOSS里面跑动，寻找战斗目标
							if State#bossrobot.x < 40 ->  
%%  							   io:format("runtoboss---0~n"),
								   ToX = 42,
								   NewState = State#bossrobot{tox=ToX} ,
								   handle(run,{NewState#bossrobot.x,State#bossrobot.y, NewState#bossrobot.tox,State#bossrobot.y},NewState#bossrobot.socket), %%在活动场景里面跑动
								   Time = round(abs(ToX - State#bossrobot.x) / 4)* 1000,
								   sleep(Time),
								    handle(run,{NewState#bossrobot.tox,State#bossrobot.y, NewState#bossrobot.tox,State#bossrobot.y},NewState#bossrobot.socket), 
								   gen_server:cast(State#bossrobot.pid,{upgrade_state,NewState});
							 true ->
%% 								   io:format("runtoboss---5~n"),
								   %handle(get_fightObjId, a, State#bossrobot.socket),		%%向服务器发送获取BossId或守护者Id的指令
								   NewState = State#bossrobot{tox=4,toy=15,status=fight} ,			%%到达boss点，状态改为战斗
							       gen_server:cast(State#bossrobot.pid,{upgrade_state,NewState}) 		%%更新机器人状态
				 		    end;
						fight ->						%%当前动作为战斗				
%% 							case State#bossrobot.useRatio =:= 0 of												
%% 								true ->																			%%非概率模式
%% 									handle(fight,{State#bossrobot.fightObjType, State#bossrobot.fightObjId}, State#bossrobot.socket);%%与服务器返回的对象战斗
%% 								false ->																		%%概率模式
%% 									WhichOne = random:uniform(10),
%% 									if WhichOne > 6 ->
%% 										   handle(fight,{State#bossrobot.fightObjType, State#bossrobot.fightObjId}, State#bossrobot.socket);%%与服务器返回的对象战斗
%% 									   true ->
%% 										   handle(fight,{0,State#bossrobot.bossId}, State#bossrobot.socket)			%%与BOSS战斗
%% 									end
%% 							end,
							
							handle(fight,{0,State#bossrobot.bossId}, State#bossrobot.socket),
							NewState=State#bossrobot{status=to_revive},					%%状态改为waiting
							gen_server:cast(State#bossrobot.pid,{upgrade_state,NewState});				%%更新机器人状态
						    
						to_get_reward ->
							NewState=State#bossrobot{status=to_revive},					%%状态改为waiting
							gen_server:cast(State#bossrobot.pid,{upgrade_state,NewState}),				%%更新机器人状态
							handle(get_reward, {State#bossrobot.acid}, State#bossrobot.socket);			%%挑战者领取奖励
						to_revive ->						%%当前等待复活
%% 							io:format("go to_revive~n"),
							sleep(10000),
							case State#bossrobot.useRatio =:= 0 of
								true ->
%% 									sleep(31*1000), 			%% 40 秒后自动复活, 此处休息41秒，等待复活
									Gold = 2;
								false ->
									Use = random:uniform(10),
									if Use < 6 ->
										   sleep(31*1000),
										   Gold = 0; 			%% 40 秒后自动复活, 此处休息41秒，等待复活
									   true ->
										   sleep(8*1000), 			%% 此处改为8秒, 用元宝复活
								   		   Gold = rand(0,2)
							        end
					        end,
							handle(revive, Gold, State#bossrobot.socket),
							NewState=State#bossrobot{tox=4,toy=15, status=waiting},		%%状态改为waiting
							gen_server:cast(State#bossrobot.pid,{upgrade_state,NewState});
						_ ->
							io:format("unknow challenger,act:~p, status:~p~n",[State#bossrobot.act, State#bossrobot.status]),
							ok
					end;
				%%%%%%%%%%%%%%%%%%%%%%%挑战者  end %%%%%%%%%%%%%%%%%%%
				to_quit_boss ->
					handle(quit_boss, {State#bossrobot.acid},State#bossrobot.socket),				%%发退出活动指令
					handle(enter_scene,State#bossrobot.dstScene, State#bossrobot.socket),			%%发去场景指令
					NewState=State#bossrobot{inside=0, act=out_act, status=standing,tox=25,toy=35},	%%更新本地机器人动作为out_act, 状态为standing、更新目的坐标
            		gen_server:cast(State#bossrobot.pid,{upgrade_state,NewState});					%%更新本地机器人状态
		
				_ ->    %%未知动作
					io:format("unknow inside act:~p, status:~p~n",[State#bossrobot.act, State#bossrobot.status]),
					ok
			end;
		%%%%%%%%%%%%%%%%%%%%%%%世界BOSS 里面  end %%%%%%%%%%%%%%%%%%%
        _ ->
			io:format("unknown side:~p~n",[State#bossrobot.inside]),
            ok
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


get_scene() ->
[
10101,
10102,
10103,
10104,
10105,
10201,
10202,
10203,
10204,
10205,
10301,
10302,
10303,
10304,
10305,
10401,
10402,
10403,
10404,
10405,
10501,
10502,
10503,
10504,
10505,
10601,
10602,
10603,
10604,
10605,
10701,
10702,
10703,
10704,
10705,
10801
].
