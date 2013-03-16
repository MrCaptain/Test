%%%------------------------------------
%%% @Module     : pt_22
%%% @Author     : csj
%%% @Created    : 2010.10.06 
%%% @Description: 排行榜协议处理 
%%%------------------------------------
-module(pt_22).
-export([read/2, write/2]).
-include("common.hrl").
-include("record.hrl").

%%
%%客户端 -> 服务端 ----------------------------
%%

%% %% 查询人物排行榜
%% read(22001, <<Realm:8, Career:8, Sex:8, Type:8>>) ->
%%     {ok, [Realm, Career, Sex, Type]};
%% 
%% %% %% 查询装备排名
%% read(22002, <<Type:8>>) ->
%%     {ok, Type};
%% 
%% %% 查询帮会排名
%% read(22003, <<Type:8>>) ->
%%     {ok, Type};
%% 
%% %%宠物排行
%% read(22004, _) ->
%% 	{ok, []};
%% 
%% %%封神台霸主榜
%% read(22005, _) ->
%% 	{ok, []};
%% 
%% %%氏族战排行
%% read(22006, _) ->
%% 	{ok, []};
%% %%22007 上场个人功勋排行
%% read(22007, _) ->
%% 	{ok, []};
%% 
%% %%镇妖台排行
%% read(22008, _) ->
%% 	{ok, []};
%% read(22009, _) ->
%% 	{ok, []};
%% 
%% %%22010	魅力值排行榜
%% read(22010, _) ->
%% 	{ok, []};

%%个人排行
read(22001, <<Type:8>>) ->
	{ok, [Type]};

%%个人排行战力排行
read(22002, _) ->
	{ok, []};

%%个人排行财富排行
read(22003, _) ->
	{ok, []};

%%巨兽排行
read(22004, _) ->
	{ok, []};

%%英灵排行
read(22005, _) ->
	{ok, []};

%%宠物排行
read(22006, _) ->
	{ok, []};

%%联盟排行
read(22007, <<Type:8>>) ->
	{ok, [Type]};

read(_, _) ->
    {error, no_match}.

%%
%%服务端 -> 客户端 ------------------------------------
%%

