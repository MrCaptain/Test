%%%------------------------------------
%%% @Module     : mod_rank
%%% @Author     : 
%%% @Email      : 
%%% @Created    :
%%% @Description: 排行榜
%%%------------------------------------
-module(mod_rank). 
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, code_change/3, terminate/2]).

-compile(export_all).

-include("common.hrl").
-include("record.hrl").
-include("rank.hrl").
-include("goods.hrl").


%%%------------------------------------
%%%             接口函数
%%%------------------------------------

start_link() ->      %% 启动服务
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

s() ->
    gen_server:cast(?MODULE, 'START_RANK_LOG').

%%%------------------------------------
%%%             回调函数
%%%------------------------------------

init(_) ->
    process_flag(trap_exit, true),
%%     % 创建ets表
%%     create_rank_ets(),
%%     % 加载勇士榜
%%     load_rank_champion(),
%%     % 刷新榜单
%%     do_init_rank_data(),
%%     % 开启定时器
%%     timer_start(),
%%     % 开启日志定时器
%%     start_rank_log_timer(),
    {ok, []}.

%% %% desc: 刷新鲜花/魅力榜信息(每隔3个小时)
%% handle_info('REFRESH_FC_RANK', State) ->
%%     % NexTime = rank_util:get_now_to_next_hour() + 2 * 3600,
%%     NexTime = rank_util:get_now_to_next_3div_hour(),
%%     erlang:send_after((NexTime + 60) * 1000, self(), 'REFRESH_FC_RANK'),   % 每3小时执行一次,延迟1分钟
%%     lists:foreach(fun rank_util:refresh_rank/1, ?RANK_FC_ALL),
%%     {noreply, State};
%% 
%% %% desc: 刷新排行榜榜信息(每天刷新2次)
%% handle_info('REFRESH_RANK', State) ->
%%     NexTime = rank_util:get_now_to_next_hour(),
%%     erlang:send_after((NexTime + 60) * 1000, self(), 'REFRESH_RANK'),    % 延迟1分钟
%%     {H, _, _} = time(),
%%     if
%%         H =:= 12 ->
%%             lists:foreach(fun rank_util:refresh_rank/1, ?RANK_ARENA_ALL),   % 刷新竞技
%%             lists:foreach(fun rank_util:refresh_rank/1, ?RANK_PARTNER_ALL), % 刷新武将榜
%%             lists:foreach(fun rank_util:refresh_rank/1, ?RANK_PERSONAL_ALL);% 刷新个人榜
%%         H =:= 14 ->
%%             lists:foreach(fun rank_util:refresh_rank/1, ?RANK_EQUIP_ALL);   % 刷新装备榜
%%         H =:= 18 ->
%%             lists:foreach(fun rank_util:refresh_rank/1, ?RANK_PERSONAL_ALL);% 刷新个人榜
%%         H =:= 22 ->
%%             lists:foreach(fun rank_util:refresh_rank/1, ?RANK_ARENA_ALL),   % 刷新竞技
%%             lists:foreach(fun rank_util:refresh_rank/1, ?RANK_PARTNER_ALL); % 刷新武将榜
%%         H =:= 24 ->
%%             lists:foreach(fun rank_util:refresh_rank/1, ?RANK_EQUIP_ALL);   % 刷新装备榜
%%         H =:= 1 ->  % 刷新
%%             DungeonList = data_chaos:get_rank_dungeon(),
%%             lists:foreach(fun rank_util:refresh_dungeon_rank/1, DungeonList),
%% 			% 刷新竞技场第一
%%            	lib_title:refresh_arena(),
%%             % 刷新个人战力排行榜
%%             lib_title:refresh_fighting(),
%%             % 刷新个人等级排行榜
%%             lib_title:refresh_level(),
%% 		    % 刷新个人个人财富排行榜
%%             lib_title:refresh_riches();
%%         true ->
%%             skip
%%     end,
%%     {noreply, State};
%% 
%% %% desc: 开启日志记录
%% handle_info('START_RANK_LOG', State) ->
%% 	erlang:send_after(24 * 60 * 60 * 1000, self(), 'START_RANK_LOG'),
%%     Self = self(),
%%     Fun = fun(Num) -> Self ! {'WRITE_RANK_LOG', Num} end,
%%     lists:foreach(Fun, ?RANK_PERSONAL_ALL ++ [?RANK_T_FLOWER_D, ?RANK_T_CHARM_D]),
%%     {noreply, State};
%% 
%% %% desc: 排行榜日志记录
%% handle_info({'WRITE_RANK_LOG', Type}, State) ->
%%     Time = rank_util:get_time(),
%%     Date = util:get_date(),
%%     DataList = rank_util:get_rank_list(Type),
%%     WeekDay = calendar:day_of_the_week(date()),
%% 	lib_common:actin_new_proc(db, bg_replace, 
%% 							  [
%% 							   log_rank, 
%% 							   [{type, Type}, {weekday, WeekDay}, {time, Time}, {date, Date}, {content, util:term_to_string(DataList)}]
%% 							   ]),
%% %%     db:bg_replace(log_rank, [{type, Type}, {weekday, WeekDay}, {time, Time}, {date, Date}, {content, util:term_to_string(DataList)}]),
%%     {noreply, State};

