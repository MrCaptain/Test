/*
Navicat MySQL Data Transfer

Source Server         : loca_csj
Source Server Version : 50150
Source Host           : localhost:3306
Source Database       : csj_dev

Target Server Type    : MYSQL
Target Server Version : 50150
File Encoding         : 65001

Date: 2011-09-01 21:00:29
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for `guild`
-- ----------------------------
DROP TABLE IF EXISTS `guild`;
CREATE TABLE `guild` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '联盟编号',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '联盟名称',
  `mastor_uid` int(11) DEFAULT '0' COMMENT '盟主角色ID',
  `mastor_uname` varchar(50) DEFAULT '' COMMENT '盟主角色名字',
  `announce` varchar(2000) DEFAULT '' COMMENT '联盟公告',
  `grade` int(11) unsigned DEFAULT '0' COMMENT '联盟等级(1-20共20个级)，初始为最大42人，每增加以及，人数增加2人，最多为80人。',
  `cur_member` int(11) unsigned DEFAULT '0' COMMENT '联盟当前人数,当有成员加入时，更新该字段',
  `max_member` int(11) unsigned DEFAULT '42' COMMENT '联盟最大人数，等级没升1级，该字段值加2',
  `devotion` int(11) unsigned DEFAULT '0' COMMENT '联盟贡献度(成员贡献度的总和)',
  `fund` int(11) unsigned DEFAULT '0' COMMENT '联盟资金(联盟资金可通过成员捐献铜币，完成联盟任务增加。)',
  `flag` int(11) NOT NULL COMMENT '联盟旗帜',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '最近升级时间',
  `jion_ltime` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '上次参战时间',
  `create_time` int(11) unsigned DEFAULT '0' COMMENT '创建时间',
  `status` int(1) unsigned DEFAULT '0' COMMENT '----1 弹劾盟主中，0----正常  在本次弹劾结束时清零',
  `impeach_uid` int(11) unsigned DEFAULT NULL COMMENT '发起弹劾的成员 --本次弹劾结束后清除',
  `impeach_time` int(11) unsigned DEFAULT '0' COMMENT '发起弹劾时间  --本次弹劾结束后清除',
  `against` int(11) unsigned DEFAULT '0' COMMENT '反对分数 --本次弹劾结束后清除',
  `agree` int(11) unsigned DEFAULT '0' COMMENT '赞成分数     --本次弹劾结束后清除',
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 CHECKSUM=1 DELAY_KEY_WRITE=1 ROW_FORMAT=DYNAMIC COMMENT='氏族';

-- ----------------------------
-- Records of guild
-- ----------------------------

/*
Navicat MySQL Data Transfer

Source Server         : loca_csj
Source Server Version : 50150
Source Host           : localhost:3306
Source Database       : csj_dev

Target Server Type    : MYSQL
Target Server Version : 50150
File Encoding         : 65001

Date: 2011-09-01 21:00:20
*/


-- ----------------------------
-- Table structure for `guild_member`
-- ----------------------------
DROP TABLE IF EXISTS `guild_member`;
CREATE TABLE `guild_member` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '编号',
  `unid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '联盟ID',
  `unname` varchar(50) NOT NULL DEFAULT '' COMMENT '联盟名称',
  `uid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '角色ID',
  `uname` varchar(50) NOT NULL DEFAULT '' COMMENT '角色昵称',
  `position` int(2) unsigned DEFAULT '4' COMMENT '1-盟主；2-长老；3-元老；4-盟众',
  `dn_coin` int(11) unsigned DEFAULT '0' COMMENT '玩家捐献总铜币（累加）',
  `dn_gold` int(11) unsigned DEFAULT '0' COMMENT '玩家捐献总元宝（累加）',
  `dn_coin_lst` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '最后捐献铜币时间',
  `dn_gold_lst` int(11) NOT NULL DEFAULT '0' COMMENT '最后捐献元宝时间',
  `devotion` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '成员总贡献度（可以通过捐献，完成联盟任务，参与联盟战获得）devotion - sub_devo',
  `jion_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '加入联盟时间',
  `update_time` int(11) DEFAULT '0' COMMENT '上次晋升时间(新加入的，跟jion_time填成一样，而后记录级别或者职位的提升时间)',
  `vote` int(1) unsigned DEFAULT '0' COMMENT '1、赞成票 ； 2、反对票  --本次弹劾结束后清除',
  `vote_time` int(11) DEFAULT '0' COMMENT '投票时间，本次弹劾结束后清除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `player_id` (`uid`),
  KEY `index_guild_member_player_id` (`uid`),
  KEY `index_guild_member_guild_id` (`unid`),
  KEY `id` (`id`),
  KEY `guild_name` (`unname`),
  KEY `player_name` (`uname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 CHECKSUM=1 DELAY_KEY_WRITE=1 ROW_FORMAT=DYNAMIC COMMENT='氏族成员';

-- ----------------------------
-- Records of guild_member
-- ----------------------------

/*
Navicat MySQL Data Transfer

Source Server         : loca_csj
Source Server Version : 50150
Source Host           : localhost:3306
Source Database       : csj_dev

Target Server Type    : MYSQL
Target Server Version : 50150
File Encoding         : 65001

Date: 2011-09-01 21:00:07
*/


-- ----------------------------
-- Table structure for `guild_apply`
-- ----------------------------
DROP TABLE IF EXISTS `guild_apply`;
CREATE TABLE `guild_apply` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '编号',
  `unid` int(11) unsigned DEFAULT '0' COMMENT '申请要加入的联盟ID',
  `uid` int(11) unsigned DEFAULT '0' COMMENT '申请角色ID',
  `uname` varchar(50) DEFAULT '' COMMENT '申请角色名字',
  `crtm` int(11) unsigned DEFAULT '0' COMMENT '申请时间',
  PRIMARY KEY (`id`),
  KEY `index_guild_apply_player_id` (`uid`),
  KEY `index_guild_apply_guild_id` (`unid`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 CHECKSUM=1 DELAY_KEY_WRITE=1 ROW_FORMAT=DYNAMIC COMMENT='氏族申请';

-- ----------------------------
-- Records of guild_apply
-- ----------------------------
/*
Navicat MySQL Data Transfer

Source Server         : loca_csj
Source Server Version : 50150
Source Host           : localhost:3306
Source Database       : csj_dev

Target Server Type    : MYSQL
Target Server Version : 50150
File Encoding         : 65001

Date: 2011-09-01 21:00:38
*/


-- ----------------------------
-- Table structure for `guild_log`
-- ----------------------------
DROP TABLE IF EXISTS `guild_log`;
CREATE TABLE `guild_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '事件ID',
  `unid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '联盟ID',
  `unname` varchar(50) NOT NULL DEFAULT '' COMMENT '联盟名字',
  `log_type` int(2) NOT NULL DEFAULT '0' COMMENT '1-联盟事件；2-成员事件',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '角色ID',
  `uname` varchar(255) DEFAULT '' COMMENT '角色名字',
  `time` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '帮派事件发生时间',
  `content` varchar(200) NOT NULL DEFAULT '' COMMENT '帮派事件内容',
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `guild_id` (`unid`),
  KEY `guild_name` (`unname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='帮派事件日志';

-- ----------------------------
-- Records of guild_log
-- ----------------------------
