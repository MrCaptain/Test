%% Author: Administrator
%% Created: 2011-11-3
%% Description: TODO: Add description to pt_56
-module(pt_56).

%%
%% Include files
%%

%%
%% Exported Functions
%%
-include("common.hrl").
-include("record.hrl").

-export([write/2, read/2]).



%%获取玩家信息
read(56001, _ ) ->
	{ok, th};


%%获取对手信息
read(56002, _ ) ->
	{ok, th};


%%获取情报
read(56003, _ ) ->
	{ok, th};


%%公告
read(56004, _ ) ->
	{ok, th};


%%奖励
read(56005, _ ) ->
	{ok, th};

%%获取榜单
read(56010, _ ) ->
	{ok, th};

%%获取榜单（前三）
read(56011, _ ) ->
	{ok, th};

%%战斗
read(56020, <<PlayerBRank:32,Flag:32>> ) ->
	{ok, [PlayerBRank,Flag]};


%%增加次数
read(56021, _ ) ->
	{ok, th};

%%清除冷却时间
read(56022, <<Flag:8>> ) ->
	{ok, [Flag]};

%%领取奖励
read(56024, _ ) ->
	{ok, th};


%%查看自己战斗
read(56030, <<PlayerIdb:32,Time:32,Br:8>> ) ->
	{ok, [PlayerIdb,Time,Br]};


%%分享战斗
read(56031, <<PlayerIdb:32,Time:32,Br:8>> ) ->
	{ok, [PlayerIdb,Time,Br]};

%%根据战斗纪律id查看战斗
read(56032, <<Bin/binary>> ) ->
	{Con, _} = pt:read_string(Bin),
	Flag = list_to_integer(Con),
	{ok, [Flag]};

%%选择卡片
read(56040, <<CardId:32>> ) ->
	{ok, [CardId]};

%%取消卡片
read(56041, <<CardId:32>> ) ->
	{ok, [CardId]};

%%查询是否有奖励可领
read(56050, _) ->
	{ok, th};

%%查询聚宝盆
read(56055, _) ->
	{ok, th};

%%聚宝盆
read(56056, _) ->
	{ok, th};

read(_Cmd, _R) ->
%% 	?DEBUG("~p",[_Cmd]),
%% 	?DEBUG("~p",[_R]),
    {error, no_match}.


%%----------------------------------------------------------------------------------------------------------

write(56001,[Rank,Win,Def,ADef,Force,Cd,Up,Fg]) ->
%% 	?DEBUG("~p",[ADef]),
	ListNum = length(Up),
	%%io:format("write_56001:[~p]\n",[[Rank,Win,Def,ADef,Force,Cd,Up,Fg]]),
	ListBin = tool:to_binary(lists:map(fun({CardId, Num, Type})-> 
											   Data_vaule = <<CardId:32,Num:32, Type:8>>,
											   Data_vaule
									   end,Up)),
    %%Data = <<ListNum:16, ListBin/binary>>,
    {ok, pt:pack(56001, <<Rank:32,Win:32,Def:16,ADef:16,Force:32,Cd:32,Fg:8,ListNum:16, ListBin/binary>>)};

write(56002,[Rlist]) ->
%% 	?DEBUG("~p",[Rlist]),
	SN = bo_to_client(Rlist),
	SBin = tool:to_binary(SN),
	Slen = length(SN),
%% 	if
%% 		Slen < 5 ->
%% 			io:format("~s write_56002_msg  ##ListLen: ~p  __________________~n",[misc:time_format(now()), Slen]);
%% 		true ->
%% 			skip
%% 	end,
	{ok, pt:pack(56002, <<Slen:16,SBin/binary>>)};	

write(56003,[Rlist]) ->
	SN = lists:reverse(bl_to_client(Rlist)),
	SBin = tool:to_binary(SN),
	Slen = length(SN),
	{ok, pt:pack(56003, <<Slen:16,SBin/binary>>)};	

write(56004,[PlayerId,Nick,Type,Num]) ->
%% 	?DEBUG("~p",[[56004]]),
	G = tool:to_binary(Nick),
	G_len = byte_size(G),
    {ok, pt:pack(56004, <<PlayerId:32,G_len:16,G/binary,Type:8,Num:32>>)};


write(56005,[Rank,Timeres,AwardL]) ->
	ABinLen = length(AwardL),
	ABin = list_to_binary([<<GoodsId:32, GoodsNum:32>>||{GoodsId, GoodsNum}<-AwardL]),
    {ok, pt:pack(56005, <<Rank:32,Timeres:32,ABinLen:16,ABin/binary>>)};

%% 长生榜
write(56010,[Rlist]) ->
	SN = br_to_client(Rlist),
	SBin = tool:to_binary(SN),
	Slen = length(SN),
	{ok, pt:pack(56010, <<Slen:16,SBin/binary>>)};

%% 前三名
write(56011,[Rlist]) ->
	SN = br_to_client_top3(Rlist),
	SBin = tool:to_binary(SN),
	Slen = length(SN),
	{ok, pt:pack(56011, <<Slen:16,SBin/binary>>)};	

write(56015,[Id,Nick,Rank]) ->
	G = tool:to_binary(Nick),
	G_len = byte_size(G),
	{ok, pt:pack(56015,<<Id:32,G_len:16,G/binary,Rank:32>>)};



write(56020,[Res]) ->
    {ok, pt:pack(56020, <<Res:8>>)};


