/*
MySQL Data Transfer
Source Host: 192.168.51.170
Source Database: smxx
Target Host: 192.168.51.170
Target Database: smxx
Date: 2013-1-15 ���� 03:08:30
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for temp_item_set
-- ----------------------------
DROP TABLE IF EXISTS `temp_item_set`;
CREATE TABLE `temp_item_set` (
  `setid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '套装编号',
  `name` varchar(20) NOT NULL DEFAULT '' COMMENT '套装名',
  `goods_list` varchar(255) NOT NULL DEFAULT '[]' COMMENT '套装物品ID列表',
  `effect_list` varchar(255) NOT NULL DEFAULT '[]' COMMENT '套装效果列表'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='套装物品表';

-- ----------------------------
-- Records 
-- ----------------------------
