%%%---------------------------------------------
%%% @Module  : test_client
%%% @Author  : csj
%%% @Created : 2010.10.05
%%% @Description: 客户端
%%%---------------------------------------------
-module(test_client2).
-include("common.hrl").

%%数据库连接
-define(DB, csj_mysql_conn).
-define(DB_HOST, "113.107.160.8").
-define(DB_PORT, 3306).
-define(DB_USER, "root").
-define(DB_PASS, "Ysyh2012ljt").
-define(DB_NAME, "csj_dev").
-define(DB_ENCODE, utf8).

-export([start/0, login/1, send_heart/1]).

-define(HEAT_INTERVAL, 1*20*1000).

start() ->
    mysql:start_link(?DB, ?DB_HOST, ?DB_PORT, ?DB_USER, ?DB_PASS, ?DB_NAME, fun(_, _, _, _) -> ok end, ?DB_ENCODE),
    mysql:connect(?DB, ?DB_HOST, ?DB_PORT, ?DB_USER, ?DB_PASS, ?DB_NAME, ?DB_ENCODE, true),
	
    case gen_tcp:connect("localhost", 7788, [binary, {packet, 0}]) of
        {ok, Socket1} ->
            gen_tcp:send(Socket1, <<"<policy-file-request/>\0">>),
            rec(Socket1),
            gen_tcp:close(Socket1);
        {error, _Reason1} ->
            io:format("connect failed!~n")
	end,
    
    %%case gen_tcp:connect("113.107.160.2", 6666, [binary, {packet, 0}]) of
    case gen_tcp:connect("localhost", 7788, [binary, {packet, 0}]) of
		{ok, Socket} ->
			login(Socket),
            create(Socket),
%%             player_list(Socket),
            enter(Socket),
            load_scene(Socket),
            load_player(Socket),
            attack_mon(Socket),
			
			timer:apply_after(?HEAT_INTERVAL, 
					  ?MODULE, send_heart,
					  [Socket]),			
            ok;
		{error, _Reason} ->
            io:format("connect failed!~n")
	end.

%%登陆
login(Socket) ->
    %L = byte_size( <<1:16,10000:16,99:32,1274722973:32,6:16,"997f64",32:16,"5a6462292fd5a2e04950e12edbb5dcf8">>),
    %gen_tcp:send(Socket, <<L:16,10000:16,99:32,1274722973:32,6:16,"997f64",32:16,"5a6462292fd5a2e04950e12edbb5dcf8">>),
%%     L = byte_size( <<1:16,10000:16,2:32,1282547629:32,6:16,"555550",32:16,"05f1009d41200eddc7ec3596f0a71d29">>),
%%     gen_tcp:send(Socket, <<L:16,10000:16,2:32,1282547629:32,6:16,"555550",32:16,"05f1009d41200eddc7ec3596f0a71d29">>),
	
	Accid = 55555, 
	AccName = "555550",
    AccStamp = 1273027133,
    Tick = integer_to_list(Accid) ++ AccName ++ integer_to_list(AccStamp) ++ ?TICKET,
    TickMd5 = util:md5(Tick),
    TickMd5Bin = list_to_binary(TickMd5),
    AccNameLen = byte_size(list_to_binary(AccName)),
    AccNameBin = list_to_binary(AccName),
    Data = <<Accid:32, AccStamp:32, AccNameLen:16, AccNameBin/binary, 32:16, TickMd5Bin/binary>>,
    Len = byte_size(Data) + 4,
    gen_tcp:send(Socket, <<Len:16, 10000:16, Data/binary>>),

    rec(Socket).

%%创建角色
create(Socket) -> 
    L = byte_size( <<1:16,10003:16,1:16,1:16,6:16,"逍遥">>),
    gen_tcp:send(Socket, <<L:16,10003:16,1:16,1:16,6:16,"逍遥">>),
    %%gen_tcp:send(Socket, <<10003:16,3:16,"htc",1:16,1:16>>),
    rec(Socket).

%% %%玩家列表
%% player_list(Socket) ->
%%     gen_tcp:send(Socket, <<6:16,10002:16,1:16>>),
%%     rec(Socket).

%%选择角色进入
enter(Socket) ->
    gen_tcp:send(Socket, <<8:16,10004:16, 2:32>>),
    %gen_tcp:send(Socket, <<10004:16, 20:32>>),
    rec(Socket).