%% %% 查询人物排名
%% write(22001, []) ->
%%     {ok, pt:pack(22001, <<0:16>>)};     %% 无数据
%% %%write(22001, [RankList]) ->
%% write(22001, RankList) ->
%% %% RankList = RoleRank#ets_rank.rank_list,
%%     F = fun(Info) ->
%%             [Rank, Id, Nick, Sex, Career, Realm, GuildName, Value, Vip] = Info,
%% 			Nick1 = tool:to_binary(Nick), 
%%             Len1 = byte_size(Nick1),
%% 			GuildName1 = tool:to_binary(GuildName),
%%             Len2 = byte_size(GuildName1),
%%             <<Rank:16, Id:32, Len1:16, Nick1/binary, Vip:8, Sex:8, Realm:8, Career:8, Len2:16, GuildName1/binary, Value:32>>
%%     end,
%%     Size = length(RankList),
%%     BinList = tool:to_binary([F(Info) || Info <- RankList]),
%%     {ok, pt:pack(22001, <<Size:16, BinList/binary>>)};
%% 
%% %% 查询装备排名
%% write(22002, []) ->
%%     {ok, pt:pack(22002, <<0:16>>)};     %% 无数据
%% write(22002, [EquipRank]) ->
%%     RankList = EquipRank#ets_rank.rank_list,
%%     F = fun(Info) ->
%%             [Rank, GoodsId, GoodsName, PlayerId, PlayerName, Realm, Guild, Score, _Vip] = Info,
%% 			GoodsName1 = tool:to_binary(GoodsName), 
%%             Len1 = byte_size(GoodsName1),
%% 			PlayerName1 = tool:to_binary(PlayerName),
%%             Len2 = byte_size(PlayerName1),
%% 			GuildName1 = tool:to_binary(Guild),
%%             Len3 = byte_size(GuildName1),
%%             NewScore = trunc(Score),
%%             <<Rank:16, GoodsId:32, Len1:16, GoodsName1/binary, PlayerId:32, Len2:16, 
%% 					PlayerName1/binary, Realm:8, Len3:16, GuildName1/binary, NewScore:32>>
%%     end,
%%     Size = length(RankList),
%%     BinList = tool:to_binary([F(Info) || Info <- RankList]),
%%     {ok, pt:pack(22002, <<Size:16, BinList/binary>>)};
%% 
%% %% 查询帮会排名
%% write(22003, []) ->
%%     {ok, pt:pack(22003, <<0:16>>)};
%% write(22003, [GuildRank]) ->
%%     RankList = GuildRank#ets_rank.rank_list,
%%     F = fun(Info) ->
%%             [Rank, Id, Name, Realm, Funds, Chief_name, MemberNum, Level] = Info,
%% 			Name1 = tool:to_binary(Name), 
%%             Name_len = byte_size(Name1),
%% 			Chief_name1 = tool:to_binary(Chief_name),
%% 			Chief_name_len = byte_size(Chief_name1),
%%             <<Rank:16, Id:32, Name_len:16, Name1/binary, Funds:32, Chief_name_len:16, 
%% 			  Chief_name1/binary, Realm:8, MemberNum:16, Level:8>>
%%     end,
%%     Size = length(RankList),
%%     BinList = tool:to_binary([F(Info) || Info <- RankList]),
%%     {ok, pt:pack(22003, <<Size:16, BinList/binary>>)};
%% 
%% %%宠物排行榜
%% write(22004, []) ->
%% 	Data = <<0:16>>,
%% 	{ok, pt:pack(22004, Data)};
%% write(22004, [RankPet]) ->
%% 	RankList = RankPet#ets_rank.rank_list,
%% 	F = fun(Info) ->
%% 				[Rank, PetId, PetName, PlayerId, PlayerName, PetLevel, PetAptitude, Grow, Vip] = Info,
%% 				PetNameBin = tool:to_binary(PetName),
%% 				PetNameBinLen = byte_size(PetNameBin),
%% 				PlayerNameBin = tool:to_binary(PlayerName),
%% 				PlayerNameBinLen = byte_size(PlayerNameBin),
%% 				<<Rank:8, PetId:32, PetNameBinLen:16, PetNameBin/binary, PlayerId:32,
%% 				  PlayerNameBinLen:16, PlayerNameBin/binary, Vip:8, PetLevel:8, PetAptitude:8, Grow:8>>
%% 		end,
%% 	Size = length(RankList),
%% 	BinData = tool:to_binary([F(Elem) || Elem <- RankList]),
%% 	Data = <<Size:16, BinData/binary>>,
%% 	{ok, pt:pack(22004, Data)};
%% 	
%% %% 查询封神台霸主
%% write(22005, []) ->
%%     {ok, pt:pack(22005, <<0:16>>)};     %% 无数据
%% write(22005, [FST_G_List]) ->
%%     F = fun(Info) ->
%%             [Thru_Time, Loc, Nick] = Info,
%% 			Nick1 = tool:to_binary(Nick), 
%%             Len1 = byte_size(Nick1),
%%             <<Thru_Time:32, Loc:8, Len1:16, Nick1/binary>>
%%     end,
%%     Size = length(FST_G_List),
%%     BinList = tool:to_binary([F(G_info) || G_info <- FST_G_List]),
%%     {ok, pt:pack(22005, <<Size:16, BinList/binary>>)};
%% 
%% %%氏族战排行
%% write(22006, []) ->
%%     {ok, pt:pack(22006, <<0:16>>)};
%% write(22006, [GuildRank]) ->
%%     RankList = GuildRank#ets_rank.rank_list,
%%     F = fun(Info) ->
%%             [Order, Name, Level, Combat_all_num, Combat_Num] = Info,
%% 			Name1 = tool:to_binary(Name), 
%%             Name_len = byte_size(Name1),
%%             <<Order:8, Name_len:16, Name1/binary, Level:8, Combat_all_num:32, Combat_Num:16>>
%%     end,
%%     Size = length(RankList),
%%     BinList = tool:to_binary([F(Info) || Info <- RankList]),
%%     {ok, pt:pack(22006, <<Size:16, BinList/binary>>)};
%% 
%% %%22007 上场个人功勋排行
%% write(22007, RankInfo) -> 
%% 	{RankInfoLen, RankInfoBin} = handle_skymemrank_list(RankInfo), 
%% 	{ok, pt:pack(22007, <<RankInfoLen:16, RankInfoBin/binary>>)};
%% 
%% %% 镇妖台排行
%% write(22008, []) ->
%%     {ok, pt:pack(22008, <<0:16>>)};     %% 无数据
%% write(22008, [TD_S_List]) ->
%%     F = fun(Info) ->
%%             [Att_num, G_name, Nick, Career, Realm, _Uid, Hor_td, Mgc_td, Vip] = Info,
%% 			Nick1 = tool:to_binary(Nick), 
%%             NLen = byte_size(Nick1),
%% 			G_name1 = tool:to_binary(G_name),
%% 			GLen = byte_size(G_name1),
%%             <<NLen:16, Nick1/binary, Vip:8, Career:8, Realm:8, GLen:16, G_name1/binary, Att_num:8, Hor_td:32, Mgc_td:32>>
%%     end,
%%     Size = length(TD_S_List),
%%     BinList = tool:to_binary([F(TD_info) || TD_info <- TD_S_List]),
%%     {ok, pt:pack(22008, <<Size:16, BinList/binary>>)};
%% 
%% write(22009, []) ->
%%     {ok, pt:pack(22009, <<0:16>>)};     %% 无数据
%% write(22009, [TD_M_List]) ->
%%     F = fun(Info) ->
%%             [Att_num, Nicks, _Uids, Hor_td, Mgc_td] = Info,
%% 			Nick1 = tool:to_binary(Nicks), 
%%             NLen = byte_size(Nick1),
%%             <<NLen:16, Nick1/binary, Att_num:8, Hor_td:32, Mgc_td:32>>
%%     end,
%%     Size = length(TD_M_List),
%%     BinList = tool:to_binary([F(TD_info) || TD_info <- TD_M_List]),
%%     {ok, pt:pack(22009, <<Size:16, BinList/binary>>)};
%% 
%% %%22010	魅力值排行榜
%% write(22010, []) ->
%%     {ok, pt:pack(22010, <<0:16>>)};     %% 无数据
%% write(22010, [CharmRank]) ->
%% 	List = CharmRank#ets_rank.rank_list,
%% 	F = fun(Info) ->
%% 				[Order, _PId, PlayerName, Career, Realm, GuildName, Title, Charm, Vip] = Info,
%% 				PNameBin = tool:to_binary(PlayerName),
%% 				PNameLen = byte_size(PNameBin),
%% 				GNameBin = tool:to_binary(GuildName),
%% 				GNameLen = byte_size(GNameBin),
%% 				<<Order:8, PNameLen:16, PNameBin/binary, Vip:8, Career:8, Realm:8, GNameLen:16, GNameBin/binary, Title:32, Charm:32>>
%% 		end, 
%% 	Size = length(List),
%%     BinList = tool:to_binary([F(CharmInfo) || CharmInfo <- List]),
%%     {ok, pt:pack(22010, <<Size:16, BinList/binary>>)};

