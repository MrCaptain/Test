/*
MySQL Data Transfer
Source Host: 192.168.51.170
Source Database: smxx
Target Host: 192.168.51.170
Target Database: smxx
Date: 2013-1-15 ���� 03:07:36
*/

SET FOREIGN_KEY_CHECKS=0;
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
-- Records 
-- ----------------------------
