/*
MySQL Data Transfer
Source Host: 192.168.51.170
Source Database: smxx
Target Host: 192.168.51.170
Target Database: smxx
Date: 2013-1-15 ���� 03:07:16
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for player_sys_setting
-- ----------------------------
DROP TABLE IF EXISTS `player_sys_setting`;
CREATE TABLE `player_sys_setting` (
  `uid` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '玩家Id',
  `shield_role` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '蔽屏附近玩家和宠物，0：不屏蔽；1：屏蔽',
  `shield_skill` tinyint(1) NOT NULL DEFAULT '0' COMMENT '屏蔽技能特效， 0：不屏蔽；1：屏蔽',
  `shield_rela` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '屏蔽好友请求，0：不屏蔽；1：屏蔽',
  `shield_team` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '屏蔽组队邀请，0：不屏蔽；1：屏蔽',
  `shield_chat` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '屏蔽聊天传闻，0：不屏蔽；1：屏蔽',
  `music` mediumint(8) unsigned NOT NULL DEFAULT '50' COMMENT '游戏音乐，默认值为50',
  `soundeffect` mediumint(8) NOT NULL DEFAULT '50' COMMENT '游戏音效，默认值为50',
  `fasheffect` tinyint(1) NOT NULL DEFAULT '0' COMMENT '时装显示(0对别人显示，1对别人不显示)',
  PRIMARY KEY (`uid`),
  KEY `player_id` (`uid`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='玩家系统设置';

-- ----------------------------
-- Records 
-- ----------------------------
