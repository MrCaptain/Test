%%%--------------------------------------
%%% @Module  : pt_14
%%% @Author  : csj
%%% @Created : 2010.10.05
%%% @Description:  14玩家间关系信息
%%%--------------------------------------
-module(pt_14).
-export([read/2, write/2]).
-include("common.hrl").
-include("record.hrl").
%%客户端 -> 服务端 ----------------------------

%% %%  获取关注列表
%% read(14000, _) ->
%%     {ok, []};
%% 
%% %%  关注
%% read(14001, <<PlayerId:32>>) ->
%%     {ok, PlayerId};
%% 
%% %%  取消关注
%% read(14002, <<PlayerId:32>>) ->
%%     {ok, PlayerId};
%% 
%% %%  听众列表
%% read(14003, _) ->
%%     {ok, []};
%% 
%% %%加入黑名单
%% read(14004,<<PlayerId:32>>) ->
%% 	{ok,PlayerId};
%% 
%% %%最近联系人
%% read(14005,_) ->
%% 	{ok,[]};
%% 
%% read(14006,<<PlayerId:32>>) ->
%% 	{ok,PlayerId};
%% 
%% %%  分组列表
%% read(14010, _) ->
%%     {ok, []}; 



%% %%  创建分组
%% read(14011,<<Bin/binary>>) ->
%% 	?DEBUG("~p",[[14011]]),
%%     {Name, _} = pt:read_string(Bin),
%%     {ok, [Name]};
%% 
%% %%  改变所在组
%% read(14012,<<PlayerId:32,Gid:32>>) ->
%%     {ok, [PlayerId,Gid]};
%% 
%% %%  修改组名
%% read(14013, <<Gid:32,Bin/binary>>) ->
%% 	{Name, _} = pt:read_string(Bin),
%%     {ok, [Gid,Name]};
%% 
%% %%  删除分组
%% read(14014, <<Gid:32>>) ->
%%     {ok, Gid};
%% 
%% 
%% 
%% 
%% %%  发送祝福
%% read(14021,<<PlayerId:32,Type:8>>) ->
%%     {ok, [PlayerId,Type]};
%% 
%% %%  接受祝福
%% read(14022, <<PlayerId:32>>) ->
%%     {ok, PlayerId};
%% 
%% %%确认接收
%% read(14023, <<PlayerId:32>>) ->
%%     {ok, PlayerId};
%% 
%% 
%% %%查询玩家是否存在
%% read(14030, <<Bin/binary>>) ->
%% 	{Name, _} = pt:read_string(Bin),
%%     {ok, Name};
%% 
%% 
%% %%查询部分信息
%% read(14031, <<PlayerId:32>>) ->
%%     {ok, PlayerId};

%% %%离线消息
%% read(14050, _) ->
%%     {ok, []};

%% read(14040, <<Id:32, Bin/binary>>) ->
%% 	{Msg, _} = pt:read_string(Bin),
%%     {ok, [Id, Msg]};

read(_Cmd, _R) ->
    {error, no_match}.




%%服务端 -> 客户端 ------------------------------------



