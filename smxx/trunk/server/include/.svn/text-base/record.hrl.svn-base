%%%------------------------------------------------
%%% File    : record.erl
%%% Author  : csj
%%% Created : 2010-09-15
%%% Description: record
%%%------------------------------------------------
-include("table_to_record.hrl").

%%战斗属性 战斗相关属性的率一般为 万分比值*10000,
%%         发给客户端显示使用 万分比值*10000/100,显示为等级
-record(battle_attr,  {
			    x = 0,						   %% X 坐标 
				y = 0, 						   %% Y 坐标
                career = 1,                    %% 职业(参考common.hrl定义)
                skill_cd_all = 0,              %% 对所有技能的CD, 冷冻到期时间(毫秒)
                skill_cd_list = [],            %% 技能使用CD,格式[{SkillId, CdTime},...],　CdTime为冷冻到期时间(毫秒)
                skill_buff = [],               %% 技能特殊状态Buff/单次有效,过期还原/需发到客户端[{BufId, 过期时间},...] 毫秒, 
                buff1 = [],                    %% 技能加战斗属性BUF列表/单次有效,过期还原 [{BufId, 过期时间},...] 毫秒
                buff2 = [],                    %% 技能加血力法量BUF列表/周期性, 过期保留 [{BufId, CD到期时间, 剩余次数},...] 毫秒
                sing_expire = 0,               %% 吟唱到期时间(毫秒), 目前只对怪有效, 0为不在吟唱时间内
                use_combopoint = 0,            %% 是否使用了combopoint增加属性攻击值(0未用, 其他为使用的点数)
                combopoint_max = 0,            %% 最大连击点数
                combopoint = 0,                %% 连击点数(技能消耗/获得的属性,可额外增加伤害率或防御率)
                hit_point = 0,                 %% 生命	
                hit_point_max = 0,             %% 生命上限	
                magic = 0,                     %% 法力值	
                magic_max = 0,                 %% 法力值上限	
                anger = 0,                     %% 怒气值	
                anger_max = 0,                 %% 怒气值上限	
                attack = 0,                    %% 普通攻击力	
                attack_ratio = 0,              %% 普通攻击力增加伤害率(Buff附加值, 初始为0)                
                defense = 0,                   %% 普通防御力
                defense_ratio = 0,             %% 普通防御力增加防御率(Buff附加值, 初始为0)
                abs_damage = 0,                %% 绝对伤害值	
                fattack = 0,                   %% 仙攻值
                fattack_ratio = 0,             %% 仙攻值增加伤害率(Buff附加值, 初始为0) 
                mattack = 0,                   %% 魔攻值	
                mattack_ratio = 0,             %% 魔攻值增加伤害率(Buff附加值, 初始为0)
                dattack = 0,                   %% 妖攻值
                dattack_ratio = 0,             %% 妖攻值增加伤害率(Buff附加值, 初始为0)
                fdefense = 0,                  %% 仙防值
                fdefense_ratio = 0,            %% 仙防值增加防御率(Buff附加值, 初始为0)
                mdefense = 0,                  %% 魔防值
                mdefense_ratio = 0,            %% 魔防值增加防御率(Buff附加值, 初始为0)
                ddefense = 0,                  %% 妖防值
                ddefense_ratio = 0,            %% 妖防值增加防御率(Buff附加值, 初始为0)
                speed = 0,                     %% 移动速度	
                attack_speed = 0,              %% 攻击速度	
                hit_ratio = 1,                 %% 命中等级(万分比)
                dodge_ratio = 1,               %% 闪避等级(万分比)	
                crit_ratio = 1,                %% 暴击等级(万分比)	
                tough_ratio = 1,               %% 坚韧等级(万分比)
                frozen_resis_ratio = 0,        %% 冰冻抗性率(帮派技能引入)	
                weak_resis_ratio = 0,          %% 虚弱抗性率(帮派技能引入)	
                flaw_resis_ratio = 0,          %% 破绽抗性率(帮派技能引入)	
                poison_resis_ratio = 0,        %% 中毒抗性率(帮派技能引入)	
                avoid_attack_ratio = 0,        %% 受到普攻免伤害率(Buff附加值, 初始为0)
                avoid_fattack_ratio = 0,       %% 受到仙攻免伤率(Buff附加值, 初始为0)
                avoid_mattack_ratio = 0,       %% 受到魔攻免伤率(Buff附加值, 初始为0)
                avoid_dattack_ratio = 0,       %% 受到妖攻免伤率(Buff附加值, 初始为0)
                avoid_crit_attack_ratio = 0,   %% 受到普攻暴击免伤害率(Buff附加值, 初始为0)
                avoid_crit_fattack_ratio = 0,  %% 受到仙攻暴击免伤率(Buff附加值, 初始为0)
                avoid_crit_mattack_ratio = 0,  %% 受到魔攻暴击免伤率(Buff附加值, 初始为0)
                avoid_crit_dattack_ratio = 0,  %% 受到妖攻暴击免伤率(Buff附加值, 初始为0)
                ignore_defense = 0,            %% 攻方忽略防方普防值(武魂引入)
                ignore_fdefense = 0,           %% 攻方忽略防方仙防值(武魂引入)
                ignore_mdefense = 0,           %% 攻方忽略防方魔防值(武魂引入)
                ignore_ddefense = 0            %% 攻方忽略防方妖防值(武魂引入)
          }).

