%%%------------------------------------------------	
%%% File    : table_to_record.erl	
%%% Author  : smxx	
%%% Created : 2013-01-16 20:41:52	
%%% Description: 从mysql表生成的record	
%%% Warning:  由程序自动生成，请不要随意修改！	
%%%------------------------------------------------		
 	
	
%% 服务器列表	
%% server ==> server 	
-record(server, {	
      id = 0,                                 %% 编号Id	
      ip = "",                                %% ip地址	
      port = 0,                               %% 端口号	
      node = "",                              %% 节点	
      num = 0,                                %% 节点用户数	
      stop_access = 0                         %% 是否停止登陆该节点，0为可以登录，1为停止登陆	
    }).	
	
%% 角色基本信息	
%% player ==> player 	
-record(player, {	
      id,                                     %% 用户ID	
      account_id = 0,                         %% 平台账号ID	
      account_name = "",                      %% 平台账号	
      nick = "",                              %% 玩家名	
      type = 1,                               %% 玩家身份 1- 普通玩家 2 - 指导员 3 - gm	
      icon = 0,                               %% 玩家头像ID	
      reg_time = 0,                           %% 注册时间	
      last_login_time = 0,                    %% 最后登陆时间	
      last_login_ip = "",                     %% 最后登陆IP	
      status = 0,                             %% 玩家状态（0正常、1禁止、2战斗中、3死亡、4挂机、5打坐）	
      gender = 1,                             %% 性别 1男 2女	
      career = 0,                             %% 职业(0:未定义，1: 神 2:魔 3:妖)	
      gold = 0,                               %% 元宝	
      bgold = 0,                              %% 绑定元宝	
      coin = 0,                               %% 铜钱	
      bcoin = 0,                              %% 绑定铜钱	
      scene = 0,                              %% 场景ID	
      x = 0,                                  %% X坐标	
      y = 0,                                  %% Y坐标	
      level = 1,                              %% 等级	
      exp = 0,                                %% 经验	
      hit_point = 0,                          %% 生命	
      hit_point_max = 0,                      %% 生命上限	
      magic = 0,                              %% 法力值	
      magic_max = 0,                          %% 法力值上限	
      anger = 0,                              %% 怒气值	
      anger_max = 0,                          %% 怒气值上限	
      attack = 0,                             %% 普通攻击力	
      defense = 0,                            %% 普通防御力	
      abs_damage = 0,                         %% 绝对伤害值	
      fattack = 0,                            %% 仙攻值	
      mattack = 0,                            %% 魔攻值	
      dattack = 0,                            %% 妖攻值	
      fdefense = 0,                           %% 仙防值	
      mdefense = 0,                           %% 魔防值	
      ddefense = 0,                           %% 妖防值	
      speed = 0,                              %% 移动速度	
      attack_speed = 0,                       %% 攻击速度	
      hit = 0,                                %% 命中等级	
      dodge = 0,                              %% 闪避等级	
      crit = 0,                               %% 暴击等级	
      tough = 0,                              %% 坚韧等级	
      hit_per = 0,                            %% 命中率(万分比)	
      dodge_per = 0,                          %% 闪避率(万分比)	
      crit_per = 0,                           %% 暴击率(万分比)	
      tough_per = 0,                          %% 坚韧率(万分比)	
      frozen_resis_per = 0,                   %% 冰冻抗性率(万分比)	
      weak_resis_per = 0,                     %% 虚弱抗性率(万分比)	
      flaw_resis_per = 0,                     %% 破绽抗性率(万分比)	
      poison_resis_per = 0,                   %% 中毒抗性率(万分比)	
      online_flag = 0,                        %% 在线标记，0不在线 1在线	
      resolut_x = 0,                          %% 分辨率 X	
      resolut_y = 0,                          %% 分辨率 Y	
      liveness = 0,                           %% 活跃度	
      camp = 0,                               %% 阵营(国籍)	
      other = 0                               %% 其他信息	
    }).	
	
%% 玩家物品记录	
%% goods ==> goods 	
-record(goods, {	
      id,                                     %% 玩家物品Id	
      uid = 0,                                %% 玩家ID	
      gtid = 0,                               %% 物品类型Id	
      type = 0,                               %% 物品类型	
      stype = 0,                              %% 物品子类型	
      quality = 0,                            %% 品质，决定颜色	
      num,                                    %% 当前数量	
      cell,                                   %% 所在格子	
      streng_lv = 0,                          %% 强化等级	
      use_times = 0,                          %% 使用次数	
      expire_time,                            %% 有效时间	
      spec                                    %% 特殊字段	
    }).	
	
