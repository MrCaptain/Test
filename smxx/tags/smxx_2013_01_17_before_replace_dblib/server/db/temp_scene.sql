/*
MySQL Data Transfer
Source Host: 192.168.51.170
Source Database: smxx
Target Host: 192.168.51.170
Target Database: smxx
Date: 2013-1-15 ���� 03:09:05
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for temp_scene
-- ----------------------------
DROP TABLE IF EXISTS `temp_scene`;
CREATE TABLE `temp_scene` (
  `sid` int(11) NOT NULL COMMENT '场景id',
  `name` char(20) NOT NULL DEFAULT '' COMMENT '场景名称',
  `icon` int(11) NOT NULL DEFAULT '0' COMMENT '场景资源编号',
  `mode` smallint(1) NOT NULL DEFAULT '0' COMMENT '0:都不可以 1:可以PK, 2:可以原地复活...',
  `type` smallint(5) NOT NULL DEFAULT '1' COMMENT '1:新手村,2:野外,3:主城',
  `pk_mode` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0:不强制PK, 1强制PK 2:强制和平',
  `level_limit` smallint(5) NOT NULL DEFAULT '0' COMMENT '进入等级限制',
  `x` int(11) NOT NULL DEFAULT '0' COMMENT '进入后默认x坐标',
  `y` int(11) NOT NULL DEFAULT '0' COMMENT '进入后默认y坐标',
  `poem` char(30) NOT NULL DEFAULT '0' COMMENT '进入诗词',
  `loading` int(11) NOT NULL DEFAULT '0' COMMENT '调用Loading图',
  `revive_sid` int(11) NOT NULL DEFAULT '0' COMMENT '复活场景',
  `revive_x` int(11) NOT NULL DEFAULT '0' COMMENT '复活X坐标',
  `revive_y` int(11) NOT NULL DEFAULT '0' COMMENT '复活Y坐标',
  `npc` char(255) DEFAULT '[]' COMMENT 'NPC',
  `id` int(11) NOT NULL DEFAULT '0' COMMENT '场景实例唯一标识',
  PRIMARY KEY (`sid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='场景数据结构';

-- ----------------------------
-- Records 
-- ----------------------------
INSERT INTO `temp_scene` VALUES ('1', '黄泉宗', '0', '0', '0', '0', '1', '0', '1', '黄花古城路，泉中掩龙章', '0', '0', '0', '1', null, '0');
INSERT INTO `temp_scene` VALUES ('2', '羽化门', '0', '0', '0', '0', '1', '0', '1', '羽翼皆随风，化虚九霄行', '0', '0', '0', '1', null, '0');
INSERT INTO `temp_scene` VALUES ('3', '无极宫', '0', '0', '0', '0', '1', '0', '1', '无令海客悲，极目思依依', '0', '0', '0', '1', null, '0');
INSERT INTO `temp_scene` VALUES ('4', '天州城', '0', '0', '0', '0', '20', '0', '1', '霓裳欲向大罗天，青山远近九皇州', '0', '0', '0', '1', null, '0');
INSERT INTO `temp_scene` VALUES ('5', '星罗大陆', '0', '0', '15', '0', '10', '0', '1', '青天唯见三两星，紫陌金堤映绮罗', '0', '5', '0', '1', null, '0');
INSERT INTO `temp_scene` VALUES ('6', '紫竹林', '0', '0', '15', '0', '21', '0', '1', '紫台迢迢皆过往，竹下忘言对清茗', '0', '6', '0', '1', null, '0');
INSERT INTO `temp_scene` VALUES ('7', '蛮荒丛林', '0', '0', '15', '0', '30', '0', '1', '蛮溪边夷莫敢侵，荒芜满城逢旧颜', '0', '7', '0', '1', null, '0');
INSERT INTO `temp_scene` VALUES ('8', '炎魔谷', '0', '0', '15', '0', '31', '0', '1', '炎暑郁蒸无处避，魔王轮幢自摧折', '0', '8', '0', '1', null, '0');
INSERT INTO `temp_scene` VALUES ('9', '瀚海沙漠', '0', '0', '15', '0', '40', '0', '1', '瀚海龙城皆习战，海上亭台山下烟', '0', '9', '0', '1', null, '0');
INSERT INTO `temp_scene` VALUES ('10', '不老峰', '0', '0', '15', '0', '41', '0', '1', '不堪吟罢西风起，老逢佳景唯惆怅', '0', '10', '0', '1', null, '0');
INSERT INTO `temp_scene` VALUES ('11', '乱神海', '0', '0', '15', '0', '51', '0', '1', '乱世未必长离别，神海幻山路无边', '0', '11', '0', '1', null, '0');
INSERT INTO `temp_scene` VALUES ('12', '九幽之地', '0', '0', '15', '0', '60', '0', '1', '九转丹成最上仙，幽居喜见凡草生', '0', '12', '0', '1', null, '0');
INSERT INTO `temp_scene` VALUES ('13', '堕仙岭', '0', '0', '15', '0', '61', '0', '1', '堕凡忘仙气数尽，仙宫深处却无山', '0', '13', '0', '1', null, '0');
INSERT INTO `temp_scene` VALUES ('14', '无尽雪原', '0', '0', '15', '0', '71', '0', '1', '闲云幽水皆无尽，雪原仙山魔重重', '0', '14', '0', '1', null, '0');
INSERT INTO `temp_scene` VALUES ('15', '太元仙府', '0', '0', '7', '0', '50', '0', '1', '太元清虚修真路，仙府花开无人知', '0', '15', '0', '1', null, '0');
INSERT INTO `temp_scene` VALUES ('16', '幽林梦境', '0', '0', '7', '0', '60', '0', '1', '幽林处处少人行，梦境梦回梦里情', '0', '16', '0', '1', null, '0');
INSERT INTO `temp_scene` VALUES ('17', '试炼之路', '0', '0', '7', '0', '34', '0', '1', '今有豪情志，尽在试炼地', '0', '17', '0', '1', null, '0');
INSERT INTO `temp_scene` VALUES ('18', '冰雪幻境', '0', '0', '7', '0', '60', '0', '1', '不辞冰雪修仙人，幻境美景多险恶', '0', '18', '0', '1', null, '0');
INSERT INTO `temp_scene` VALUES ('19', '万归仙岛', '0', '0', '7', '0', '45', '0', '1', '万物尽生道行中，归人何处觅归途', '0', '19', '0', '1', null, '0');
INSERT INTO `temp_scene` VALUES ('20', '桃源幻境', '0', '0', '7', '0', '40', '0', '1', '桃源桃花相映红，不见当年幻境春', '0', '20', '0', '1', null, '0');
INSERT INTO `temp_scene` VALUES ('21', '五行之地', '0', '0', '7', '0', '50', '0', '1', '天地阴阳自生化，五行奥秘待人识', '0', '21', '0', '1', null, '0');
INSERT INTO `temp_scene` VALUES ('22', '九渊神域', '0', '0', '7', '0', '45', '0', '1', '九渊圣域擂战鼓，仙界传扬英雄名', '0', '22', '0', '1', null, '0');
INSERT INTO `temp_scene` VALUES ('23', '锁妖塔', '0', '0', '7', '0', '37', '0', '1', '锁妖塔中锁妖龙，留待真人灭妖时', '0', '23', '0', '1', null, '0');
INSERT INTO `temp_scene` VALUES ('24', '金谷棋局', '0', '0', '7', '0', '35', '0', '1', '观棋不语真君子，局中自有金万千', '0', '24', '0', '1', null, '0');
