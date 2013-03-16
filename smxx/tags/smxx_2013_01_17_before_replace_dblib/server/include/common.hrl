%%%------------------------------------------------
%%% File    : common.hrl
%%% Author  : csj
%%% Created : 2010-09-15
%%% Description: 公共定义
%%%------------------------------------------------
-include("guild_info.hrl").

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

%% 每个场景的工作进程数
-define(SCENE_WORKER_NUMBER, 10).

%% 每个场景的启动的副场景数
-define(SCENE_COPY_NUMBER, 20).

%% 每个场景的最多容纳人数
-define(SCENE_PLAYER_MAX_NUMBER, 100).

%% 默认场景的最少人数
-define(SCENE_PLAYER_MIN_NUMBER, 20).

%%安全校验
-define(TICKET, "SDFSDESF123DFSDF"). 

%%flash843安全沙箱
-define(FL_POLICY_REQ, <<"<polic">>).
%% -define(FL_POLICY_REQ, <<60,112,111,108,105,99,121,45,102,105,108,101,45,114,101,113,117,101,115,116,47,62,0>>).
%% -define(FL_POLICY_FILE, <<"<cross-domain-policy><allow-access-from domain='*' to-ports='*' /></cross-domain-policy>">>).
-define(FL_POLICY_FILE, "<cross-domain-policy><site-control permitted-cross-domain-policies=\"master-only\"/><allow-access-from domain=\"*\" to-ports=\"*\"/></cross-domain-policy>\0\0").
%%tcp_server监听参数
-define(TCP_OPTIONS, [binary, {packet, 0}, {active, false}, {reuseaddr, true}, {nodelay, false}, {delay_send, true}, {send_timeout, 5000}, {keepalive, true}, {exit_on_close, true}]).
-define(RECV_TIMEOUT, 5000).

%% 心跳包时间间隔
-define(HEARTBEAT_TICKET_TIME, 180*1000).	%%seconds
%% 最大心跳包检测失败次数
-define(HEARTBEAT_MAX_FAIL_TIME, 3).
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
-define(INIT_SCENE_ID, 100).      %%新手村
-define(INIT_SCENE_XY, {10,10}).  %%新建帐号位置

%性别
-define(GENDER_ANY, 0).
-define(GENDER_MALE,1).
-define(GENDER_FEMALE, 2).

%职业
-define(CAREER_ANY, 0). %未定义
-define(CAREER_F, 1). %神
-define(CAREER_M, 2). %魔
-define(CAREER_D, 3). %妖

%%打开发送消息客户端进程数量 
-define(SEND_MSG, 3).

%% 联盟进程的工作进程数
-define(GUILD_WORKER_NUMBER, 10).
-define(MON_LIMIT_NUM, 100000000).								%% 怪物数量限制数
-define(DIFF_SECONDS_1970_1900, 2208988800).
-define(DIFF_SECONDS_0000_1900, 62167219200).
-define(ONE_DAY_SECONDS,        86400).					%%一天的时间（秒）
-define(ONE_DAY_MILLISECONDS, 86400000).				%%一天时间（毫秒）

-define(DEFAULT_NAME, "匿名") .	
%%ETS
-define(ETS_SERVER, ets_server).
-define(ETS_GET_SERVER,ets_get_server).
-define(ETS_GET_SCENE,ets_get_scene).
-define(ETS_SYSTEM_INFO,  ets_system_info).						%% 系统配置信息
-define(ETS_MONITOR_PID,  ets_monitor_pid).						%% 记录监控的PID
-define(ETS_STAT_SOCKET, ets_stat_socket).						%% Socket送出数据统计(协议号，次数)
-define(ETS_STAT_DB, ets_stat_db).								%% 数据库访问统计(表名，操作，次数)

%% -define(ETS_BASE_MON, ets_base_mon).							%% 基础_怪物信息
%% -define(ETS_MONGROUP, ets_mongroup).							%% 基础_怪物信息

-define(ETS_NPC, temp_npc).										%% 基础_NPC/怪物信息
-define(ETS_TEMP_SCENE, temp_scene).							%% 基础_场景信息
-define(ETS_SCENE, ets_scene).									%% 本节点场景实例
-define(ETS_NPC_LAYOUT, npc_layout).						    %% 实例-场景NPC布局
-define(ETS_TEMP_MON_LAYOUT, temp_mon_layout).					%% 基础_场景怪物布局
-define(ETS_MON_LAYOUT, mon_layout).						    %% 实例-场景怪物布局

-define(ETS_ONLINE, ets_online).								%% 本节点在线玩家
-define(ETS_ONLINE_SCENE, ets_online_scene).					%% 本节点场景中玩家














%% -define(ETS_BASE_SCENE_POSES, ets_base_scene_poses).			%% 基本_场景坐标表
-define(ETS_BASE_SCENE_MON, ets_base_scene_mon).				%% 基础_场景怪物信息
-define(ETS_BASE_SCENE_NPC, ets_base_scene_npc).				%% 基础_场景NPC信息


-define(ETS_SCENE_MON, ets_mon).								%% 本节点场景中怪物
-define(ETS_SCENE_NPC, ets_npc).								%% 本节点场景中NPC


-define(ETS_BLACKLIST,ets_blacklist).							%% 黑名单记录表

-define(ETS_BASE_CAREER, ets_base_career).                        			%% 基础职业属性
-define(ETS_BASE_GOODS, ets_base_goods).                        			%% 物品类型表
%% -define(ETS_BASE_GOODS_ADD_ATTRIBUTE, ets_base_goods_add_attribute).      	%% 装备类型附加属性表
-define(ETS_BASE_GOODS_SUIT_ATTRIBUTE, ets_base_goods_suit_attribute).    	%% 装备套装属性表
-define(ETS_BASE_GOODS_SUIT,ets_base_goods_suit).							%% 装备套装基础表 
-define(ETS_BASE_GOODS_DROP_NUM, ets_base_goods_drop_num).                	%% 物品掉落个数规则表
-define(ETS_BASE_GOODS_DROP_RULE, ets_base_goods_drop_rule).              	%% 物品掉落规则表

-define(ETS_GUILD,        ets_guild).                          	 			%% 联盟
-define(ETS_GUILD_MEMBER, ets_guild_member).                    			%% 联盟成员
-define(ETS_GUILD_APPLY,  ets_guild_apply).                    				%% 联盟申请
-define(ETS_GUILD_INVITE, ets_guild_invite).                    			%% 联盟邀请





