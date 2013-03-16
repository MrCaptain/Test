/*
MySQL Data Transfer
Source Host: 192.168.51.170
Source Database: smxx
Target Host: 192.168.51.170
Target Database: smxx
Date: 2013-1-15 ���� 03:07:50
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for temp_goods
-- ----------------------------
DROP TABLE IF EXISTS `temp_goods`;
CREATE TABLE `temp_goods` (
  `gtid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '物品类型编号',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '物品名称',
  `icon` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '物品资源ID',
  `fall` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '物品掉落外观ID',
  `type` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '物品类型(参考宏定义)',
  `quality` tinyint(1) NOT NULL COMMENT '品质，决定了物品名称颜色',
  `price_type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '价格类型：1 铜钱, 2 金币',
  `sell_price` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '物品出售价格',
  `career` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '职业限制，0为不限',
  `gender` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '性别限制，0为不限',
  `level` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '等级限制，0为不限',
  `max_num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '可叠加数，0为不可叠加',
  `limit` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '限制条件，0不限制 1捡取绑定 2装备绑定 4不能出售',
  `expire_time` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '有效期，0为不限，单位为秒',
  `set_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '套装ID，0为不是套装',
  `descr` varchar(50) NOT NULL DEFAULT '' COMMENT '物品描述信息',
  `special` varchar(50) NOT NULL DEFAULT '' COMMENT '特殊字段',
  PRIMARY KEY (`gtid`),
  UNIQUE KEY `gid` (`gtid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='物品基础表';

-- ----------------------------
-- Records 
-- ----------------------------
