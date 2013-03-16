%%%------------------------------------------------	
%%% File    : table_to_record.erl	
%%% Author  : smxx	 
%%% Created : 2013-03-15 16:55:20	 
%%% Description: 从mysql表生成的record	
%%% Warning:  由程序自动生成，请不要随意修改！	
%%%------------------------------------------------		
 	
	
%% 服务器列表	
%% server ==> server 	
-record(server, {	
      id = 0,                                 %% 编号Id	
      domain = 1,                             %% 分区号	
      ip = "",                                %% ip地址	
      port = 0,                               %% 端口号	
      node = "",                              %% 节点	
      num = 0,                                %% 节点用户数	
      stop_access = 0,                        %% 是否停止登陆该节点，0为可以登录，1为停止登陆	
      start_time = 0,                         %% 开服时间	
      state = 0                               %% 1-新开；2-火爆；3-良好；4-流畅；5-维护。	
    }).	
	
%% server_config	
%% server_config ==> server_config 	
-record(server_config, {	
      id = 0,                                 %% 编号Id	
      name = ""                               %% 服务器名字	
    }).	
	
%% server_player	
%% server_player ==> server_player 	
-record(server_player, {	
      uid = 0,                                %% 玩家ID，全平台唯一	
      accid = 0,                              %% 玩家Id	
      serv_id = 0,                            %% 服务器标识	
      domain = 0,                             %% 大区标识	
      acc_name = "",                          %% 账号名字	
      nick = "",                              %% 角色名字	
      sex = 0,                                %% 角色性别	
      career = 0,                             %% 角色职业	
      lv = 0,                                 %% 角色等级	
      icon = 0,                               %% 图标	
      last_login = 0                          %% 最后登录时间	
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
      logout_time = 0,                        %% 上次离线时间	
      last_login_time = 0,                    %% 最后登陆时间	
      last_login_ip = "",                     %% 最后登陆IP	
      status = 0,                             %% 玩家状态（0正常、1禁止、2战斗中、3死亡、4挂机、5打坐）	
      gender = 1,                             %% 性别 1男 2女	
      career = 0,                             %% 职业(0:未定义，1: 神 2:魔 3:妖)	
      gold = 0,                               %% 元宝	
      bgold = 0,                              %% 绑定元宝	
      coin = 0,                               %% 铜钱	
      bcoin = 0,                              %% 绑定铜钱	
      vip = 0,                                %% VIP类型，0不是VIP，其他参考common.hrl	
      vip_expire_time = 0,                    %% VIP过期时间(秒)	
      scene = 0,                              %% 场景ID	
      cell_num = 0,                           %% 背包格子数	
      level = 1,                              %% 等级	
      exp = 0,                                %% 经验	
      online_flag = 0,                        %% 在线标记，0不在线 1在线	
      resolut_x = 0,                          %% 分辨率 X	
      resolut_y = 0,                          %% 分辨率 Y	
      liveness = 0,                           %% 活跃度	
      camp = 0,                               %% 阵营(国籍)	
      lilian = 0,                             %% 历练值	
      switch = 0,                             %% 状态开关码1:功能开 0:功能关，位定义参考common.hrl	
      guild_id = 0,                           %% 派帮ID(无帮派:0)	
      guild_name = "",                        %% 帮派名称	
      guild_post = 0,                         %% 帮派职位(0为小兵)	
      battle_attr = [],                       %% 战斗结构体	
      other = 0                               %% 其他信息	
    }).	
	
%% 玩家物品记录	
%% goods ==> goods 	
-record(goods, {	
      id,                                     %% 玩家物品Id	
      uid = 0,                                %% 玩家ID	
      pet_id = 0,                             %% 宠物Id（装备穿在宠物身上时对应的武将唯一Id）	
      gtid = 0,                               %% 物品类型编号	
      location = 0,                           %% 物品所在位置	
      cell = 0,                               %% 物品所在格子位置	
      num = 0,                                %% 物品数量	
      score = 0,                              %% 装备评分：非装备用0表示	
      hole = 0,                               %% 镶孔数	
      hole_goods = [],                        %% 孔所镶物品类型ID	
      polish_num = 0,                         %% 洗练次数	
      stren_lv = 0,                           %% 强化等级	
      stren_percent = 0,                      %% 强化完美度	
      type = 0,                               %% 物品类型(参考宏定义)	
      subtype = 0,                            %% 物品子类型(参考宏定义)	
      quality,                                %% 品质，决定了物品名称颜色1:白色，2：绿色，3：蓝色，4：紫色，5：橙色	
      sell_price = 0,                         %% 物品出售价格	
      career = 0,                             %% 职业限制，0为不限	
      gender = 0,                             %% 性别限制，0为女，1为男，2为男女不限	
      level = 0,                              %% 等级限制，0为不限	
      max_num = 0,                            %% 可叠加数，0为不可叠加	
      bind = 0,                               %% 绑定状态0不限制,2装备绑定,3已绑定,	
      expire_time = 0,                        %% 有效期，0为不限，单位为秒	
      suit_id = 0,                            %% 套装ID，0为不是套装	
      gilding_lv = 0,                         %% 镀金等级	
      goods_cd = 0                            %% 物品使用cd	
    }).	
	