%% %%  获取关注列表
%% write(14000, Data) ->
%% %% 	?DEBUG("~p",[Data]),
%% 	Fall = people_to_client(Data),
%% %% 	?DEBUG("~p",[Fall]),
%% 	MsgBin = tool:to_binary(Fall),
%% 	Rlen = length(Fall),
%%     {ok, pt:pack(14000, <<Rlen:16,MsgBin/binary>>)};
%% 
%% %%  关注 
%% write(14001,Res) ->
%%     {ok, pt:pack(14001, <<Res:8>>)};
%% 
%% %%  取消关注
%% write(14002,Res) ->
%%     {ok, pt:pack(14002, <<Res:8>>)};
%% 
%% 
%% 
%% %%  听众列表
%% write(14003,Data) ->
%% %% 	?DEBUG("~p",[Data]),
%% 	Fall = people_to_client(Data) ,
%% %% 	?DEBUG("~p",[Fall]),
%% 	MsgBin = tool:to_binary(Fall),
%% 	Rlen = length(Fall),
%%     {ok, pt:pack(14003, <<Rlen:16,MsgBin/binary>>)};
%% 
%% %%黑名单
%% write(14004,Res) ->
%% 	{ok, pt:pack(14004, <<Res:8>>)};
%% 
%% %%获取最近联系人
%% write(14005,DataAll) ->
%% 	Fall = relationship_last_all_to_client(DataAll),
%% 	MsgBin = tool:to_binary(Fall),
%% 	Rlen = length(Fall),
%%     {ok, pt:pack(14005, <<Rlen:16,MsgBin/binary>>)};	
%% 
%% %%增加最近联系人
%% write(14006,[PlayerId,Rela]) ->
%% 	{ok, pt:pack(14006, <<PlayerId:32,Rela:8>>)};
%% 
%% 
%% %%上下线通知
%% write(14008,[PlayerId,Flag]) ->
%% 	{ok, pt:pack(14008, <<PlayerId:32,Flag:8>>)};
%% 
%% 
%% %%好友更改通知
%% write(14009,[PlayerId,Nick,Flag]) ->
%% %% 	?DEBUG("~p",[[14009]]),
%% 	G = tool:to_binary(Nick),
%% 	G_len = byte_size(G),
%% 	{ok, pt:pack(14009, <<PlayerId:32,G_len:16,G/binary,Flag:8>>)};
%% 
%% 
%% 
%% 
%% 
%% %%  分组列表
%% write(14010,Data) ->
%% 	Fall = group_to_client(Data),
%% 	MsgBin = tool:to_binary(Fall),
%% 	Rlen = length(Fall),
%%     {ok, pt:pack(14010, <<Rlen:16,MsgBin/binary>>)};
%% 
%% 
%% %%  创建分组
%% write(14011,[Res,Gid]) ->
%%     {ok, pt:pack(14011, <<Res:8,Gid:32>>)};
%% 
%% %%  改变所在组
%% write(14012,Res) ->
%%     {ok, pt:pack(14012, <<Res:8>>)};
%% 
%% %%  修改组名
%% write(14013,[Res]) ->
%%     {ok, pt:pack(14013, <<Res:8>>)};
%% 
%% %%  删除分组
%% write(14014,[Res]) ->
%%     {ok, pt:pack(14014, <<Res:8>>)};
%% 
%% 
%% %%可发送祝福通知
%% write(14020,[PlayerId,Nick,Lv]) ->
%% 	G = tool:to_binary(Nick),
%% 	G_len = byte_size(G),	
%% 	{ok,pt:pack(14020,<<PlayerId:32,G_len:16,G/binary,Lv:8>>)};
%% 
%% 
%% 
%% %%发送祝福
%% write(14021,[Res,Ti]) ->
%% 	{ok, pt:pack(14021, <<Res:8,Ti:8>>)};
%% 
%% 
%% %%接收祝福
%% write(14022,[PlayerId,Nick,Lv,Type]) ->
%% 	G = tool:to_binary(Nick),
%% 	G_len = byte_size(G),
%% 	{ok, pt:pack(14022, <<PlayerId:32,G_len:16,G/binary,Lv:8,Type:8>>)};
%% 
%% %%确认接收
%% write(14023,[Res]) ->
%% 	{ok, pt:pack(14023, <<Res:8>>)};
%% 
%% 
%% 
%% 
%% 
%% 
%% %%查询玩家
%% write(14030,[Res,List,PlayerId]) ->
%% 	{ok, pt:pack(14030, <<Res:8,List:8,PlayerId:32>>)};
%% 
%% 
%% %%查询玩家
%% write(14031,R) ->
%% %% 	?DEBUG("~p",[R]),
%% 	case R of
%% 		[] ->
%% 			Bin = <<>>;
%% 		_ ->
%% 			[PlayerId,Nick,Sex,Crr,Lv,Ftst] = R,
%% 			G = tool:to_binary(Nick),
%% 			G_len = byte_size(G),
%% 			F = Ftst band 512,
%% 			case F == 0 of
%% 				true ->
%% 					Open = 1;
%% 				_ ->
%% 					Open = 0
%% 			end,
%% 			Bin = <<PlayerId:32,G_len:16,G/binary,Sex:8,Crr:8,Lv:32,Open:8>>
%% 	end,
%% %% 	?DEBUG("~p",[Bin]),
%% 	{ok, pt:pack(14031, Bin)};


