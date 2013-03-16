/*
MySQL Data Transfer
Source Host: 192.168.51.170
Source Database: smxx
Target Host: 192.168.51.170
Target Database: smxx
Date: 2013-1-15 ���� 03:09:15
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `account_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '平台账号id',
  `account_name` varchar(50) NOT NULL DEFAULT '' COMMENT '平台账号',
  `state` smallint(5) NOT NULL DEFAULT '0' COMMENT '账号状态(0正常；1被封)',
  `id_card_state` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '身份证验证状态，0表示没填身份证信息，1表示成年人，2表示未成年人，3表示暂时未填身份证信息',
  PRIMARY KEY (`account_id`),
  KEY `account_name` (`account_name`),
  KEY `account_id` (`account_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='平台账号';

-- ----------------------------
-- Records 
-- ----------------------------