%% 技能	
%% skill ==> skill 	
-record(skill, {	
      uid = 0,                                %% 角色id	
      skill_list = [],                        %% 技能ID列表	
      cur_skill = 0                           %% 当前正在使用的技能的ID	
    }).	
	
%% 玩家系统设置	
%% player_sys_setting ==> player_sys_setting 	
-record(player_sys_setting, {	
      uid = 0,                                %% 玩家Id	
      shield_role = 0,                        %% 蔽屏附近玩家和宠物，0：不屏蔽；1：屏蔽	
      shield_skill = 0,                       %% 屏蔽技能特效， 0：不屏蔽；1：屏蔽	
      shield_rela = 0,                        %% 屏蔽好友请求，0：不屏蔽；1：屏蔽	
      shield_team = 0,                        %% 屏蔽组队邀请，0：不屏蔽；1：屏蔽	
      shield_chat = 0,                        %% 屏蔽聊天传闻，0：不屏蔽；1：屏蔽	
      music = 50,                             %% 游戏音乐，默认值为50	
      soundeffect = 50,                       %% 游戏音效，默认值为50	
      fasheffect = 0                          %% 时装显示(0对别人显示，1对别人不显示)	
    }).	
	
%% 玩家反馈	
%% feedback ==> feedback 	
-record(feedback, {	
      id,                                     %% ID	
      type = 1,                               %% 类型(1-Bug/2-投诉/3-建议/4-其它)	
      state = 0,                              %% 状态(已回复1/未回复0)	
      player_id = 0,                          %% 玩家ID	
      player_name = "",                       %% 玩家名	
      title = "",                             %% 标题	
      content,                                %% 内容	
      timestamp = 0,                          %% Unix时间戳	
      ip = "",                                %% 玩家IP	
      server = "",                            %% 服务器	
      gm = "",                                %% 游戏管理员	
      reply,                                  %% 回复内容[{NickContent}....],	
      reply_time = 0                          %% 回复时间	
    }).	
	
%% 战斗属性表	
%% temp_combat_attr ==> temp_combat_attr 	
-record(temp_combat_attr, {	
      level = 0,                              %% 等级	
      career = 0,                             %% 对人是职业，对怪物是类型。	
      exp = 0,                                %% 对人是升级所需经验，对怪是产出经验。	
      hit_point_max = 0,                      %% 生命上限	
      magic_max = 0,                          %% 法力上限	
      combopoint_max = 0,                     %% 最大连击点数	
      anger_max = 0,                          %% 怒气值上限	
      attack = 0,                             %% 普通攻击力	
      abs_damage = 0,                         %% 绝对伤害值	
      ndefense = 0,                           %% 普通防御力	
      fattack = 0,                            %% 仙攻值	
      mattack = 0,                            %% 魔攻值	
      dattack = 0,                            %% 妖攻值	
      fdefense = 0,                           %% 仙防值	
      mdefense = 0,                           %% 魔防值	
      ddefense = 0,                           %% 妖防值	
      speed = 0,                              %% 移动速度	
      attack_speed = 0,                       %% 攻击速度	
      hit = 0,                                %% 命中等级	
      dodge = 0,                              %% 闪避等级	
      crit = 0,                               %% 暴击等级	
      tough = 0,                              %% 坚韧等级	
      frozen_resis_per = 0,                   %% 冰冻抗性率	
      weak_resis_per = 0,                     %% 虚弱抗性率	
      flaw_resis_per = 0,                     %% 破绽抗性率	
      poison_resis_per = 0                    %% 中毒抗性率	
    }).	
	