%%个人排行等级排行
write(22001, Data) ->
	if
		Data =:= [] ->
			{ok, pt:pack(22001, <<0:8>>)};
		true ->
			[Res, ResData] = Data,
			if
				Res =/= 1 ->
					{ok, pt:pack(22001, <<Res:8>>)};
				true ->
					[Tm, MyRank, MyLv, MyExp, MyRankChg, ShowData] = ResData,
					F = fun(R) ->
								{Rank, Uid, Nick, Crr, Lv, Exp, RankChg} = R,
								BinNick = tool:to_binary(Nick),
								LenBinNick = byte_size(BinNick),
								<<Rank:16, Uid:32, LenBinNick:16, BinNick/binary, Crr:8, Lv:8, Exp:32, RankChg:8>>
						end,
					LenShowData = length(ShowData),
					BinShowData = tool:to_binary(lists:map(F, ShowData)),
					{ok, pt:pack(22001, <<Res:8, Tm:32, MyRank:16, MyLv:8, MyExp:32, MyRankChg:8, LenShowData:16, BinShowData/binary>>)}
			end
	end;


%%个人排行战力排行
write(22002, Data) ->
	if
		Data =:= [] ->
			{ok, pt:pack(22002, <<0:8>>)};
		true ->
			[Res, ResData] = Data,
			if
				Res =/= 1 ->
					{ok, pt:pack(22002, <<Res:8>>)};
				true ->
					[Tm, MyRank, MyFfc, MyRankChg, ShowData] = ResData,
					F = fun(R) ->
								{Rank, Uid, Nick, Crr, Ffc, RankChg} = R,
								BinNick = tool:to_binary(Nick),
								LenBinNick = byte_size(BinNick),
								<<Rank:16, Uid:32, LenBinNick:16, BinNick/binary, Crr:8, Ffc:32, RankChg:8>>
						end,
					LenShowData = length(ShowData),
					BinShowData = tool:to_binary(lists:map(F, ShowData)),
					{ok, pt:pack(22002, <<Res:8, Tm:32, MyRank:16, MyFfc:32, MyRankChg:8, LenShowData:16, BinShowData/binary>>)}
			end
	end;

