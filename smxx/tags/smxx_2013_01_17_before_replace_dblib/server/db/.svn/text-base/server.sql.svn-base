/*
MySQL Data Transfer
Source Host: 192.168.51.170
Source Database: smxx
Target Host: 192.168.51.170
Target Database: smxx
Date: 2013-1-15 ���� 03:07:31
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for server
-- ----------------------------
DROP TABLE IF EXISTS `server`;
CREATE TABLE `server` (
  `id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '编号Id',
  `ip` varchar(50) NOT NULL DEFAULT '' COMMENT 'ip地址',
  `port` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '端口号',
  `node` varchar(50) NOT NULL DEFAULT '' COMMENT '节点',
  `num` int(11) DEFAULT '0' COMMENT '节点用户数',
  `stop_access` tinyint(5) NOT NULL DEFAULT '0' COMMENT '是否停止登陆该节点，0为可以登录，1为停止登陆',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='服务器列表';

-- ----------------------------
-- Records 
-- ----------------------------
INSERT INTO `server` VALUES ('0', '127.0.0.1', '7777', 'game_gateway@127.0.0.1', '0', '0');
INSERT INTO `server` VALUES ('1', '127.0.0.1', '7788', 'game_server1@127.0.0.1', '0', '0');
