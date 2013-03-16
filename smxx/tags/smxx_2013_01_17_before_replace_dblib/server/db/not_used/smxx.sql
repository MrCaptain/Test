/*
MySQL Data Transfer
Source Host: 192.168.51.145
Source Database: smxx
Target Host: 192.168.51.145
Target Database: smxx
Date: 2013-1-10 ���� 05:18:23
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for base_npc
-- ----------------------------
DROP TABLE IF EXISTS `base_npc`;
CREATE TABLE `base_npc` (
  `nid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'NPC编号',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '字名',
  `title` varchar(50) NOT NULL DEFAULT '' COMMENT '称号',
  `icon` int(11) NOT NULL DEFAULT '0' COMMENT '怪物资源',
  `head` int(11) NOT NULL DEFAULT '0' COMMENT '头像资源',
  `scn` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '场景',
  `x` int(11) NOT NULL DEFAULT '0' COMMENT '位置X',
  `y` int(11) NOT NULL DEFAULT '0' COMMENT '位置X',
  `npc_type` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '怪物类型',
  `level` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '怪物等级',
  `attr_id` int(11) NOT NULL DEFAULT '0' COMMENT '战斗属性ID',
  `fire_range` int(11) NOT NULL DEFAULT '0' COMMENT '追击范围(格子距离)',
  `warn_range` int(11) NOT NULL DEFAULT '0' COMMENT '警介范围(格子距离)',
  `shop_id` int(11) NOT NULL DEFAULT '0' COMMENT '商店ID',
  `hit_point` int(11) NOT NULL DEFAULT '0' COMMENT '生命值',
  `magic` int(11) NOT NULL DEFAULT '0' COMMENT '法力值上限',
  `fall_gtid` int(11) NOT NULL DEFAULT '0' COMMENT '掉落物品编号',
  `act_skilllist` varchar(50) NOT NULL DEFAULT '[]' COMMENT '被动技能列表',
  `pas_skilllist` varchar(50) NOT NULL DEFAULT '[]' COMMENT '主动技能列表',
  PRIMARY KEY (`nid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='NPC基础表';

-- ----------------------------
-- Table structure for goods
-- ----------------------------
DROP TABLE IF EXISTS `goods`;
CREATE TABLE `goods` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '玩家物品Id',
  `uid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '玩家ID',
  `gtid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '物品类型Id',
  `type` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT '物品类型',
  `stype` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT '物品子类型',
  `quality` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT '品质，决定颜色',
  `num` mediumint(8) NOT NULL COMMENT '当前数量',
  `cell` mediumint(8) NOT NULL COMMENT '所在格子',
  `streng_lv` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '强化等级',
  `use_times` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '使用次数',
  `expire_time` bigint(20) NOT NULL COMMENT '有效时间',
  `spec` text COMMENT '特殊字段',
  PRIMARY KEY (`id`),
  KEY `type` (`type`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `gtid` (`gtid`) USING BTREE,
  KEY `streng_lv` (`streng_lv`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='玩家物品记录';

-- ----------------------------
-- Table structure for player
-- ----------------------------
DROP TABLE IF EXISTS `player`;
CREATE TABLE `player` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `account_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '平台账号ID',
  `account_name` varchar(50) NOT NULL DEFAULT '' COMMENT '平台账号',
  `nick` varchar(50) NOT NULL DEFAULT '' COMMENT '玩家名',
  `state` smallint(5) NOT NULL DEFAULT '1' COMMENT '玩家身份 1普通玩家 2指导员3gm',
  `reg_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '注册时间',
  `last_login_time` int(11) NOT NULL DEFAULT '0' COMMENT '最后登陆时间',
  `last_login_ip` varchar(20) NOT NULL DEFAULT '' COMMENT '最后登陆IP',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '玩家状态（0正常、1禁止、2战斗中、3死亡、4挂机、5打坐）',
  `gender` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '性别 1男 2女',
  `career` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '职业',
  `gold` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '元宝',
  `bgold` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '绑定元宝',
  `coin` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '铜钱',
  `bcoin` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '绑定铜钱',
  `scene` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '场景ID',
  `x` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'X坐标',
  `y` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'Y坐标',
  `level` smallint(5) unsigned NOT NULL DEFAULT '1' COMMENT '等级',
  `exp` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '经验',
  `energy` int(11) unsigned NOT NULL DEFAULT '40' COMMENT '体力',
  `energy_limit` int(11) NOT NULL DEFAULT '1000' COMMENT '体力值上限',
  `hit_point` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '生命',
  `hit_point_max` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '生命上限',
  `magic` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '法力值',
  `magic_max` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '法力值上限',
  `anger` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '怒气值',
  `anger_max` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '怒气值上限',
  `attack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '普通攻击力',
  `defense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '普通防御力',
  `abs_damage` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '绝对伤害值',
  `fattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '仙攻值',
  `mattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '魔攻值',
  `dattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '妖攻值',
  `fdefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '仙防值',
  `mdefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '魔防值',
  `ddefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '妖防值',
  `speed` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '移动速度',
  `attack_speed` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '攻击速度',
  `hit` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '命中等级',
  `dodge` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '闪避等级',
  `crit` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '暴击等级',
  `tough` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '坚韧等级',
  `hit_per` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '命中率',
  `dodge_per` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '闪避率',
  `crit_per` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '暴击率',
  `tough_per` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '坚韧率',
  `frozen_resis_per` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '冰冻抗性率',
  `weak_resis_per` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '虚弱抗性率',
  `flaw_resis_per` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '破绽抗性率',
  `poison_resis_per` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '中毒抗性率',
  `online_flag` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '在线标记，0不在线 1在线',
  `other` tinyint(4) DEFAULT '0' COMMENT '其他信息',
  PRIMARY KEY (`id`),
  UNIQUE KEY `nick` (`nick`),
  UNIQUE KEY `account_id` (`account_id`) USING BTREE,
  KEY `level` (`level`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `account_name` (`account_name`) USING BTREE,
  KEY `last_login_time` (`last_login_time`) USING BTREE,
  KEY `reg_time` (`reg_time`) USING BTREE,
  KEY `gold` (`gold`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='角色基本信息';

-- ----------------------------
-- Table structure for skill
-- ----------------------------
DROP TABLE IF EXISTS `skill`;
CREATE TABLE `skill` (
  `uid` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '角色id',
  `skill_list` varchar(50) NOT NULL DEFAULT '[]' COMMENT '技能ID列表',
  `cur_skill` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '当前正在使用的技能的ID',
  PRIMARY KEY (`uid`),
  KEY `uid` (`uid`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='技能';

-- ----------------------------
-- Table structure for temp_combatattr
-- ----------------------------
DROP TABLE IF EXISTS `temp_combatattr`;
CREATE TABLE `temp_combatattr` (
  `level` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '等级',
  `exp` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '经验',
  `career` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '职业',
  `hit_point_max` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '生命上限',
  `magic_max` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '法力上限',
  `combopoint_max` int(11) DEFAULT NULL,
  `anger_max` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '怒气值上限',
  `attack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '普通攻击力',
  `abs_damage` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '绝对伤害值',
  `ndefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '普通防御力',
  `fattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '仙攻值',
  `mattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '魔攻值',
  `dattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '妖攻值',
  `fdefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '仙防值',
  `mdefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '魔防值',
  `ddefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '妖防值',
  `speed` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '移动速度',
  `attack_speed` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '攻击速度',
  `hit` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '命中等级',
  `dodge` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '闪避等级',
  `crit` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '暴击等级',
  `tough` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '坚韧等级',
  `frozen_resis_per` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '冰冻抗性率',
  `weak_resis_per` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '虚弱抗性率',
  `flaw_resis_per` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '破绽抗性率',
  `poison_resis_per` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '中毒抗性率',
  PRIMARY KEY (`level`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='战斗属性表';

-- ----------------------------
-- Table structure for temp_goods
-- ----------------------------
DROP TABLE IF EXISTS `temp_goods`;
CREATE TABLE `temp_goods` (
  `gtid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '物品类型编号',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '物品名称',
  `icon` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '物品资源ID',
  `fall` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '物品掉落外观ID',
  `type` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '物品类型(参考宏定义)',
  `quality` tinyint(1) NOT NULL COMMENT '品质，决定了物品名称颜色',
  `price_type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '价格类型：1 铜钱, 2 金币',
  `buy_price` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '物品购买价格',
  `sell_price` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '物品出售价格',
  `career` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '职业限制，0为不限',
  `gender` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '性别限制，0为不限',
  `level` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '等级限制，0为不限',
  `max_num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '可叠加数，0为不可叠加',
  `limit` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '限制条件，0不限制 1捡取绑定 2装备绑定 4不能出售',
  `expire_time` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '有效期，0为不限，单位为秒',
  `set_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '套装ID，0为不是套装',
  `descr` varchar(50) NOT NULL DEFAULT '' COMMENT '物品描述信息',
  `special` varchar(50) NOT NULL DEFAULT '' COMMENT '特殊字段',
  PRIMARY KEY (`gtid`),
  UNIQUE KEY `gid` (`gtid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='物品基础表';

-- ----------------------------
-- Table structure for temp_item_equip
-- ----------------------------
DROP TABLE IF EXISTS `temp_item_equip`;
CREATE TABLE `temp_item_equip` (
  `gtid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '物品类型编号',
  `icon` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '装备外观',
  `set_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '套装编号',
  `hit_point` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加生命值',
  `defense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加普防值',
  `attack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加普攻值',
  `fattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加仙攻值',
  `mattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加魔攻值',
  `dattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加妖攻值',
  `fdefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加仙防值',
  `mdefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加魔防值',
  `ddefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加妖防值',
  `hit` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加命中等级',
  `dodge` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加闪避等级',
  `crit` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加暴击等级',
  `tough` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加韧性等级',
  `abs_damage` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加绝对伤害值',
  PRIMARY KEY (`gtid`),
  UNIQUE KEY `gtid` (`gtid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for temp_item_gem
-- ----------------------------
DROP TABLE IF EXISTS `temp_item_gem`;
CREATE TABLE `temp_item_gem` (
  `gtid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '物品ID',
  `hit_point` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加生命值',
  `attack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加普攻值',
  `fattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加仙攻值',
  `mattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加魔攻值',
  `dattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加妖攻值',
  `defense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加普防值',
  `fdefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加仙防值',
  `mdefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加魔防值',
  `ddefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加妖防值',
  PRIMARY KEY (`gtid`),
  UNIQUE KEY `gtid` (`gtid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='宝石属性';

-- ----------------------------
-- Table structure for temp_item_gemholy
-- ----------------------------
DROP TABLE IF EXISTS `temp_item_gemholy`;
CREATE TABLE `temp_item_gemholy` (
  `gtid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '编号',
  `hit_point` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加生命值',
  `attack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加普攻值',
  `fattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加仙攻值',
  `mattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加魔攻值',
  `dattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加妖攻值',
  `defense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加普防值',
  `fdefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加仙防值',
  `mdefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加魔防值',
  `ddefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加妖防值',
  PRIMARY KEY (`gtid`),
  UNIQUE KEY `gtid` (`gtid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='宝石神炼属性';

-- ----------------------------
-- Table structure for temp_item_set
-- ----------------------------
DROP TABLE IF EXISTS `temp_item_set`;
CREATE TABLE `temp_item_set` (
  `setid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '套装编号',
  `name` varchar(20) NOT NULL DEFAULT '' COMMENT '套装名',
  `goods_list` varchar(255) NOT NULL DEFAULT '[]' COMMENT '套装物品ID列表',
  `effect_list` varchar(255) NOT NULL DEFAULT '[]' COMMENT '套装效果列表'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='套装物品表';

-- ----------------------------
-- Table structure for temp_mon_refresh
-- ----------------------------
DROP TABLE IF EXISTS `temp_mon_refresh`;
CREATE TABLE `temp_mon_refresh` (
  `monid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '怪物ID',
  `scene_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '场景ID',
  `x` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'X坐标',
  `y` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'Y坐标',
  `towards` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '朝向',
  PRIMARY KEY (`monid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='怪物刷新';

-- ----------------------------
-- Table structure for temp_notice
-- ----------------------------
DROP TABLE IF EXISTS `temp_notice`;
CREATE TABLE `temp_notice` (
  `noticeid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '消息ID',
  `noticetext` varchar(255) NOT NULL DEFAULT '' COMMENT '消息内容',
  `noticelv` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '通知等级',
  `type` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '类型',
  PRIMARY KEY (`noticeid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='通知消息';

-- ----------------------------
-- Table structure for temp_npc
-- ----------------------------
DROP TABLE IF EXISTS `temp_npc`;
CREATE TABLE `temp_npc` (
  `nid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'NPC编号',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '字名',
  `title` varchar(50) NOT NULL DEFAULT '' COMMENT '称号',
  `icon` int(11) NOT NULL DEFAULT '0' COMMENT '怪物资源',
  `head` int(11) NOT NULL DEFAULT '0' COMMENT '头像资源',
  `scene_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '场景ID',
  `x` int(11) NOT NULL DEFAULT '0' COMMENT '位置X',
  `y` int(11) NOT NULL DEFAULT '0' COMMENT '位置X',
  `npc_type` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '怪物类型',
  `level` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '怪物等级',
  `attr_id` int(11) NOT NULL DEFAULT '0' COMMENT '战斗属性ID',
  `fire_range` int(11) NOT NULL DEFAULT '0' COMMENT '追击范围(格子距离)',
  `warn_range` int(11) NOT NULL DEFAULT '0' COMMENT '警介范围(格子距离)',
  `shop_id` int(11) NOT NULL DEFAULT '0' COMMENT '商店ID',
  `hit_point` int(11) NOT NULL DEFAULT '0' COMMENT '生命值',
  `magic` int(11) NOT NULL DEFAULT '0' COMMENT '法力值上限',
  `fall_gtid` int(11) NOT NULL DEFAULT '0' COMMENT '掉落物品编号',
  `act_skilllist` varchar(50) NOT NULL DEFAULT '[]' COMMENT '被动技能列表',
  `pas_skilllist` varchar(50) NOT NULL DEFAULT '[]' COMMENT '主动技能列表',
  PRIMARY KEY (`nid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='NPC基础表';

-- ----------------------------
-- Table structure for temp_npc_refresh
-- ----------------------------
DROP TABLE IF EXISTS `temp_npc_refresh`;
CREATE TABLE `temp_npc_refresh` (
  `npcid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'NPCID',
  `scene_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '场景ID',
  `x` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'X坐标',
  `y` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'Y坐标',
  `towards` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '朝向',
  PRIMARY KEY (`npcid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='NPC刷新';

-- ----------------------------
-- Table structure for temp_scene
-- ----------------------------
DROP TABLE IF EXISTS `temp_scene`;
CREATE TABLE `temp_scene` (
  `sid` int(11) NOT NULL COMMENT '场景id',
  `name` char(20) NOT NULL DEFAULT '' COMMENT '场景名称',
  `icon` int(11) NOT NULL DEFAULT '0' COMMENT '场景资源编号',
  `mode` smallint(1) NOT NULL DEFAULT '0' COMMENT '0:都不可以 1:可以PK, 2:可以原地复活...',
  `type` smallint(5) NOT NULL DEFAULT '1' COMMENT '1:新手村,2:野外,3:主城',
  `pk_mode` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0:不强制PK, 1强制PK 2:强制和平',
  `level_limit` smallint(5) NOT NULL DEFAULT '0' COMMENT '进入等级限制',
  `x` int(11) NOT NULL DEFAULT '0' COMMENT '进入后默认x坐标',
  `y` int(11) NOT NULL DEFAULT '0' COMMENT '进入后默认y坐标',
  `poem` int(11) NOT NULL DEFAULT '0' COMMENT '进入诗词',
  `loading` int(11) NOT NULL DEFAULT '0' COMMENT '调用Loading图',
  `revive_sid` int(11) NOT NULL DEFAULT '0' COMMENT '复活场景',
  `revive_x` int(11) NOT NULL DEFAULT '0' COMMENT '复活X坐标',
  `revive_y` int(11) NOT NULL DEFAULT '0' COMMENT '复活Y坐标',
  PRIMARY KEY (`sid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='场景数据结构';

-- ----------------------------
-- Table structure for temp_skill
-- ----------------------------
DROP TABLE IF EXISTS `temp_skill`;
CREATE TABLE `temp_skill` (
  `sid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '技能编号',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '技能名称',
  `icon` int(11) NOT NULL DEFAULT '0' COMMENT '技能资源编号',
  `type` smallint(5) NOT NULL DEFAULT '0' COMMENT '技能类型',
  `distance` int(11) NOT NULL DEFAULT '0' COMMENT '技能释放距离',
  `aoe_dist` int(11) NOT NULL DEFAULT '0' COMMENT '技能AOE距离',
  `aoe_tnum` int(11) NOT NULL DEFAULT '0' COMMENT '技能AOE目标数量',
  `cd` int(11) NOT NULL DEFAULT '0' COMMENT '技能CD(秒)',
  `cd_group` int(11) NOT NULL DEFAULT '0' COMMENT '技能CD组(秒)',
  `cost_magic_list` int(11) NOT NULL DEFAULT '0' COMMENT '技能消耗法力值列表',
  `damage_list` int(11) NOT NULL DEFAULT '0' COMMENT '技能伤害值列表',
  `get_cont` int(11) NOT NULL DEFAULT '0' COMMENT '使用获得连击点',
  `cost_cont` int(11) NOT NULL DEFAULT '0' COMMENT '使用消耗连击点',
  `cost_anger` int(11) NOT NULL DEFAULT '0' COMMENT '使用消耗怒气值',
  `link_skill_list` varchar(50) NOT NULL DEFAULT '' COMMENT '挂接技能列表',
  `unlink_skill_list` varchar(50) NOT NULL DEFAULT '' COMMENT '技能解除列表',
  `descr` varchar(200) NOT NULL DEFAULT '' COMMENT '技能描述',
  PRIMARY KEY (`sid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='技能数据';

-- ----------------------------
-- Records 
-- ----------------------------
