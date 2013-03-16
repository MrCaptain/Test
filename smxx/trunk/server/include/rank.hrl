-ifndef(_RANK_H_).
-define(_RANK_H_, _rank_h_).

%%
%% 排行榜类型
%%

% desc: 个人榜
-define(RANK_T_PERSONAL_BATTLE, 0).   % 个人榜*战力
-define(RANK_T_PERSONAL_LV, 1).   % 个人榜*等级
-define(RANK_T_PERSONAL_MONEY, 2).   % 个人榜*财富
% desc: 鲜花/魅力榜
-define(RANK_T_FLOWER_D, 3).   % 鲜花日榜
-define(RANK_T_FLOWER_T, 4).   % 鲜花总榜
-define(RANK_T_CHARM_D, 5).    % 魅力日榜
-define(RANK_T_CHARM_T, 6).    % 魅力总榜
% desc: 武将榜
-define(RANK_T_PARTNER_BATTLE, 7).   % 武将榜*战力
-define(RANK_T_PARTNER_LV, 8).   % 武将榜*等级
% desc: 装备榜
-define(RANK_T_EQUIP_WEAPON, 9).   % 武器
-define(RANK_T_EQUIP_CLOTHES, 10).   % 防具
-define(RANK_T_EQUIP_NECK, 11).   % 饰品
-define(RANK_T_EQUIP_SPIRIT, 12).   % 灵器

-define(RANK_T_FLOWER_W, 13).  % 鲜花周榜
-define(RANK_T_CHARM_W,  14).  % 魅力周榜

%% desc: 个人榜
-define(RANK_T_PERSONAL_VENATION,       15).        % 个人-灵脉排行榜
-define(RANK_T_PERSONAL_WEEK_TIME,      16).        % 个人-周在线时长

%% desc: 竞技类
-define(RANK_T_ARENA_HEROIC,            17).        % 竞技-英雄榜
-define(RANK_T_ARENA_WIN_STREAK,        18).        % 竞技-连胜榜
-define(RANK_T_ARENA_LOSS_STREAK,       19).        % 竞技-连败榜
-define(RANK_T_ARENA_WIN_TOTAL,         20).        % 竞技-总胜榜
-define(RANK_T_ARENA_LOSS_TOTAL,        21).        % 竞技-总败榜

% desc: 个人榜子榜单类型
-define(RANK_PERSONAL_ALL, [?RANK_T_PERSONAL_BATTLE, ?RANK_T_PERSONAL_LV, ?RANK_T_PERSONAL_MONEY,
        ?RANK_T_PERSONAL_VENATION, ?RANK_T_PERSONAL_WEEK_TIME]).

% desc: 鲜花魅力榜所有子榜单类型
-define(RANK_FC_ALL, [?RANK_T_FLOWER_D, ?RANK_T_FLOWER_W, ?RANK_T_FLOWER_T, ?RANK_T_CHARM_D, ?RANK_T_CHARM_W, ?RANK_T_CHARM_T]).

% desc: 武将榜类型
-define(RANK_PARTNER_ALL, [?RANK_T_PARTNER_BATTLE, ?RANK_T_PARTNER_LV]).

% desc: 装备榜类型
-define(RANK_EQUIP_ALL, [?RANK_T_EQUIP_WEAPON, ?RANK_T_EQUIP_CLOTHES, ?RANK_T_EQUIP_NECK, ?RANK_T_EQUIP_SPIRIT]).

% desc: 竞技类型(除英雄榜外)
-define(RANK_ARENA_ALL, [?RANK_T_ARENA_WIN_STREAK, ?RANK_T_ARENA_LOSS_STREAK, ?RANK_T_ARENA_WIN_TOTAL, ?RANK_T_ARENA_LOSS_TOTAL]).

%%
%% 排行榜条数上限
%%

-define(RANK_PERSONAL_MAX, 50).   % 个人榜/武将榜50条
-define(RANK_FLOWER_CHARM_MAX, 30).   % 鲜花/魅力榜30条
-define(RANK_EQUIP_MAX, 30).   % 装备榜30条

-define(RANK_ARENA_HEROIC_MAX,          100).       %竞技-英雄榜100条
-define(RANK_ARENA_COMM_MAX,            50).        %竞技-除英雄榜外50条
-define(RANK_DUNGEON_MAX,               30).        %副本-30条


%% 排行榜-上榜下限 %%

%% 个人榜战斗力下限
-define(RANK_PERSON_BATTLE_MIN,     10000).
%% 个人榜等级下限
-define(RANK_PERSON_LEVEL_MIN,      10).
%% 个人榜金钱下限
-define(RANK_PERSON_MONEY_MIN,      100000).
%% 武将榜等级下限
-define(RANK_PARTNER_LEVEL_MIN,     10).
%% 武将榜战斗力下限
-define(RANK_PARTNER_BATTLE_MIN,    100000).
%% 装备评分下限
-define(RANK_EQUIP_MIN,             200).
%% 勇士榜人物战斗力下限
-define(CHAMPION_PERSON_BATTLE_MIN, 10000).
%% 勇士榜武将战斗力下限
-define(CHAMPION_PARTNER_BATTLE_MIN,10000).