%%用户的其他附加信息(对应player.other)
-record(player_other, {
                       skill_list = [],              % 技能列表[{SkillId, Level}, ...]
                       socket = undefined,           % 当前用户的socket
                       pid = undefined,              % 用户进程Pid
                       pid_goods = undefined,        % 物品模块进程Pid
                       pid_send = [],                % 消息发送进程Pid(可多个)
                       pid_battle = undefined,       % 战斗进程Pid
                       pid_scene = undefined,        % 当前场景Pid
                       pid_dungeon = undefined,      % 当前副本进程
                       pid_task = undefined,         % 当前任务Pid
                       node = undefined,             % 进程所在节点    
                       blacklist = false,            % 是否受黑名单监控
					   pk_mode = 0,                  % 0-不强制pk模式 1-强制和平模式 2-强制自由pk模式 3-强制帮会pk模式
					   goods_ets_id = 0,             % 物品ets表ID
					   equip_current = [],           % 影响玩家外观装备 
					   weapon_strenLv = 0,			 % 武器强化等级	
					   armor_strenLv = 0,			 % 盔甲强化等级
					   fashion_strenLv = 0,			 % 时装强化等级
					   wapon_accstrenLv = 0,         % 武饰强化等级
					   wing_strenLv = 0,		     % 翅膀强化等级
					   pet_template_id = 0,			 % 宠物模版类型id
					   pet_nick = "",				 % 宠物昵称
                       mount_fashion = 0,            % 坐骑外观
                       team_id = 0,                  % 队伍ID, 0为无队伍
                       team_leader = 0               % 是否队长1是,其他不是
                      }).

%%任务进度（用于在杀怪，采集等动作时保存对应的未完成任务与已完成任务）
-record(task_process_info,{
		task_unfinsh = [], %%未完成的任务
		task_fin = [] %%已完成任务
	}).

%%怪物掉落
-record(mon_drop_goods,{
				  mon_id = 0 ,
				  goods_id	= 0 , 	%% 物品ID
				  goods_num	= 0 , 	%% 掉落数量
				  x	= 0 ,			%% 掉落的X左边
				  y = 0 ,			%% 掉落的Y坐标
				  drop_time = 0 	%% 掉落时间单位秒
				 }).

%% 购买npc商店日志	
-record(ets_npc_shop_log, {	
	  key,	
      buy_num,                                %% 	
      buy_time                                %% 	
    }).

%% 购买商城日志	
-record(ets_shop_log, {	
	  key,	
      buy_num,                                %% 	
      buy_time                                %% 	
    }).

%% 购买商城日志	
-record(ets_special_shop_log, {	
	  key,	
      buy_num,                                %% 	
      buy_time                                %% 	
    }).

%% 队伍信息	
-record(team, {	
        tid = 0,                   %%队伍ID
        leader_id = 0,             %%队长ID
        leader_nick = <<>>,        %%队长名字
        leader_level = 0,          %%队长的等级
        direct_join = 0,           %%直接加入队伍
        invite_allow = 0,          %%成员可发邀请
        max_num = 0,               %%最大队员数
        member_ids = []            %%成员ID列表
    }).

%% 成员信息	
-record(team_member, {	
        uid = 0,             %%角色ID
        tid = 0,             %%队伍ID
        level = 0,           %%队长的等级
        nick = <<>>,         %%名字
        force = 0,           %%战斗力
        camp = 0,            %%阵营
        career = 0,          %%职业
        gender = 0           %%性别          
    }).