%% desc: 错误处理
handle_info(_Msg, State) ->
    {noreply, State}.

%% handle_call(top_player_lv, _From, StateData) ->
%%     Res0 = lib_common:get_ets_info(?ETS_RANK_TOTAL, ?RANK_T_PERSONAL_LV),
%% 
%%     Lv0 = case Res0 =/= {} andalso Res0#ets_rank_total.rank_list =/= [] of
%%         true    ->
%%             [{_Rank, _PlayerId, _NickName, _Carrer, _GuildName, Lv, _Change, _Title, _Sex, _Vip} | _] = Res0#ets_rank_total.rank_list,
%%             Lv;
%%         false   ->
%%             case db:select_row(player, "SELECT MAX(lv) FROM player") of
%%                 [Lv]    -> Lv;
%%                 _       -> 0
%%             end
%%     end,
%% 
%%     {reply, Lv0, StateData};

handle_call(_Event, _From, StateData) ->
    {reply, ok, StateData}.

%% handle_cast({event_guild_level, GuildInfo}, StateData) ->
%%     event_guild_level(GuildInfo),
%%     {noreply, StateData};
%% handle_cast({event_arena, PS, Tag, ChallengerAr, PassiveAr}, StateData) ->
%%     event_arena(PS, Tag, ChallengerAr, PassiveAr),
%%     {noreply, StateData};
%% handle_cast({event_be_wanted, PlayerId}, StateData) ->
%%     event_be_wanted(PlayerId),
%%     {noreply, StateData};
handle_cast(_Event, StateData) ->
    {noreply, StateData}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

terminate(_Any, _Opts) ->
    ok.

