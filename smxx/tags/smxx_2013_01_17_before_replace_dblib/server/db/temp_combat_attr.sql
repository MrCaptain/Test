/*
MySQL Data Transfer
Source Host: 192.168.51.170
Source Database: smxx
Target Host: 192.168.51.170
Target Database: smxx
Date: 2013-1-15 ���� 03:07:46
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for temp_combat_attr
-- ----------------------------
DROP TABLE IF EXISTS `temp_combat_attr`;
CREATE TABLE `temp_combat_attr` (
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
  `poison_resis_per` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '中毒抗性率'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='战斗属性表';

-- ----------------------------
-- Records 
-- ----------------------------
