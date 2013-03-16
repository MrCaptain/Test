/*
MySQL Data Transfer
Source Host: 192.168.51.170
Source Database: smxx
Target Host: 192.168.51.170
Target Database: smxx
Date: 2013-1-15 ���� 03:08:41
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for temp_monster_refresh
-- ----------------------------
DROP TABLE IF EXISTS `temp_monster_refresh`;
CREATE TABLE `temp_monster_refresh` (
  `monid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '怪物ID',
  `scene_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '场景ID',
  `x` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'X坐标',
  `y` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'Y坐标',
  `towards` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '朝向',
  PRIMARY KEY (`monid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='怪物刷新';

-- ----------------------------
-- Records 
-- ----------------------------
