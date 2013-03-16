%%%-----------------------------------
%%% @Module  : lib_send
%%% @Author  : csj
%%% @Created : 2010.10.05
%%% @Description: 发送消息
%%%-----------------------------------
-module(lib_send).
-include("record.hrl").
-include("common.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
-define(SOCKET_BROADCAST,2).%%默认广播socket
-compile(export_all).

%%发送信息给指定socket玩家.
%%Socket:游戏Socket
%%Bin:二进制数据
send_one(Socket, Bin) ->
    gen_tcp:send(Socket, Bin).

%%发送信息给指定玩家名.
%%Nick:名称 
%%Bin:二进制数据.
send_to_nick(Nick, Bin) ->
   case lib_player:get_role_id_by_name(Nick) of
		null -> no_player;
		PlayerId -> send_to_uid(PlayerId, Bin)
   end.

%%发送信息给指定sid玩家.
%%Pid_send:游戏发送进程Pid_send
%%Bin:二进制数据.
send_to_sid(PidSend, Bin) ->
	Pid =  misc:rand_to_process(PidSend),
	Pid ! {send, Bin}.

%% 发送到指定的socket pid 进程
send_to_sids([Pid_send1,_Pid_send2,_Pid_send3],Bin,1)  ->
	Pid = (catch misc:rand_to_process(Pid_send1)),
	case Pid of
		GetPid when is_pid(GetPid) ->
			GetPid ! {send,Bin};
		_ ->
			skip
	end;
send_to_sids([Pid_send1,Pid_send2,Pid_send3],Bin,2) ->
	Pid = (catch misc:rand_to_process(Pid_send2)),
	case Pid of
		GetPid when is_pid(GetPid) ->
			GetPid ! {send,Bin};
		_ ->
			send_to_sids([Pid_send1,Pid_send2,Pid_send3],Bin,1)
	end;
send_to_sids([Pid_send1,Pid_send2,Pid_send3],Bin,3) ->
	Pid = (catch misc:rand_to_process(Pid_send3)),
	case Pid of
		GetPid when is_pid(GetPid) ->
			GetPid ! {send,Bin};
		_ ->
			send_to_sids([Pid_send1,Pid_send2,Pid_send3],Bin,1)
	end;
send_to_sids([_Pid_send1,_Pid_send2,_Pid_send3],_Bin,_) ->
	skip;
send_to_sids([],_Bin,_) ->
	skip.

%%发送信息给指定玩家ID.
%%PlayerId:玩家ID
%%Bin:二进制数据.
send_to_uid(PlayerId, Bin) ->
	PlayerProcessName = misc:player_process_name(PlayerId),
	case misc:whereis_name({global, PlayerProcessName}) of
		Pid when is_pid(Pid) ->
			gen_server:cast(Pid,{send_to_sid, Bin});
		_ -> 
			no_pid
	end.

%%%发送信息到本地情景
%%%Q:场景ID
%%%Bin:数据
send_to_local_scene(Q, Bin) ->
	send_to_local_scene(Q, Bin ,?SOCKET_BROADCAST).

send_to_local_scene(Q, Bin,SocketN) ->
   	MS = ets:fun2ms(fun(T) when T#player.scene == Q-> 
						 [T#player.other#player_other.pid_send,T#player.other#player_other.pid_send2,T#player.other#player_other.pid_send3]
						end),
   	L = ets:select(?ETS_ONLINE, MS),	
 %io:format("send_to_local_scene__/~p/~p/ ~n",[Q,L]),	
   	do_broadcast(L, Bin,SocketN).


%%发送信息到同场景同屏的人
%%Q:场景ID
%%X,Y坐标
%%Bin:数据
send_to_same_screen(Q, X2, Y2, Bin) ->
	send_to_same_screen(Q, X2, Y2, Bin,"") .
send_to_same_screen(Q, X2, Y2, Bin,ExcepUId) ->
   	MS = ets:fun2ms(fun(T) when T#player.scene == Q-> 
		[
		 	T#player.id,
			[T#player.other#player_other.pid_send, T#player.other#player_other.pid_send2,T#player.other#player_other.pid_send3],
			T#player.x, 
			T#player.y,
			T#player.resolut_x , 
			T#player.resolut_y 
		] 
	end),
   	AllUser = ets:select(?ETS_ONLINE, MS),	
    F = fun([UId,Sids, X, Y, SolutX, SolutY]) ->
        XY = lib_scene:get_screen_posxy(X2, Y2, SolutX, SolutY),
		case lib_scene:is_same_screen(X,Y, XY) andalso UId =/= ExcepUId of
			true ->
				send_to_sids(Sids, Bin,?SOCKET_BROADCAST);
			false ->
				skip
		end
    end,
    [spawn(fun()->F([Sids, X, Y])end) || [Sids, X, Y] <- AllUser] .

%
%发送信息到场景(9宫格区域，不是整个场景)
%Q:场景ID
%X,Y坐标
%Bin:数据
send_to_local_scene(Q, X2, Y2, Bin) ->
	send_to_local_scene(Q, X2, Y2, Bin,?SOCKET_BROADCAST).

send_to_local_scene(Q, X2, Y2, Bin,SocketN) ->
   	MS = ets:fun2ms(fun(T) when T#player.scene == Q-> 
		[
			[T#player.other#player_other.pid_send, T#player.other#player_other.pid_send2,T#player.other#player_other.pid_send3],
			T#player.x, 
			T#player.y
		] 
	end),
   	AllUser = ets:select(?ETS_ONLINE, MS),	
	XY2 = lib_scene:get_xy(X2, Y2),	
    F = fun([Sids, X, Y]) ->
        XY = lib_scene:get_xy(X, Y),
		case lib_scene:is_in_area(XY, XY2) of
			true ->
				send_to_sids(Sids, Bin, SocketN);
			false ->
				skip
		end
    end,
    [spawn(fun()->F([Sids, X, Y])end) || [Sids, X, Y] <- AllUser].
%
%%%发送信息到基础场景
%%%Q:场景ID
%%%Bin:数据
%send_to_base_scene(Q, Bin) ->
%	send_to_base_scene(Q, Bin ,?SOCKET_BROADCAST).
%
%send_to_base_scene(Q, Bin,SocketN) ->
%	Base_scene =
%		if
%			Q >= 1000 ->
%				Q div 100;
%			true ->
%				Q
%		end,
%    	MS = ets:fun2ms(fun(T) when T#player.scene >= Base_scene * 100 andalso T#player.scene =< Base_scene * 100 + ?SCENE_COPY_NUMBER-> 
% 						 [T#player.other#player_other.pid_send,T#player.other#player_other.pid_send2,T#player.other#player_other.pid_send3]
% 						end),
%
%
%   	L = ets:select(?ETS_ONLINE, MS),	
%%% io:format("send_to_base_scene__/~p/~p/ ~n",[Q,L]),	
%   	do_broadcast(L, Bin,SocketN).
%
%
%%%发送信息到联盟
%%%GuildId:联盟ID
%%%Bin:数据
%send_to_guild(GuildId, Bin) ->
%	lib_guild:send_guild(0 ,0, GuildId, Bin).
%
%%% 发送信息到组队
%%% PlayerId 本用户消息发送进程
%%% TeamPid 组队PID
%%% Bin 数据
%send_to_team(PlayerId, TeamPid, Bin) ->
%	case misc:is_process_alive(TeamPid) of 
%		true ->
%			gen_server:cast(TeamPid, {'SEND_TO_MEMBER', Bin});
%   		false ->
%            send_to_uid(PlayerId, Bin)
%    end.
%    
%%% 发送信息到世界 
%%% 添加指定socket接口
%send_to_all(Bin) ->
%	send_to_all(Bin,?SOCKET_BROADCAST).
%
%send_to_all(Bin,SocketN) ->
%    send_to_local_all(Bin,SocketN),
%    mod_disperse:broadcast_to_world(ets:tab2list(?ETS_SERVER), Bin).
%
%send_to_local_all(Bin) ->
%	send_to_local_all(Bin,?SOCKET_BROADCAST).
%
%send_to_local_all(Bin ,SocketN) ->
%	MS = ets:fun2ms(fun(T) -> 
%		[
%		 	T#player.other#player_other.pid_send,
%			T#player.other#player_other.pid_send2,
%			T#player.other#player_other.pid_send3
%		]
%	end),
%	L = ets:select(?ETS_ONLINE, MS),	
%    do_broadcast(L, Bin ,SocketN).
%
%%% 发送信息到部落
%send_to_realm(Realm, Bin) ->
%	send_to_realm(Realm, Bin,?SOCKET_BROADCAST).
%
%send_to_realm(Realm, Bin,SocketN) ->
%    send_to_local_realm(Realm,Bin,SocketN),
%    mod_disperse:broadcast_to_realm(ets:tab2list(?ETS_SERVER), Realm, Bin).
%
%send_to_local_realm(Realm, Bin) ->
%	send_to_local_realm(Realm, Bin ,?SOCKET_BROADCAST).
%
%send_to_local_realm(Realm, Bin ,SocketN) ->
%	MS = ets:fun2ms(fun(T) when T#player.camp == Realm-> 
%					 [T#player.other#player_other.pid_send,T#player.other#player_other.pid_send2,T#player.other#player_other.pid_send3]
%					end),
%	L = ets:select(?ETS_ONLINE, MS),	
%    do_broadcast(L, Bin, SocketN).
%
% 对列表中的所有socket进行广播
do_broadcast(L, Bin,SocketN) ->
    [spawn(fun()->send_to_sids(Sids, Bin,SocketN) end) || Sids <- L].

%
%
%%% @spec 发送信息给一定级别的以上在线的玩家
%send_to_online_player(Level, Bin) ->
%	send_to_online_player(Level, Bin,?SOCKET_BROADCAST).
%
%send_to_online_player(Level, Bin,SocketN) ->
%    send_to_local_online_player(Level,Bin,SocketN),
%    mod_disperse:broadcast_to_online_player(ets:tab2list(?ETS_SERVER), Level, Bin).
%
%send_to_local_online_player(Level, Bin) ->
%	send_to_local_online_player(Level, Bin ,?SOCKET_BROADCAST).
%
%send_to_local_online_player(Level, Bin ,SocketN) ->
%	MS = ets:fun2ms(fun(T) when T#player.lv >= Level-> 
%					 [T#player.other#player_other.pid_send,T#player.other#player_other.pid_send2,T#player.other#player_other.pid_send3]
%					end),
%	L = ets:select(?ETS_ONLINE, MS),	
%	
%    do_broadcast(L, Bin, SocketN).
%
%%% @spec 发送信息给一定级别的以上在线的玩家,但不包括制定的UID
%send_to_online_player_except(Level,Bin,UId) ->
%	send_to_online_player_except(Level, Bin,?SOCKET_BROADCAST,UId).
%
%send_to_online_player_except(Level, Bin, SocketN, UId) ->
%    send_to_local_online_player_except(Level,Bin,SocketN,UId),
%    mod_disperse:broadcast_to_online_player_except(ets:tab2list(?ETS_SERVER), Level, Bin,UId).
%
%send_to_local_online_player_except(Level, Bin, UId) ->
%	send_to_local_online_player_except(Level, Bin ,?SOCKET_BROADCAST,UId).
%
%send_to_local_online_player_except(Level, Bin, SocketN, UId) ->
%	MS = ets:fun2ms(fun(T) when T#player.lv >= Level andalso T#player.id =/= UId  -> 
%					 [T#player.other#player_other.pid_send,T#player.other#player_other.pid_send2,T#player.other#player_other.pid_send3]
%					end),
%	L = ets:select(?ETS_ONLINE, MS),	
%	
%    do_broadcast(L, Bin, SocketN).
%	
%	
%%% @spec 发送信息开通了某个功能的玩家
%send_to_opened_player(FuncNum, Bin) ->
%	send_to_opened_player(FuncNum, Bin,?SOCKET_BROADCAST).
%
%send_to_opened_player(FuncNum, Bin,SocketN) ->
%    send_to_local_opened_player(FuncNum,Bin,SocketN),
%    mod_disperse:broadcast_to_opened_player(ets:tab2list(?ETS_SERVER), FuncNum, Bin).
%
%send_to_local_opened_player(FuncNum, Bin) ->
%	send_to_local_opened_player(FuncNum, Bin ,?SOCKET_BROADCAST).
%
%send_to_local_opened_player(FuncNum, Bin ,SocketN) ->
%	MS = ets:fun2ms(fun(T) when (T#player.ftst band FuncNum) =/= 0 -> 
%					 [T#player.other#player_other.pid_send,T#player.other#player_other.pid_send2,T#player.other#player_other.pid_send3]
%					end),
%	L = ets:select(?ETS_ONLINE, MS),	
%	
%    do_broadcast(L, Bin, SocketN).
%
%%% @spec 发送消息给联盟成员
%%% Who -- all | leader
%send_to_guild_member(Who,Bin) ->
%	send_to_guild_member(Who, Bin,?SOCKET_BROADCAST).
%
%send_to_guild_member(Who, Bin,SocketN) ->
%    send_to_local_guild_member(Who,Bin,SocketN),
%    mod_disperse:broadcast_to_guild_member(ets:tab2list(?ETS_SERVER), Who, Bin).
%
%send_to_local_guild_member(Who, Bin) ->
%	send_to_local_guild_member(Who, Bin ,?SOCKET_BROADCAST).
%
%send_to_local_guild_member(Who, Bin ,SocketN) ->
%	case Who of
%		all ->
%			MS = ets:fun2ms(fun(T) when (T#player.unid > 0)  -> 
%					 [T#player.other#player_other.pid_send,T#player.other#player_other.pid_send2,T#player.other#player_other.pid_send3]
%					end) ;
%		leader ->
%			MS = ets:fun2ms(fun(T) when ( T#player.unid > 0 andalso T#player.upst >= 1 andalso T#player.upst =< 3)  -> 
%					 [T#player.other#player_other.pid_send,T#player.other#player_other.pid_send2,T#player.other#player_other.pid_send3]
%					end) ;
%		_ ->
%			MS = []
%	end ,
%	L = ets:select(?ETS_ONLINE, MS),	
%    do_broadcast(L, Bin, SocketN).
%	
%	
%%% @spec 发送消息给指定联盟成员
%send_to_assigned_guild(GuildId,Bin) ->
%	send_to_assigned_guild(GuildId, Bin,?SOCKET_BROADCAST).
%
%send_to_assigned_guild(GuildId, Bin,SocketN) ->
%    send_to_local_assigned_guild(GuildId,Bin,SocketN),
%    mod_disperse:broadcast_to_assigned_guild(ets:tab2list(?ETS_SERVER), GuildId, Bin).
%
%send_to_local_assigned_guild(GuildId, Bin) ->
%	send_to_local_assigned_guild(GuildId, Bin ,?SOCKET_BROADCAST).
%
%send_to_local_assigned_guild(GuildId, Bin,SocketN) ->
%	MS = ets:fun2ms(fun(T) when (T#player.unid =:=GuildId)  -> 
%							[T#player.other#player_other.pid_send,T#player.other#player_other.pid_send2,T#player.other#player_other.pid_send3]
%					end) ,
%	L = ets:select(?ETS_ONLINE, MS),	
%    do_broadcast(L, Bin, SocketN).	
%	
%%% @spec 发送消息给指定联盟之外的联盟成员
%send_to_except_guild(GuildId,Bin) ->
%	send_to_except_guild(GuildId, Bin,?SOCKET_BROADCAST).
%
%send_to_except_guild(GuildId, Bin,SocketN) ->
%    send_to_local_except_guild(GuildId,Bin,SocketN),
%    mod_disperse:broadcast_to_except_guild(ets:tab2list(?ETS_SERVER), GuildId, Bin).
%
%send_to_local_except_guild(GuildId, Bin) ->
%	send_to_local_except_guild(GuildId, Bin ,?SOCKET_BROADCAST).
%
%send_to_local_except_guild(GuildId, Bin,SocketN) ->
%	MS = ets:fun2ms(fun(T) when (T#player.unid > 0 andalso T#player.unid =/=GuildId)  -> 
%							[T#player.other#player_other.pid_send,T#player.other#player_other.pid_send2,T#player.other#player_other.pid_send3]
%					end) ,
%	L = ets:select(?ETS_ONLINE, MS),	
%    do_broadcast(L, Bin, SocketN).		
	
	
	
	
	
	
