/*
MySQL Data Transfer
Source Host: 192.168.51.170
Source Database: smxx
Target Host: 192.168.51.170
Target Database: smxx
Date: 2013-1-15 ���� 03:07:26
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for goods
-- ----------------------------
DROP TABLE IF EXISTS `goods`;
CREATE TABLE `goods` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '玩家物品Id',
  `uid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '玩家ID',
  `gtid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '物品类型Id',
  `type` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT '物品类型',
  `stype` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT '物品子类型',
  `quality` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT '品质，决定颜色',
  `num` mediumint(8) NOT NULL COMMENT '当前数量',
  `cell` mediumint(8) NOT NULL COMMENT '所在格子',
  `streng_lv` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '强化等级',
  `use_times` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '使用次数',
  `expire_time` bigint(20) NOT NULL COMMENT '有效时间',
  `spec` text COMMENT '特殊字段',
  PRIMARY KEY (`id`),
  KEY `type` (`type`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `gtid` (`gtid`) USING BTREE,
  KEY `streng_lv` (`streng_lv`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='玩家物品记录';

-- ----------------------------
-- Records 
-- ----------------------------
