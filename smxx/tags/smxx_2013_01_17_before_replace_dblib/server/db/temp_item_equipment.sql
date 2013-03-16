/*
MySQL Data Transfer
Source Host: 192.168.51.170
Source Database: smxx
Target Host: 192.168.51.170
Target Database: smxx
Date: 2013-1-15 ���� 03:08:16
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for temp_item_equipment
-- ----------------------------
DROP TABLE IF EXISTS `temp_item_equipment`;
CREATE TABLE `temp_item_equipment` (
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
-- Records 
-- ----------------------------
