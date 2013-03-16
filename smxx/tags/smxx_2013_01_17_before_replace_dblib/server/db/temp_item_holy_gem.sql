/*
MySQL Data Transfer
Source Host: 192.168.51.170
Source Database: smxx
Target Host: 192.168.51.170
Target Database: smxx
Date: 2013-1-15 ���� 03:08:21
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for temp_item_holy_gem
-- ----------------------------
DROP TABLE IF EXISTS `temp_item_holy_gem`;
CREATE TABLE `temp_item_holy_gem` (
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
-- Records 
-- ----------------------------