%% %%关注通知
%% write(14032,[PlayerId,Nick]) ->
%% 	G = tool:to_binary(Nick),
%% 	G_len = byte_size(G),
%% 	{ok, pt:pack(14032, <<PlayerId:32,G_len:16,G/binary>>)};

write(Cmd, _R) ->
?INFO_MSG("~s_errorcmd_[~p] ",[misc:time_format(game_timer:now()), Cmd]),
    {ok, pt:pack(0, <<>>)}.


%% people_to_client(Data) ->
%% %% 	?DEBUG("~p",[Data]),
%% 	people_to_client(Data,[]).
%% 
%% people_to_client(Data,Res) ->
%% 	case Data of
%% 		[] ->
%% 			Res;
%% 		_ ->
%% 			[H|T] = Data,
%% %% 			?DEBUG("~p",[H]),
%% 			[A,B,C,D,E,F,K,M,N] = H,
%% 			G = tool:to_binary(F),
%% 			G_len = byte_size(G),
%% 			P = tool:to_binary(M),
%% 			P_len = byte_size(P),	
%% %% 			?DEBUG("~p",[Res]),
%% 			Ktm = [<<A:8,B:32,C:8,D:32,E:8,G_len:16,G/binary,K:8,P_len:16,P/binary,N:8>>],
%% %% 			?DEBUG("~p",[Ktm]),
%% 			R = Res ++ Ktm,
%% %% 			?DEBUG("~p",[R]),
%% 			people_to_client(T,R)
%% 	end.
%% 
%% group_to_client(Data) ->
%% 	group_to_client(Data,[]).
%% 
%% group_to_client(Data,Res) ->
%% 	case Data of
%% 		[] ->
%% 			Res;
%% 		_ ->
%% 			[H|T] = Data,
%% 			[A,B] = H,
%% 			G = tool:to_binary(B),
%% 			G_len = byte_size(G),
%% %% 			Len = byte_size(G), 
%% 			R = Res ++ [<<A:32,G_len:16,G/binary>>],
%% %% 			?DEBUG("~p",[R]),
%% 			people_to_client(T,R)
%% 	end.
%% 
%% 
%% relationship_last_all_to_client(DataAll) ->
%% 	relationship_last_all_to_client_loop(DataAll,[]).
%% 
%% relationship_last_all_to_client_loop(DataAll,Res) ->
%% 	case DataAll of
%% 		[] ->
%% 			Res;
%% 		_ ->
%% 			[H|T] = DataAll,
%% 			PlayerId = H#ets_relationship_last.idb,
%% 			case lib_player:is_online(PlayerId) of
%% 				true ->
%% 					Flag = 0;
%% 				_ ->
%% 					Flag = 1
%% 			end,
%% 			Rela = H#ets_relationship_last.rela,
%% 			Sex = H#ets_relationship_last.bsex ,
%% 			Nick = H#ets_relationship_last.bnick,
%% 			Car = H#ets_relationship_last.bcar,
%% 			Bg = H#ets_relationship_last.bg,
%% 			Bj = H#ets_relationship_last.bj,
%% 			Lo = H#ets_relationship_last.lo,
%% 			G = tool:to_binary(Nick),
%% 			G_len = byte_size(G),
%% 			P = tool:to_binary(Bg),
%% 			P_len = byte_size(P),
%% 			R = Res ++ [<<PlayerId:32,Flag:8,Rela:8,Sex:8,G_len:16,G/binary,Car:8,P_len:16,P/binary,Bj:8,Lo:32>>],
%% 			relationship_last_all_to_client_loop(T,R)
%% 	end.





