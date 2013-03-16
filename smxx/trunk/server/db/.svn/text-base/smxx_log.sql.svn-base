use smxx_log;
-- MySQL dump 10.13  Distrib 5.1.66, for redhat-linux-gnu (x86_64)
--
-- Host: 192.168.44.51    Database: smxx_log
-- ------------------------------------------------------
-- Server version	5.1.50-community-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `audit_cost_type`
--

DROP TABLE IF EXISTS `audit_cost_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `audit_cost_type` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `type_id` int(10) NOT NULL DEFAULT '0' COMMENT '消费类型编码',
  `type_name` varchar(100) NOT NULL DEFAULT '0' COMMENT '消费类型名称',
  PRIMARY KEY (`id`),
  KEY `type_id` (`type_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='消费类型配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_cost_type`
--

LOCK TABLES `audit_cost_type` WRITE;
/*!40000 ALTER TABLE `audit_cost_type` DISABLE KEYS */;
/*!40000 ALTER TABLE `audit_cost_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audit_gold_cost`
--

DROP TABLE IF EXISTS `audit_gold_cost`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `audit_gold_cost` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `item_type` int(11) NOT NULL COMMENT '消费类型',
  `gold_count` int(11) NOT NULL COMMENT '元宝数量',
  `recdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `recdate` (`recdate`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='各消费类型元宝消耗统计';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_gold_cost`
--

LOCK TABLES `audit_gold_cost` WRITE;
/*!40000 ALTER TABLE `audit_gold_cost` DISABLE KEYS */;
/*!40000 ALTER TABLE `audit_gold_cost` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audit_gold_stock`
--

DROP TABLE IF EXISTS `audit_gold_stock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `audit_gold_stock` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `all_gold` int(11) NOT NULL COMMENT '总充值元宝',
  `send_gold` int(11) NOT NULL DEFAULT '0' COMMENT '充值赠送元宝数',
  `used_gold` int(11) NOT NULL COMMENT '消耗元宝',
  `remain_gold` int(11) NOT NULL COMMENT '元宝库存总量',
  `recdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `recdate` (`recdate`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='元宝库存';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_gold_stock`
--

LOCK TABLES `audit_gold_stock` WRITE;
/*!40000 ALTER TABLE `audit_gold_stock` DISABLE KEYS */;
/*!40000 ALTER TABLE `audit_gold_stock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audit_goods_cost`
--

DROP TABLE IF EXISTS `audit_goods_cost`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `audit_goods_cost` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `item_id` int(11) NOT NULL COMMENT '物品id',
  `used_count` int(11) NOT NULL COMMENT '消耗的物品数量',
  `recdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `recdate` (`recdate`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='物品的消耗量（不区分是商城购买还是系统产出，只要有消耗，就加1，区分两套道具，只有在商城有销售的物品才统计消耗）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_goods_cost`
--

LOCK TABLES `audit_goods_cost` WRITE;
/*!40000 ALTER TABLE `audit_goods_cost` DISABLE KEYS */;
/*!40000 ALTER TABLE `audit_goods_cost` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audit_goods_output`
--

DROP TABLE IF EXISTS `audit_goods_output`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `audit_goods_output` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `item_id` int(11) NOT NULL COMMENT '物品id',
  `get_count` int(11) NOT NULL COMMENT '玩家获得的物品数量',
  `recdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `recdate` (`recdate`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='物品产出统计（统计除了商城购买外，其他任何方式取得的道具数据，包括开箱子、淘宝等方式，可以只统计商城有售的物品清单）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_goods_output`
--

LOCK TABLES `audit_goods_output` WRITE;
/*!40000 ALTER TABLE `audit_goods_output` DISABLE KEYS */;
/*!40000 ALTER TABLE `audit_goods_output` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audit_goods_sell`
--

DROP TABLE IF EXISTS `audit_goods_sell`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `audit_goods_sell` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `item_id` int(11) NOT NULL COMMENT '物品id',
  `buy_count` int(11) NOT NULL COMMENT '购买的物品数量',
  `cost` int(11) NOT NULL COMMENT '总价',
  `recdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `recdate` (`recdate`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='商城物品销售统计';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_goods_sell`
--

LOCK TABLES `audit_goods_sell` WRITE;
/*!40000 ALTER TABLE `audit_goods_sell` DISABLE KEYS */;
/*!40000 ALTER TABLE `audit_goods_sell` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audit_goods_stock`
--

DROP TABLE IF EXISTS `audit_goods_stock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `audit_goods_stock` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `item_id` int(11) NOT NULL COMMENT '物品id',
  `remain_count` int(11) NOT NULL COMMENT '剩余的物品数量',
  `recdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `recdate` (`recdate`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='物品的库存量（仅统计商城有出售的物品）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_goods_stock`
--

LOCK TABLES `audit_goods_stock` WRITE;
/*!40000 ALTER TABLE `audit_goods_stock` DISABLE KEYS */;
/*!40000 ALTER TABLE `audit_goods_stock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_add_coin`
--

DROP TABLE IF EXISTS `log_add_coin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_add_coin` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uid` bigint(20) NOT NULL DEFAULT '0',
  `num` int(11) NOT NULL DEFAULT '0',
  `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0绑定铜钱,1铜钱',
  `source` int(11) NOT NULL DEFAULT '0' COMMENT '来源',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`)
) ENGINE=MyISAM AUTO_INCREMENT=58 DEFAULT CHARSET=utf8 COMMENT='发放铜钱和绑定铜钱日志';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_add_coin`
--

LOCK TABLES `log_add_coin` WRITE;
/*!40000 ALTER TABLE `log_add_coin` DISABLE KEYS */;
INSERT INTO `log_add_coin` VALUES (1,1,300,0,0,'2013-03-07 04:41:17'),(2,1,300,0,0,'2013-03-07 04:41:28'),(3,2,300,0,0,'2013-03-07 05:43:17'),(4,2,300,0,0,'2013-03-07 07:07:04'),(5,2,10,0,0,'2013-03-07 07:26:40'),(6,2,12,0,0,'2013-03-07 08:22:07'),(7,1,300,0,1,'2013-03-07 09:56:41'),(8,1,300,0,1,'2013-03-07 09:57:07'),(9,1,300,0,1,'2013-03-07 09:57:36'),(10,1,300,0,1,'2013-03-07 09:59:48'),(11,1,300,0,1,'2013-03-07 10:00:11'),(12,1,300,0,1,'2013-03-07 10:15:42'),(13,1,300,0,1,'2013-03-07 11:58:26'),(14,1,300,0,1,'2013-03-07 12:02:45'),(15,2,300,0,1,'2013-03-08 01:19:01'),(16,1,300,0,1,'2013-03-08 01:36:52'),(17,164006,12,0,2000,'2013-03-08 03:59:00'),(18,164006,14,0,2000,'2013-03-08 05:48:23'),(19,164006,14,0,2000,'2013-03-08 05:48:43'),(20,164006,140,0,2000,'2013-03-08 06:43:49'),(21,164006,140,0,2000,'2013-03-08 06:45:11'),(22,164006,140,0,2000,'2013-03-08 06:45:39'),(23,164006,140,0,2000,'2013-03-08 06:46:14'),(24,2,120,0,2000,'2013-03-08 06:46:41'),(25,2,300,0,1,'2013-03-08 06:58:34'),(26,164006,140,0,2000,'2013-03-08 07:55:50'),(27,164006,140,0,2000,'2013-03-08 07:57:58'),(28,164006,140,0,2000,'2013-03-08 08:00:12'),(29,2,120,0,2000,'2013-03-08 08:02:00'),(30,2,120,0,2000,'2013-03-08 08:02:14'),(31,2,120,0,2000,'2013-03-08 08:02:56'),(32,2,120,0,2000,'2013-03-08 08:03:19'),(33,2,120,0,2000,'2013-03-08 08:04:04'),(34,2,120,0,2000,'2013-03-08 08:04:15'),(35,2,120,0,2000,'2013-03-08 08:04:33'),(36,2,120,0,2000,'2013-03-08 08:39:57'),(37,2,100,0,2000,'2013-03-08 08:56:00'),(38,2,120,0,2000,'2013-03-08 09:00:50'),(39,2,120,0,2000,'2013-03-08 09:01:18'),(40,2,120,0,2000,'2013-03-08 09:01:46'),(41,164006,120,0,2000,'2013-03-08 09:04:26'),(42,164006,140,0,2000,'2013-03-08 09:06:15'),(43,2,120,0,2000,'2013-03-08 09:11:04'),(44,3,140,0,2000,'2013-03-08 09:14:01'),(45,3,140,0,2000,'2013-03-08 09:14:25'),(46,3,140,0,2000,'2013-03-08 09:14:37'),(47,3,140,0,2000,'2013-03-08 09:15:17'),(48,1,140,0,2000,'2013-03-08 09:37:10'),(49,129003,140,0,2000,'2013-03-08 09:57:00'),(50,92002,100,0,2000,'2013-03-11 08:13:59'),(51,92002,100,0,2000,'2013-03-11 08:14:36'),(52,92002,100,0,2000,'2013-03-11 08:15:04'),(53,92002,100,0,2000,'2013-03-11 08:15:33'),(54,92002,100,0,2000,'2013-03-11 08:16:07'),(55,92002,100,0,2000,'2013-03-11 08:16:53'),(56,92002,100,0,2000,'2013-03-11 08:17:21'),(57,92002,100,0,2000,'2013-03-11 08:17:50');
/*!40000 ALTER TABLE `log_add_coin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_add_gold`
--

DROP TABLE IF EXISTS `log_add_gold`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_add_gold` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uid` bigint(20) NOT NULL DEFAULT '0',
  `num` int(11) NOT NULL DEFAULT '0',
  `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0绑定元宝,1元宝',
  `source` int(11) NOT NULL DEFAULT '0' COMMENT '来源',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='发放元宝和绑定元宝日志';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_add_gold`
--

LOCK TABLES `log_add_gold` WRITE;
/*!40000 ALTER TABLE `log_add_gold` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_add_gold` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_add_goods`
--

DROP TABLE IF EXISTS `log_add_goods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_add_goods` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uid` bigint(20) NOT NULL DEFAULT '0',
  `gtid` int(11) NOT NULL DEFAULT '0',
  `num` int(11) NOT NULL DEFAULT '0',
  `bind` tinyint(4) NOT NULL COMMENT '0不限制,2装备绑定,3已绑定',
  `add_type` int(11) NOT NULL,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`),
  KEY `create_time` (`create_time`)
) ENGINE=MyISAM AUTO_INCREMENT=167 DEFAULT CHARSET=utf8 COMMENT='物品发放日志';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_add_goods`
--

LOCK TABLES `log_add_goods` WRITE;
/*!40000 ALTER TABLE `log_add_goods` DISABLE KEYS */;
INSERT INTO `log_add_goods` VALUES (1,1,217073204,1,3,0,'2013-03-07 09:55:19'),(2,1,217073204,1,3,0,'2013-03-07 09:55:19'),(3,1,217073204,1,3,0,'2013-03-07 09:55:19'),(4,1,217073204,1,3,0,'2013-03-07 09:55:19'),(5,1,217073204,1,3,0,'2013-03-07 09:55:19'),(6,1,253005201,3,0,0,'2013-03-07 09:55:19'),(7,1,217073204,1,3,1,'2013-03-07 09:56:41'),(8,1,217073204,1,3,1,'2013-03-07 09:57:07'),(9,1,253005201,5,3,1,'2013-03-07 09:57:36'),(10,1,217073204,1,3,1,'2013-03-07 09:57:36'),(11,1,217073204,1,3,1,'2013-03-07 09:57:36'),(12,1,253005201,5,3,1,'2013-03-07 09:59:48'),(13,1,217073204,1,3,1,'2013-03-07 09:59:48'),(14,1,217073204,1,3,1,'2013-03-07 09:59:48'),(15,1,253005201,5,3,1,'2013-03-07 10:00:11'),(16,1,217073204,1,3,1,'2013-03-07 10:00:11'),(17,1,217073204,1,3,1,'2013-03-07 10:00:11'),(18,1,253005201,5,3,0,'2013-03-07 10:04:09'),(19,1,253005201,5,3,0,'2013-03-07 10:07:19'),(20,1,253005201,5,3,0,'2013-03-07 10:07:22'),(21,1,253005201,5,3,0,'2013-03-07 10:15:17'),(22,1,253005201,5,3,1,'2013-03-07 10:15:42'),(23,1,217073204,1,3,1,'2013-03-07 10:15:42'),(24,1,217073204,1,3,1,'2013-03-07 10:15:42'),(25,1,217073204,1,3,0,'2013-03-07 11:58:08'),(26,1,217073204,1,3,0,'2013-03-07 11:58:08'),(27,1,217073204,1,3,0,'2013-03-07 11:58:08'),(28,1,217073204,1,3,0,'2013-03-07 11:58:08'),(29,1,217073204,1,3,0,'2013-03-07 11:58:08'),(30,1,253005201,5,3,1,'2013-03-07 11:58:26'),(31,1,217073204,1,3,1,'2013-03-07 11:58:26'),(32,1,217073204,1,3,1,'2013-03-07 11:58:26'),(33,1,253005201,5,3,1,'2013-03-07 12:02:45'),(34,1,217073204,1,3,1,'2013-03-07 12:02:45'),(35,1,217073204,1,3,1,'2013-03-07 12:02:45'),(36,1,217073204,1,3,0,'2013-03-07 12:11:11'),(37,1,217073204,1,3,0,'2013-03-07 12:11:11'),(38,1,217073204,1,3,0,'2013-03-07 12:11:11'),(39,1,217073204,1,3,0,'2013-03-07 12:11:11'),(40,1,217073204,1,3,0,'2013-03-07 12:11:11'),(41,1,217073204,1,3,0,'2013-03-07 12:23:42'),(42,1,217073204,1,3,0,'2013-03-07 12:23:42'),(43,1,217073204,1,3,0,'2013-03-07 12:23:42'),(44,1,217073204,1,3,0,'2013-03-07 12:23:42'),(45,1,217073204,1,3,0,'2013-03-07 12:23:42'),(46,1,217073204,1,3,0,'2013-03-07 12:25:07'),(47,1,217073204,1,3,0,'2013-03-07 12:25:07'),(48,1,217073204,1,3,0,'2013-03-07 12:25:07'),(49,1,217073204,1,3,0,'2013-03-07 12:25:07'),(50,1,217073204,1,3,0,'2013-03-07 12:25:07'),(51,1,217073204,1,3,0,'2013-03-07 12:30:11'),(52,1,217073204,1,3,0,'2013-03-07 12:30:15'),(53,1,217073204,1,3,0,'2013-03-07 12:30:15'),(54,1,217073204,1,3,0,'2013-03-07 12:30:15'),(55,1,217073204,1,3,0,'2013-03-07 12:30:15'),(56,1,217073204,1,3,0,'2013-03-07 12:34:26'),(57,1,217073204,1,3,0,'2013-03-07 12:34:32'),(58,1,217073204,1,3,0,'2013-03-07 12:34:32'),(59,1,217073204,1,3,0,'2013-03-07 12:34:32'),(60,1,217073204,1,3,0,'2013-03-07 12:34:32'),(61,1,217073204,1,3,0,'2013-03-07 12:34:36'),(62,1,217073204,1,3,0,'2013-03-07 12:34:36'),(63,1,217073204,1,3,0,'2013-03-07 12:34:36'),(64,1,217073204,1,3,0,'2013-03-07 12:34:36'),(65,1,217073204,1,3,0,'2013-03-07 12:34:36'),(66,1,217073204,1,3,0,'2013-03-07 12:34:43'),(67,1,217073204,1,3,0,'2013-03-07 12:34:50'),(68,1,217073204,1,3,0,'2013-03-07 12:34:50'),(69,1,217073204,1,3,0,'2013-03-07 12:34:50'),(70,1,217073204,1,3,0,'2013-03-07 12:34:50'),(71,1,217073204,1,3,0,'2013-03-07 12:51:03'),(72,1,217073204,1,3,0,'2013-03-07 12:51:07'),(73,1,217073204,1,3,0,'2013-03-07 12:51:07'),(74,1,217073204,1,3,0,'2013-03-07 12:51:07'),(75,1,217073204,1,3,0,'2013-03-07 12:51:07'),(76,2,217073204,1,3,0,'2013-03-07 12:53:55'),(77,2,217073204,1,3,0,'2013-03-07 12:54:00'),(78,2,217073204,1,3,0,'2013-03-07 12:54:01'),(79,2,217073204,1,3,0,'2013-03-07 12:54:01'),(80,2,217073204,1,3,0,'2013-03-07 12:54:01'),(81,2,217073204,1,3,0,'2013-03-07 12:56:44'),(82,2,217073204,1,3,0,'2013-03-07 12:56:54'),(83,2,217073204,1,3,0,'2013-03-07 12:56:54'),(84,2,217073204,1,3,0,'2013-03-07 12:56:54'),(85,2,217073204,1,3,0,'2013-03-07 12:56:54'),(86,2,217073204,1,3,0,'2013-03-07 12:59:41'),(87,2,217073204,1,3,0,'2013-03-07 12:59:53'),(88,2,217073204,1,3,0,'2013-03-07 12:59:53'),(89,2,217073204,1,3,0,'2013-03-07 12:59:53'),(90,2,217073204,1,3,0,'2013-03-07 12:59:53'),(91,1,217073204,1,3,0,'2013-03-07 13:07:15'),(92,1,217073204,1,3,0,'2013-03-07 13:07:15'),(93,1,217073204,1,3,0,'2013-03-07 13:07:15'),(94,1,217073204,1,3,0,'2013-03-07 13:07:15'),(95,1,217073204,1,3,0,'2013-03-07 13:07:15'),(96,1,217073204,1,3,0,'2013-03-07 13:08:43'),(97,1,217073204,1,3,0,'2013-03-07 13:09:13'),(98,1,217073204,1,3,0,'2013-03-07 13:09:13'),(99,1,217073204,1,3,0,'2013-03-07 13:09:13'),(100,1,217073204,1,3,0,'2013-03-07 13:09:13'),(101,2,217073204,1,3,0,'2013-03-07 13:10:46'),(102,2,217073204,1,3,0,'2013-03-07 13:10:50'),(103,2,217073204,1,3,0,'2013-03-07 13:10:50'),(104,2,217073204,1,3,0,'2013-03-07 13:10:50'),(105,2,217073204,1,3,0,'2013-03-07 13:10:50'),(106,2,217073204,1,3,0,'2013-03-08 01:15:05'),(107,2,217073204,1,3,0,'2013-03-08 01:15:05'),(108,2,217073204,1,3,0,'2013-03-08 01:15:05'),(109,2,217073204,1,3,0,'2013-03-08 01:15:05'),(110,2,217073204,1,3,0,'2013-03-08 01:15:05'),(111,2,205073204,1,3,1,'2013-03-08 01:19:01'),(112,2,205073204,1,3,1,'2013-03-08 01:19:01'),(113,2,203063204,1,3,1,'2013-03-08 01:19:01'),(114,2,203063204,1,3,1,'2013-03-08 01:19:01'),(115,2,201011203,1,3,1,'2013-03-08 01:19:01'),(116,2,201011203,1,3,1,'2013-03-08 01:19:01'),(117,2,253005201,5,3,1,'2013-03-08 01:19:01'),(118,2,217073204,1,3,1,'2013-03-08 01:19:01'),(119,2,217073204,1,3,1,'2013-03-08 01:19:01'),(120,1,217073204,1,3,0,'2013-03-08 01:29:20'),(121,1,217073204,1,3,0,'2013-03-08 01:29:20'),(122,1,217073204,1,3,0,'2013-03-08 01:29:20'),(123,1,217073204,1,3,0,'2013-03-08 01:29:20'),(124,1,217073204,1,3,0,'2013-03-08 01:29:20'),(125,1,205073204,1,3,1,'2013-03-08 01:36:52'),(126,1,205073204,1,3,1,'2013-03-08 01:36:57'),(127,1,203063204,1,3,1,'2013-03-08 01:36:57'),(128,1,203063204,1,3,1,'2013-03-08 01:36:57'),(129,1,201011203,1,3,1,'2013-03-08 01:36:57'),(130,1,201011203,1,3,1,'2013-03-08 01:36:57'),(131,1,253005201,5,3,1,'2013-03-08 01:36:57'),(132,1,217073204,1,3,1,'2013-03-08 01:36:57'),(133,1,217073204,1,3,1,'2013-03-08 01:36:57'),(134,1,431006201,5,0,0,'2013-03-08 01:37:43'),(135,2,203102204,1,3,1,'2013-03-08 07:00:45'),(136,2,203102204,1,3,1,'2013-03-08 07:00:45'),(137,2,201042204,1,3,1,'2013-03-08 07:00:45'),(138,2,201042204,1,3,1,'2013-03-08 07:00:45'),(139,2,201042204,1,3,1,'2013-03-08 07:00:45'),(140,2,201042204,1,3,1,'2013-03-08 07:00:45'),(141,2,201042204,1,3,1,'2013-03-08 07:00:45'),(142,2,201011203,1,3,1,'2013-03-08 07:00:45'),(143,2,201011203,1,3,1,'2013-03-08 07:00:45'),(144,1,431006201,5,0,0,'2013-03-08 08:12:43'),(145,129001,203102204,1,3,1,'2013-03-09 01:05:24'),(146,129001,203102204,1,3,1,'2013-03-09 01:05:24'),(147,129001,201042204,1,3,1,'2013-03-09 01:05:24'),(148,129001,201042204,1,3,1,'2013-03-09 01:05:24'),(149,129001,201042204,1,3,1,'2013-03-09 01:05:24'),(150,129001,201042204,1,3,1,'2013-03-09 01:05:24'),(151,129001,201042204,1,3,1,'2013-03-09 01:05:24'),(152,129001,201011203,1,3,1,'2013-03-09 01:05:24'),(153,129001,201011203,1,3,1,'2013-03-09 01:05:24'),(154,129001,203102204,1,3,1,'2013-03-09 01:06:09'),(155,129001,203102204,1,3,1,'2013-03-09 01:06:09'),(156,129001,201042204,1,3,1,'2013-03-09 01:06:09'),(157,129001,201042204,1,3,1,'2013-03-09 01:06:09'),(158,129001,201042204,1,3,1,'2013-03-09 01:06:09'),(159,129001,201042204,1,3,1,'2013-03-09 01:06:09'),(160,129001,201042204,1,3,1,'2013-03-09 01:06:09'),(161,129001,201011203,1,3,1,'2013-03-09 01:06:09'),(162,92002,211031204,1,3,2000,'2013-03-11 08:14:03'),(163,92002,211032204,1,3,2000,'2013-03-11 08:14:38'),(164,92002,211031204,1,3,2000,'2013-03-11 08:15:18'),(165,92002,211031204,1,3,2000,'2013-03-11 08:15:43'),(166,92002,211031204,1,3,2000,'2013-03-11 08:16:59');
/*!40000 ALTER TABLE `log_add_goods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_cost_coin`
--

DROP TABLE IF EXISTS `log_cost_coin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_cost_coin` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uid` bigint(20) NOT NULL DEFAULT '0',
  `coin` int(11) NOT NULL DEFAULT '0',
  `bcoin` int(11) NOT NULL DEFAULT '0',
  `cost_type` int(11) NOT NULL DEFAULT '0',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `create_time` (`create_time`),
  KEY `uid` (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='铜钱消耗日志';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_cost_coin`
--

LOCK TABLES `log_cost_coin` WRITE;
/*!40000 ALTER TABLE `log_cost_coin` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_cost_coin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_cost_gold`
--

DROP TABLE IF EXISTS `log_cost_gold`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_cost_gold` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uid` bigint(20) NOT NULL DEFAULT '0',
  `gold` int(11) NOT NULL DEFAULT '0' COMMENT '消耗元宝',
  `bgold` int(11) NOT NULL DEFAULT '0' COMMENT '消耗绑定元宝',
  `cost_type` int(11) NOT NULL DEFAULT '0' COMMENT '消费类型',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `create_time` (`create_time`),
  KEY `uid` (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='元宝消耗日志';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_cost_gold`
--

LOCK TABLES `log_cost_gold` WRITE;
/*!40000 ALTER TABLE `log_cost_gold` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_cost_gold` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_cost_goods`
--

DROP TABLE IF EXISTS `log_cost_goods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_cost_goods` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uid` bigint(20) NOT NULL DEFAULT '0',
  `gtid` int(11) NOT NULL DEFAULT '0',
  `num` int(11) NOT NULL DEFAULT '0',
  `bind` tinyint(4) NOT NULL COMMENT '0不限制,2装备绑定,3已绑定',
  `cost_type` int(11) NOT NULL,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`),
  KEY `create_time` (`create_time`)
) ENGINE=MyISAM AUTO_INCREMENT=44 DEFAULT CHARSET=utf8 COMMENT='消耗物品日志';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_cost_goods`
--

LOCK TABLES `log_cost_goods` WRITE;
/*!40000 ALTER TABLE `log_cost_goods` DISABLE KEYS */;
INSERT INTO `log_cost_goods` VALUES (1,1,217073204,2,3,100,'2013-03-07 12:24:05'),(2,1,217073204,1,3,100,'2013-03-07 12:24:05'),(3,1,217073204,2,3,100,'2013-03-07 12:24:15'),(4,1,217073204,1,3,100,'2013-03-07 12:24:15'),(5,1,217073204,1,3,100,'2013-03-07 12:24:34'),(6,1,217073204,2,3,100,'2013-03-07 12:25:11'),(7,1,217073204,1,3,100,'2013-03-07 12:25:11'),(8,1,217073204,2,3,100,'2013-03-07 12:25:22'),(9,1,217073204,1,3,100,'2013-03-07 12:25:22'),(10,1,217073204,1,3,100,'2013-03-07 12:26:19'),(11,1,217073204,2,3,100,'2013-03-07 12:31:28'),(12,1,217073204,1,3,100,'2013-03-07 12:31:28'),(13,1,217073204,2,3,100,'2013-03-07 12:31:33'),(14,1,217073204,1,3,100,'2013-03-07 12:31:33'),(15,1,217073204,1,3,100,'2013-03-07 12:31:38'),(16,1,217073204,13,3,100,'2013-03-07 12:35:37'),(17,1,217073204,12,3,100,'2013-03-07 12:35:37'),(18,1,217073204,11,3,100,'2013-03-07 12:35:37'),(19,1,217073204,10,3,100,'2013-03-07 12:35:37'),(20,1,217073204,9,3,100,'2013-03-07 12:35:37'),(21,1,217073204,8,3,100,'2013-03-07 12:35:37'),(22,1,217073204,7,3,100,'2013-03-07 12:35:37'),(23,1,217073204,6,3,100,'2013-03-07 12:35:37'),(24,1,217073204,5,3,100,'2013-03-07 12:35:37'),(25,1,217073204,4,3,100,'2013-03-07 12:35:37'),(26,1,217073204,3,3,100,'2013-03-07 12:35:37'),(27,1,217073204,2,3,100,'2013-03-07 12:35:37'),(28,1,217073204,1,3,100,'2013-03-07 12:35:37'),(29,1,217073204,1,3,100,'2013-03-07 12:36:51'),(30,2,205073204,1,3,100,'2013-03-08 01:20:32'),(31,2,201011203,1,3,100,'2013-03-08 01:23:54'),(32,2,205073204,1,3,5,'2013-03-08 01:25:34'),(33,2,201011203,1,3,5,'2013-03-08 01:25:45'),(34,2,203063204,1,3,5,'2013-03-08 01:25:47'),(35,2,203063204,1,3,5,'2013-03-08 01:25:48'),(36,2,253005201,5,3,5,'2013-03-08 01:25:49'),(37,2,217073204,1,3,5,'2013-03-08 01:25:50'),(38,2,217073204,1,3,5,'2013-03-08 01:25:51'),(39,1,431006201,1,0,2,'2013-03-08 01:40:06'),(40,1,431006201,1,0,2,'2013-03-08 01:40:17'),(41,2,203102204,1,3,5,'2013-03-08 08:38:34'),(42,2,201042204,1,3,5,'2013-03-08 08:39:41'),(43,2,203102204,1,3,5,'2013-03-08 08:39:55');
/*!40000 ALTER TABLE `log_cost_goods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_gem`
--

DROP TABLE IF EXISTS `log_gem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_gem` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uid` bigint(20) NOT NULL,
  `gid` bigint(20) NOT NULL,
  `gtid` int(11) NOT NULL,
  `type` tinyint(4) NOT NULL COMMENT '0镶嵌,1拆除',
  `old_gem` varchar(100) NOT NULL,
  `new_gem` varchar(100) NOT NULL,
  `coin` int(11) NOT NULL,
  `bcoin` int(11) NOT NULL,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='宝石镶嵌、拆除';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_gem`
--

LOCK TABLES `log_gem` WRITE;
/*!40000 ALTER TABLE `log_gem` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_gem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_gem_compose`
--

DROP TABLE IF EXISTS `log_gem_compose`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_gem_compose` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uid` bigint(20) DEFAULT NULL,
  `gid` bigint(20) DEFAULT NULL,
  `gtid` int(11) DEFAULT NULL,
  `cost_goods` varchar(100) DEFAULT NULL,
  `coin` int(11) DEFAULT NULL,
  `bcoin` int(11) DEFAULT NULL,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='宝石合成';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_gem_compose`
--

LOCK TABLES `log_gem_compose` WRITE;
/*!40000 ALTER TABLE `log_gem_compose` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_gem_compose` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_gilding`
--

DROP TABLE IF EXISTS `log_gilding`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_gilding` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uid` bigint(20) NOT NULL,
  `gid` bigint(20) NOT NULL,
  `gtid` int(11) NOT NULL,
  `coin` int(11) NOT NULL,
  `bcoin` int(11) NOT NULL,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='镀金';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_gilding`
--

LOCK TABLES `log_gilding` WRITE;
/*!40000 ALTER TABLE `log_gilding` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_gilding` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_godtried`
--

DROP TABLE IF EXISTS `log_godtried`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_godtried` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uid` bigint(20) NOT NULL,
  `gid` bigint(20) NOT NULL,
  `gtid` int(11) NOT NULL,
  `cost_goods` varchar(100) NOT NULL,
  `coin` int(11) NOT NULL,
  `bcoin` int(11) NOT NULL,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='宝石神炼';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_godtried`
--

LOCK TABLES `log_godtried` WRITE;
/*!40000 ALTER TABLE `log_godtried` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_godtried` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_goods_output`
--

DROP TABLE IF EXISTS `log_goods_output`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_goods_output` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `goods_tid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '物品ID',
  `num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '物品数量',
  `timestamp` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`),
  KEY `index_goods_id` (`goods_tid`),
  KEY `index_timestamp` (`timestamp`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='物品产出统计（统计除了商城购买外，其他任何方式取得的道具数据，包括开箱子、淘宝等方式，可以只统计商城有售的物品清单）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_goods_output`
--

LOCK TABLES `log_goods_output` WRITE;
/*!40000 ALTER TABLE `log_goods_output` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_goods_output` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_kick_off`
--

DROP TABLE IF EXISTS `log_kick_off`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_kick_off` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `uid` bigint(20) unsigned NOT NULL COMMENT '用户ID',
  `nick` varchar(200) CHARACTER SET utf8 NOT NULL COMMENT '名称',
  `k_type` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '踢出类型:1废号,2发包异常,3超时,7心跳包异常,8走路异常,9切换场景异常',
  `time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '时间记录',
  `scene` int(11) NOT NULL,
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL,
  `other` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '[]' COMMENT '其他',
  PRIMARY KEY (`id`),
  KEY `id` (`id`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=7630 DEFAULT CHARSET=latin1 COMMENT='镇妖塔日志';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_kick_off`
--

LOCK TABLES `log_kick_off` WRITE;
/*!40000 ALTER TABLE `log_kick_off` DISABLE KEYS */;
INSERT INTO `log_kick_off` VALUES (7624,23,'GUEST-40008',7,1359085709,10101,11,13,''),(7625,22,'GUEST-40007',7,1359095494,10101,21,20,''),(7626,36,'u40000',7,1359459874,10101,34,14,''),(7627,1291007,'player_1362469208',7,1362471334,10101,8,12,''),(7628,164001,'player_1362476898',7,1362540502,10101,8,16,''),(7629,2,'player_1362473818',7,1362724881,10101,10,10,'');
/*!40000 ALTER TABLE `log_kick_off` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_pay`
--

DROP TABLE IF EXISTS `log_pay`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_pay` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pay_num` varchar(20) CHARACTER SET latin1 NOT NULL DEFAULT '' COMMENT '充值订单号',
  `pay_user` varchar(20) CHARACTER SET latin1 NOT NULL DEFAULT '' COMMENT '充值用户名',
  `player_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '玩家角色ID',
  `nickname` varchar(50) CHARACTER SET latin1 NOT NULL DEFAULT '' COMMENT '角色名称',
  `lv` smallint(6) unsigned NOT NULL DEFAULT '0' COMMENT '角色等级',
  `reg_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '注册时间',
  `first_pay` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否第一次充值:1-是0-否',
  `money` int(11) unsigned DEFAULT '0' COMMENT '币货数',
  `pay_gold` int(11) NOT NULL DEFAULT '0' COMMENT '游戏币数量',
  `pay_time` int(11) NOT NULL DEFAULT '0' COMMENT '来自平台的时间 ',
  `insert_time` int(11) NOT NULL DEFAULT '0' COMMENT '插入数据库时间',
  `pay_status` smallint(6) NOT NULL DEFAULT '0' COMMENT '支付状态(1:成功;0失败;2:角色不存在)',
  `state` smallint(55) NOT NULL DEFAULT '0' COMMENT '奖励系统使用标志(0 未使用，1已使用)',
  PRIMARY KEY (`id`),
  KEY `id` (`id`) USING BTREE,
  KEY `player_id` (`player_id`) USING BTREE,
  KEY `nickname` (`nickname`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='玩家充值记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_pay`
--

LOCK TABLES `log_pay` WRITE;
/*!40000 ALTER TABLE `log_pay` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_pay` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_player`
--

DROP TABLE IF EXISTS `log_player`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_player` (
  `id` int(20) unsigned NOT NULL AUTO_INCREMENT,
  `acid` int(20) NOT NULL,
  `acnm` varchar(200) NOT NULL,
  `uid` int(20) NOT NULL,
  `nick` varchar(200) NOT NULL,
  `sex` int(3) DEFAULT NULL,
  `crr` int(5) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=232 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_player`
--

LOCK TABLES `log_player` WRITE;
/*!40000 ALTER TABLE `log_player` DISABLE KEYS */;
INSERT INTO `log_player` VALUES (1,30000,'Guest30000',13,'GUEST-30000',1,1),(2,100,'gg100',35,'GUEST-100',1,1),(3,4000,'USER4000',36,'u40000',1,123),(4,30000,'Guest30000',45,'GUEST-30000',1,1),(5,100,'gg100',46,'GUEST-100',1,1),(6,30000,'Guest30000',49,'GUEST-30000',1,1),(7,30000,'Guest30000',54,'GUEST-30000',1,1),(8,1,'guest1',59,'GUEST-1',1,1),(9,1,'guest1',6,'GUEST-1',1,1),(10,1,'guest1',13,'GUEST-1',1,1),(11,10000,'guest10000',15,'GUEST-10000',1,1),(12,10001,'guest10001',16,'GUEST-10001',1,1),(13,10002,'guest10002',17,'GUEST-10002',1,1),(14,10003,'guest10003',18,'GUEST-10003',1,1),(15,10004,'guest10004',19,'GUEST-10004',1,1),(16,10005,'guest10005',20,'GUEST-10005',1,1),(17,10006,'guest10006',21,'GUEST-10006',1,1),(18,10007,'guest10007',22,'GUEST-10007',1,1),(19,10008,'guest10008',23,'GUEST-10008',1,1),(20,10009,'guest10009',24,'GUEST-10009',1,1),(21,10010,'guest10010',25,'GUEST-10010',1,1),(22,10011,'guest10011',26,'GUEST-10011',1,1),(23,10012,'guest10012',27,'GUEST-10012',1,1),(24,10013,'guest10013',28,'GUEST-10013',1,1),(25,10014,'guest10014',29,'GUEST-10014',1,1),(26,10015,'guest10015',30,'GUEST-10015',1,1),(27,10016,'guest10016',31,'GUEST-10016',1,1),(28,10017,'guest10017',32,'GUEST-10017',1,1),(29,10018,'guest10018',33,'GUEST-10018',1,1),(30,10019,'guest10019',34,'GUEST-10019',1,1),(31,10020,'guest10020',35,'GUEST-10020',1,1),(32,10021,'guest10021',36,'GUEST-10021',1,1),(33,10022,'guest10022',37,'GUEST-10022',1,1),(34,10023,'guest10023',38,'GUEST-10023',1,1),(35,10024,'guest10024',39,'GUEST-10024',1,1),(36,10025,'guest10025',40,'GUEST-10025',1,1),(37,10026,'guest10026',41,'GUEST-10026',1,1),(38,10027,'guest10027',42,'GUEST-10027',1,1),(39,10028,'guest10028',43,'GUEST-10028',1,1),(40,10029,'guest10029',44,'GUEST-10029',1,1),(41,10030,'guest10030',45,'GUEST-10030',1,1),(42,10031,'guest10031',46,'GUEST-10031',1,1),(43,10032,'guest10032',47,'GUEST-10032',1,1),(44,10033,'guest10033',48,'GUEST-10033',1,1),(45,10034,'guest10034',49,'GUEST-10034',1,1),(46,10035,'guest10035',50,'GUEST-10035',1,1),(47,10036,'guest10036',51,'GUEST-10036',1,1),(48,10037,'guest10037',52,'GUEST-10037',1,1),(49,10038,'guest10038',53,'GUEST-10038',1,1),(50,10039,'guest10039',54,'GUEST-10039',1,1),(51,10040,'guest10040',55,'GUEST-10040',1,1),(52,10041,'guest10041',56,'GUEST-10041',1,1),(53,10042,'guest10042',57,'GUEST-10042',1,1),(54,10043,'guest10043',58,'GUEST-10043',1,1),(55,10044,'guest10044',59,'GUEST-10044',1,1),(56,10045,'guest10045',60,'GUEST-10045',1,1),(57,10046,'guest10046',61,'GUEST-10046',1,1),(58,10047,'guest10047',62,'GUEST-10047',1,1),(59,10048,'guest10048',63,'GUEST-10048',1,1),(60,10049,'guest10049',64,'GUEST-10049',1,1),(61,10050,'guest10050',65,'GUEST-10050',1,1),(62,10051,'guest10051',66,'GUEST-10051',1,1),(63,10052,'guest10052',67,'GUEST-10052',1,1),(64,10053,'guest10053',68,'GUEST-10053',1,1),(65,10054,'guest10054',69,'GUEST-10054',1,1),(66,10055,'guest10055',70,'GUEST-10055',1,1),(67,10056,'guest10056',71,'GUEST-10056',1,1),(68,10057,'guest10057',72,'GUEST-10057',1,1),(69,10058,'guest10058',73,'GUEST-10058',1,1),(70,10059,'guest10059',74,'GUEST-10059',1,1),(71,10060,'guest10060',75,'GUEST-10060',1,1),(72,10061,'guest10061',76,'GUEST-10061',1,1),(73,10062,'guest10062',77,'GUEST-10062',1,1),(74,10063,'guest10063',78,'GUEST-10063',1,1),(75,10064,'guest10064',79,'GUEST-10064',1,1),(76,10065,'guest10065',80,'GUEST-10065',1,1),(77,10066,'guest10066',81,'GUEST-10066',1,1),(78,10067,'guest10067',82,'GUEST-10067',1,1),(79,10068,'guest10068',83,'GUEST-10068',1,1),(80,10069,'guest10069',84,'GUEST-10069',1,1),(81,10070,'guest10070',85,'GUEST-10070',1,1),(82,10071,'guest10071',86,'GUEST-10071',1,1),(83,10072,'guest10072',87,'GUEST-10072',1,1),(84,10073,'guest10073',88,'GUEST-10073',1,1),(85,10074,'guest10074',89,'GUEST-10074',1,1),(86,10075,'guest10075',90,'GUEST-10075',1,1),(87,10076,'guest10076',91,'GUEST-10076',1,1),(88,10077,'guest10077',92,'GUEST-10077',1,1),(89,10078,'guest10078',93,'GUEST-10078',1,1),(90,10079,'guest10079',94,'GUEST-10079',1,1),(91,10080,'guest10080',95,'GUEST-10080',1,1),(92,10081,'guest10081',96,'GUEST-10081',1,1),(93,10082,'guest10082',97,'GUEST-10082',1,1),(94,10083,'guest10083',98,'GUEST-10083',1,1),(95,10084,'guest10084',99,'GUEST-10084',1,1),(96,10085,'guest10085',100,'GUEST-10085',1,1),(97,10086,'guest10086',101,'GUEST-10086',1,1),(98,10087,'guest10087',102,'GUEST-10087',1,1),(99,10088,'guest10088',103,'GUEST-10088',1,1),(100,10089,'guest10089',104,'GUEST-10089',1,1),(101,10090,'guest10090',105,'GUEST-10090',1,1),(102,10091,'guest10091',106,'GUEST-10091',1,1),(103,10092,'guest10092',107,'GUEST-10092',1,1),(104,10093,'guest10093',108,'GUEST-10093',1,1),(105,10094,'guest10094',109,'GUEST-10094',1,1),(106,10095,'guest10095',110,'GUEST-10095',1,1),(107,10096,'guest10096',111,'GUEST-10096',1,1),(108,10097,'guest10097',112,'GUEST-10097',1,1),(109,10098,'guest10098',113,'GUEST-10098',1,1),(110,10099,'guest10099',114,'GUEST-10099',1,1),(111,10100,'guest10100',115,'GUEST-10100',1,1),(112,10101,'guest10101',116,'GUEST-10101',1,1),(113,10102,'guest10102',117,'GUEST-10102',1,1),(114,10103,'guest10103',118,'GUEST-10103',1,1),(115,10104,'guest10104',119,'GUEST-10104',1,1),(116,10105,'guest10105',120,'GUEST-10105',1,1),(117,10106,'guest10106',121,'GUEST-10106',1,1),(118,10107,'guest10107',122,'GUEST-10107',1,1),(119,10108,'guest10108',123,'GUEST-10108',1,1),(120,10109,'guest10109',124,'GUEST-10109',1,1),(121,10110,'guest10110',125,'GUEST-10110',1,1),(122,10111,'guest10111',126,'GUEST-10111',1,1),(123,10112,'guest10112',127,'GUEST-10112',1,1),(124,10113,'guest10113',128,'GUEST-10113',1,1),(125,10114,'guest10114',129,'GUEST-10114',1,1),(126,10115,'guest10115',130,'GUEST-10115',1,1),(127,10116,'guest10116',131,'GUEST-10116',1,1),(128,10117,'guest10117',132,'GUEST-10117',1,1),(129,10118,'guest10118',133,'GUEST-10118',1,1),(130,10119,'guest10119',134,'GUEST-10119',1,1),(131,10120,'guest10120',135,'GUEST-10120',1,1),(132,10121,'guest10121',136,'GUEST-10121',1,1),(133,10122,'guest10122',137,'GUEST-10122',1,1),(134,10123,'guest10123',138,'GUEST-10123',1,1),(135,10124,'guest10124',139,'GUEST-10124',1,1),(136,10125,'guest10125',140,'GUEST-10125',1,1),(137,10126,'guest10126',141,'GUEST-10126',1,1),(138,10127,'guest10127',142,'GUEST-10127',1,1),(139,10128,'guest10128',143,'GUEST-10128',1,1),(140,10129,'guest10129',144,'GUEST-10129',1,1),(141,10130,'guest10130',145,'GUEST-10130',1,1),(142,10131,'guest10131',146,'GUEST-10131',1,1),(143,10132,'guest10132',147,'GUEST-10132',1,1),(144,10133,'guest10133',148,'GUEST-10133',1,1),(145,10134,'guest10134',149,'GUEST-10134',1,1),(146,10135,'guest10135',150,'GUEST-10135',1,1),(147,10136,'guest10136',151,'GUEST-10136',1,1),(148,10137,'guest10137',152,'GUEST-10137',1,1),(149,10138,'guest10138',153,'GUEST-10138',1,1),(150,10139,'guest10139',154,'GUEST-10139',1,1),(151,10140,'guest10140',155,'GUEST-10140',1,1),(152,10141,'guest10141',156,'GUEST-10141',1,1),(153,10142,'guest10142',157,'GUEST-10142',1,1),(154,10143,'guest10143',158,'GUEST-10143',1,1),(155,10144,'guest10144',159,'GUEST-10144',1,1),(156,10145,'guest10145',160,'GUEST-10145',1,1),(157,10146,'guest10146',161,'GUEST-10146',1,1),(158,10147,'guest10147',162,'GUEST-10147',1,1),(159,10148,'guest10148',163,'GUEST-10148',1,1),(160,10149,'guest10149',164,'GUEST-10149',1,1),(161,10150,'guest10150',165,'GUEST-10150',1,1),(162,10151,'guest10151',166,'GUEST-10151',1,1),(163,10152,'guest10152',167,'GUEST-10152',1,1),(164,10153,'guest10153',168,'GUEST-10153',1,1),(165,10154,'guest10154',169,'GUEST-10154',1,1),(166,10155,'guest10155',170,'GUEST-10155',1,1),(167,10156,'guest10156',171,'GUEST-10156',1,1),(168,10157,'guest10157',172,'GUEST-10157',1,1),(169,10158,'guest10158',173,'GUEST-10158',1,1),(170,10159,'guest10159',174,'GUEST-10159',1,1),(171,10160,'guest10160',175,'GUEST-10160',1,1),(172,10161,'guest10161',176,'GUEST-10161',1,1),(173,10162,'guest10162',177,'GUEST-10162',1,1),(174,10163,'guest10163',178,'GUEST-10163',1,1),(175,10164,'guest10164',179,'GUEST-10164',1,1),(176,10165,'guest10165',180,'GUEST-10165',1,1),(177,10166,'guest10166',181,'GUEST-10166',1,1),(178,10167,'guest10167',182,'GUEST-10167',1,1),(179,10168,'guest10168',183,'GUEST-10168',1,1),(180,10169,'guest10169',184,'GUEST-10169',1,1),(181,10170,'guest10170',185,'GUEST-10170',1,1),(182,10171,'guest10171',186,'GUEST-10171',1,1),(183,10172,'guest10172',187,'GUEST-10172',1,1),(184,10173,'guest10173',188,'GUEST-10173',1,1),(185,10174,'guest10174',189,'GUEST-10174',1,1),(186,10175,'guest10175',190,'GUEST-10175',1,1),(187,10176,'guest10176',191,'GUEST-10176',1,1),(188,10177,'guest10177',192,'GUEST-10177',1,1),(189,10178,'guest10178',193,'GUEST-10178',1,1),(190,10179,'guest10179',194,'GUEST-10179',1,1),(191,10180,'guest10180',195,'GUEST-10180',1,1),(192,10181,'guest10181',196,'GUEST-10181',1,1),(193,10000,'guest10000',197,'GUEST-10000',1,1),(194,100000,'guest100000',451,'GUEST-100000',1,1),(195,30000,'Guest30000',452,'GUEST-30000',1,1),(196,111,'mm10',455,'player_1362109745',1,1),(197,1111,'mm1311',10001,'player_1362130929',1,1),(198,777777,'8888',10002,'player_1362132160',1,1),(199,144,'jj144',129001,'player_1362188278',1,1),(200,145,'jj145',129002,'player_1362197993',1,1),(201,148,'jj148',129003,'player_1362199694',1,1),(202,149,'jj149',164001,'player_1362377167',1,1),(203,150,'jj150',1291001,'player_1362378608',1,1),(204,151,'jj151',1291002,'player_1362467863',1,1),(205,34234,'sdfdsfdsfdsfsdds',1291003,'player_1362468538',1,1),(206,34344,'sdfdsfdsfdsfsddsdf',1291004,'player_1362468569',1,3),(207,234234342,'4656dsfdfs33er',1291005,'player_1362468842',1,1),(208,5454,'465dsfdsfdfff',1291006,'player_1362469063',1,3),(209,3434,'465dsfdsfdfff2344',1291007,'player_1362469208',1,3),(210,343455555,'463ewrdsfdfs',1291008,'player_1362469345',1,3),(211,4534324,'dfgdfgdfggggg',1291009,'player_1362472138',1,3),(212,100000,'guest100000',1,'GUEST-100000',1,1),(213,0,'',2,'player_1362473688',1,1),(214,100000,'guest100000',1,'GUEST-100000',1,1),(215,0,'ccccljkplkjio',2,'player_1362473818',1,1),(216,151,'jj151',3,'player_1362473865',1,1),(217,152,'jj152',164001,'player_1362476898',1,1),(218,20000,'ROBOT20000',164002,'GUEST20000',1,3),(219,20001,'ROBOT20001',164003,'GUEST20001',1,3),(220,20002,'ROBOT20002',164004,'GUEST20002',1,3),(221,20003,'ROBOT20003',164005,'GUEST20003',1,3),(222,10,'mm10',164006,'player_1362647557',1,1),(223,7777,'_ssssssuuu77',164007,'player_1362656124',1,1),(224,858575754,'pyoyoiy',1,'安☆白wing~',1,1),(225,8578575,'pyoyoiy',2,'沛白飞风',1,1),(226,0,'001111111',129001,'player_1362736158',1,1),(227,858555556,'pyoyoiy',129002,'ωǒ诺破天',1,3),(228,10,'mm10',129003,'player_1362736598',1,1),(229,100000,'guest100000',164001,'GUEST-100000',1,1),(230,100000,'guest100000',92001,'GUEST-100000',1,1),(231,0,'001111111',92002,'player_1362989624',1,1);
/*!40000 ALTER TABLE `log_player` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_real_play`
--

DROP TABLE IF EXISTS `log_real_play`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_real_play` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pt` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '真正开始游戏的时间',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '角色ID',
  PRIMARY KEY (`id`),
  KEY `id` (`id`) USING BTREE,
  KEY `cp_time` (`pt`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_real_play`
--

LOCK TABLES `log_real_play` WRITE;
/*!40000 ALTER TABLE `log_real_play` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_real_play` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_stren`
--

DROP TABLE IF EXISTS `log_stren`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_stren` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uid` bigint(20) NOT NULL,
  `gid` bigint(20) NOT NULL,
  `gtid` int(11) NOT NULL,
  `old_stren` int(11) NOT NULL,
  `old_stren_percent` int(11) NOT NULL,
  `new_stren` int(11) NOT NULL,
  `new_stren_percent` int(11) unsigned NOT NULL,
  `coin` int(11) NOT NULL,
  `bcoin` int(11) NOT NULL,
  `gold` int(11) NOT NULL,
  `bgold` int(11) NOT NULL,
  `cost_goods` varchar(100) NOT NULL,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='强化日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_stren`
--

LOCK TABLES `log_stren` WRITE;
/*!40000 ALTER TABLE `log_stren` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_stren` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_upgrade`
--

DROP TABLE IF EXISTS `log_upgrade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_upgrade` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uid` bigint(20) NOT NULL,
  `gid` bigint(20) NOT NULL,
  `gtid` int(11) NOT NULL,
  `new_gtid` int(11) NOT NULL,
  `coin` int(11) NOT NULL,
  `bcoin` int(11) NOT NULL,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='装备升级';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_upgrade`
--

LOCK TABLES `log_upgrade` WRITE;
/*!40000 ALTER TABLE `log_upgrade` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_upgrade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_wash`
--

DROP TABLE IF EXISTS `log_wash`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_wash` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uid` bigint(20) NOT NULL,
  `gid` bigint(20) NOT NULL,
  `gtid` int(11) NOT NULL,
  `old_attri` varchar(100) NOT NULL,
  `new_attri` varchar(100) NOT NULL,
  `coin` int(11) NOT NULL,
  `bcoin` int(11) NOT NULL,
  `gold` int(11) NOT NULL,
  `bgold` int(11) NOT NULL,
  `cost_goods` varchar(100) NOT NULL,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='洗练日志';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_wash`
--

LOCK TABLES `log_wash` WRITE;
/*!40000 ALTER TABLE `log_wash` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_wash` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-03-11 16:27:29
