/*
MySQL Data Transfer
Source Host: 192.168.51.170
Source Database: smxx
Target Host: 192.168.51.170
Target Database: smxx
Date: 2013-1-15 ���� 03:09:11
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for temp_skill
-- ----------------------------
DROP TABLE IF EXISTS `temp_skill`;
CREATE TABLE `temp_skill` (
  `sid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '技能编号',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '技能名称',
  `icon` int(11) NOT NULL DEFAULT '0' COMMENT '技能资源编号',
  `type` smallint(5) NOT NULL DEFAULT '0' COMMENT '技能类型',
  `distance` int(11) NOT NULL DEFAULT '0' COMMENT '技能释放距离',
  `aoe_dist` int(11) NOT NULL DEFAULT '0' COMMENT '技能AOE距离',
  `aoe_tnum` int(11) NOT NULL DEFAULT '0' COMMENT '技能AOE目标数量',
  `cd` int(11) NOT NULL DEFAULT '0' COMMENT '技能CD(秒)',
  `cd_group` int(11) NOT NULL DEFAULT '0' COMMENT '技能CD组(秒)',
  `cost_magic_list` int(11) NOT NULL DEFAULT '0' COMMENT '技能消耗法力值列表',
  `damage_list` int(11) NOT NULL DEFAULT '0' COMMENT '技能伤害值列表',
  `get_cont` int(11) NOT NULL DEFAULT '0' COMMENT '使用获得连击点',
  `cost_cont` int(11) NOT NULL DEFAULT '0' COMMENT '使用消耗连击点',
  `cost_anger` int(11) NOT NULL DEFAULT '0' COMMENT '使用消耗怒气值',
  `link_skill_list` varchar(50) NOT NULL DEFAULT '' COMMENT '挂接技能列表',
  `unlink_skill_list` varchar(50) NOT NULL DEFAULT '' COMMENT '技能解除列表',
  `descr` varchar(200) NOT NULL DEFAULT '' COMMENT '技能描述',
  PRIMARY KEY (`sid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='技能数据';

-- ----------------------------
-- Records 
-- ----------------------------
