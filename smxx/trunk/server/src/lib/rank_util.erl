%%%-------------------------------------- 
%%% @Module: rank_util
%%% @Author:
%%% @Created:
%%% @Description: 
%%%-------------------------------------- 
-module(rank_util).

%% 
%% Including Files
%%

-include("record.hrl").
-include("common.hrl").
-include("rank.hrl").
-include("debug.hrl").

-compile(export_all).

%% 1. External Functions
%% 2. LESS USE External Functions
%% 3. Internal Functions
%% 4. LESS USE Internal Functions
    
%% ---------------------------------------------------------------------
%% External Functions
%% ---------------------------------------------------------------------
%% 
%% %% desc: 刷新排行榜
%% refresh_rank(Type) ->
%%     Field = data_rank:get_field_by_type(Type),
%%     refresh_per_rank(Type, Field).
%% 
%% %% desc: 查询个人榜*战力
%% get_pers_battle_rank() ->
%%     get_rank_list(?RANK_T_PERSONAL_BATTLE).
%% 
%% %% desc: 查询个人榜*等级
%% get_pers_lv_rank() ->
%%     get_rank_list(?RANK_T_PERSONAL_LV).
%% 
%% %% desc: 查询个人榜*财富
%% get_pers_money_rank() ->
%%     get_rank_list(?RANK_T_PERSONAL_MONEY).
%% 
%% %% desc: 查询个人榜:灵脉
%% get_pers_venation_rank() ->
%%     get_rank_list(?RANK_T_PERSONAL_VENATION).
%% 
%% %% desc: 查询个人榜*在线
%% get_pers_weektime_rank() ->
%%     get_rank_list(?RANK_T_PERSONAL_WEEK_TIME).
%% 
%% %% desc: 查询鲜花榜*日榜
%% get_flower_d_rank() ->
%%     get_rank_list(?RANK_T_FLOWER_D).
%% 
%% %% desc: 查询鲜花榜*周榜
%% get_flower_w_rank() ->
%%     get_rank_list(?RANK_T_FLOWER_W).
%%     
%% %% desc: 查询鲜花榜*总榜
%% get_flower_t_rank() ->
%%     get_rank_list(?RANK_T_FLOWER_T).
%% 
%% %% desc: 查询魅力榜*日榜
%% get_charm_d_rank() ->
%%     get_rank_list(?RANK_T_CHARM_D).
%% 
%% %% desc: 查询魅力榜*周榜
%% get_charm_w_rank() ->
%%     get_rank_list(?RANK_T_CHARM_W).
%% 
%% %% desc: 查询魅力榜*总榜
%% get_charm_t_rank() ->
%%     get_rank_list(?RANK_T_CHARM_T).
%% 
%% %% desc: 查询武将榜*战力榜
%% get_partner_battle_rank() ->
%%     get_rank_list(?RANK_T_PARTNER_BATTLE).
%% 
%% %% desc: 查询武将榜*等级榜
%% get_partner_lv_rank() ->
%%     get_rank_list(?RANK_T_PARTNER_LV).
%% 
%% %% desc: 查询装备榜*武器
%% get_equip_weapon_rank() ->
%%     get_rank_list(?RANK_T_EQUIP_WEAPON).
%% 
%% %% desc: 查询装备榜*防具
%% get_equip_clothes_rank() ->
%%     get_rank_list(?RANK_T_EQUIP_CLOTHES).
%% 
%% %% desc: 查询装备榜*饰品
%% get_equip_neck_rank() ->
%%     get_rank_list(?RANK_T_EQUIP_NECK).
%% 
%% %% desc: 查询装备榜*灵器
%% get_equip_spirit_rank() ->
%%     get_rank_list(?RANK_T_EQUIP_SPIRIT).
%% 
%% %% desc: 查询勇士榜
%% get_champion_rank_list() ->
%%     ets:tab2list(?ETS_RANK_CHAMPION).
%% 
%% %% desc: 竞技类:英雄榜
%% get_arena_heroic_rank() ->
%%     List = case mod_arena:query_rank(-1) of
%%         {ok, _TotalCount, ArenaList} ->
%%             ArenaList;
%%         _   ->
%%             []
%%     end,
%% 
%%     FectFun = fun(Arena, L) ->
%%             Info = convert_arena2tuple(Arena),
%%             [Info | L]
%%     end,
%% 
%%     RevList = lists:foldl(FectFun, [], List),
%%     lists:reverse(RevList).
%% 
%% %% desc: 竞技类:连胜榜
%% get_arena_win_streak_rank() ->
%%     get_rank_list(?RANK_T_ARENA_WIN_STREAK).
%% %% desc: 竞技类:连败榜
%% get_arena_loss_streak_rank() ->
%%     get_rank_list(?RANK_T_ARENA_LOSS_STREAK).
%% %% desc: 竞技类:总胜榜
%% get_arena_win_total_rank() ->
%%     get_rank_list(?RANK_T_ARENA_WIN_TOTAL).
%% %% desc: 竞技类:总败榜
%% get_arena_loss_total_rank() ->
%%     get_rank_list(?RANK_T_ARENA_LOSS_TOTAL).
%% 
%% %% desc: 查询自己的榜单信息
%% get_my_rank_list(PS) ->
%%     % 先查询英雄榜
%%     HeroicList = get_my_heroic_info(PS),
%% 
%%     RankTypes = ?RANK_PERSONAL_ALL ++ ?RANK_FC_ALL ++ ?RANK_ARENA_ALL,
%%     {_, RankList} = lists:foldl(fun get_my_rank_info/2, {PS#player_status.id, []}, lists:reverse(RankTypes)),
%%     % RankList.
%%     HeroicList ++ RankList.
%%     
%% %% desc: 查询副本排行榜信息
%% get_dungeon_rank(DungeonId) ->
%%     case lib_common:get_ets_info(?ETS_RANK_DUNGEON, DungeonId) of
%%         {} ->
%%             [];
%%         Info ->
%%             Info#ets_rank_dungeon.list
%%     end.
%% 
%% %% desc: 获取当前时间
%% get_time() ->
%%     {H, M, S} = time(),
%%     H * 10 * 1000 + M * 10 * 10 + S.
%% 
%% %% desc: 计算距离下一个整点的时间(秒为单位)
%% get_now_to_next_hour() ->
%%     3600 - ( 1 + (calendar:time_to_seconds(time()) rem 3600) ).
%% 
%% %% 到下一个3倍数的整点的秒数
%% get_now_to_next_3div_hour() ->
%%     ResTime = get_time() rem (3600 * 3),
%%     case ResTime =:= 0 of
%%         true    -> 3600 * 3;
%%         false   -> ResTime
%%     end.
%% 
%% %% 检查存在该勇士项,以及是否有人达到
%% check_insert_champion(PS, Event, Cond1, Cond2) ->
%%     Record = data_champion:get(Event, Cond1, Cond2),
%%     case Record#champion.id of
%%         0 ->
%%             skip;
%%         _Num ->
%%             case ets:lookup(?ETS_RANK_CHAMPION, Record#champion.id) of
%%                 [_Any] ->
%%                     skip;
%%                 [] ->
%%                     insert_champion(PS, Record)
%%             end
%%     end,
%%     ok.
%% 
%% %% desc: 取得玩家在总次数表数据 
%% get_total_count(PlayerId, Desc) ->
%%    case db:select_row(log_total, atom_to_list(Desc), [{player_id,PlayerId}]) of
%%         [Cnt] -> Cnt;
%%         _ -> 0
%%     end.
%% 
%% %% desc: 更新个人灵脉
%% update_personl_venation(PS) ->
%%     PlayerId = PS#player_status.id,
%%     check_or_create_table_log_total(PlayerId,
%%         PS#player_status.nickname,
%%         PS#player_status.sex,
%%         PS#player_status.career,
%%         PS#player_status.guild_name,
%%         PS#player_status.vip),
%%     db:update(log_total, [{venation, 1, add}], [{player_id,PlayerId}]).
%% 
%% %% desc: 更新竞技胜利玩家
%% update_arena_win(Arena) ->
%%     PlayerId = Arena#arena.id,
%%     Rank = Arena#arena.rank,
%%     check_or_create_table_log_total(PlayerId,
%%         Arena#arena.name,
%%         Arena#arena.sex,
%%         Arena#arena.career,
%%         Arena#arena.guild_name,
%%         Arena#arena.vip),
%%     db:update(log_total, [{cur_arena_win_streak, 1, add}, {arena_win_total, 1, add}, {cur_arena_loss_streak, 0}, {arena_rank, Rank}], [{player_id, PlayerId}]),
%% 
%%     db:update(log_total, io_lib:format("update log_total set arena_win_streak = cur_arena_win_streak where player_id = ~p and cur_arena_win_streak > arena_win_streak", [PlayerId])).
%% 
%% %% desc: 更新竞技失败玩家
%% update_arena_loss(Arena) ->
%%     PlayerId = Arena#arena.id,
%%     Rank = Arena#arena.rank,
%%     check_or_create_table_log_total(PlayerId,
%%         Arena#arena.name,
%%         Arena#arena.sex,
%%         Arena#arena.career,
%%         Arena#arena.guild_name,
%%         Arena#arena.vip),
%%     db:update(log_total, [{cur_arena_loss_streak, 1, add}, {arena_loss_total, 1, add}, {cur_arena_win_streak, 0}, {arena_rank, Rank}], [{player_id, PlayerId}]),
%% 
%%     db:update(log_total, io_lib:format("update log_total set arena_loss_streak = cur_arena_loss_streak where player_id = ~p and cur_arena_loss_streak > arena_loss_streak", [PlayerId])).
%% 
%% %% desc: 更新在线时间
%% update_personal_weektime(PS) ->
%%     PlayerId = PS#player_status.id,
%%     LastLoginTime = PS#player_status.last_login_time - 5,
%% 
%%     check_or_create_table_log_total(PlayerId,
%%         PS#player_status.nickname,
%%         PS#player_status.sex,
%%         PS#player_status.career,
%%         PS#player_status.guild_name,
%%         PS#player_status.vip),
%%     [TS] = db:select_row(log_total, "logout_time", [{player_id, PlayerId}]),
%% 
%%     {Date, _Time} = calendar:seconds_to_daystime(TS),
%%     case check_in_same_week(Date) of
%%         true ->
%%             db:update(log_total, [{"week_time", util:unixtime() - LastLoginTime, add}, {"logout_time", util:unixtime()}],
%%                 [{player_id, PlayerId}]);
%%         false ->
%%             db:update(log_total, [{"week_time", util:unixtime() - LastLoginTime}, {"logout_time", util:unixtime()}],
%%                 [{player_id, PlayerId}])
%%     end.
%% 
%% update_be_wanted(PS) ->
%%     PlayerId = PS#player_status.id,
%% 
%%     check_or_create_table_log_total(PlayerId,
%%         PS#player_status.nickname,
%%         PS#player_status.sex,
%%         PS#player_status.career,
%%         PS#player_status.guild_name,
%%         PS#player_status.vip),
%%     db:update(log_total, [{be_wanted, 1, add}], [{player_id, PlayerId}]).
%% 
%% %% desc: 检测次数表或者建表
%% check_or_create_table_log_total(PlayerId, NickName, Sex, Career, GuildName, Vip) ->
%%     case db:select_row(log_total, "player_id", [{player_id, PlayerId}]) of
%%         [_Id] ->
%%             skip;
%%         [] ->
%%             db:insert(log_total, ["player_id", "nickname", "sex", "career", "guild_name", "vip", "logout_time"],
%%                 [PlayerId, NickName, Sex, Career, GuildName, Vip, util:unixtime()])
%%     end.
%% 
%% check_update_rank_dungeon(PS, DungeonId, Time) ->
%%     DungeonList = data_chaos:get_rank_dungeon(),
%%     case true =:= lists:member(DungeonId, DungeonList) andalso Time < get_pass_times(PS, DungeonId) of
%%         false ->
%%             skip;
%%         true ->
%%             db:update(rank_dungeon, [{"pass_times", Time}, {"create_time", util:unixtime()}],
%%                 [{player_id, PS#player_status.id}, {dungeon_id, DungeonId}])
%%     end.
%% 
%% get_pass_times(PS, DungeonId) ->
%%     case db:select_row(rank_dungeon, "pass_times", [{player_id, PS#player_status.id}, {dungeon_id, DungeonId}]) of
%%         [PassTimes] ->
%%             PassTimes;
%%         [] ->
%%             db:insert(rank_dungeon, ["player_id", "dungeon_id", "nickname", "sex", "career", "guild_name", "vip", "create_time"],
%%                 [PS#player_status.id, DungeonId, PS#player_status.nickname, PS#player_status.sex, PS#player_status.career,
%%                     PS#player_status.guild_name, PS#player_status.vip, util:unixtime()]),
%%             16#ffffffff
%%     end.
%% 
%% refresh_dungeon_rank(DungeonId) ->
%%     Sql = io_lib:format("select player_id, nickname, sex, career, vip, guild_name, pass_times from `rank_dungeon`"
%%         " where dungeon_id = ~p and pass_times > 0 and (logout_time > ~p or logout_time = 0) ORDER BY pass_times LIMIT ~p",
%%         [DungeonId, ?RANK_STARTED_TIME, ?RANK_DUNGEON_MAX]),
%%     case db:select_all(rank_dungeon, Sql) of
%%         List when is_list(List) ->
%%             RankList = handle_dungeon_ranklist(DungeonId, List),
%%             Info = #ets_rank_dungeon{id = DungeonId, list = lists:sort(RankList)},
%%             ets:insert(?ETS_RANK_DUNGEON, Info);
%%         Error ->
%%             ?ERROR_MSG("refresh_dungeon_rank failed:~p", [Error])
%%     end.
%% 
%% get_1st_role_battle() ->
%%     List = case lib_common:get_ets_info(?ETS_RANK_TOTAL, ?RANK_T_PERSONAL_BATTLE) of
%%         {} ->
%%             [];
%%         Info ->
%%             Info#ets_rank_total.rank_list
%%     end,
%%     case List =/= [] of
%%         false ->
%%             0;
%%         true ->
%%             {_Rank, _PlayerId, _NickName, _Carrer, _GuildName, Battle, _Change, _Title, _Sex, _Vip} = lists:nth(1, List),
%%             Battle
%%     end.
%% 
%% %% ---------------------------------------------------------------------
%% %% LESS USE External Functions
%% %% ---------------------------------------------------------------------
%% 
%% %% desc: 更新送花记录
%% update_flower_send(PS, FlowerNum) ->
%%     case has_flower_charm_data(PS#player_status.id) of
%%         true ->      update_send_data(PS#player_status.id, FlowerNum);
%%         false ->     insert_send_data(PS, FlowerNum)
%%     end.
%% 
%% %% desc: 更新收花记录
%% update_flower_receive(PS, AddCharm) ->
%%     case has_flower_charm_data(PS#player_status.id) of
%%         true ->      update_receive_data(PS#player_status.id, AddCharm);
%%         false ->     insert_receive_data(PS, AddCharm)
%%     end.
%% 
%% %% desc: 竞技数据转化为排行榜数据
%% convert_arena2tuple(Arena) ->
%%     {
%%         Arena#arena.rank,
%%         Arena#arena.id,
%%         lib_common:make_sure_binary(Arena#arena.name),
%%         Arena#arena.career,
%%         lib_common:make_sure_binary(Arena#arena.guild_name),
%%         lib_arena:get_grade(Arena#arena.rank),
%%         0,  % 不显示波动
%%         lib_common:make_sure_binary(lib_arena:get_title(Arena#arena.rank)),
%%         Arena#arena.sex,
%%         0  % Vip
%%     }.
%% 
%% %% desc: 查询自己的英雄榜信息
%% get_my_heroic_info(PS) ->
%%     case mod_arena:query_arena_info(PS) of
%%         {ok, RetArInfo} ->
%%             [{
%%                     ?RANK_T_ARENA_HEROIC,
%%                     RetArInfo#arena.rank,
%%                     <<"">>,
%%                     1,
%%                     <<"">>,
%%                     1,
%%                     0
%%                 }];
%%         _   ->
%%             []
%%     end.
%%     
%% %% desc: 查询自己的排行榜信息
%% get_my_rank_info(Type, {PlayerId, List}) ->
%%     case get_rank_list(Type) of
%%         {} ->       {PlayerId, List};
%%         RankList ->
%%             case lists:keyfind(PlayerId, 2, RankList) of
%%                 false ->       {PlayerId, List};
%%                 Tuple ->
%%                     NewInfo = lib_rank:make_my_rank_infos(Tuple, Type, RankList),
%%                     {PlayerId, [NewInfo | List]}
%%             end
%%     end.
%% 
%% %% ---------------------------------------------------------------------
%% %% Internal Functions
%% %% ---------------------------------------------------------------------
%% 
%% %% desc: 刷新个人榜
%% refresh_per_rank(RankType, []) ->
%%     ?ERROR_MSG("refresh_per_rank failed:~p", [RankType]);
%% refresh_per_rank(RankType, Field) ->
%%     case lib_rank:get_sql_by_rank_type(RankType, Field) of
%%         [none, <<>>] -> skip;
%%         [Table, SQL] ->
%%             case db:select_all(Table, SQL) of
%%                 List when is_list(List) ->
%%                     RankList = handle_pers_ranklist(RankType, List),
%%                     Info = #ets_rank_total{type = RankType, rank_list = lists:sort(RankList)},
%%                     ets:insert(?ETS_RANK_TOTAL, Info);
%%                 Error ->
%%                     ?ERROR_MSG("refresh_per_rank failed:~p", [Error]),
%%                     ?ASSERT(false)
%%             end
%%     end.
%%     
%% %% desc: 根据类型查询排行榜信息
%% get_rank_list(Type) ->
%%     case lib_common:get_ets_info(?ETS_RANK_TOTAL, Type) of
%%         {} -> [];
%%         Info -> Info#ets_rank_total.rank_list
%%     end.
%% 
%% %% ---------------------------------------------------------------------
%% %% LESS USE Internal Functions
%% %% ---------------------------------------------------------------------
%%     
%% %% desc: 更新排行榜
%% handle_pers_ranklist(RankType, List) ->
%%     F = fun(Data, {ResList, Rank, OldList}) ->
%%                 Change = lib_rank:calc_rank_change(Data, OldList, Rank),
%%                 Tuple = lib_rank:make_per_tuple(RankType, Data, Rank, Change),
%%                 {[Tuple | ResList], Rank + 1, OldList}
%%         end,
%%     InitTuple = {[], 1, get_rank_list(RankType)},
%%     {ResultRank, _, _} = lists:foldl(F, InitTuple, List),
%%     ResultRank.
%% 
%% %% desc: 检测是否鲜花榜已有数据
%% has_flower_charm_data(PlayerId) ->
%%     case db:select_row(rank_flower_charm, "player_id", [{player_id,PlayerId}]) of
%%         [_Id] -> true;
%%         _ -> false
%%     end.
%% 
%% %% desc: 判断同天
%% check_in_same_day(Date) ->
%%     util:get_date() =:= Date.
%% %% desc: 判断同周
%% check_in_same_week(Date) ->
%%     {Y, M, D} = erlang:date(),
%%     Week      = calendar:day_of_the_week(Y, M, D),
%% 
%%     CurDates = calendar:date_to_gregorian_days(Y, M, D) - calendar:date_to_gregorian_days(1970,1,1),
%%     WeekStart = CurDates - Week + 1,
%%     Date >= WeekStart.
%% 
%% get_d_w_expr(PlayerId, Num, DNum, WNum, Date) ->
%%     LastDate = case db:select_row(rank_flower_charm,
%%             atom_to_list(Date),
%%             [{player_id,PlayerId}]) of
%%         [LastDate1] -> LastDate1;
%%         _           -> 0
%%     end,
%% 
%%     DExpr = case
%%         check_in_same_day(LastDate)
%%         of
%%         true    -> {DNum, Num, add};
%%         _       -> {DNum, Num}
%%     end,
%% 
%%     LYear   = LastDate div 10000,
%%     LMonth  = LastDate rem 10000 div 100,
%%     LDay    = LastDate rem 10000 rem 100,
%% 
%%     LastDates = case calendar:valid_date(LYear,LMonth, LDay) of
%%         false ->
%%             0;
%%         true ->
%%             calendar:date_to_gregorian_days(LYear, LMonth, LDay)
%%     end,
%% 
%%     WExpr = case check_in_same_week(LastDates) of
%%         true    -> {WNum, Num, add};
%%         _       -> {WNum, Num}
%%     end,
%%     {DExpr, WExpr}.
%% 
%% %% desc: 更新送花数量
%% update_send_data(PlayerId, Num) ->
%%     {DExpr, WExpr} = get_d_w_expr(PlayerId, Num, fd_num, fw_num, f_date),
%%     db:update(rank_flower_charm, [DExpr, WExpr, {ft_num, Num, add}, {f_date,util:get_date()}], [{player_id,PlayerId}]).
%% 
%% %% desc: 更新收花数量
%% update_receive_data(PlayerId, Num) ->
%%     {DExpr, WExpr} = get_d_w_expr(PlayerId, Num, cd_num, cw_num, c_date),
%%     db:update(rank_flower_charm, [DExpr, WExpr, {ct_num, Num, add}, {c_date,util:get_date()}], [{player_id,PlayerId}]).
%% 
%% %% desc:
%% insert_send_data(PS, Num) ->
%%     Fields = ["player_id", "nickname", "sex", "career", "guild_name", "vip", "fd_num", "fw_num", "ft_num", "f_date"],
%%     Data = [PS#player_status.id, PS#player_status.nickname, PS#player_status.sex, PS#player_status.career, PS#player_status.guild_name, PS#player_status.vip, Num, Num, Num, util:get_date()],
%% 
%% 	db:insert(rank_flower_charm, Fields, Data).
%% %% desc:
%% insert_receive_data(PS, Num) ->
%%     Fields = ["player_id", "nickname", "sex", "career", "guild_name", "vip", "cd_num", "cw_num", "ct_num", "c_date"],
%%     Data = [PS#player_status.id, PS#player_status.nickname, PS#player_status.sex, PS#player_status.career, PS#player_status.guild_name, PS#player_status.vip, Num, Num, Num, util:get_date()],
%% 
%% 	db:insert(rank_flower_charm, Fields, Data).
%% 
%% 
%% %% desc: 插入勇士榜
%% insert_champion(PS, Champion) ->
%%     Info = #ets_rank_champion{
%%                               id          = Champion#champion.id,
%%                               player_id   = PS#player_status.id,
%%                               nickname    = PS#player_status.nickname,
%%                               guild_name  = PS#player_status.guild_name,
%%                               career      = PS#player_status.career,
%%                               sex         = PS#player_status.sex,
%%                               vip         = PS#player_status.vip,
%%                               create_time = util:get_date()
%%                              },
%%     ets:insert(?ETS_RANK_CHAMPION, Info),
%%     
%%     % 发邮件
%%     {GoodsId, GoodsNum} = case Champion#champion.award of
%%                               [] ->
%%                                   {0, 0};
%%                               [{GI, GN} | _] ->
%%                                   {GI, GN}
%%                           end,
%%     Content = 
%%         "恭喜您获得" ++
%%             erlang:binary_to_list(Champion#champion.name) ++
%%             "荣誉,获得" ++
%%             lib_goods:get_goods_name(GoodsId) ++
%%             "奖励",
%%     
%%     lib_mail:send_sys_mail_id_by_base_goods_id([PS#player_status.id],
%%                                             "系统",
%%                                             Content,
%%                                             GoodsId,
%%                                             GoodsNum,
%%                                             0,
%%                                             0,
%%                                             0),
%%     
%%     % goods_util:send_goods_and_money_by_mail(Champion#champion.award, [PS#player_status.id], "勇士榜奖励", "binggo"),
%%     
%%     Fields = ["champion_id", "player_id", "nickname", "guild_name", "career", "sex", "vip", "create_time"],
%%     Data = [Champion#champion.id, PS#player_status.id, PS#player_status.nickname, PS#player_status.guild_name,
%%             PS#player_status.career, PS#player_status.sex, PS#player_status.vip,  util:get_date()],
%%     db:insert(rank_champion, Fields, Data).
%% 	
%% %% 副本排行榜
%% handle_dungeon_ranklist(DungeonId, List) ->
%%     FunCalc = fun(Data, {ResList, Rank, OldList}) ->
%%             Change = lib_rank:calc_rank_change(Data, OldList, Rank),
%%             Tuple = make_dungeon_tuple(Data, Rank, Change),
%%             {[Tuple | ResList], Rank + 1, OldList}
%%     end,
%% 
%%     OldList = case lib_common:get_ets_info(?ETS_RANK_DUNGEON, DungeonId) of
%%         {} ->
%%             [];
%%         Info ->
%%             Info#ets_rank_dungeon.list
%%     end,
%%     {ResultRank, _, _} = lists:foldl(FunCalc, {[], 1, OldList}, List),
%%     ResultRank.
%% 
%% make_dungeon_tuple(Data, Rank, Change) ->
%%     [PlayerId, NickName, Sex, Career, Vip, GuildName, Val] = Data,
%%     {
%%         Rank,
%%         PlayerId,
%%         lib_common:make_sure_binary(NickName),
%%         Sex,
%%         Career,
%%         Vip,
%%         lib_common:make_sure_binary(GuildName),
%%         Val,
%%         Change
%%     }.