%%
%%  SQL
%%

-define(SQL_SELECT_PER_LIMIT, <<"select id, ~s, nickname, sex, career, guild_name, vip from `player` where ~s > 0 and (logout_time > ~p or online_flag = 1) ORDER BY ~s DESC LIMIT ~p">>).
-define(SQL_SELECT_PARTNER_LIMIT, <<"select partner.id, lv, exp, battle_capacity, player_id, career, sex, name from `partner` where ~s > 0 ORDER BY ~s DESC LIMIT ~p">>).
-define(SQL_SELECT_FLOWER_CHARM_D_LIMIT, <<"select player_id, nickname, sex, career, guild_name, vip, ~s from `rank_flower_charm` where ~s > 0 and ~s = ~p ORDER BY ~s DESC LIMIT ~p">>).
-define(SQL_SELECT_FLOWER_CHARM_W_LIMIT, <<"select player_id, nickname, sex, career, guild_name, vip, ~s from `rank_flower_charm` where ~s > 0 and (logout_time > ~p or logout_time = 0) ORDER BY ~s DESC LIMIT ~p">>).
-define(SQL_SELECT_FLOWER_CHARM_T_LIMIT, <<"select player_id, nickname, sex, career, guild_name, vip, ~s from `rank_flower_charm` where ~s > 0 and (logout_time > ~p or logout_time = 0) ORDER BY ~s DESC LIMIT ~p">>).
-define(SQL_SELECT_EQUIP_T_LIMIT, <<"select id, score, player_id, goods_id, stren from `goods` where score > 0 and (goods.type = ~p and goods.subtype in (~s)) and (goods.location >= 0 and goods.location <= 3) ORDER BY score desc limit ~p">>).

-define(SQL_SELECT_PER_VENATION_WEEKTIME_ARENA_LIMIT, "select player_id, nickname, sex, career, guild_name, vip, ~s from `log_total` where ~s > 0 and logout_time > ~p order by ~s desc limit ~p").

%%
%% ETS表
%%

% desc: ets表
-define(ETS_RANK_TOTAL, ets_rank_total).
% desc: 勇士表
-define(ETS_RANK_CHAMPION, ets_rank_champion).
% desc: 副本表
-define(ETS_RANK_DUNGEON, ets_rank_dungeon).
% desc: 排行榜称号变更离线信息表
-define(ETS_OFFLINE_RANKTITLE, ets_offline_ranktitle).


%%
%% Other
%%

-define(SEVEN_DAY_SECONDS, 7*24*60*60).
-define(RANK_STARTED_TIME, util:unixtime() - ?SEVEN_DAY_SECONDS).


%% 勇士榜类型
-define(EVENT_ROLE_LEVEL,           1).
-define(EVENT_GUILD_LEVEL,          2).
-define(EVENT_VENATION_LEVEL,       3).
-define(EVENT_PARTNER_COLOR,        4).
-define(EVENT_PARTNER_LEVEL,        5).
-define(EVENT_WORLDBOSS,            6).
-define(EVENT_TOWER,                7).
-define(EVENT_DUNGEON,              8).
-define(EVENT_ARENA,                9).
-define(EVENT_BE_WANTED,            10).
-define(EVENT_EQUIPS_SUIT,           11).
-define(EVENT_EQUIPS_PROMPT,        12).
-define(EVENT_EQUIPS_PROMPT_FULL,   13).
-define(EVENT_EQUIPS_CAST,          14).
-define(EVENT_STONE,                15).
-define(EVENT_ROLE_BATTLE_CAPACITY, 16).
-define(EVENT_PARTNER_BATTLE_CAPACITY,17).

%% 
%% 记录体
%%

% 状态
-record(ets_rank_total, {
                         type = 0,   % 榜单类型：见宏定义 排行榜类型
                         rank_list = []
                   }).

% 排行榜称号离线数据
-record(ets_offline_ranktitle, {
                         player_id = 0,
						 flag = 0,
						 titleid = 0
                   }).

% 鲜花榜
-record(ets_rank_flower, {
                          player_id = 0,
                          sex = 0,   % 0-全部，1-男，2-女
                          career = 0,   % 0-全部，1-天刃，2-长空，3-飞翎
                          nickname = [],   % 玩家名称
                          guildname = [],   % 玩家所在帮会名称
                          last_logouttime = 0,   % 最近一次退出时间
                          vip = 0,   % vip等级
                          
                          d_num = 0,   % 每日总数
                          d_rank = 0,   % 日排行
                          d_change = 0,
                          
                          t_num = 0,   % 总数
                          t_rank = 0,   % 总排行
                          t_change = 0
                         }).

%% 勇士榜结构
-record(ets_rank_champion, {
        id          = 0,        %% 编号ID
        player_id   = 0,        %% 玩家ID
        nickname    = [],       %% 玩家名称
        guild_name  = [],       %% 公会名称
        career      = 0,        %% 职业
        sex         = 0,        %% 性别
        vip         = 0,        %% VIP等级
        create_time = 0         %% 创建时间
    }).

-record(
    ets_rank_dungeon, {
        id      = 0,    % 副本ID
        list    = []    % 排行榜数据
    }). 

-endif.
