/*
MySQL Data Transfer
Source Host: 192.168.51.170
Source Database: smxx
Target Host: 192.168.51.170
Target Database: smxx
Date: 2013-1-15 ���� 03:08:36
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for temp_mon
-- ----------------------------
DROP TABLE IF EXISTS `temp_mon`;
CREATE TABLE `temp_mon` (
  `mon_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '怪物Id',
  `level` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '等级',
  `type` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '类型',
  `res_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '皮',
  `hit_point` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '生命值上限',
  `attack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '普通攻击',
  `fattcck` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '仙攻',
  `mattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '魔攻',
  `dattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '妖攻',
  `ndefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '普通防御',
  `fdefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '仙防',
  `mdefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '魔防',
  `ddefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '妖防',
  `hit` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '命中',
  `dodge` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '闪避',
  `crit` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '暴击',
  `tough` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '坚韧',
  `frozen_attack_ppm` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '冰冻攻击',
  `weak_attack_ppm` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '虚弱攻击',
  `flaw_attack_ppm` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '破绽攻击',
  `poison_attack_ppm` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '毒性攻击',
  `frozen_resis_ppm` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '冰冻抗性',
  `weak_resis_ppm` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '虚弱抗性',
  `flaw_resis_ppm` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '破绽抗性',
  `poison_resis_ppm` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '中毒抗性',
  `skill_id_list` varchar(50) NOT NULL DEFAULT '[]' COMMENT '技能ID列表',
  `buff_id_list` varchar(50) NOT NULL DEFAULT '[]' COMMENT 'buff_id列表',
  PRIMARY KEY (`mon_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='怪物表';

-- ----------------------------
-- Records 
-- ----------------------------
INSERT INTO `temp_mon` VALUES ('0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '[]', '[]');