%% goods_attribute	
%% goods_attribute ==> goods_attribute 	
-record(goods_attribute, {	
      id,                                     %% 编号	
      uid = 0,                                %% 角色ID	
      gid = 0,                                %% 物品编号ID	
      attribute_type = 0,                     %% 属性类型，1 强化，2 强化+4，3 强化+7，5 镶嵌	
      stone_type_id = 0,                      %% 宝石编号ID，无宝石为0	
      attribute_id = 0,                       %% 属性类型Id：0-气血，1-物理攻击。。。	
      value = 0,                              %% 属性值	
      value_type = 0,                         %% 属性值类型，0为数值，1为百分比	
      hole_seq = 0,                           %% 镶嵌宝石孔位置	
      status = 0                              %% 是否生效，1为生效，0为不生效	
    }).	
	
%% 技能	
%% skill ==> skill 	
-record(skill, {	
      uid = 0,                                %% 角色id	
      skill_list = [],                        %% 已学习的技能ID列表[{SkillId Level}],	
      cur_skill_list = []                     %% 当前正在使用的技能的ID[{SkillId Level},...],	
    }).	
	
%% 玩家系统设置	
%% system_config ==> system_config 	
-record(system_config, {	
      uid = 0,                                %% 玩家Id	
      shield_role = 0,                        %% 蔽屏附近玩家和宠物，0：不屏蔽；1：屏蔽	
      shield_skill = 0,                       %% 屏蔽技能特效， 0：不屏蔽；1：屏蔽	
      shield_rela = 0,                        %% 屏蔽好友请求，0：不屏蔽；1：屏蔽	
      shield_team = 0,                        %% 屏蔽组队邀请，0：不屏蔽；1：屏蔽	
      shield_chat = 0,                        %% 屏蔽聊天传闻，0：不屏蔽；1：屏蔽	
      fasheffect = 0,                         %% 时装显示(0对别人显示，1对别人不显示)	
      music = 50,                             %% 游戏音乐，默认值为50	
      soundeffect = 50                        %% 游戏音效，默认值为50	
    }).	
	
%% 玩家反馈	
%% feedback ==> feedback 	
-record(feedback, {	
      id,                                     %% ID	
      type = 1,                               %% 类型(1-Bug/2-投诉/3-建议/4-其它)	
      state = 0,                              %% 状态(已回复1/未回复0)	
      uid = 0,                                %% 玩家ID	
      name = "",                              %% 玩家名	
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
      defense = 0,                            %% 普通防御力	
      fattack = 0,                            %% 仙攻值	
      mattack = 0,                            %% 魔攻值	
      dattack = 0,                            %% 妖攻值	
      fdefense = 0,                           %% 仙防值	
      mdefense = 0,                           %% 魔防值	
      ddefense = 0,                           %% 妖防值	
      speed = 0,                              %% 移动速度	
      attack_speed = 0,                       %% 攻击速度	
      hit_ratio = 0,                          %% 命中率(万分比)	
      dodge_ratio = 0,                        %% 闪避率(万分比)	
      crit_ratio = 0,                         %% 暴击率(万分比)	
      tough_ratio = 0,                        %% 坚韧率(万分比)	
      frozen_resis_ratio = 0,                 %% 冰冻抗性率(万分比)	
      weak_resis_ratio = 0,                   %% 虚弱抗性率(万分比)	
      flaw_resis_ratio = 0,                   %% 破绽抗性率(万分比)	
      poison_resis_ratio = 0                  %% 中毒抗性率(万分比)	
    }).	
	