%%个人排行财富排行
write(22003, Data) ->
	if
		Data =:= [] ->
			{ok, pt:pack(22003, <<0:8>>)};
		true ->
			[Res, ResData] = Data,
			if
				Res =/= 1 ->
					{ok, pt:pack(22003, <<Res:8>>)};
				true ->
					[Tm, MyRank, MyCoin, MyRankChg, ShowData] = ResData,
					F = fun(R) ->
								{Rank, Uid, Nick, Crr, Coin, RankChg} = R,
								BinNick = tool:to_binary(Nick),
								LenBinNick = byte_size(BinNick),
								<<Rank:16, Uid:32, LenBinNick:16, BinNick/binary, Crr:8, Coin:32, RankChg:8>>
						end,
					LenShowData = length(ShowData),
					BinShowData = tool:to_binary(lists:map(F, ShowData)),
					{ok, pt:pack(22003, <<Res:8, Tm:32, MyRank:16,  MyCoin:32, MyRankChg:8, LenShowData:16, BinShowData/binary>>)}
			end
	end;

%%巨兽排行
write(22004, Data) ->
	if
		Data =:= [] ->
			{ok, pt:pack(22004, <<0:8>>)};
		true ->
			[Res, ResData] = Data,
			if
				Res =/= 1 ->
					{ok, pt:pack(22004, <<Res:8>>)};
				true ->
					[Tm, ShowData] = ResData,
					F = fun(R) ->
								{Rank, GiantId, GiantNick, Qly, Ffc, Lv, Teclv, RankChg, Uid, Nick} = R,
								BinGiantNick = tool:to_binary(GiantNick),
								LenGiantNick = byte_size(BinGiantNick),
								BinNick = tool:to_binary(Nick),
								LenBinNick = byte_size(BinNick),
								<<Rank:16, GiantId:32, LenGiantNick:16, BinGiantNick/binary, Qly:8, Ffc:32, Lv:8, 
								  Teclv:8, Uid:32, LenBinNick:16, BinNick/binary, RankChg:8>>
						end,
					LenShowData = length(ShowData),
					BinShowData = tool:to_binary(lists:map(F, ShowData)),
					{ok, pt:pack(22004, <<Res:8, Tm:32, LenShowData:16, BinShowData/binary>>)}
			end
	end;
	
