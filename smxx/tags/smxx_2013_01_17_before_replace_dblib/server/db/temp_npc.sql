/*
MySQL Data Transfer
Source Host: 192.168.51.170
Source Database: smxx
Target Host: 192.168.51.170
Target Database: smxx
Date: 2013-1-15 ���� 03:08:51
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for temp_npc
-- ----------------------------
DROP TABLE IF EXISTS `temp_npc`;
CREATE TABLE `temp_npc` (
  `nid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'NPC编号',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '字名',
  `title` varchar(50) NOT NULL DEFAULT '' COMMENT '称号',
  `icon` int(11) NOT NULL DEFAULT '0' COMMENT '怪物资源',
  `head` int(11) NOT NULL DEFAULT '0' COMMENT '头像资源',
  `scene_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '场景ID',
  `x` int(11) NOT NULL DEFAULT '0' COMMENT '位置X',
  `y` int(11) NOT NULL DEFAULT '0' COMMENT '位置X',
  `npc_type` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '怪物类型',
  `level` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '怪物等级',
  `attr_id` int(11) NOT NULL DEFAULT '0' COMMENT '战斗属性ID',
  `fire_range` int(11) NOT NULL DEFAULT '0' COMMENT '追击范围(格子距离)',
  `warn_range` int(11) NOT NULL DEFAULT '0' COMMENT '警介范围(格子距离)',
  `shop_id` int(11) NOT NULL DEFAULT '0' COMMENT '商店ID',
  `hit_point` int(11) NOT NULL DEFAULT '0' COMMENT '生命值',
  `magic` int(11) NOT NULL DEFAULT '0' COMMENT '法力值上限',
  `fall_gtid` int(11) NOT NULL DEFAULT '0' COMMENT '掉落物品编号',
  `act_skilllist` varchar(50) NOT NULL DEFAULT '[]' COMMENT '被动技能列表',
  `pas_skilllist` varchar(50) NOT NULL DEFAULT '[]' COMMENT '主动技能列表',
  PRIMARY KEY (`nid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='NPC基础表';

-- ----------------------------
-- Records 
-- ----------------------------
INSERT INTO `temp_npc` VALUES ('100001', '司马光', '扔孩子进缸', '0', '0', '100', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '[]', '[]');