%%加载场景
load_scene(Socket) ->
    io:format("send:12002~n"),
    gen_tcp:send(Socket, <<6:16,12002:16,1:16>>),
    rec(Socket).

%%用户信息
load_player(Socket) ->
    gen_tcp:send(Socket, <<6:16,13001:16,1:16>>),
    rec(Socket).

%%人攻击怪
attack_mon(Socket) ->
    io:format("send:20001~n"),
    gen_tcp:send(Socket, <<10:16,20002:16,1:32,1:16>>),
    rec(Socket).

%%心跳包
send_heart(Socket) ->
    io:format("client send: heart 10006~n"),
    gen_tcp:send(Socket, <<4:16, 10006:16>>),
	timer:apply_after(?HEAT_INTERVAL, 
			  ?MODULE, send_heart,
			  [Socket]),	
    ok.

rec(Socket) ->
    receive
        {tcp, Socket, <<"<cross-domain-policy><allow-access-from domain='*' to-ports='*' /></cross-domain-policy>">>} -> 
            io:format("revc : ~p~n", ["flash_file"]);

        %%用户信息
        {tcp, Socket, <<_L:16,13001:16, Scene:32, X:16, Y:16, Id:32, Hp:32, Hp_lim:32, Mp:32, Mp_lim:32,Sex:16, Lv:16, Bin/binary>>} -> 
            {Nick, _} = read_string(Bin),
            io:format("revc player info:~p~n",[[Scene,X,Y,Id,Hp,Hp_lim,Mp,Mp_lim,Sex,Lv,Nick]]);

        %%场景
        {tcp, Socket, <<_L:16,12002:16, Bin/binary>>} -> 
            <<L:16, Bin22/binary>> = Bin,
            F = fun(Bin3) ->
                <<X1:16, Y1:16, Uid1:32, Bin4/binary>> = Bin3,
                {Nick1, Bin5} = read_string(Bin4),
                io:format("revc scene user online :~p~n",[[X1,Y1,Uid1,Nick1]]),
                Bin5
            end,
            Bin2 = for(0, L, F, Bin22),

            <<L2:16, Bin222/binary>> = Bin2,
            F2 = fun(Bin32) ->
                <<X1:16, Y1:16, Uid1:32,_,_,_,_,_, Bin4/binary>> = Bin32,
                {Nick1, Bin5} = read_string(Bin4),
                io:format("revc scene mon online :~p~n",[[X1,Y1,Uid1,Nick1]]),
                Bin5
            end,
            for(0, L2, F2, Bin222);

        {tcp, Socket, <<_L:16,Cmd:16, Bin:16>>} -> 
            io:format("revc : ~p~n", [[Cmd, Bin]]);

        %复活
        {tcp, Socket, <<_L:16,Cmd:16, _X:16, _Y:16, Id:32, Hp:32, Mp:32, _Hp_lim:32, _Mp_lim:32, Lv:16, _Len:16, _Name1/binary>>} ->
            io:format("revc revive: ~p:~p~n", [Cmd, [Id, Hp, Mp, Lv]]);

        %战斗结果
        {tcp, Socket, <<_L:16, _Cmd:16, Id:32, Id2:32, Hp:32, S:16>>} ->
            io:format("revc battle: ~p,~p,~p,~p~n", [Id, Id2, Hp, S]),
            rec(Socket);

        %%角色列表啊
        {tcp, Socket, <<_L:16,Cmd:16, Len:16, Bin/binary>>} -> 
            F = fun(Bin2) ->
                <<Id:32, S:16, C:16, Sex:16, Lv:16, L:16, Bin1/binary>> = Bin2,
                io:format("revc player list: ~p", [[Cmd, Id, S,C,Sex,Lv,L]]),
                <<Str:L/binary-unit:8, Rest/binary>> = Bin1,
                io:format("~p~n", [Str]),
                Rest
            end,
            for(0, Len, F, Bin);

        {tcp_closed, Socket} ->
            gen_tcp:close(Socket)
    end.

for(Max, Max, _F, X) ->
    X;
for(Min, Max, F, X) ->
    X1 = F(X),
    for(Min+1, Max, F, X1).

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
