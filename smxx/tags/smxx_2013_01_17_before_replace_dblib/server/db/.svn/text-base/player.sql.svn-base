/*
MySQL Data Transfer
Source Host: 192.168.51.170
Source Database: smxx
Target Host: 192.168.51.170
Target Database: smxx
Date: 2013-1-15 ���� 03:07:21
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for player
-- ----------------------------
DROP TABLE IF EXISTS `player`;
CREATE TABLE `player` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `account_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '平台账号ID',
  `account_name` varchar(50) NOT NULL DEFAULT '' COMMENT '平台账号',
  `nick` varchar(50) NOT NULL DEFAULT '' COMMENT '玩家名',
  `type` smallint(5) NOT NULL DEFAULT '1' COMMENT '玩家身份 1- 普通玩家 2 - 指导员 3 - gm',
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
  `resolut_x` int(8) NOT NULL DEFAULT '0' COMMENT '分辨率 X',
  `resolut_y` int(8) NOT NULL DEFAULT '0' COMMENT '分辨率 Y',
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
-- Records 
-- ----------------------------
