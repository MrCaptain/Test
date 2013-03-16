/*
MySQL Data Transfer
Source Host: 192.168.51.170
Source Database: smxx
Target Host: 192.168.51.170
Target Database: smxx
Date: 2013-1-15 ĻĀĪē 03:08:21
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for temp_item_holy_gem
-- ----------------------------
DROP TABLE IF EXISTS `temp_item_holy_gem`;
CREATE TABLE `temp_item_holy_gem` (
  `gtid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'ē¼å·',
  `hit_point` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'éå ēå½å¼',
  `attack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'éå ę®ę»å¼',
  `fattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'éå ä»ę»å¼',
  `mattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'éå é­ę»å¼',
  `dattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'éå å¦ę»å¼',
  `defense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'éå ę®é²å¼',
  `fdefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'éå ä»é²å¼',
  `mdefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'éå é­é²å¼',
  `ddefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'éå å¦é²å¼',
  PRIMARY KEY (`gtid`),
  UNIQUE KEY `gtid` (`gtid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='å®ē³ē„ē¼å±ę§';

-- ----------------------------
-- Records 
-- ----------------------------