%% 物品基础表	
%% temp_goods ==> temp_goods 	
-record(temp_goods, {	
      gtid = 0,                               %% 物品类型编号	
      name = "",                              %% 物品名称	
      icon = 0,                               %% 物品资源ID	
      fall = 0,                               %% 物品掉落外观ID	
      type = 0,                               %% 物品类型(参考宏定义)	
      quality,                                %% 品质，决定了物品名称颜色	
      price_type = 0,                         %% 价格类型：1 铜钱 2 金币,	
      sell_price = 0,                         %% 物品出售价格	
      career = 0,                             %% 职业限制，0为不限	
      gender = 0,                             %% 性别限制，0为不限	
      level = 0,                              %% 等级限制，0为不限	
      max_num = 0,                            %% 可叠加数，0为不可叠加	
      limit = 0,                              %% 限制条件，0不限制 1捡取绑定 2装备绑定 4不能出售	
      expire_time = 0,                        %% 有效期，0为不限，单位为秒	
      set_id = 0,                             %% 套装ID，0为不是套装	
      descr = "",                             %% 物品描述信息	
      special = ""                            %% 特殊字段	
    }).	
	
%% temp_item_equipment	
%% temp_item_equipment ==> temp_item_equipment 	
-record(temp_item_equipment, {	
      gtid = 0,                               %% 物品类型编号	
      icon = 0,                               %% 装备外观	
      set_id = 0,                             %% 套装编号	
      hit_point = 0,                          %% 附加生命值	
      defense = 0,                            %% 附加普防值	
      attack = 0,                             %% 附加普攻值	
      fattack = 0,                            %% 附加仙攻值	
      mattack = 0,                            %% 附加魔攻值	
      dattack = 0,                            %% 附加妖攻值	
      fdefense = 0,                           %% 附加仙防值	
      mdefense = 0,                           %% 附加魔防值	
      ddefense = 0,                           %% 附加妖防值	
      hit = 0,                                %% 附加命中等级	
      dodge = 0,                              %% 附加闪避等级	
      crit = 0,                               %% 附加暴击等级	
      tough = 0,                              %% 附加韧性等级	
      abs_damage = 0                          %% 附加绝对伤害值	
    }).	
	
%% 宝石属性	
%% temp_item_gem ==> temp_item_gem 	
-record(temp_item_gem, {	
      gtid = 0,                               %% 物品ID	
      hit_point = 0,                          %% 附加生命值	
      attack = 0,                             %% 附加普攻值	
      fattack = 0,                            %% 附加仙攻值	
      mattack = 0,                            %% 附加魔攻值	
      dattack = 0,                            %% 附加妖攻值	
      defense = 0,                            %% 附加普防值	
      fdefense = 0,                           %% 附加仙防值	
      mdefense = 0,                           %% 附加魔防值	
      ddefense = 0                            %% 附加妖防值	
    }).	
	
%% 宝石神炼属性	
%% temp_item_holy_gem ==> temp_item_holy_gem 	
-record(temp_item_holy_gem, {	
      gtid = 0,                               %% 编号	
      hit_point = 0,                          %% 附加生命值	
      attack = 0,                             %% 附加普攻值	
      fattack = 0,                            %% 附加仙攻值	
      mattack = 0,                            %% 附加魔攻值	
      dattack = 0,                            %% 附加妖攻值	
      defense = 0,                            %% 附加普防值	
      fdefense = 0,                           %% 附加仙防值	
      mdefense = 0,                           %% 附加魔防值	
      ddefense = 0                            %% 附加妖防值	
    }).	
	
%% 套装物品表	
%% temp_item_set ==> temp_item_set 	
-record(temp_item_set, {	
      setid = 0,                              %% 套装编号	
      name = "",                              %% 套装名	
      goods_list = [],                        %% 套装物品ID列表	
      effect_list = []                        %% 套装效果列表	
    }).	
	
%% 怪物刷新	
%% temp_mon_layout ==> temp_mon_layout 	
-record(temp_mon_layout, {	
      scene_id = 0,                           %% 场景ID	
      monid = 0,                              %% 怪物ID	
      x = 0,                                  %% X坐标	
      y = 0,                                  %% Y坐标	
      towards = 0,                            %% 朝向	
      state = 0,                              %% 怪物状态：1-正常，2-战斗中，3-追击，4-死亡。	
      revive_time = 0,                        %% 死亡后复活时间	
      monrcd = <<"{}">>,                      %% 怪物实例结构，配置的时候不用填	
      combatattrrcd = <<"{}">>,               %% 怪物战斗属性实例，配置的时候不用填	
      id = 0                                  %% 怪物唯一标识(场景ID+怪物ID+**).配置的时候不用填	
    }).	
	