write(56021,[Res]) ->
    {ok, pt:pack(56021, <<Res:8>>)};


write(56022,[Res]) ->
    {ok, pt:pack(56022, <<Res:8>>)};

write(56024,[Rank, Awards]) ->
	ABinLen = length(Awards),
	ABin = list_to_binary([<<GoodsId:32, GoodsNum:32>>||{GoodsId, GoodsNum}<-Awards]),
    {ok, pt:pack(56024, <<Rank:32, ABinLen:16, ABin/binary>>)};

write(56025, [BaseList, VipList, Bin]) ->
	BsBinLen = length(BaseList),
	BsBin = list_to_binary([<<GoodsId:32, GoodsNum:32>>||{GoodsId, GoodsNum}<-BaseList]),
	VpBinLen = length(VipList),
	VpBin = list_to_binary([<<GoodsId1:32, GoodsNum1:32>>||{GoodsId1, GoodsNum1}<-VipList]),
	{ok, pt:pack(56025, <<0:32, BsBinLen:16, BsBin/binary, VpBinLen:16, VpBin/binary, Bin/binary>>)};

write(56030,[Res,Bin]) ->
    {ok, pt:pack(56030, <<Res:8,Bin/binary>>)};


write(56031,[Res]) ->
%% 	Con = integer_to_list(Flag),
%% 	G = tool:to_binary(Con),
%% 	G_len = byte_size(G),
%% 	H = tool:to_binary(NickA),
%% 	H_len = byte_size(H),
%% 	I = tool:to_binary(NickB),
%% 	I_len = byte_size(I),
    {ok, pt:pack(56031, <<Res:8>>)};


write(56032,[Res,NickA,NickB,Br,Bin]) ->
%% 	?DEBUG("~p",[Res]),
	H = tool:to_binary(NickA),
	H_len = byte_size(H),
	I = tool:to_binary(NickB),
	I_len = byte_size(I),
%% 	?DEBUG("~p",[Bin]),
    {ok, pt:pack(56032, <<Res:8,H_len:16,H/binary,I_len:16,I/binary,Br:8,Bin/binary>>)};

write(56040,[CardId, Res]) ->
	%%io:format("write_56040:[~p]\n",[[CardId, Res]]),
	{ok, pt:pack(56040, <<CardId:32, Res:8>>)};

write(56041,[CardId, Res]) ->
	%%io:format("write_56041:[~p]\n",[[CardId, Res]]),
	{ok, pt:pack(56041, <<CardId:32, Res:8>>)};

write(56050, [Awards]) ->
	ABinLen = length(Awards),
	ABin = list_to_binary([<<GoodsId:32, GoodsNum:32>>||{GoodsId, GoodsNum}<-Awards]),
	{ok, pt:pack(56050, <<ABinLen:16, ABin/binary>>)};

write(56051, _) ->
	{ok, pt:pack(56051, <<>>)};

%%查询聚宝盆
write(56055, Coin) ->
	{ok, pt:pack(56055, <<Coin:32>>)};

%%聚宝盆领取
write(56056, [Res, RCoin]) ->
	{ok, pt:pack(56056, <<Res:8, RCoin:32>>)};

write(Cmd, _R) ->
?INFO_MSG("~s_errorcmd_[~p] ",[misc:time_format(game_timer:now()), Cmd]),
    {ok, pt:pack(0, <<>>)}.


bo_to_client(Rlist) ->
	bo_to_client_loop(Rlist,[]).


bo_to_client_loop(Rlist,Res) ->
	case Rlist of
		[] ->
			Res;
		[H|T] ->
			[Id,Nick,Sex,Crr,Lv,Rank] = H,
			G = tool:to_binary(Nick),
			G_len = byte_size(G),
			R = Res ++ [<<Id:32,G_len:16,G/binary,Sex:8,Crr:8,Lv:16,Rank:32>>],
			bo_to_client_loop(T,R)
	end.



bl_to_client(Data) ->
	bl_to_client_loop(Data,[]).

bl_to_client_loop(Data,Res) ->
	case Data of
		[] ->
			Res;
		[H|T] ->
			[PlayerId,Nick,Def,Wf,Rank,Time] = H,
			G = tool:to_binary(Nick),
			G_len = byte_size(G),
			R = Res ++ [<<PlayerId:32,G_len:16,G/binary,Def:8,Wf:8,Rank:32,Time:32>>],
			bl_to_client_loop(T,R)
	end.
	
	
br_to_client(Rlist) ->
	br_to_client_loop(Rlist,[]).

br_to_client_loop(Rlist,Res) ->
	case Rlist of
		[] ->
			Res;
		[H|T] ->
			[Rank,PlayerId,Nick,Lv,Sex,Force] = H,
			G = tool:to_binary(Nick),
			G_len = byte_size(G),
			R = Res ++ [<<Rank:32,PlayerId:32,G_len:16,G/binary,Lv:16,Sex:8,Force:32>>],
			br_to_client_loop(T,R)
	end.


br_to_client_top3(Rlist) ->
	br_to_client_top3_loop(Rlist,[]).

br_to_client_top3_loop(Rlist,Res) ->
	case Rlist of
		[] ->
			Res;
		[H|T] ->
			[Rank,PlayerId,Nick,_Lv,_Sex,_Force] = H,
			G = tool:to_binary(Nick),
			G_len = byte_size(G),
			R = Res ++ [<<Rank:8,PlayerId:32,G_len:16,G/binary>>],
			br_to_client_top3_loop(T,R)
	end.
	





