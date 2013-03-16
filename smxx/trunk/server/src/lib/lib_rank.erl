%%%------------------------------------
%%% @Module     : lib_rank
%%% @Author     : 
%%% @Email      : 
%%% @Created    :
%%% @Description: 排行榜处理函数
%%%------------------------------------
-module(lib_rank).

-include("common.hrl").
-include("rank.hrl").

-compile(export_all).
%% 
%% %% desc: 计算排名变化
%% calc_rank_change(Data, OldList, Rank) ->
%%     RoleId = hd(Data),
%%     case lists:keyfind(RoleId, 2, OldList) of
%%         false ->       0;   % 新入榜
%%         OldTuple ->   element(1, OldTuple) - Rank 
%%     end.
%% 
%% %% desc: 元组格式转化
%% make_per_tuple(RankType, Data, Rank, Change) when RankType >= ?RANK_T_EQUIP_WEAPON, RankType =< ?RANK_T_EQUIP_SPIRIT ->
%%     make_equip_rank_info_tuple(Data, Rank, Change);
%% make_per_tuple(RankType, Data, Rank, Change) when RankType == ?RANK_T_PARTNER_BATTLE; RankType == ?RANK_T_PARTNER_LV ->
%%     make_partner_rank_info_tuple(RankType, Data, Rank, Change);
%% make_per_tuple(RankType, Data, Rank, Change) when RankType >= ?RANK_T_PERSONAL_BATTLE, RankType =< ?RANK_T_PERSONAL_MONEY ->
%%     make_per_rank_info_tuple(RankType, Data, Rank, Change);
%% make_per_tuple(RankType, Data, Rank, Change) when RankType >= ?RANK_T_PERSONAL_VENATION, RankType =< ?RANK_T_ARENA_LOSS_TOTAL  ->
%%     make_per_arena_info_tuple(RankType, Data, Rank, Change);
%% make_per_tuple(RankType, Data, Rank, Change) ->
%%     make_fc_rank_info_tuple(RankType, Data, Rank, Change).
%% 
%% %% desc: 获取字段
%% get_per_index_field() -> "lv, `exp`, battle_capacity, coin".
%% 
%% %% desc: 查询sql语句
%% % 个人榜
%% get_sql_by_rank_type(Type, Field) when Type >= ?RANK_T_PERSONAL_BATTLE, Type =< ?RANK_T_PERSONAL_MONEY ->
%%     IndexField = get_per_index_field(),
%%     NewField = case Type == ?RANK_T_PERSONAL_LV of
%%                    true -> Field ++ " desc, exp ";
%%                    false -> Field
%%                end,
%%     Data = [IndexField, Field, ?RANK_STARTED_TIME, NewField, ?RANK_PERSONAL_MAX],
%%     [player, io_lib:format(?SQL_SELECT_PER_LIMIT, Data)];
%% % 武将榜
%% get_sql_by_rank_type(Type, Field) when Type >= ?RANK_T_PARTNER_BATTLE, Type =< ?RANK_T_PARTNER_LV ->
%%     NewField = case Type == ?RANK_T_PERSONAL_LV of
%%                    true -> Field ++ " desc, exp ";
%%                    false -> Field
%%                end,
%%     Data = [NewField, Field, ?RANK_PERSONAL_MAX],
%%     [partner, io_lib:format(?SQL_SELECT_PARTNER_LIMIT, Data)];
%% % 鲜花/魅力总榜
%% get_sql_by_rank_type(Type, Field) when Type == ?RANK_T_CHARM_T; Type == ?RANK_T_FLOWER_T ->
%%     Data = [Field, Field, ?RANK_STARTED_TIME, Field, ?RANK_FLOWER_CHARM_MAX],
%%     [rank_flower_charm, io_lib:format(?SQL_SELECT_FLOWER_CHARM_T_LIMIT, Data)];
%% % 鲜花/魅力周榜
%% get_sql_by_rank_type(Type, Field) when Type == ?RANK_T_CHARM_W; Type == ?RANK_T_FLOWER_W ->
%%     Data = [Field, Field, ?RANK_STARTED_TIME, Field, ?RANK_FLOWER_CHARM_MAX],
%%     [rank_flower_charm, io_lib:format(?SQL_SELECT_FLOWER_CHARM_W_LIMIT, Data)];
%% % 魅力日榜
%% get_sql_by_rank_type(Type, Field) when Type == ?RANK_T_CHARM_D ->
%%     Data = [Field, Field, "c_date", util:get_date(), Field, ?RANK_FLOWER_CHARM_MAX],
%%     [rank_flower_charm, io_lib:format(?SQL_SELECT_FLOWER_CHARM_D_LIMIT, Data)];
%% % 鲜花日榜
%% get_sql_by_rank_type(Type, Field) when Type == ?RANK_T_FLOWER_D ->
%%     Data = [Field, Field, "f_date", util:get_date(), Field, ?RANK_FLOWER_CHARM_MAX],
%%     [rank_flower_charm, io_lib:format(?SQL_SELECT_FLOWER_CHARM_D_LIMIT, Data)];
%% % 装备榜
%% get_sql_by_rank_type(Type, _Field) when Type >= ?RANK_T_EQUIP_WEAPON, Type =< ?RANK_T_EQUIP_SPIRIT ->
%%     {GoodsType, SubTypeList} = data_rank:get_type_subtype(Type),
%%     Str = convert_subtype(SubTypeList, []),
%%     Data = [GoodsType, Str, ?RANK_EQUIP_MAX],
%%     [goods, io_lib:format(?SQL_SELECT_EQUIP_T_LIMIT, Data)];
%% 
%% % 个人榜-灵脉/在线
%% get_sql_by_rank_type(Type, Field) when Type =:= ?RANK_T_PERSONAL_VENATION; Type =:= ?RANK_T_PERSONAL_WEEK_TIME ->
%%     Data = [Field, Field, ?RANK_STARTED_TIME, Field, ?RANK_PERSONAL_MAX],
%%     [log_total, io_lib:format(?SQL_SELECT_PER_VENATION_WEEKTIME_ARENA_LIMIT, Data)];
%% % 竞技类
%% get_sql_by_rank_type(Type, Field) when Type >= ?RANK_T_ARENA_WIN_STREAK , Type =< ?RANK_T_ARENA_LOSS_TOTAL ->
%%     Data = [Field, Field, ?RANK_STARTED_TIME, Field, ?RANK_ARENA_COMM_MAX],
%%     [log_total, io_lib:format(?SQL_SELECT_PER_VENATION_WEEKTIME_ARENA_LIMIT, Data)];
%% 
%% get_sql_by_rank_type(_, _) ->
%%     [none, <<>>].
%% 
%% %% desc: 子类型格式转换
%% convert_subtype([], Str) -> Str;
%% convert_subtype([Int | T], Str) ->
%%     NewStr = 
%%         case Str == [] of
%%             true ->  integer_to_list(Int);
%%             false -> integer_to_list(Int) ++ "," ++ Str
%%         end,
%%     convert_subtype(T, NewStr).
%% 
%% %% desc: 返回个人排行信息
%% make_my_rank_infos(Tuple, Type, List) ->
%%     Rank = element(1, Tuple),
%%     {PreName, PreSex} = get_pre_role_data(Rank, List),
%%     {AftName, AftSex} = get_aft_role_data(Rank, List),
%%     {Type,
%%      Rank,
%%      AftName,
%%      AftSex,
%%      PreName,
%%      PreSex,
%%      data_rank:get_title(Type, Rank)}.
%% 
%% %% desc: 查询排行榜前一名信息
%% get_pre_role_data(Rank, List) ->
%%     case Rank > 1 of
%%         false -> {<<>>, 0};
%%         true ->
%%             Tuple = lists:nth(Rank - 1, List),
%%             {element(3, Tuple), element(9, Tuple)}
%%     end.
%% 
%% %% desc: 查询排行榜后一名信息
%% get_aft_role_data(Rank, List) ->
%%     case Rank >= length(List) of
%%         true -> {<<>>, 0};
%%         false ->
%%             Tuple = lists:nth(Rank + 1, List),
%%             {element(3, Tuple), element(9, Tuple)}
%%     end.
%%     
%% %% desc: 个人榜信息
%% make_per_rank_info_tuple(RankType, Data, Rank, Change) ->
%%     [PlayerId, Lv, _Exp, Battle_capacity, Coin, NickName, Sex, Career, GuildName, Vip] = Data,
%%     Val = if
%%               RankType == ?RANK_T_PERSONAL_BATTLE -> Battle_capacity;
%%               RankType == ?RANK_T_PERSONAL_LV -> Lv;
%%               true -> Coin
%%           end,
%%     {
%%      Rank,
%%      PlayerId, 
%%      lib_common:make_sure_binary(NickName), 
%%      Career, 
%%      lib_common:make_sure_binary(GuildName), 
%%      Val,
%%      Change,
%%      data_rank:get_title(RankType, Rank),   % binary 
%%      Sex, 
%%      Vip
%%      }. 
%%     
%% %% desc: 装备榜信息
%% make_equip_rank_info_tuple(Data, Rank, Change) ->
%%     [GoodsId, Score, PlayerId, GoodsTid, Stren] = Data,
%%     [NickName, _GuildName, Sex, Career, Vip] = get_role_base_data_from_db(goods, GoodsId, PlayerId),
%%     EquipName = lib_goods:get_goods_name(GoodsTid),
%%     Color = lib_goods:get_goods_color(GoodsTid),
%%     {
%%      Rank, 
%%      GoodsId,
%%      PlayerId,
%%      lib_common:make_sure_binary(NickName),
%%      Career, 
%%      Score,
%%      Change,
%%      Sex,
%%      Vip,
%%      lib_common:make_sure_binary(EquipName),
%%      Color,
%%      Stren
%%      }.
%%     
%% %% desc: 武将榜信息
%% make_partner_rank_info_tuple(RankType, Data, Rank, Change) ->
%%     [ParId, Lv, _Exp, ParBattle,  PlayerId, ParCareer, ParSex, ParName] = Data,
%%     [NickName, GuildName, _Sex, _Career, Vip] = get_role_base_data_from_db(partner, ParId, PlayerId),
%%     Val = if
%%               RankType == ?RANK_T_PARTNER_BATTLE -> ParBattle;
%%               true -> Lv
%%           end,
%%     {
%%      Rank, 
%%      ParId,
%%      PlayerId,
%%      lib_common:make_sure_binary(NickName),
%%      lib_common:make_sure_binary(GuildName),
%%      Vip,
%%      ParCareer, 
%%      ParSex,
%%      lib_common:make_sure_binary(ParName),
%%      Val,
%%      Change
%%      }.
%%     
%% %% desc: 
%%  make_fc_rank_info_tuple(RankType, Data, Rank, Change) ->
%%     [PlayerId, NickName, Sex, Career, GuildName, Vip, Val] = Data,
%%     {
%%      Rank,
%%      PlayerId, 
%%      lib_common:make_sure_binary(NickName), 
%%      Career, 
%%      lib_common:make_sure_binary(GuildName), 
%%      Val,
%%      Change,
%%      data_rank:get_title(RankType, Rank),   % binary 
%%      Sex, 
%%      Vip
%%      }.
%% 
%% make_per_arena_info_tuple(RankType, Data, Rank, Change) ->
%%     [PlayerId, NickName, Sex, Career, GuildName, Vip, Val] = Data,
%%     {
%%      Rank,
%%      PlayerId, 
%%      lib_common:make_sure_binary(NickName), 
%%      Career, 
%%      lib_common:make_sure_binary(GuildName), 
%%      Val,
%%      Change,
%%      data_rank:get_title(RankType, Rank),   % binary 
%%      Sex, 
%%      Vip
%%      }.
%% 
%% %% desc: 从数据库查询玩家信息
%% get_role_base_data_from_db(Type, Id, PlayerId) ->
%%     case db:select_row(player, "nickname, guild_name, sex, career, vip", [{id, PlayerId}], [], [1]) of
%%         [BinNickName, BinGuildName, Sex, Career, Vip]  ->
%%             [BinNickName, BinGuildName, Sex, Career, Vip];
%%         Error ->
%%             ?ERROR_MSG("failed to select from db:~p, error:~p", [{Type, Id, PlayerId}, Error]), ?ASSERT(false),
%%             [<<>>, <<>>, 0, 0, 0]
%%     end.