%% 通知消息	
%% temp_notice ==> temp_notice 	
-record(temp_notice, {	
      noticeid = 0,                           %% 消息ID	
      noticetext = "",                        %% 消息内容	
      noticelv = 0,                           %% 通知等级	
      type = 0                                %% 类型	
    }).	
	
%% NPC基础表	
%% temp_npc ==> temp_npc 	
-record(temp_npc, {	
      nid = 0,                                %% NPC编号	
      name = "",                              %% 字名	
      title = "",                             %% 称号	
      icon = 0,                               %% 怪物或者NPC形象	
      head = 0,                               %% 怪物或者NPC头像	
      model = 0,                              %% NPC头顶图片资源	
      npc_type = 0,                           %% 类型：10-NPC;11-采集怪;20-普通小怪;21-精英怪物;22-野外BOS;23-世界BOSS;24-副本小怪;25-副本BOSS;30-宠物;40-坐骑	
      level = 0,                              %% 怪物等级	
      fire_range = 0,                         %% 追击范围(格子距离)	
      warn_range = 0,                         %% 警介范围(格子距离)	
      shop_id = 0,                            %% 商店ID	
      hit_point = 0,                          %% 生命值	
      magic = 0,                              %% 法力值上限	
      fall_goods = [],                        %% 掉落物品编号[{IDNUMBER}],	
      act_skilllist = [],                     %% 被动技能列表[ID]	
      pas_skilllist = []                      %% 主动技能列表 [ID]	
    }).	
	
%% NPC刷新	
%% temp_npc_layout ==> temp_npc_layout 	
-record(temp_npc_layout, {	
      scene_id = 0,                           %% 场景ID	
      npcid = 0,                              %% NPCID	
      x = 0,                                  %% X坐标	
      y = 0,                                  %% Y坐标	
      towards = 0,                            %% 朝向	
      npcrcd = <<"{}">>,                      %% NPC实例，配置的时候不用填	
      id = 0                                  %% NPC唯一ID 配置的时候不用填	
    }).	
	
%% 场景数据结构	
%% temp_scene ==> temp_scene 	
-record(temp_scene, {	
      sid,                                    %% 场景id	
      name = "",                              %% 场景名称	
      icon = 0,                               %% 场景资源编号	
      mode = 0,                               %% 地图模式：\r\n默认为1\r\n1-新手村 \r\n2-野外 \r\n3-主城 \r\n4-副本 \r\n5-跨服副本 	
      type = 1,                               %% 地图类型：多种类型可以共存\r\n0-表示都不可以\r\n1-可以PK\r\n2-可以原地复活\r\n4-可以吃瞬加药\r\n8-可以使用小飞鞋传送	
      pk_mode = 1,                            %% 0-不强制pk模式\r\n1-强制和平模式\r\n2-强制自由pk模式\r\n3-强制帮会pk模式	
      level_limit = 0,                        %% 进入等级限制	
      x = 0,                                  %% 进入后默认x坐标	
      y = 0,                                  %% 进入后默认y坐标	
      poem = <<"0">>,                         %% 进入诗词	
      loading = 0,                            %% 调用Loading图	
      revive_sid = 0,                         %% 复活场景	
      revive_x = 0,                           %% 复活X坐标	
      revive_y = 0,                           %% 复活Y坐标	
      npc = [],                               %% NPC	
      id = 0                                  %% 场景实例唯一标识	
    }).	
	
%% 角色基本信息	
%% temp_player ==> temp_player 	
-record(temp_player, {	
      career = 0,                             %% 职业	
      level = 1,                              %% 等级	
      exp = 0,                                %% 升级经验	
      hit_point_max = 0,                      %% 生命上限	
      magic_max = 0,                          %% 法力值上限	
      anger_max = 0,                          %% 怒气值上限	
      attack = 0,                             %% 普通攻击力	
      defense = 0,                            %% 普通防御力	
      abs_damage = 0,                         %% 绝对伤害值	
      fattack = 0,                            %% 仙攻值	
      mattack = 0,                            %% 魔攻值	
      dattack = 0,                            %% 妖攻值	
      fdefense = 0,                           %% 仙防值	
      mdefense = 0,                           %% 魔防值	
      ddefense = 0,                           %% 妖防值	
      speed = 0,                              %% 移动速度	
      attack_speed = 0                        %% 攻击速度	
    }).	
