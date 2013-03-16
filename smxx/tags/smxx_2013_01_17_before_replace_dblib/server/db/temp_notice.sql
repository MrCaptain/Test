/*
MySQL Data Transfer
Source Host: 192.168.51.170
Source Database: smxx
Target Host: 192.168.51.170
Target Database: smxx
Date: 2013-1-15 ���� 03:08:46
*/

SET FOREIGN_KEY_CHECKS=0;
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
-- Records 
-- ----------------------------
