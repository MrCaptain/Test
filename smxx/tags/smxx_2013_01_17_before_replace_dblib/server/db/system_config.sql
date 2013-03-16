/*
MySQL Data Transfer
Source Host: 192.168.51.170
Source Database: smxx
Target Host: 192.168.51.170
Target Database: smxx
Date: 2013-1-15 ���� 03:07:41
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for system_config
-- ----------------------------
DROP TABLE IF EXISTS `system_config`;
CREATE TABLE `system_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT 'uid',
  `pro` text COMMENT '新手引导',
  PRIMARY KEY (`id`,`uid`),
  KEY `id` (`id`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='系统参数配置';

-- ----------------------------
-- Records 
-- ----------------------------
INSERT INTO `system_config` VALUES ('1', '1', '[]');