%% %% desc: 创建ets表
%% create_rank_ets() ->
%%     ets:new(?ETS_RANK_DUNGEON, [named_table, public, set, {keypos, #ets_rank_dungeon.id}]),
%%     ets:new(?ETS_RANK_CHAMPION, [named_table, public, set, {keypos, #ets_rank_champion.id}]),
%%     ets:new(?ETS_RANK_TOTAL, [named_table, public, set, {keypos, #ets_rank_total.type}]),
%% 	
%% 	ets:new(?ETS_OFFLINE_RANKTITLE, [named_table, public, set, {keypos, #ets_offline_ranktitle.player_id}]).
%% 
%% %% 加载勇士榜
%% load_rank_champion() ->
%%     F = fun([Id, PlayerId, NickName, GuildName, Career, Sex, Vip, CreateTime]) ->
%%             case lists:member(Id, data_champion:list()) of
%%                 true    -> ets:insert(?ETS_RANK_CHAMPION, #ets_rank_champion{id = Id, player_id = PlayerId,
%%                             nickname = NickName, guild_name = GuildName, career = Career, sex = Sex, vip = Vip, create_time = CreateTime});
%%                 false   -> skip
%%             end
%%         end,
%%     case db:select_all(rank_champion, "champion_id, player_id, nickname, guild_name, career, sex, vip, create_time", []) of
%%         RuleList when is_list(RuleList) ->   lists:foreach(F, RuleList);
%%         _ ->                                   skip
%%     end,
%%     ok.
%%     
%% %% desc: 刷新榜单数据
%% do_init_rank_data() -> 
%%     DungeonList = data_chaos:get_rank_dungeon(),
%%     lists:foreach(fun rank_util:refresh_dungeon_rank/1, DungeonList),
%% 
%%     RankTypes = ?RANK_PERSONAL_ALL
%%     ++ ?RANK_PARTNER_ALL
%%     ++ ?RANK_EQUIP_ALL
%%     ++ ?RANK_ARENA_ALL,
%%     lists:foreach(fun rank_util:refresh_rank/1, RankTypes).
%%     
%% %% desc: 开启定时器
%% timer_start() -> 
%%     self() ! 'REFRESH_RANK',
%%     self() ! 'REFRESH_FC_RANK'.
%%     
%% %% desc: 排行榜日志记录启动
%% start_rank_log_timer() ->
%%     Self = self(),
%%     {H, _, _} = time(),
%%     Cur = calendar:time_to_seconds(time()),
%%     Time = case H >= 18 of
%%                false -> 
%%                    Diff = 18 * 60 * 60 - Cur,
%%                    1000 * (Diff + 120); % 延迟120秒， 保证排行榜是全部更新了的
%%                true ->
%%                    Diff = (18+24) * 60 * 60 - Cur,
%%                    1000 * (Diff + 120) % 延迟120秒， 保证排行榜是全部更新了的
%%                end,
%%     erlang:send_after(Time, Self, 'START_RANK_LOG').
%%     
%%     
%%     
%% %%
%% %% Extra Functions
%% %%
%% 
%% %% desc: 改变玩家鲜花/魅力榜的帮会名
%% change_role_fc_guildname(PS) ->
%%     change_role_fc_guildname(PS#player_status.id, PS#player_status.guild_name).
%% change_role_fc_guildname(RoleId, GuildName) ->
%%     db:update(rank_dungeon, ["guild_name"], [lib_common:make_sure_list(GuildName)], "player_id", RoleId),
%%     db:update(log_total, ["guild_name"], [lib_common:make_sure_list(GuildName)], "player_id", RoleId),
%%     db:update(rank_champion, ["guild_name"], [lib_common:make_sure_list(GuildName)], "player_id", RoleId),
%%     db:update(rank_flower_charm, ["guild_name"], [lib_common:make_sure_list(GuildName)], "player_id", RoleId).
%% 
%% %% desc: 改变玩家鲜花/魅力榜的vip状态
%% change_role_fc_vip(PS) ->
%%     change_role_fc_vip(PS#player_status.id, PS#player_status.vip).
%% change_role_fc_vip(RoleId, Vip) ->
%%     db:update(rank_dungeon, ["vip"], [Vip], "player_id", RoleId),
%%     db:update(log_total, ["vip"], [Vip], "player_id", RoleId),
%%     db:update(rank_champion, ["vip"], [Vip], "player_id", RoleId),    
%%     db:update(rank_flower_charm, ["vip"], [Vip], "player_id", RoleId).
%% 
%% %% desc: 更新送花数据库记录
%% record_flower_charm(PS, FlowerNum, RoleS, AddCharm) ->
%%     rank_util:update_flower_send(PS, FlowerNum),
%%     rank_util:update_flower_receive(RoleS, AddCharm).
%%     
%% 
%% % 玩家最高等级
%% top_player_lv() ->
%%     case catch gen_server:call({global, ?MODULE}, top_player_lv) of
%%         {'EXIT', _}     -> 0;
%%         Lv              -> Lv
%%     end.
%% 
%% %% desc: 人物升级
%% event_role_level(PS) ->
%%     rank_util:check_insert_champion(PS, ?EVENT_ROLE_LEVEL, PS#player_status.lv, 0).
%% 
%% %% desc: 公会升级
%% event_guild_level(Guild) ->
%%     case mod_arena:get_player(Guild#ets_guild.chief_id) of
%%         null ->
%%             skip;
%%         PS ->
%%             rank_util:check_insert_champion(PS, ?EVENT_GUILD_LEVEL, Guild#ets_guild.guild_level, 0)
%%     end,
%%     ok.
%% 
%% %% desc: 灵脉升级
%% event_venation_level(PS, Type, Lv) ->
%%     rank_util:update_personl_venation(PS),
%%     case tool:to_integer(Type) of
%%         1 ->
%%             rank_util:check_insert_champion(PS, ?EVENT_VENATION_LEVEL, Lv, 0);
%%         _Num ->
%%             skip
%%     end,
%%     ok.
%% 
%% %% desc: 招募武将
%% event_partner_color(PS, ParInfo) ->
%%     rank_util:check_insert_champion(PS, ?EVENT_PARTNER_COLOR, ParInfo#ets_partner.quality, 0).
%% 
%% %% desc: 武将升级
%% event_partner_level(PS, ParInfo) ->
%%     rank_util:check_insert_champion(PS, ?EVENT_PARTNER_LEVEL, ParInfo#ets_partner.lv, 0).
%% 
%% %% desc: 杀死世界BOSS
%% event_worldboss(PS, Lv) ->
%%     rank_util:check_insert_champion(PS, ?EVENT_WORLDBOSS, Lv, 0).
%% 
%% %% desc: 爬塔
%% event_tower(PS, Floor) ->
%%     rank_util:check_insert_champion(PS, ?EVENT_TOWER, Floor, 0).
%% 
%% %% desc: 通关精英副本
%% event_dungeon(PS, DungeonId, Time) ->
%%     rank_util:check_update_rank_dungeon(PS, DungeonId, Time),
%%     rank_util:check_insert_champion(PS, ?EVENT_DUNGEON, DungeonId, 0).
%% 
%% %% desc: 竞技场胜利
%% event_arena(PS, win, ChallengerAr, PassiveAr) ->
%%     rank_util:update_arena_win(ChallengerAr),
%%     rank_util:update_arena_loss(PassiveAr),
%% 
%%     Count = rank_util:get_total_count(ChallengerAr#arena.id, arena_win_total),
%%     rank_util:check_insert_champion(PS, ?EVENT_ARENA, Count, 0);
%% %% desc: 竞技场失败
%% event_arena(_PS, lose, ChallengerAr, _PassiveAr) ->
%%     rank_util:update_arena_loss(ChallengerAr).
%% 
%% %% desc: 定时更新在线时间
%% event_update_online_times(PS) ->
%%     rank_util:update_personal_weektime(PS).
%% 
%% %% 保存/退出事件
%% event_logout(PS) ->
%%     db:update(rank_dungeon, ["logout_time"], [util:unixtime()], "player_id", PS#player_status.id),
%%     db:update(log_total, ["logout_time"], [util:unixtime()], "player_id", PS#player_status.id),
%%     db:update(rank_flower_charm, ["logout_time"], [util:unixtime()], "player_id", PS#player_status.id).
%% 
%% %% desc: 被通缉记录
%% event_be_wanted(PlayerId) ->
%%     case mod_arena:get_player(PlayerId) of
%%         null ->
%%             skip;
%%         PS ->
%%             rank_util:update_be_wanted(PS),
%%             Count = rank_util:get_total_count(PS#player_status.id, be_wanted),
%%             rank_util:check_insert_champion(PS, ?EVENT_BE_WANTED, Count, 0)
%%     end,
%%     ok.
%% 
%% %% desc: 获得套装
%% event_equips_suit(PS, GoodsInfo) ->
%%     Fun = fun(Data, {Cnt, Color, SuitId}) ->
%%                   if
%%                       % 非装备或不同品质
%%                       Data#goods.subtype > ?EQUIP_POS_SHOES orelse Data#goods.color =/= Color
%%                         orelse Data#goods.suit_id =:= 0 orelse Data#goods.suit_id =/= SuitId ->
%%                           {Cnt, Color, SuitId};
%%                       true ->
%%                           {1 + Cnt, Color, SuitId}
%%                   end
%%           end,
%%     
%%     if
%%         ?LOCATION_PLAYER =/= GoodsInfo#goods.location orelse ?GOODS_T_EQUIP =/= GoodsInfo#goods.type ->
%%             skip;
%%         true ->
%%             GoodsList = goods_util:get_goods_list(PS, ?LOCATION_PLAYER),
%%             {Count, _, _} = lists:foldl(Fun, {0, GoodsInfo#goods.color, GoodsInfo#goods.suit_id}, GoodsList),
%%             if
%%                 ?EQUIP_POS_SHOES > Count ->
%%                     skip;
%%                 true ->
%%                     rank_util:check_insert_champion(PS, ?EVENT_EQUIPS_SUIT, GoodsInfo#goods.level, GoodsInfo#goods.color)
%%             end
%%     end,
%%     ok.
%% 
%% %% desc: 装备强化
%% event_equips_prompt(PS, GoodsInfo) ->
%%     if
%%         ?LOCATION_PLAYER =/= GoodsInfo#goods.location orelse ?GOODS_T_EQUIP =/= GoodsInfo#goods.type ->
%%             skip;
%%         true ->
%%             if
%%                 ?EQUIP_T_WEAPON =:= GoodsInfo#goods.subtype ->
%% 					lib_achievement:do(weapon_stren, GoodsInfo#goods.stren, 1, PS),
%%                     rank_util:check_insert_champion(PS, ?EVENT_EQUIPS_PROMPT, 1, GoodsInfo#goods.stren);
%%                 true ->
%%                     rank_util:check_insert_champion(PS, ?EVENT_EQUIPS_PROMPT, 0, GoodsInfo#goods.stren)
%%             end
%%     end,
%%     ok.
%% 
%% %% desc: 装备全身强化
%% event_equips_prompt_full(PS, GoodsInfo) ->
%%     FunLv = fun(Data, {Cnt, Id, MinLv}) ->
%%                   if
%%                       % 非装备
%%                       Data#goods.subtype > ?EQUIP_POS_SHOES orelse Data#goods.id =:= Id ->
%%                           {Cnt, Id, MinLv};
%%                       Data#goods.stren > MinLv ->
%%                           {1 + Cnt, Id, MinLv};
%%                       true ->
%%                           {1 + Cnt, Id, Data#goods.stren}
%%                   end
%%           end,
%%     
%%     if
%%         ?LOCATION_PLAYER =/= GoodsInfo#goods.location orelse ?GOODS_T_EQUIP =/= GoodsInfo#goods.type ->
%%             skip;
%%         true ->
%%             GoodsList = goods_util:get_goods_list(PS, ?LOCATION_PLAYER),
%%             {Count, _, StrenLv} = lists:foldl(FunLv, {1, GoodsInfo#goods.id, GoodsInfo#goods.stren}, GoodsList),
%%             if
%%                 ?EQUIP_POS_SHOES > Count ->
%%                     skip;
%%                 true ->
%% 					lib_achievement:do(all_stren, StrenLv, 1, PS),
%%                     rank_util:check_insert_champion(PS, ?EVENT_EQUIPS_PROMPT_FULL, StrenLv, 0)
%%             end
%%     end,
%%     ok.
%% 
%% %% desc: 洗炼属性
%% event_equips_cast(PS, WashTuple) ->
%%     Fun = fun({_, WashLv, _}, Min) -> 
%%                   case WashLv > Min of
%%                       true  -> Min;
%%                       false -> WashLv
%%                   end
%%           end,
%%     Length = erlang:length(WashTuple),
%%     MinLv = lists:foldl(Fun, 9999, WashTuple),
%%     
%%     rank_util:check_insert_champion(PS, ?EVENT_EQUIPS_CAST, Length, MinLv).
%% 
%% %% desc: 宝石
%% event_stone(_PS, _Lv) ->
%%     % rank_util:check_insert_champion(PS, ?EVENT_STONE, Lv, 0).
%%     ok.
%% 
%% %% desc: 人物战斗力
%% event_role_battle_capacity(PS, BattleCapacity) ->
%%     if
%%         BattleCapacity >= ?CHAMPION_PERSON_BATTLE_MIN ->
%%             rank_util:check_insert_champion(PS, ?EVENT_ROLE_BATTLE_CAPACITY,
%%                                      BattleCapacity - BattleCapacity rem ?CHAMPION_PERSON_BATTLE_MIN, 0);
%%         true ->
%%             skip
%%     end,
%%     ok.
%% 
%% %% desc: 武将战斗力
%% event_partner_battle_capacity(PS, #ets_partner{battle_capacity = BattleCapacity} = _ParInfo) ->
%%     if
%%         BattleCapacity >= ?CHAMPION_PARTNER_BATTLE_MIN ->
%%             rank_util:check_insert_champion(PS, ?EVENT_PARTNER_BATTLE_CAPACITY,
%%                                      BattleCapacity - BattleCapacity rem ?CHAMPION_PARTNER_BATTLE_MIN, 0);
%%         true ->
%%             skip
%%     end,
%%     ok.