%% 物品基础表	
%% temp_goods ==> temp_goods 	
-record(temp_goods, {	
      gtid = 0,                               %% 物品类型编号	
      name = "",                              %% 物品名称	
      icon = 0,                               %% 物品图标资源ID	
      fall = 0,                               %% 物品掉落在地图标ID	
      type = 0,                               %% 物品类型(参考宏定义)	
      subtype = 0,                            %% 物品子类型(参考宏定义)	
      quality,                                %% 品质，决定了物品名称颜色1:白色，2：绿色，3：蓝色，4：紫色，5：橙色	
      sell_price = 0,                         %% 物品出售价格	
      career = 0,                             %% 职业限制，0为不限	
      gender = 0,                             %% 性别限制，0为女，1为男，2为男女不限	
      level = 0,                              %% 等级限制，0为不限	
      max_num = 0,                            %% 可叠加数	
      limit = 0,                              %% 限制条件，0不限制 1捡取绑定 2装备绑定 4不能出售	
      expire_time = 0,                        %% 有效期，0为不限，单位为秒	
      suit_id = 0,                            %% 套装ID，0为不是套装	
      cd = 0,                                 %% cd	
      desc = ""                               %% 物品描述信息	
    }).	
	
%% temp_item_equipment	
%% temp_item_equipment ==> temp_item_equipment 	
-record(temp_item_equipment, {	
      gtid = 0,                               %% 物品类型编号	
      appearance = 0,                         %% 装备外观	
      set_id = 0,                             %% 套装编号	
      max_stren = 0,                          %% 最大强化等级	
      equip_attr = [],                        %% 装备属性	
      stren_change = [],                      %% 强化后换装	
      max_holes = 0,                          %% 镶嵌孔上限	
      max_gilding = 0                         %% 镀金上限	
    }).	
	
%% 宝石属性	
%% temp_item_gem ==> temp_item_gem 	
-record(temp_item_gem, {	
      gtid = 0,                               %% 物品ID	
      coin_num = 0,                           %% 消耗铜钱	
      attri_add = <<"{}">>                    %% 属性加成	
    }).	
	
%% temp_item_suit	
%% temp_item_suit ==> temp_item_suit 	
-record(temp_item_suit, {	
      suit_id = 0,                            %% 套装编号	
      suit_num = 0,                           %% 套装件数	
      name = "",                              %% 套装名	
      goods_list = [],                        %% 套装物品ID列表[gdid1gtid2],	
      effect_list = []                        %% 套装效果列表[{hit_ponit_maxnumbner},],	
    }).	
	
%% temp_mon_layout	
%% temp_mon_layout ==> temp_mon_layout 	
-record(temp_mon_layout, {	
      scene_id = 0,                           %% 场景ID	
      monid = 0,                              %% 怪物ID	
      x = 0,                                  %% 出生X坐标	
      y = 0,                                  %% 出生Y坐标	
      towards = 0,                            %% 1.北；2.东北；3.东；4.东南；5.南；6.西南；7.西；8.西北	
      revive_time = 0,                        %% 怪物死亡后的复活时长	
      state = 0,                              %% 怪物状态：1-正常，2-战斗中，3-追击，4-死亡。	
      pos_x = 0,                              %% 当前位置的X左边	
      pos_y = 0,                              %% 当前位置的Y左边	
      attack_skill = 0,                       %% 攻击技能	
      skill_lv = 0,                           %% 技能等级	
      refresh_time = 0,                       %% 下次需要刷新的时间	
      last_move_time = 0,                     %% 上次移动的时间	
      move_time = 00000000000,                %% 移动时间间隔一个范围内的随机值,	
      move_path = 00000000000,                %% 上次移动的路径	
      hate_list = "",                         %% 怪物的仇恨列表[{UIDDAMAGE,ADDTIME}],	
      buff_list = "",                         %% 怪物的BUFF列表[{BUFFIDExpireTime}],	
      begin_sing,                             %% 开始吟唱时间	
      monrcd = <<"{}">>,                      %% 怪物配置结构，配置的时候不用填	
      battle_attr = <<"{}">>,                 %% 战斗属性战斗属性，玩家不用填	
      target_uid = 0,                         %% 主动怪物，被动怪物的攻击 目标玩家ID	
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
      half_length = 0,                        %% NPC半身原画(在玩家点击打开NPC对话时显示的资源)	
      npc_type = 0,                           %% 类型：10-NPC;11-采集怪;20-普通小怪;21-精英怪物;22-副本小怪;30-野外BOS;31-世界BOSS;32-副本BOSS;33-帮派BOSS;40-宠物;50-坐骑	
      level = 0,                              %% 怪物等级	
      fire_range = 0,                         %% 追击范围(格子距离)	
      warn_range = 0,                         %% 警介范围(格子距离)为0 的时候是被动怪物，大于0是主动怪物	
      hit_point = 0,                          %% 生命值	
      magic = 0,                              %% 法力值上限	
      greeting = [],                          %% 怪物招呼语(怪物自说自话)	
      dialog = [],                            %% NPC无任务的时候点击显示	
      func = [],                              %% \r\n此处填写NPC的功能：\r\n1-挂接挂接商店（对应是shopid）\r\n2-挂接水月洞天副本（对应是mapid）\r\n3-挂接圣兽山（对应是mapid）\r\n……\r\n\r\n填写方式：[{1shopid,打开药店}，{2,mapid,进入水月洞天}，{3,mapid,进入圣兽山},……]\r\n第一个参数代表功能编号，第二个参数根据功能填入不同的编号（1时填商店编号，2、3、4、……填地图编号），第三个参数填功能的描述文字,	
      drop_id = 0,                            %% 掉落ID(temp_drop_main.did) 需要广播到场景中掉落物品	
      output_id = 0,                          %% 产出的掉落(temp_drop_main.did) 根据不同的怪物类型决定发给具体的角色	
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
      towards = 0,                            %% 1.北；2.东北；3.东；4.东南；5.南；6.西南；7.西；8.西北	
      npcrcd = <<"{}">>,                      %% NPC实例，配置的时候不用填	
      id = 0                                  %% NPC唯一ID 配置的时候不用填	
    }).	
	
