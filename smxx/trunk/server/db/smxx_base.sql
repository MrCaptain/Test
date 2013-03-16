-- phpMyAdmin SQL Dump
-- version 3.3.7
-- http://www.phpmyadmin.net
--
-- 主机: localhost
-- 生成日期: 2013 年 01 月 23 日 08:41
-- 服务器版本: 5.1.50
-- PHP 版本: 5.2.14

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- 数据库: `smxx_base`
--

-- --------------------------------------------------------

--
-- 表的结构 `server`
--
-- 创建时间: 2013 年 01 月 11 日 11:31
-- 最后更新: 2013 年 01 月 11 日 11:31
--

DROP TABLE IF EXISTS `server`;
CREATE TABLE IF NOT EXISTS `server` (
  `id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '编号Id',
  `ip` varchar(50) NOT NULL DEFAULT '' COMMENT 'ip地址',
  `port` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '端口号',
  `node` varchar(50) NOT NULL DEFAULT '' COMMENT '节点',
  `num` int(11) DEFAULT '0' COMMENT '节点用户数',
  `stop_access` tinyint(5) NOT NULL DEFAULT '0' COMMENT '是否停止登陆该节点，0为可以登录，1为停止登陆',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='服务器列表';

--
-- 转存表中的数据 `server`
--

INSERT INTO `server` (`id`, `ip`, `port`, `node`, `num`, `stop_access`) VALUES
(0, '127.0.0.1', 7777, 'game_gateway@127.0.0.1', 0, 0),
(1, '127.0.0.1', 7788, 'game_server1@127.0.0.1', 0, 0);

-- --------------------------------------------------------

--
-- 表的结构 `temp_combatattr`
--
-- 创建时间: 2013 年 01 月 10 日 17:19
-- 最后更新: 2013 年 01 月 10 日 17:19
--

DROP TABLE IF EXISTS `temp_combatattr`;
CREATE TABLE IF NOT EXISTS `temp_combatattr` (
  `level` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '等级',
  `exp` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '经验',
  `career` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '职业',
  `hit_point_max` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '生命上限',
  `magic_max` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '法力上限',
  `combopoint_max` int(11) DEFAULT NULL,
  `anger_max` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '怒气值上限',
  `attack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '普通攻击力',
  `abs_damage` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '绝对伤害值',
  `ndefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '普通防御力',
  `fattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '仙攻值',
  `mattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '魔攻值',
  `dattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '妖攻值',
  `fdefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '仙防值',
  `mdefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '魔防值',
  `ddefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '妖防值',
  `speed` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '移动速度',
  `attack_speed` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '攻击速度',
  `hit` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '命中等级',
  `dodge` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '闪避等级',
  `crit` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '暴击等级',
  `tough` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '坚韧等级',
  `frozen_resis_per` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '冰冻抗性率',
  `weak_resis_per` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '虚弱抗性率',
  `flaw_resis_per` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '破绽抗性率',
  `poison_resis_per` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '中毒抗性率',
  PRIMARY KEY (`level`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='战斗属性表';

--
-- 转存表中的数据 `temp_combatattr`
--


-- --------------------------------------------------------

--
-- 表的结构 `temp_goods`
--
-- 创建时间: 2013 年 01 月 10 日 17:19
-- 最后更新: 2013 年 01 月 10 日 17:19
--

DROP TABLE IF EXISTS `temp_goods`;
CREATE TABLE IF NOT EXISTS `temp_goods` (
  `gtid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '物品类型编号',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '物品名称',
  `icon` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '物品资源ID',
  `fall` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '物品掉落外观ID',
  `type` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '物品类型(参考宏定义)',
  `quality` tinyint(1) NOT NULL COMMENT '品质，决定了物品名称颜色',
  `price_type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '价格类型：1 铜钱, 2 金币',
  `buy_price` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '物品购买价格',
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

--
-- 转存表中的数据 `temp_goods`
--


-- --------------------------------------------------------

--
-- 表的结构 `temp_item_equip`
--
-- 创建时间: 2013 年 01 月 10 日 17:19
-- 最后更新: 2013 年 01 月 10 日 17:19
--

DROP TABLE IF EXISTS `temp_item_equip`;
CREATE TABLE IF NOT EXISTS `temp_item_equip` (
  `gtid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '物品类型编号',
  `icon` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '装备外观',
  `set_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '套装编号',
  `hit_point` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加生命值',
  `defense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加普防值',
  `attack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加普攻值',
  `fattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加仙攻值',
  `mattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加魔攻值',
  `dattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加妖攻值',
  `fdefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加仙防值',
  `mdefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加魔防值',
  `ddefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加妖防值',
  `hit` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加命中等级',
  `dodge` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加闪避等级',
  `crit` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加暴击等级',
  `tough` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加韧性等级',
  `abs_damage` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加绝对伤害值',
  PRIMARY KEY (`gtid`),
  UNIQUE KEY `gtid` (`gtid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `temp_item_equip`
--


-- --------------------------------------------------------

--
-- 表的结构 `temp_item_gem`
--
-- 创建时间: 2013 年 01 月 10 日 17:19
-- 最后更新: 2013 年 01 月 10 日 17:19
--

DROP TABLE IF EXISTS `temp_item_gem`;
CREATE TABLE IF NOT EXISTS `temp_item_gem` (
  `gtid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '物品ID',
  `hit_point` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加生命值',
  `attack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加普攻值',
  `fattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加仙攻值',
  `mattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加魔攻值',
  `dattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加妖攻值',
  `defense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加普防值',
  `fdefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加仙防值',
  `mdefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加魔防值',
  `ddefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加妖防值',
  PRIMARY KEY (`gtid`),
  UNIQUE KEY `gtid` (`gtid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='宝石属性';

--
-- 转存表中的数据 `temp_item_gem`
--


-- --------------------------------------------------------

--
-- 表的结构 `temp_item_gemholy`
--
-- 创建时间: 2013 年 01 月 10 日 17:19
-- 最后更新: 2013 年 01 月 10 日 17:19
--

DROP TABLE IF EXISTS `temp_item_gemholy`;
CREATE TABLE IF NOT EXISTS `temp_item_gemholy` (
  `gtid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '编号',
  `hit_point` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加生命值',
  `attack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加普攻值',
  `fattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加仙攻值',
  `mattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加魔攻值',
  `dattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加妖攻值',
  `defense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加普防值',
  `fdefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加仙防值',
  `mdefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加魔防值',
  `ddefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '附加妖防值',
  PRIMARY KEY (`gtid`),
  UNIQUE KEY `gtid` (`gtid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='宝石神炼属性';

--
-- 转存表中的数据 `temp_item_gemholy`
--


-- --------------------------------------------------------

--
-- 表的结构 `temp_item_set`
--
-- 创建时间: 2013 年 01 月 10 日 17:19
-- 最后更新: 2013 年 01 月 10 日 17:19
--

DROP TABLE IF EXISTS `temp_item_set`;
CREATE TABLE IF NOT EXISTS `temp_item_set` (
  `setid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '套装编号',
  `name` varchar(20) NOT NULL DEFAULT '' COMMENT '套装名',
  `goods_list` varchar(255) NOT NULL DEFAULT '[]' COMMENT '套装物品ID列表',
  `effect_list` varchar(255) NOT NULL DEFAULT '[]' COMMENT '套装效果列表'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='套装物品表';

--
-- 转存表中的数据 `temp_item_set`
--


-- --------------------------------------------------------

--
-- 表的结构 `temp_mon_refresh`
--
-- 创建时间: 2013 年 01 月 10 日 17:19
-- 最后更新: 2013 年 01 月 10 日 17:19
--

DROP TABLE IF EXISTS `temp_mon_refresh`;
CREATE TABLE IF NOT EXISTS `temp_mon_refresh` (
  `monid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '怪物ID',
  `scene_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '场景ID',
  `x` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'X坐标',
  `y` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'Y坐标',
  `towards` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '朝向',
  PRIMARY KEY (`monid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='怪物刷新';

--
-- 转存表中的数据 `temp_mon_refresh`
--


-- --------------------------------------------------------

--
-- 表的结构 `temp_notice`
--
-- 创建时间: 2013 年 01 月 10 日 17:19
-- 最后更新: 2013 年 01 月 10 日 17:19
--

DROP TABLE IF EXISTS `temp_notice`;
CREATE TABLE IF NOT EXISTS `temp_notice` (
  `noticeid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '消息ID',
  `noticetext` varchar(255) NOT NULL DEFAULT '' COMMENT '消息内容',
  `noticelv` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '通知等级',
  `type` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '类型',
  PRIMARY KEY (`noticeid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='通知消息';

--
-- 转存表中的数据 `temp_notice`
--


-- --------------------------------------------------------

--
-- 表的结构 `temp_npc`
--
-- 创建时间: 2013 年 01 月 10 日 20:38
-- 最后更新: 2013 年 01 月 10 日 20:38
--

DROP TABLE IF EXISTS `temp_npc`;
CREATE TABLE IF NOT EXISTS `temp_npc` (
  `nid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'NPC编号',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '字名',
  `title` varchar(50) NOT NULL DEFAULT '' COMMENT '称号',
  `icon` int(11) NOT NULL DEFAULT '0' COMMENT '怪物资源',
  `head` int(11) NOT NULL DEFAULT '0' COMMENT '头像资源',
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

--
-- 转存表中的数据 `temp_npc`
--


-- --------------------------------------------------------

--
-- 表的结构 `temp_npc_refresh`
--
-- 创建时间: 2013 年 01 月 10 日 17:19
-- 最后更新: 2013 年 01 月 10 日 17:19
--

DROP TABLE IF EXISTS `temp_npc_refresh`;
CREATE TABLE IF NOT EXISTS `temp_npc_refresh` (
  `npcid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'NPCID',
  `scene_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '场景ID',
  `x` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'X坐标',
  `y` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'Y坐标',
  `towards` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '朝向',
  PRIMARY KEY (`npcid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='NPC刷新';

--
-- 转存表中的数据 `temp_npc_refresh`
--


-- --------------------------------------------------------

--
-- 表的结构 `temp_player`
--
-- 创建时间: 2013 年 01 月 11 日 16:02
-- 最后更新: 2013 年 01 月 11 日 16:02
--

DROP TABLE IF EXISTS `temp_player`;
CREATE TABLE IF NOT EXISTS `temp_player` (
  `career` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '职业',
  `level` smallint(5) unsigned NOT NULL DEFAULT '1' COMMENT '等级',
  `exp` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '升级经验',
  `hit_point_max` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '生命上限',
  `magic_max` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '法力值上限',
  `anger_max` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '怒气值上限',
  `attack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '普通攻击力',
  `defense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '普通防御力',
  `abs_damage` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '绝对伤害值',
  `fattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '仙攻值',
  `mattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '魔攻值',
  `dattack` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '妖攻值',
  `fdefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '仙防值',
  `mdefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '魔防值',
  `ddefense` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '妖防值',
  `speed` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '移动速度',
  `attack_speed` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '攻击速度'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='角色基本信息';

--
-- 转存表中的数据 `temp_player`
--


-- --------------------------------------------------------

--
-- 表的结构 `temp_scene`
--
-- 创建时间: 2013 年 01 月 12 日 09:51
-- 最后更新: 2013 年 01 月 12 日 09:51
--

DROP TABLE IF EXISTS `temp_scene`;
CREATE TABLE IF NOT EXISTS `temp_scene` (
  `sid` int(11) NOT NULL COMMENT '场景id',
  `name` char(20) NOT NULL DEFAULT '' COMMENT '场景名称',
  `icon` int(11) NOT NULL DEFAULT '0' COMMENT '场景资源编号',
  `mode` smallint(1) NOT NULL DEFAULT '0' COMMENT '0:都不可以 1:可以PK, 2:可以原地复活...',
  `type` smallint(5) NOT NULL DEFAULT '1' COMMENT '1:新手村,2:野外,3:主城',
  `pk_mode` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0:不强制PK, 1强制PK 2:强制和平',
  `level_limit` smallint(5) NOT NULL DEFAULT '0' COMMENT '进入等级限制',
  `x` int(11) NOT NULL DEFAULT '0' COMMENT '进入后默认x坐标',
  `y` int(11) NOT NULL DEFAULT '0' COMMENT '进入后默认y坐标',
  `poem` int(11) NOT NULL DEFAULT '0' COMMENT '进入诗词',
  `loading` int(11) NOT NULL DEFAULT '0' COMMENT '调用Loading图',
  `revive_sid` int(11) NOT NULL DEFAULT '0' COMMENT '复活场景',
  `revive_x` int(11) NOT NULL DEFAULT '0' COMMENT '复活X坐标',
  `revive_y` int(11) NOT NULL DEFAULT '0' COMMENT '复活Y坐标',
  `npc` varchar(255) DEFAULT '[]' COMMENT 'NPC',
  `id` int(11) NOT NULL DEFAULT '0' COMMENT '场景实例唯一标识',
  PRIMARY KEY (`sid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='场景数据结构';

--
-- 转存表中的数据 `temp_scene`
--

INSERT INTO `temp_scene` (`sid`, `name`, `icon`, `mode`, `type`, `pk_mode`, `level_limit`, `x`, `y`, `poem`, `loading`, `revive_sid`, `revive_x`, `revive_y`, `npc`, `id`) VALUES
(100, '小村正', 1, 2, 1, 1, 1, 20, 30, 0, 0, 0, 0, 0, '[]', 0);

-- --------------------------------------------------------

--
-- 表的结构 `temp_skill`
--
-- 创建时间: 2013 年 01 月 10 日 17:19
-- 最后更新: 2013 年 01 月 10 日 17:19
--

DROP TABLE IF EXISTS `temp_skill`;
CREATE TABLE IF NOT EXISTS `temp_skill` (
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

--
-- 转存表中的数据 `temp_skill`
--


-- --------------------------------------------------------

--
-- 表的结构 `user`
--
-- 创建时间: 2013 年 01 月 11 日 11:31
-- 最后更新: 2013 年 01 月 11 日 11:31
--

DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `acid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '平台账号id',
  `acnm` varchar(50) NOT NULL DEFAULT '' COMMENT '平台账号',
  `state` smallint(5) NOT NULL DEFAULT '0' COMMENT '账号状态(0正常；1被封)',
  `idcrs` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '身份证验证状态，0表示没填身份证信息，1表示成年人，2表示未成年人，3表示暂时未填身份证信息',
  PRIMARY KEY (`id`,`acid`),
  KEY `accname` (`acnm`) USING BTREE,
  KEY `accid` (`acid`) USING BTREE,
  KEY `id` (`id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='平台账号' AUTO_INCREMENT=1 ;

--
-- 转存表中的数据 `user`
--

