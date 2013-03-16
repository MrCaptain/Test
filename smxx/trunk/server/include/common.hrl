%%%------------------------------------------------
%%% File    : common.hrl
%%% Author  : csj
%%% Created : 2010-09-15
%%% Description: 公共定义
%%%------------------------------------------------
-define(ALL_SERVER_PLAYERS, 10000).

%%数据库模块选择 (db_mysql 或 db_mongo)
-define(DB_MODULE, db_mysql).            
%%数据库模块(日志数据库)
-define(DB_LOG_MODULE, db_mysql_admin).

-define(DB_SERVER, mysql_dispatcher).            
%%数据库模块(日志数据库)
-define(DB_SERVER_ADMIN, mysql_admin_dispatcher).

%%mongo主数据库链接池
-define(MASTER_POOLID,master_mongo).
%%mongo从数据库链接池
-define(SLAVE_POOLID,slave_mongo).

%%Mysql数据库连接 
-define(DB_POOL, mysql_conn). 

%%消息头长度
-define(HEADER_LENGTH, 4).               %%消息头长度 2Byte 长度 + 2Byte 消息编号

%% 心跳包时间间隔
-define(HEART_TIMEOUT, 5*60*1000).    %%心跳包超时时间
%% 最大心跳包检测失败次数
-define(HEART_TIMEOUT_TIME, 2).      %%心跳包超时次数
-define(TCP_TIMEOUT, 1000).      % 解析协议超时时间

%% 每个场景的工作进程数
-define(SCENE_WORKER_NUMBER, 10).

%% 每个场景的最多容纳人数
-define(SCENE_PLAYER_MAX_NUMBER, 20).
%% 最大分场景数
-define(SCENE_MAX_NUMBER, 20).

%% 默认场景的最少人数
-define(SCENE_PLAYER_MIN_NUMBER, 20).

%%安全校验
-define(TICKET, "SDFSDESF123DFSDF"). 

%%tcp_server监听参数
-define(TCP_OPTIONS, [binary, {packet, 0}, {active, false}, {reuseaddr, true}, {nodelay, false}, {delay_send, true}, {send_timeout, 5000}, {keepalive, true}, {exit_on_close, true}]).
-define(RECV_TIMEOUT, 5000).

%%出师等级限制 
-define(FINISHED_MASTER_LV,35).
%%徒弟未汇报时间
-define(UNREPORT_DAYS,3).
%%师傅未登陆时间
-define(UNLOGIN_DAYS,3).

%%人物和宠物死亡后的最低血量
-define(LIMIT_HP, 10).

%%自然对数的底
-define(E, 2.718281828459).

%% ---------------------------------
%% Logging mechanism
%% Print in standard output
-define(PRINT(Format, Args),
    io:format(Format, Args)).
-define(TEST_MSG(Format, Args),
    logger:test_msg(?MODULE,?LINE,Format, Args)).
-define(DEBUG(Format, Args),
    logger:debug_msg(?MODULE,?LINE,Format, Args)).
-define(INFO_MSG(Format, Args),
    logger:info_msg(?MODULE,?LINE,Format, Args)).
-define(WARNING_MSG(Format, Args),
    logger:warning_msg(?MODULE,?LINE,Format, Args)).
-define(ERROR_MSG(Format, Args),
    logger:error_msg(?MODULE,?LINE,Format, Args)).
-define(CRITICAL_MSG(Format, Args),
    logger:critical_msg(?MODULE,?LINE,Format, Args)).

%% 新手村场景ID
-define(INIT_SCENE_ID, 101).      %%新手村
-define(INIT_SCENE_XY, {10,10}).  %%新建帐号位置

%性别
-define(GENDER_ANY, 0).
-define(GENDER_MALE,1).
-define(GENDER_FEMALE, 2).

%职业
-define(CAREER_ANY, 0). %未定义
-define(CAREER_F, 1). %战士
-define(CAREER_M, 2). %法师
-define(CAREER_D, 3). %射手

%% 性别
-define(SEX_ANY,    0).    % 男女通用
-define(SEX_MALE,   1).    % 男
-define(SEX_FEMALE, 2).    % 女

%VIP类型定义
-define(VIP_NOT, 0).  %不是VIP
-define(VIP_HOUR, 1).  %VIP钟点卡(试用装)
-define(VIP_DAY, 11).  %VIP日卡
-define(VIP_WEEK, 12). %VIP周卡
-define(VIP_MONTH, 13).  %VIP月卡
-define(VIP_HALF_YEAR, 21).  %VIP半年卡
-define(VIP_YEAR, 22).       %VIP年卡
-define(VIP_FOREVER, 99).    %VIP终身卡

