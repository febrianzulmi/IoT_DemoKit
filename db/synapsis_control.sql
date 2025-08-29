-- MariaDB dump 10.19  Distrib 10.5.23-MariaDB, for debian-linux-gnu (aarch64)
--
-- Host: localhost    Database: synapsis_control
-- ------------------------------------------------------
-- Server version	10.5.23-MariaDB-0+deb11u1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `crontab`
--

DROP TABLE IF EXISTS `crontab`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `crontab` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `schedule` varchar(50) NOT NULL,
  `command` varchar(200) NOT NULL,
  `state` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `crontab`
--

LOCK TABLES `crontab` WRITE;
/*!40000 ALTER TABLE `crontab` DISABLE KEYS */;
/*!40000 ALTER TABLE `crontab` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dashboard`
--

DROP TABLE IF EXISTS `dashboard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dashboard` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `value` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dashboard`
--

LOCK TABLES `dashboard` WRITE;
/*!40000 ALTER TABLE `dashboard` DISABLE KEYS */;
INSERT INTO `dashboard` VALUES (1,'name','Nearon'),(2,'port','80');
/*!40000 ALTER TABLE `dashboard` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dhcp`
--

DROP TABLE IF EXISTS `dhcp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dhcp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `value` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dhcp`
--

LOCK TABLES `dhcp` WRITE;
/*!40000 ALTER TABLE `dhcp` DISABLE KEYS */;
INSERT INTO `dhcp` VALUES (1,'interface','wlan0'),(2,'start','172.16.11.100'),(3,'end','172.16.11.255'),(4,'subnet','255.255.255.0'),(5,'gateway',''),(6,'dns1',''),(7,'dns2','');
/*!40000 ALTER TABLE `dhcp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fan`
--

DROP TABLE IF EXISTS `fan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fan` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `value` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fan`
--

LOCK TABLES `fan` WRITE;
/*!40000 ALTER TABLE `fan` DISABLE KEYS */;
INSERT INTO `fan` VALUES (1,'min_temp','25'),(2,'max_temp','40'),(3,'min_fan','0'),(4,'max_fan','20');
/*!40000 ALTER TABLE `fan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `identity`
--

DROP TABLE IF EXISTS `identity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `identity` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `value` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `identity`
--

LOCK TABLES `identity` WRITE;
/*!40000 ALTER TABLE `identity` DISABLE KEYS */;
INSERT INTO `identity` VALUES (1,'hostname','development-iot'),(2,'password','Rasp8266!');
/*!40000 ALTER TABLE `identity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `info`
--

DROP TABLE IF EXISTS `info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(10) NOT NULL,
  `value` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `info`
--

LOCK TABLES `info` WRITE;
/*!40000 ALTER TABLE `info` DISABLE KEYS */;
INSERT INTO `info` VALUES (1,'temp','0.0'),(2,'humidity','0.0'),(3,'cpu_temp','65.2'),(4,'cpu_usage','100.0 %'),(5,'memory','10% (397/3844 MB)'),(6,'storage','15% (4.3/29 GB)'),(7,'uptime','0 hour  00 minute  51 seconds'),(8,'boot_time','2025-08-29 09:07:56'),(9,'fan','20');
/*!40000 ALTER TABLE `info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `interface`
--

DROP TABLE IF EXISTS `interface`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `interface` (
  `name` varchar(10) NOT NULL,
  `tipe` tinyint(1) NOT NULL,
  `conn` tinyint(1) DEFAULT NULL,
  `mac` varchar(30) DEFAULT NULL,
  `ip` varchar(30) DEFAULT NULL,
  `subnet` varchar(30) DEFAULT NULL,
  `gateway` varchar(30) DEFAULT NULL,
  `dns` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interface`
--

LOCK TABLES `interface` WRITE;
/*!40000 ALTER TABLE `interface` DISABLE KEYS */;
INSERT INTO `interface` VALUES ('eth0',0,0,'d8:3a:dd:d5:01:3a','192.168.1.10','255.255.255.0','',''),('wlan0',1,1,'d8:3a:dd:5d:5c:0f','','','','');
/*!40000 ALTER TABLE `interface` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ntp`
--

DROP TABLE IF EXISTS `ntp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ntp` (
  `id` int(11) NOT NULL,
  `server` tinyint(1) NOT NULL,
  `ip_ntp` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ntp`
--

LOCK TABLES `ntp` WRITE;
/*!40000 ALTER TABLE `ntp` DISABLE KEYS */;
INSERT INTO `ntp` VALUES (1,1,'0.id.pool.ntp.org 1.id.pool.ntp.org 2.id.pool.ntp.org');
/*!40000 ALTER TABLE `ntp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project`
--

DROP TABLE IF EXISTS `project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `port` varchar(10) NOT NULL,
  `gateway` tinyint(1) NOT NULL,
  `node` tinyint(1) NOT NULL,
  `display` tinyint(1) NOT NULL,
  `protocol` tinyint(1) NOT NULL,
  `id_dashboard` int(11) NOT NULL,
  `id_node` int(11) NOT NULL,
  `id_gateway` int(11) NOT NULL,
  `id_auth` int(11) NOT NULL,
  `id_buffer` int(11) NOT NULL,
  `id_display` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project`
--

LOCK TABLES `project` WRITE;
/*!40000 ALTER TABLE `project` DISABLE KEYS */;
INSERT INTO `project` VALUES (1,'Nearon IoT','5000',0,1,1,1,10,11,0,13,14,12);
/*!40000 ALTER TABLE `project` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `services`
--

DROP TABLE IF EXISTS `services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `services` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `path` varchar(50) NOT NULL,
  `command` varchar(50) NOT NULL,
  `state` tinyint(1) NOT NULL,
  `autostart` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `services`
--

LOCK TABLES `services` WRITE;
/*!40000 ALTER TABLE `services` DISABLE KEYS */;
INSERT INTO `services` VALUES (2,'nearon_auth','/home/connex/project/auth','/usr/bin/python3 nearon_auth.py',1,1),(3,'nearon_routine','/home/connex/project/monitoring','/usr/bin/python3 nearon_routine.py',1,1),(4,'nearon_alarm','/home/connex/project/monitoring','/usr/bin/python3 nearon_alarm.py',1,1),(5,'nearon_buffer','/home/connex/project/monitoring','/usr/bin/python3 nearon_buffer.py',1,1),(6,'nearon_sync','/home/connex/project/synchronize','/usr/bin/python3 nearon_sync.py',1,1),(7,'nearon_notif','/home/connex/project/notification/','/usr/bin/python3 nearon_notif.py',1,1),(8,'nearon_log','/home/connex/project/log/','/usr/bin/python3 nearon_log.py',1,1),(9,'nearon_display','/home/connex/project/display','/usr/bin/python3 nearon_display.py',1,1),(10,'sensor1','/home/connex/project/sensor/','/usr/bin/python3 sensor1.py',1,1),(11,'sensor2','/home/connex/project/sensor/','/usr/bin/python3 sensor2.py',1,1),(12,'actuator1','/home/connex/project/actuator','/usr/bin/python3 actuator1.py',1,1),(13,'actuator2','/home/connex/project/actuator','/usr/bin/python3 actuator2.py',1,1);
/*!40000 ALTER TABLE `services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `snmp`
--

DROP TABLE IF EXISTS `snmp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `snmp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `value` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `snmp`
--

LOCK TABLES `snmp` WRITE;
/*!40000 ALTER TABLE `snmp` DISABLE KEYS */;
INSERT INTO `snmp` VALUES (1,'state','1'),(2,'community','connex'),(3,'user','connex-user'),(4,'password','connex-auth');
/*!40000 ALTER TABLE `snmp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(10) NOT NULL,
  `password` varchar(100) NOT NULL,
  `level` tinyint(1) NOT NULL,
  `state` tinyint(1) NOT NULL,
  `last_login` datetime NOT NULL,
  `state_project` tinyint(1) NOT NULL,
  `last_project` datetime NOT NULL,
  `create_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (5,'super','pbkdf2:sha256:50000$SfPXHgAW$7f52ff8caa7fcb29598eaaea5aaaaab0b8c1ac2751becb8fd4dca8de535b9810',1,1,'2025-08-27 09:32:48',1,'2025-08-27 10:50:47','2021-08-28 13:31:42'),(6,'admin','pbkdf2:sha256:50000$kOhHyFxh$bba765d99350895bc214fa4fd68c03959d04127b8ce7e6fbf3c80b1ad4c5b00e',0,0,'2024-08-07 17:14:18',0,'2025-01-20 17:01:29','2021-08-28 13:32:15');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wireless`
--

DROP TABLE IF EXISTS `wireless`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wireless` (
  `name` varchar(10) NOT NULL,
  `interface` varchar(10) NOT NULL,
  `state` tinyint(1) NOT NULL,
  `ssid` varchar(30) NOT NULL,
  `password` varchar(30) NOT NULL,
  `channel` tinyint(2) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wireless`
--

LOCK TABLES `wireless` WRITE;
/*!40000 ALTER TABLE `wireless` DISABLE KEYS */;
INSERT INTO `wireless` VALUES ('hotspot','wlan0',0,'Nearon IoT - SLB','12345678',1),('station','wlan0',1,'Synapsis.id Head Office','synaps1sjkt23@',0);
/*!40000 ALTER TABLE `wireless` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-08-29  9:08:50