%% 场景数据结构\r\n1、基础	
%% temp_scene ==> temp_scene 	
-record(temp_scene, {	
      sid,                                    %% 场景id	
      name = "",                              %% 场景名称	
      icon = 0,                               %% 场景资源编号	
      mode = 0,                               %% 地图模式：\r\n默认为1 \r\n1-新手村 \r\n2-野外 \r\n3-主城 \r\n4-副本 \r\n5-跨服副本 	
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
      size = 10000,                           %% 万分比。填写10000则为不缩放。此处缩放比例只对场景中的玩家角色有效（包括宠物、站骑等）	
      npc = [],                               %% NPC	
      scene_num = 0,                          %% 该基础场景的进程数	
      id = 0                                  %% 场景实例唯一标识	
    }).	
	
%% 技能数据	
%% temp_skill ==> temp_skill 	
-record(temp_skill, {	
      sid = 0,                                %% 技能编号	
      name = "",                              %% 技能名称	
      icon = 0,                               %% 技能资源编号	
      type = 0,                               %% 技能类型(0:普通(单体攻击)，1:单体攻击 2:群体攻击 3: 单体辅助 4:群体辅助)	
      stype = 0,                              %% 子类型0：没要求， 1 玩家技能 2 怪的技能	
      career = 0,                             %% 职业要求，0为不要求。1战士，2法师， 3射手	
      distance = 0,                           %% 技能释放距离	
      aoe_dist = 0,                           %% 技能AOE距离	
      aoe_tnum = 0,                           %% 技能AOE目标数量	
      cd_all = 0,                             %% 技能CD(毫秒)，对所有技能	
      cd_group = [],                          %% 技能CD组(毫秒)，对指定技能[{SkillId CdTime},...]。,	
      sing_time = 0,                          %% 吟唱时间(毫秒)	
      sing_break = 0,                         %% 吟唱状态可否中断(1可，0木)	
      description = "",                       %% 技能描述	
      use_combopoint = 0                      %% 是否消耗连击点(0为不消耗 1为消耗),	
    }).	
	