-define(ELEMENT_PLAYER, 1).  %% 玩家
-define(ELEMENT_MONSTER, 2).  %% 怪物
-define(ELEMENT_ALL, 3).  %% 玩家,怪物

%%打开发送消息客户端进程数量 
-define(SEND_MSG, 3).

%%player.switch开关位定义(32位)
-define(SW_PET_BIT,      16#00000001).  %宠物
-define(SW_MOUNT_BIT,    16#00000002).  %座骑
-define(SW_GUILD_BIT,    16#00000004).  %帮派
-define(SW_RELATION_BIT, 16#00000008).  %关系
-define(SW_SKILL_BIT,    16#00000010).  %技能

-define(SW_BIT5, 16#00000020).
-define(SW_BIT6, 16#00000040).
-define(SW_BIT7, 16#00000080).

-define(SW_BIT8,  16#00000100).
-define(SW_BIT9,  16#00000200).
-define(SW_BIT10, 16#00000400).
-define(SW_BIT11, 16#00000800).

-define(SW_BIT12, 16#00001000).
-define(SW_BIT13, 16#00002000).
-define(SW_BIT14, 16#00004000).
-define(SW_BIT15, 16#00008000).

-define(SW_BIT16, 16#00010000).
-define(SW_BIT17, 16#00020000).
-define(SW_BIT18, 16#00040000).
-define(SW_BIT19, 16#00080000).

-define(SW_BIT20, 16#00100000).
-define(SW_BIT21, 16#00200000).
-define(SW_BIT22, 16#00400000).
-define(SW_BIT23, 16#00800000).

-define(SW_BIT24, 16#01000000).
-define(SW_BIT25, 16#02000000).
-define(SW_BIT26, 16#04000000).
-define(SW_BIT27, 16#08000000).

-define(SW_BIT28, 16#10000000).
-define(SW_BIT29, 16#20000000).
-define(SW_BIT30, 16#40000000).
-define(SW_BIT31, 16#80000000).

%% 联盟进程的工作进程数
-define(MON_LIMIT_NUM, 100000000).                                %% 怪物数量限制数
-define(DIFF_SECONDS_1970_1900, 2208988800).
-define(DIFF_SECONDS_0000_1900, 62167219200).
-define(ONE_DAY_SECONDS,        86400).                    %%一天的时间（秒）
-define(ONE_DAY_MILLISECONDS, 86400000).                %%一天时间（毫秒）

-define(DEFAULT_NAME, "匿名") .    
%%ETS
-define(ETS_SERVER, ets_server).
-define(ETS_GET_SERVER,ets_get_server).
-define(ETS_GET_SCENE,ets_get_scene).
-define(ETS_SYSTEM_INFO,  ets_system_info).                        %% 系统配置信息
-define(ETS_MONITOR_PID,  ets_monitor_pid).                        %% 记录监控的PID
-define(ETS_STAT_SOCKET, ets_stat_socket).                        %% Socket送出数据统计(协议号，次数)
-define(ETS_STAT_DB, ets_stat_db).                                %% 数据库访问统计(表名，操作，次数)

%% -define(ETS_BASE_MON, ets_base_mon).                            %% 基础_怪物信息
%% -define(ETS_MONGROUP, ets_mongroup).                            %% 基础_怪物信息

-define(ETS_NPC, temp_npc).                                        %% 基础_NPC/怪物信息
-define(ETS_TEMP_SCENE, temp_scene).                            %% 基础_场景信息
-define(ETS_SCENE, ets_scene).                                    %% 本节点场景实例
-define(ETS_NPC_LAYOUT, npc_layout).                            %% 实例-场景NPC布局
-define(ETS_TEMP_MON_LAYOUT, temp_mon_layout).                    %% 基础_场景怪物布局
-define(SECNE_MON, scene_mon).                                    %% 场景中怪物保存，可以用作ETS，可以用这dict key
-define(SECNE_DROP, scene_drop).                                    %% 场景中怪物怪物掉落
-define(MON_STATE_TIMER_KEY, mon_state_timer_key).               %% 怪物状态的TimerKey
-define(MON_STATE_LOOP_TIME,200).								%% 怪物状态管理 200 毫秒先
-define(MON_STATE_1_GUARD,	1) .
-define(MON_STATE_2_TRYATT,	2) .
-define(MON_STATE_3_MOVE,	3) .
-define(MON_STATE_4_FIGHT,	4) .
-define(MON_STATE_5_RETURN,	5) .
-define(MON_STATE_6_DEAD,	6) .
-define(MON_STATE_7_CHANT,	7) .

%%guard--prepare_fight--move--fight--return--dead--guard

-define(ETS_ONLINE, ets_online).                                %% 本节点在线玩家
-define(ETS_ONLINE_SCENE, ets_online_scene).                    %% 本节点场景中玩家


%% -define(ETS_BASE_SCENE_POSES, ets_base_scene_poses).            %% 基本_场景坐标表
-define(ETS_BASE_SCENE_MON, ets_base_scene_mon).                %% 基础_场景怪物信息
-define(ETS_BASE_SCENE_NPC, ets_base_scene_npc).                %% 基础_场景NPC信息


-define(ETS_SCENE_MON, ets_mon).                                %% 本节点场景中怪物
-define(ETS_SCENE_NPC, ets_npc).                                %% 本节点场景中NPC

-define(ETS_BLACKLIST,ets_blacklist).                           %% 黑名单记录表

-define(ETS_GOODS_ONLINE, ets_goods_online).                    %% 在线物品表
-define(ETS_GOODS_EQUIP, ets_goods_equip).                      %% 装备物品类型表

-define(ETS_GUILD,        ets_guild). 						     %% 联盟
-define(ETS_GUILD_MEMBER, ets_guild_member).                    %% 联盟成员
-define(ETS_GUILD_APPLY,  ets_guild_apply).                     %% 联盟申请
-define(ETS_GUILD_INVITE, ets_guild_invite).                    %% 联盟邀请

-define(ETS_MOUNT, ets_mount).                                  %%座骑ETS表名
-define(ETS_RELATION, ets_relation).                            %%关系ETS表名
-define(ETS_TEAM, ets_team).                                    %%队伍表ETS
-define(ETS_TEAM_MEMBER, ets_team_member).                      %%队伍成员表ETS

-define(ETS_TEMP_SHOP, ets_temp_shop).							%% 商城模版表				
-define(ETS_SHOP_LOG, ets_shop_log).							%% 商城购买物品记录
-define(ETS_NPC_SHOP_LOG, ets_npc_shop_log).					%% npc商店购买物品记录

-define(ETS_TPL_TASK, tpl_task).                              %%角色任务模板
-define(ETS_TASK_DAILY_FINISH, ets_task_daily_finish).	%%日常任务完成进度
-define(ETS_TASK_PROCESS,  task_process). 							%% 角色任务记录
-define(ETS_TASK_FINISH, task_finish).							%% 角色任务历史记录  
-define(ETS_TASK_QUERY_CACHE, ets_task_query_cache).    	 	%% 当前所有可接任务
-define(ETS_TASK_DETAIL, ets_task_datil).						%%任务模板子表

-define(ONE_DAY_MSECONDS, (24 * 60 * 60 * 1000)).  % 一天的毫秒数

-define(ONE_HOUR_SECONDS, (60 * 60)).   % 一小时的秒数
-define(ONE_HOUR_MSECONDS, (60 * 60 * 1000)).   % 一小时的毫秒数

-define(ONE_MINUTE_SECONDS, 60).   % 一分钟的秒数
-define(ONE_MINUTE_MSECONDS, (60 * 1000)).   % 一分钟的毫秒数


-define(START_NOW, {-1, 0, 0}).   %% {-1, 0, 0}:表示从当前时间开始 
-define(START_TOMORROW, {-2, 0, 0}).   %% {-2, 0, 0}:表示从每日零点开始

%% 通知客户端刷新
-define(REFRESH_ROLE_ATTRI, 1).   %刷新人物属性
-define(REFRESH_BAG, 2).   %刷新背包
-define(REFRESH_P_EQUIP, 3).   %武将装备
-define(REFRESH_MONEY, 4).   %刷新三种货币
-define(REFRESH_GOODS_INFO, 5).   %刷新物品信息
-define(REFRESH_R_EQUIP, 6).   %玩家装备
-define(REFRESH_ROLE_POWER, 7).   %刷新人物体力条
-define(REFRESH_ROLE_HP, 8).   %刷新人物血条
-define(REFRESH_PAR_ATTRI, 9).   %刷新武将属性
-define(REFRESH_PAR_HP, 10).   %刷新武将血条
-define(REFRESH_STORE, 11).   %刷新仓库
-define(REFRESH_TREA, 12).   %刷新淘宝仓库
-define(REFRESH_DAN, 13).   % 刷新丹药仓库

%% 角色战斗力的调节参数
%-define(ROLE_BATTLE_CAPACITY_CONTROLLED_PARA, -242).

 
%% 体力的增减
-define(PLAYER_POWER_LIMIT, 200).   % 玩家体力值上限(固定值)
-define(ADD_POWER_PER_30_MIN, 5).   % (自动回复)体力增加
-define(POWER_INCREASE, 40).   % (购买)体力增加
-define(POWER_DECREASE, 20).   % (关卡)体力消耗
-define(POWER_BUFF, 50).   % (体力buff)12、18点系统赠予50点体力buff
-define(COST_BUY_POWER, 20).   % 购买体力固定花费的元宝


%% 背包、仓库默认格子数
-define(DEFAUL_BAG_CELL, 36*2).
-define(DEFAULT_STORE_CELL, 24).

%% VIP等级
-define(VIP_LV_0, 0).   % 0级，表示不是vip
-define(VIP_LV_1, 1).   % 一日游卡
-define(VIP_LV_2, 2).   % 周卡
-define(VIP_LV_3, 3).   % 月卡
-define(VIP_LV_4, 4).   % 半年卡
-define(VIP_LV_5, 5).   % 至尊卡

-define(VIP_TITLE_CHG_MAX_TIMES, 3).   % vip称号最多只能修改3次
-define(VIP_TITLE_MAX_LENGTH, 18).   % vip称号上限6个汉字

-define(BOOKING_GIFT, 181000005).	%预定礼包

% 定时更新称号（单位：秒）为18分钟
-define(UPDATE_TITLE_TIMER, 18*60*1000).

%% 游戏中流通的货币
-define(MONEY_T_GOLD,  1).         %% 元宝
-define(MONEY_T_BGOLD, 2).         %% 绑定元宝
-define(MONEY_T_COIN,  3).         %% 铜钱
-define(MONEY_T_BCOIN, 4).   	   %% 绑定铜钱

%% 物品、装备相关宏
-define(LOCATION_BAG,         0).   % 背包位置
-define(LOCATION_PLAYER,     1).    % 玩家身上
-define(LOCATION_PET,   2).     	% 宠物
-define(LOCATION_TREA,        4).   % 淘宝仓库 5页300格
-define(LOCATION_WINGS,        5).   % 衣柜
-define(LOCATION_HOLY_PLATFORM,        6).   % 圣坛
-define(LOCATION_MAIL,        11).   % 虚拟位置：邮件（用于标记邮件中的附件）
-define(LOCATION_MARKET,    12).   % 虚拟位置：市场（用于标记市场中挂售的物品）
-define(LOCATION_PARTNER_TRANSFORM,  20).   % 武将装备转档仓库
-define(TenMinute, 10 * 60 * 1000).




%% 返回结果：
-define(RESULT_OK,   1).  %% 成功
-define(RESULT_FAIL, 0).  %% 失败
-define(DELAY_CALL, 5000).

%% -define(ETS_TEMP_GOODS, temp_goods).                        %% 物品类型表
-define(ETS_COMPOSE_RULE, ets_compose_rule).                  %% 宝石合成规则表
-define(ETS_GOODS_INLAY, ets_goods_inlay).                      %% 宝石镶嵌规则表
-define(ETS_MARKET_GOODS_ONLINE, ets_market_goods_online).      %% 市场的上架物品信息表
-define(ETS_MARKET_GOODS_ATTR, ets_market_goods_attr).          %% 市场的上架物品的附加属性信息表
-define(ETS_GOODS_DROP, ets_goods_drop).                        %% 物品掉落表
-define(ETS_DROP_TYPE, ets_drop_type).                          %% 物品掉落类型
-define(ETS_DROP_NUM, ets_drop_num).                            %% 物品掉落上限值
-define(ETS_DROP_CONTENT, ets_drop_content).                    %% 物品掉落包中物品
-define(ETS_MARKET_SELLING, ets_mk_selling).                    %% 市场上架物品表
-define(GLOBAL_MARK_PROCESS, g_market_process). %% 市场/拍卖行
-define(ETS_PET_INFO, ets_pet_info). %% 宠物

% 32位有符号数的最大值
-define(MAX_S32, 2147483647).

% 16位有符号数的最大值
-define(MAX_S16, 32767).

% 8位有符号数的最大值
-define(MAX_S8, 127).

% 8位无符号数的最大值
-define(MAX_U8, 255).


%% 换装
-define(DEFAULT_T_WEAPON, 0). % 武器
-define(DEFAULT_T_ARMOR, 0). % 盔甲
-define(DEFAULT_T_FASHION, 0). % 时装
-define(DEFAULT_T_WINGS, 0). % 翅膀
-define(DEFAULT_T_WEAPONACCESSORIES, 0). % 武饰
-define(DEFAULT_T_MOUNT, 0). % 战骑

%%经脉
-define(ETS_MERIDIAN,player_meridian).%经脉模板表
-define(ETS_TPL_BONES,base_bones).%筋骨模板表