%%英灵排行
write(22005, Data) ->
	if
		Data =:= [] ->
			{ok, pt:pack(22005, <<0:8>>)};
		true ->
			[Res, ResData] = Data,
			if
				Res =/= 1 ->
					{ok, pt:pack(22005, <<Res:8>>)};
				true ->
					[Tm, ShowData] = ResData,
					F = fun(R) ->
								{Rank, Gid, Ffc, Lv, Relv, RankChg, Uid, Nick} = R,
								BinNick = tool:to_binary(Nick),
								LenBinNick = byte_size(BinNick),
								<<Rank:16, Gid:32, Ffc:32, Lv:8, Relv:8, Uid:32, LenBinNick:16, BinNick/binary, RankChg:8>>
						end,
					LenShowData = length(ShowData),
					BinShowData = tool:to_binary(lists:map(F, ShowData)),
					{ok, pt:pack(22005, <<Res:8, Tm:32, LenShowData:16, BinShowData/binary>>)}
			end
	end;

%%宠物排行
write(22006, Data) ->
	if
		Data =:= [] ->
			{ok, pt:pack(22006, <<0:8>>)};
		true ->
			[Res, ResData] = Data,
			if
				Res =/= 1 ->
					{ok, pt:pack(22006, <<Res:8>>)};
				true ->
					[Tm, ShowData] = ResData,
					F = fun(R) ->
								{Rank, Pid, PNick, Qly, Ffc, Lv, Rela, RankChg, Uid, Nick} = R,
								BinPNick = tool:to_binary(PNick),
								LenBinPNick = byte_size(BinPNick),
								BinNick = tool:to_binary(Nick),
								LenBinNick = byte_size(BinNick),
								<<Rank:16, Pid:32, LenBinPNick:16, BinPNick/binary, Qly:8, Ffc:32, Lv:8, Rela:32, Uid:32, LenBinNick:16, BinNick/binary, RankChg:8>>
						end,
					LenShowData = length(ShowData),
					BinShowData = tool:to_binary(lists:map(F, ShowData)),
					{ok, pt:pack(22006, <<Res:8, Tm:32, LenShowData:16, BinShowData/binary>>)}
			end
	end;

%%联盟排行
write(22007, Data) ->
	if
		Data =:= [] ->
			{ok, pt:pack(22007, <<0:8>>)};
		true ->
			[Res, Type, ResData] = Data,
%% 			io:format("22007, Data:~p~n", [Data]),
			if
				Res =/= 1 ->
					{ok, pt:pack(22007, <<Res:8>>)};
				true ->
					[Tm, MyUnRank, MyUnLv, MyNum, MyRankChg, ShowData] = ResData,
					F = fun(R) ->
								{Rank, _Unid, UnName, Unlv, Num, RankChg} = R,
								BinUnName = tool:to_binary(UnName),
								LenBinUnName = byte_size(BinUnName),
								<<Rank:16, LenBinUnName:16, BinUnName/binary, Unlv:8, Num:32, RankChg:8>>
						end,
					LenShowData = length(ShowData),
					BinShowData = tool:to_binary(lists:map(F, ShowData)),
					{ok, pt:pack(22007, <<Res:8, Type:8, Tm:32, MyUnRank:16, MyUnLv:8, MyNum:32, MyRankChg:8,
										  LenShowData:16, BinShowData/binary>>)}
			end
	end;

write(_Cmd, _R) ->
    {ok, pt:pack(0, <<>>)}.
%%22007 上场个人功勋排行 内部方法
%% handle_skymemrank_list(ThreeList) ->
%% 	Len = length(ThreeList),
%% 	List = lists:map(fun(Elem) ->
%% 							 {PlayerName, Career, PLv, KillFoe, DieC, GFlags, MNuts, Feat} = Elem,
%% 							 {PLen, PBin} = lib_guild_inner:string_to_binary_and_len(PlayerName),
%% 							 <<PLen:16, PBin/binary, Career:8, PLv:8, KillFoe:16, DieC:16, GFlags:16, MNuts:16, Feat:32>>
%% 					 end, ThreeList),
%% 	BinData = tool:to_binary(List),
%% 	{Len, BinData}.