%% temp_buff	
%% temp_buff ==> temp_buff 	
-record(temp_buff, {	
      buff_id = 0,                            %% BuffID	
      name = <<"杂技">>,                    %% Buff名字	
      type = 0,                               %% Buff类型(1增减属，2扣血加血，3特殊状态(不能移动)，4特殊状态(不能使用技能)，5特殊状态(石化)，6经验加成，7气血包，8法力包，9情缘Buff，10改变外观	
      group = 0,                              %% BUFF组	
      priority = 0,                           %% 同组BUFF应用优先级	
      last_time = 0,                          %% 持续时间（毫秒）	
      times = 0,                              %% 作用次数	
      ratio = 10000,                          %% 成功概率(10000为一定成功)	
      link_skill = [],                        %% 挂接技能(对其他玩家起作用)[{SkillId Lv}],	
      overlay = 0,                            %% BUFF是否可以叠加1可以，0不可以	
      max_num = 0,                            %% 最大叠加数量	
      data = []                               %% Buff效果列表[{Key Value},...],	
    }).	
	
%% 技能属性	
%% temp_skill_attr ==> temp_skill_attr 	
-record(temp_skill_attr, {	
      sid = 0,                                %% 技能ID	
      level = 0,                              %% 等级	
      require_list = [],                      %% 学习技能需要技能列表[{SkilId Level},...],	
      learn_level = 0,                        %% 学习技能需要玩家等级	
      cost_lilian = 0,                        %% 升级需要历练值	
      cost_coin = 0,                          %% 升级需要铜钱值	
      cost_magic = 0,                         %% 技能需要消耗法力值	
      cost_anger = 0,                         %% 使用需要的怒气值	
      abs_damage = 0,                         %% 技能附加的绝对伤害值	
      buff = []                               %% 技能BUFF[BuffId...],	
    }).	
	
%% 玩家座骑记录	
%% mount ==> mount 	
-record(mount, {	
      uid = 0,                                %% 玩家ID	
      state = 0,                              %% 状态1:骑 2休息	
      exp = 0,                                %% 经验值	
      level = 0,                              %% 等级(阶)	
      star = 0,                               %% 星级(最大10星)	
      fashion = 0,                            %% 当前幻化	
      skill_times = 0,                        %% 技能升级次数	
      skill_list = [],                        %% 技能列表[{SkillId Lv, Exp},...],	
      fashion_list = [],                      %% 幻化列表[{Fid Expired},...], Fid幻化ID, Expire过期时间,	
      old_fashion_list = []                   %% 过期幻化列表	
    }).	
	
%% 关系列表	
%% relation ==> relation 	
-record(relation, {	
      uid = 0,                                %% 玩家id	
      bless_times = 0,                        %% 今天祝福次数	
      max_friend = 0,                         %% 最大好友数目	
      max_foe = 0,                            %% 最大仇人数目	
      friend_list = [],                       %% 好友列表格式 [{Uid FriendShip, Name, Career, Gender}, ...], FirendShip 友好度,	
      foe_list = [],                          %% 仇人列表格式 [{Uid Hostitily, Name, Career, Gender}, ...], Hostitily 仇恨度,	
      recent_list = []                        %% 最近联系人列表格式 [{Uid Time, Name, Career, Gender}, ...], Time 最近一次发生关系时间(秒),	
    }).	
	
%% temp_drop_main	
%% temp_drop_main ==> temp_drop_main 	
-record(temp_drop_main, {	
      did,                                    %% 	
      dropitem = []                           %% 随机掉落实例ID	
    }).	
	
%% temp_drop_sub	
%% temp_drop_sub ==> temp_drop_sub 	
-record(temp_drop_sub, {	
      sid,                                    %% 	
      dropitem = []                           %% 	
    }).	
	
%% 任务表	
%% temp_task ==> tpl_task 	
-record(tpl_task, {	
      tid = 0,                                %% 任务编号	
      type = 0,                               %% 任务类型(见task.hrl)	
      start_npc = 0,                          %% 开始NPC	
      start_scene = 0,                        %% 开始场景	
      end_npc = 0,                            %% 结束NPC	
      end_scene = 0,                          %% 结束场景	
      target_type = 0,                        %% 任务目标类型	
      target_property = <<"0">>,              %% 任务目标数量[[idfin_num,begin_num]],	
      name = "",                              %% 任务名称	
      desc = "",                              %% 任务描述	
      ongoing_dialog = <<"""">>,              %% 未完成任务对白	
      finish_dialog,                          %% 完成任务对白，格式为：[{NPC对白}{角色对白}]，若角色不说话，则格式为：[{NPC对白}],	
      pre_tid = 0,                            %% 要求前置任务编号	
      level = 0,                              %% 等级限制	
      career = 0,                             %% 职业限定(0:不限，其他为对应职业)	
      gender = 0,                             %% 性别限定(0:不限，其他为对应性别)	
      guild = 0,                              %% 家族限定(0:不限，1:有家族才能接)	
      team = 0,                               %% 组队限定(0：不限，1：组队才能做)	
      goods_list = [],                        %% 任务可选奖励物品列表[{标识类型(0:无标识 1:以职业为标识)类型编号,奖品id,奖品数量}..],	
      guild_goods_list = [],                  %% 任务奖励帮派资源列表	
      func_num = 0,                           %% 任务目标类型(前段用)	
      next_tid                                %% 下一级任务id	
    }).	
	
%% task_detail	
%% task_detail ==> task_detail 	
-record(task_detail, {	
      task_type,                              %% 任务类型	
      can_cyc,                                %% 是否支持循环 0:不支持 1:支持	
      trigger_time,                           %% 可触发轮数	
      cycle_time,                             %% 每轮可触发次数	
      meanw_trigger,                          %% 每次可同时触发任务数	
      time_limit,                             %% 时间段限制	
      reset_time,                             %% 重置时间	
      coin = 0                                %% 自动完成任务所需的元宝	
    }).	
	
%% task_finish	
%% task_finish ==> task_finish 	
-record(task_finish, {	
      id,                                     %% ID	
      uid = 0,                                %% 玩家ID	
      td1 = [],                               %% 1-10级任务ID	
      td2 = [],                               %% 11-20级任务ID	
      td3 = [],                               %% 21-30级任务ID	
      td4 = [],                               %% 31-40级任务ID	
      td5 = [],                               %% 41-50级任务ID	
      td6 = [],                               %% 51-60级任务ID	
      td7 = [],                               %% 61-70级任务ID	
      td = []                                 %% 任务ID	
    }).	
	
%% task_process	
%% task_process ==> task_process 	
-record(task_process, {	
      id,                                     %% 	
      uid,                                    %% 玩家id	
      tid,                                    %% 任务模板id	
      state,                                  %% 任务状态	
      trigger_time,                           %% 触发时间	
      type,                                   %% 任务类型	
      mark                                    %% 任务进度	
    }).	
	
%% daily_task_finish	
%% daily_task_finish ==> daily_task_finish 	
-record(daily_task_finish, {	
      uid,                                    %% 玩家id	
      type,                                   %% 任务类型	
      state,                                  %% 任务状态	
      count_detail,                           %% 本日可用轮数{可用轮数，已用轮数}	
      cycle_datil,                            %% 每轮可用次数 {可触发次数已触发次数},	
      trigger_detail,                         %% 每次触发任务数{每次可同时触发任务数已触发任务数},	
      reset_time = 0,                         %% 上次重置时间	
      total,                                  %% 总完成次数	
      trigger_time                            %% 触发时间	
    }).	
	
%% temp_stren	
%% temp_stren ==> temp_stren 	
-record(temp_stren, {	
      stren_lv,                               %% 强化等级	
      add_percent,                            %% 附加属性比例	
      goods = [],                             %% 消耗物品编号数量[{强化石id,强化石数量},{铜钱id,铜钱数量}],	
      cost_coin = 0,                          %% 消耗铜钱	
      stren_rate,                             %% 强化基础成功率	
      stren_succ = [],                        %% 强化成功等级增加区间	
      stren_fail = [],                        %% 强化失败等级掉落区间	
      add_succ_rate,                          %% 强化失败后，下次强化成功率增加值	
      add_holes = 0,                          %% 新增插槽	
      desc                                    %% 备注	
    }).	
	
%% temp_compose	
%% temp_compose ==> temp_compose 	
-record(temp_compose, {	
      target_gtid,                            %% 目标物品类型id	
      gtid,                                   %% 源材料物品类型id	
      goods_num,                              %% 消耗材料数量	
      cost_coin                               %% 消耗铜钱数量	
    }).	
	
%% temp_polish	
%% temp_polish ==> temp_polish 	
-record(temp_polish, {	
      gtid,                                   %% 装备ID	
      polish_value = []                       %% 洗炼属性列表	
    }).	
	
%% temp_upgrade	
%% temp_upgrade ==> temp_upgrade 	
-record(temp_upgrade, {	
      gtid,                                   %% 当前物品id	
      goods,                                  %% 配方	
      cost_coin = 0,                          %% 消耗铜钱	
      target_gtid                             %% 目标物品id	
    }).	
	
%% temp_all_stren_reward	
%% temp_all_stren_reward ==> temp_all_stren_reward 	
-record(temp_all_stren_reward, {	
      stren_lv,                               %% 强化等级	
      stren_reward                            %% 强化属性加成	
    }).	
	
%% casting_polish	
%% casting_polish ==> casting_polish 	
-record(casting_polish, {	
      gid = 0,                                %% 装备ID	
      uid = 0,                                %% 玩家ID	
      cur_attri = [],                         %% 当前洗炼属性	
      new_attri = []                          %% 新洗炼属性	
    }).	
	
%% temp_polish_goods	
%% temp_polish_goods ==> temp_polish_goods 	
-record(temp_polish_goods, {	
      quality,                                %% 品质，决定了物品名称颜色1:白色，2：绿色，3：蓝色，4：紫色，5：橙色	
      max_polish,                             %% 最大洗练条数	
      goods = [],                             %% 消耗品	
      cost_coin = 0                           %% 消耗铜钱	
    }).	
	
%% temp_suit_reward	
%% temp_suit_reward ==> temp_suit_reward 	
-record(temp_suit_reward, {	
      suit_id,                                %% 套装id	
      num,                                    %% 套装件数	
      add_value = []                          %% 属性加成	
    }).	
	
%% temp_all_gem_reward	
%% temp_all_gem_reward ==> temp_all_gem_reward 	
-record(temp_all_gem_reward, {	
      gem_num,                                %% 全身宝石个数	
      add_value = []                          %% 属性加成	
    }).	
	
%% temp_gilding	
%% temp_gilding ==> temp_gilding 	
-record(temp_gilding, {	
      gilding_lv,                             %% 镀金等级	
      equip_subtype,                          %% 镀金等级	
      add_value = [],                         %% 附加属性	
      goods = [],                             %% 消耗物品	
      cost_coin = 0                           %% 消耗铜钱	
    }).	
	
%% temp_gold_bag	
%% temp_gold_bag ==> temp_gold_bag 	
-record(temp_gold_bag, {	
      cell_num = 0,                           %% 	
      gold_num = 0                            %% 	
    }).	
	
%% temp_level_bag	
%% temp_level_bag ==> temp_level_bag 	
-record(temp_level_bag, {	
      level = 0,                              %% 	
      cell_num                                %% 	
    }).	
	
%% temp_vip_bag	
%% temp_vip_bag ==> temp_vip_bag 	
-record(temp_vip_bag, {	
      vip_gtid = 0,                           %% 	
      cell_num                                %% 	
    }).	
	
%% temp_god_tried	
%% temp_god_tried ==> temp_god_tried 	
-record(temp_god_tried, {	
      target_tid = 0,                         %% 神炼宝石	
      stone_tid,                              %% 宝石	
      god_stone_tid,                          %% 神炼石	
      cost_coin                               %% 消耗铜钱	
    }).	
	
%% guild	
%% guild ==> guild 	
-record(guild, {	
      id,                                     %% 帮派编号	
      name = "",                              %% 帮派名称	
      chief_id = 0,                           %% 帮主角色	
      chief_name = "",                        %% 帮主名字	
      announce = "",                          %% 帮派公告	
      level = 0,                              %% 帮派等级	
      current_num = 0,                        %% 当前人数	
      elite_num = 0,                          %% 当前长老数	
      devo = 0,                               %% 帮派贡献度	
      fund = 0,                               %% 帮派资金	
      upgrade_time = 0,                       %% 最近升级时间	
      create_time = 0,                        %% 创建时间	
      maintain_time = 0,                      %% 下次维护时间	
      state = 0,                              %% 弹劾盟主时为1	
      accuse_id,                              %% 发起弹劾的成员ID	
      accuse_time = 0,                        %% 弹劾到期时间	
      against = 0,                            %% 反对分数	
      agree = 0,                              %% 赞成分数	
      accuse_num = 0                          %% 劾弹次数	
    }).	
	
%% guild_member	
%% guild_member ==> guild_member 	
-record(guild_member, {	
      uid = 0,                                %% 角色ID	
      guild_id = 0,                           %% 帮派ID	
      name = "",                              %% 帮派名称	
      nick = "",                              %% 角色昵称	
      gender = 0,                             %% 性别	
      career = 0,                             %% 职业	
      level = 0,                              %% 玩家等级	
      force = 0,                              %% 玩家战斗力	
      position = 4,                           %% 1帮主 2副帮主 3元老 中间预留 10-帮众(最低)	
      devo = 0,                               %% 总贡献度	
      coin = 0,                               %% 累计捐献铜钱	
      gold = 0,                               %% 累计捐献元宝	
      today_devo = 0,                         %% 今日贡献度	
      devo_time = 0,                          %% 上次捐献时间	
      remain_devo = 0,                        %% 剩余贡献度	
      vote = 0,                               %% 1赞成票2反对票	
      accuse_time = 0,                        %% 投票过期时间	
      title = 0,                              %% 称号等级	
      last_login_time = 0,                    %% 上次登录时间	
      sklist = []                             %% 技能列表[{Id Level}],	
    }).	
	
%% guild_apply	
%% guild_apply ==> guild_apply 	
-record(guild_apply, {	
      uid = 0,                                %% 角色ID	
      guild_id = 0,                           %% 帮派ID	
      nick = "",                              %% 角色昵称	
      gender = 0,                             %% 性别	
      career = 0,                             %% 职业	
      level = 0,                              %% 玩家等级	
      force = 0,                              %% 玩家战斗力	
      timestamp = 0                           %% 申请时间	
    }).	
	
%% buy_npc_shop_log	
%% buy_npc_shop_log ==> buy_npc_shop_log 	
-record(buy_npc_shop_log, {	
      uid,                                    %% 	
      shopid,                                 %% 	
      gtid,                                   %% 	
      buy_num,                                %% 	
      buy_time                                %% 	
    }).	
	
%% temp_npc_shop	
%% temp_npc_shop ==> temp_npc_shop 	
-record(temp_npc_shop, {	
      shop_id,                                %% 商店编号	
      shop_page,                              %% 商店页码	
      shop_type,                              %% 商店类型(0不限购1限购),	
      shop_goods = []                         %% [{购买兑换物品 消耗物品,数量, 限购数量}],	
    }).	
	
%% 物品使用cd	
%% goods_cd ==> goods_cd 	
-record(goods_cd, {	
      id,                                     %% 	
      uid = 0,                                %% 	
      gtid = 0,                               %% 物品类型id	
      expire_time = 0                         %% 过期时间	
    }).	
	
%% temp_meridian	
%% temp_meridian ==> tpl_meridian 	
-record(tpl_meridian, {	
      mer_id,                                 %% 经脉id	
      mer_type = 0,                           %% 经脉类型(1-督脉，2-任脉，3-冲脉，4-带脉，5-阴维，6-阳维，7-阴跷，8-阳跷)	
      mer_lv,                                 %% 经脉等级(1~100)	
      cd_type,                                %% 是否有cd(1有 2无)	
      mer_name,                               %% 经脉名称	
      mer_detail,                             %% 经脉详细[{职业类别属性类型,属性值}...],	
      next_mer_id,                            %% 下一级经脉(-1为无下一级)	
      cd = 0,                                 %% 冷却时间	
      cost_money,                             %% 升级需要的金钱花费	
      cost_Empowerment                        %% 升级需要的历练消费	
    }).	
	
%% temp_bones	
%% temp_bones ==> tpl_bones 	
-record(tpl_bones, {	
      lv,                                     %% 筋骨等级	
      bones_val,                              %% 筋骨值(万分比)	
      probability = 0,                        %% 成功概率	
      extend_pro = 0                          %% 反馈成功概率(根骨提升失败后增加成功概率)	
    }).	
	
%% meridian	
%% meridian ==> meridian 	
-record(meridian, {	
      player_id,                              %% 玩家Id	
      mer_detail_1,                           %% 玩家经脉1详细数据[{MerTypeMerlv}...],	
      mer_detail_2,                           %% 玩家经脉2详细数据[{MerTypeMerlv}...],	
      mer_state,                              %% 玩家修炼经脉阶段{state1 state2},	
      cool_down = <<"{0,0}">>                 %% 剩余的冷却时间 {玩家退出时间戳剩余冷却时间},	
    }).	
	
	
%% bones	
%% bones ==> bones 	
-record(bones, {	
      uid,                                    %% 玩家id	
      bones_info = []                         %% 根骨状况[{根骨等级成功率}...],	
    }).	
	
%% temp_shop	
%% temp_shop ==> temp_shop 	
-record(temp_shop, {	
      shop_tab_page,                          %% 	
      gtid,                                   %% 	
      page,                                   %% 	
      location,                               %% 	
      original_price,                         %% 	
      real_price,                             %% 	
      gold_type = 1,                          %% 0非绑定元宝1绑定元宝,	
      level_limit                             %% 开放等级限制	
    }).	
	
%% buy_shop_log	
%% buy_shop_log ==> buy_shop_log 	
-record(buy_shop_log, {	
      uid,                                    %% 	
      shoptabid,                              %% 	
      gtid,                                   %% 	
      buy_num,                                %% 	
      buy_time                                %% 	
    }).	
	
%% pet	
%% pet ==> pet 	
-record(pet, {	
      uid,                                    %% 	
      template_id = 0,                        %% 宠物模版id	
      name = <<"""">>,                        %% 昵称	
      attack = 0,                             %% 普通攻击力	
      attr_attack = 0,                        %% 属攻	
      attack_type = 1,                        %% 属攻类型:1仙攻2魔攻,3妖攻,	
      hit = 0,                                %% 命中	
      crit = 0,                               %% 暴击	
      fighting = 0,                           %% 战力	
      quality_lv = 1,                         %% 品阶	
      growth_val = 0,                         %% 成长值	
      growth_progress = 0,                    %% 成长进度	
      aptitude_lv = 0,                        %% 资质	
      aptitude_progress = 0,                  %% 资质进度	
      status = 0,                             %% 0休息1参战,	
      skill_hole = 0,                         %% 开启技能槽总数	
      skill_list = [],                        %% 技能ID列表[{Seq SkillId, Level}],	
      create_time = 0                         %% 创建时间	
    }).	
	
%% temp_mount_attr	
%% temp_mount_attr ==> temp_mount_attr 	
-record(temp_mount_attr, {	
      level = 0,                              %% 座骑阶级	
      star = 0,                               %% 星级	
      name = <<"座骑阶段">>,              %% 阶级名	
      data = []                               %% 属性列表[{Key Value},...],	
    }).	
	
%% temp_mount_skill	
%% temp_mount_skill ==> temp_mount_skill 	
-record(temp_mount_skill, {	
      sid = 0,                                %% 技能ID	
      level = 0,                              %% 技能等级	
      name = <<"技能名字">>,              %% 阶级名	
      data = []                               %% 属性列表[{Key Value},...],	
    }).	
