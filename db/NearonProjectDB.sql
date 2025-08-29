-- MariaDB dump 10.19  Distrib 10.5.23-MariaDB, for debian-linux-gnu (aarch64)
--
-- Host: localhost    Database: NearonProjectDB
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
-- Table structure for table `actuatorGroupDB`
--

DROP TABLE IF EXISTS `actuatorGroupDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actuatorGroupDB` (
  `id` varchar(10) NOT NULL,
  `number` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `intervals` int(11) NOT NULL,
  `unit` tinyint(1) NOT NULL,
  `service_id` int(11) DEFAULT NULL,
  `state` varchar(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `number` (`number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `actuatorGroupDB`
--

LOCK TABLES `actuatorGroupDB` WRITE;
/*!40000 ALTER TABLE `actuatorGroupDB` DISABLE KEYS */;
INSERT INTO `actuatorGroupDB` VALUES ('PAG-G9YG5',2,'Digital',1,1,13,'1','2025-08-14 16:49:33','2025-08-14 16:49:44'),('PAG-OJA3Z',1,'RTU',1,1,41,'1','2025-04-29 16:54:29','2025-07-12 10:53:37');
/*!40000 ALTER TABLE `actuatorGroupDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `actuatorListDB`
--

DROP TABLE IF EXISTS `actuatorListDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actuatorListDB` (
  `id` varchar(10) NOT NULL,
  `actuator_group_id` varchar(10) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `actuator_custom_id` varchar(50) DEFAULT NULL,
  `server_value` varchar(50) DEFAULT NULL,
  `server_sync_at` datetime DEFAULT NULL,
  `last_server_value` varchar(50) DEFAULT NULL,
  `last_server_sync_at` datetime DEFAULT NULL,
  `last_action` tinyint(1) DEFAULT NULL,
  `last_action_value` varchar(50) DEFAULT NULL,
  `last_action_at` datetime DEFAULT NULL,
  `schedule` tinyint(1) DEFAULT NULL,
  `type_actuator` tinyint(1) NOT NULL,
  `state` varchar(1) NOT NULL DEFAULT '0',
  `created_at` datetime(6) DEFAULT current_timestamp(6),
  `updated_at` datetime(6) DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `actuator_custom_id` (`actuator_custom_id`),
  KEY `fk_actuator_group` (`actuator_group_id`),
  CONSTRAINT `fk_actuator_group` FOREIGN KEY (`actuator_group_id`) REFERENCES `actuatorGroupDB` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `actuatorListDB`
--

LOCK TABLES `actuatorListDB` WRITE;
/*!40000 ALTER TABLE `actuatorListDB` DISABLE KEYS */;
INSERT INTO `actuatorListDB` VALUES ('PAL-18UVI','PAG-OJA3Z','Supply Voltage Low Alarm Setpoint RTU 1','lowVoltSetpointRtu1','170','2025-07-15 13:37:47','170','2025-07-13 13:22:16',1,'170','2025-07-13 13:22:16',0,1,'1','2025-07-14 06:46:12.934502','2025-07-12 10:53:37.318984'),('PAL-2U93L','PAG-OJA3Z','Remote Motor Start RTU 1','motorStartRtu1','0','2025-07-15 13:37:47','0','2025-07-15 11:43:29',2,'1','2025-07-15 11:50:00',1,0,'1','2025-07-14 06:46:12.964112','2025-07-12 10:53:37.528980'),('PAL-38N55','PAG-OJA3Z','Remote Motor Start - RTU 3','motorStartRtu3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'0','2025-07-14 06:46:13.239830','2025-07-12 10:53:38.169877'),('PAL-4NU2B','PAG-OJA3Z','Target Running Frequency - RTU 2','targetRunFreqRtu2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'0','2025-07-14 06:46:13.110537','2025-07-12 10:53:37.868571'),('PAL-5V7AA','PAG-OJA3Z','Intake Pressure Low - RTU 4','intakePressLowRtu4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'0','2025-07-14 06:46:13.375441','2025-07-12 10:53:38.634397'),('PAL-5ZQN2','PAG-OJA3Z','Clear Latched Motor Alarm - RTU 3','clearLatchRtu3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'0','2025-07-14 06:46:13.224074','2025-07-12 10:53:38.041906'),('PAL-67N0N','PAG-OJA3Z','Clear Latched Motor Alarm RTU 1','clearLatchRtu1','0','2025-07-15 13:37:47','0','2025-07-13 13:20:47',1,'0','2025-07-13 13:20:47',0,0,'1','2025-07-14 06:46:12.944689','2025-07-12 10:53:37.415278'),('PAL-6L65Z','PAG-OJA3Z','Clear Latched Motor Alarm - RTU 2','clearLatchRtu2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'0','2025-07-14 06:46:13.083028','2025-07-12 10:53:37.715606'),('PAL-7NQXW','PAG-OJA3Z','Clear Port Alarm RTU 1','clearPortRtu1','0','2025-07-15 13:37:47','0','2025-07-13 13:20:47',1,'0','2025-07-13 13:20:47',0,0,'1','2025-07-14 06:46:12.939765','2025-07-12 10:53:37.377286'),('PAL-BG8U3','PAG-OJA3Z','Supply Voltage Low Alarm Setpoint - RTU 2','lowVoltSetpointRtu2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'0','2025-07-14 06:46:13.068131','2025-07-12 10:53:37.641261'),('PAL-CAC3A','PAG-OJA3Z','Supply Voltage Low Alarm Setpoint - RTU 4','lowVoltSetpointRtu4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'0','2025-07-14 06:46:13.330434','2025-07-12 10:53:38.282234'),('PAL-ELZ4W','PAG-G9YG5','Trigger Motor','trigMotor',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'1','2025-08-14 16:53:01.254781','2025-08-14 16:53:01.254781'),('PAL-GJJHM','PAG-OJA3Z','Target Running Frequency - RTU 4','targetRunFreqRtu4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'0','2025-07-14 06:46:13.366481','2025-07-12 10:53:38.597818'),('PAL-H93XH','PAG-OJA3Z','Intake Pressure Low RTU 1','intakePressLowRtu1','101','2025-07-15 13:37:47','101','2025-07-13 13:20:11',1,'101','2025-07-13 13:20:11',0,1,'1','2025-07-14 06:46:12.982763','2025-07-12 10:53:37.604199'),('PAL-II0T2','PAG-OJA3Z','Supply Voltage Low Alarm Setpoint - RTU 3','lowVoltSetpointRtu3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'0','2025-07-14 06:46:13.211274','2025-07-12 10:53:37.954654'),('PAL-JXEO5','PAG-OJA3Z','Remote Motor Start - RTU 2','motorStartRtu2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'0','2025-07-14 06:46:13.099062','2025-07-12 10:53:37.826065'),('PAL-LBGDB','PAG-OJA3Z','Clear Port Alarm - RTU 2','clearPortRtu2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'0','2025-07-14 06:46:13.074840','2025-07-12 10:53:37.678340'),('PAL-LDUQ3','PAG-OJA3Z','Clear Motor Lockout - RTU 3','clearLockoutRtu3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'0','2025-07-14 06:46:13.229081','2025-07-12 10:53:38.089216'),('PAL-MK274','PAG-OJA3Z','Target Running Frequency - RTU 3','targetRunFreqRtu3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'0','2025-07-14 06:46:13.248842','2025-07-12 10:53:38.206091'),('PAL-N31OS','PAG-OJA3Z','Remote Motor Stop - RTU 2','motorStopRtu2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'0','2025-07-14 06:46:13.093657','2025-07-12 10:53:37.787482'),('PAL-NUQ6N','PAG-OJA3Z','Clear Port Alarm - RTU 4','clearPortRtu4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'0','2025-07-14 06:46:13.335752','2025-07-12 10:53:38.319886'),('PAL-OC5OH','PAG-OJA3Z','Intake Pressure Low - RTU 3','intakePressLowRtu3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'0','2025-07-14 06:46:13.257658','2025-07-12 10:53:38.242944'),('PAL-QRXBX','PAG-OJA3Z','Clear Motor Lockout RTU 1','clearLockoutRtu1','0','2025-07-15 13:37:47','0','2025-07-13 13:20:47',1,'0','2025-07-13 13:20:47',0,0,'1','2025-07-14 06:46:12.951357','2025-07-12 10:53:37.452869'),('PAL-SC4BY','PAG-OJA3Z','Remote Motor Stop - RTU 3','motorStopRtu3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'0','2025-07-14 06:46:13.234133','2025-07-12 10:53:38.133035'),('PAL-SU9YB','PAG-OJA3Z','Clear Latched Motor Alarm - RTU 4','clearLatchRtu4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'0','2025-07-14 06:46:13.340790','2025-07-12 10:53:38.449411'),('PAL-THXU3','PAG-OJA3Z','Clear Motor Lockout - RTU 2','clearLockoutRtu2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'0','2025-07-14 06:46:13.088637','2025-07-12 10:53:37.751267'),('PAL-UEXEB','PAG-OJA3Z','Remote Motor Start - RTU 4','motorStartRtu4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'0','2025-07-14 06:46:13.356096','2025-07-12 10:53:38.562051'),('PAL-VN993','PAG-OJA3Z','Clear Motor Lockout - RTU 4','clearLockoutRtu4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'0','2025-07-14 06:46:13.345833','2025-07-12 10:53:38.487060'),('PAL-WUGQA','PAG-OJA3Z','Remote Motor Stop - RTU 4','motorStopRtu4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'0','2025-07-14 06:46:13.351104','2025-07-12 10:53:38.525568'),('PAL-XFIO8','PAG-OJA3Z','Intake Pressure Low - RTU 2','intakePressLowRtu2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'0','2025-07-14 06:46:13.121195','2025-07-12 10:53:37.917532'),('PAL-XM3CG','PAG-OJA3Z','Remote Motor Stop RTU 1','motorStopRtu1','0','2025-07-15 13:37:47','0','2025-07-15 11:43:21',1,'0','2025-07-15 11:43:21',0,0,'1','2025-07-14 06:46:12.957869','2025-07-12 10:53:37.490251'),('PAL-YO96C','PAG-OJA3Z','Target Running Frequency RTU 1','targetRunFreqRtu1','21','2025-07-15 13:37:47','21','2025-07-13 13:22:29',1,'21','2025-07-13 13:22:29',0,1,'1','2025-07-14 06:46:12.973699','2025-07-12 10:53:37.566788'),('PAL-ZMV6F','PAG-OJA3Z','Clear Port Alarm - RTU 3','clearPortRtu3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'0','2025-07-14 06:46:13.218995','2025-07-12 10:53:37.999930');
/*!40000 ALTER TABLE `actuatorListDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `actuatorParameterGroupDB`
--

DROP TABLE IF EXISTS `actuatorParameterGroupDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actuatorParameterGroupDB` (
  `id` varchar(10) NOT NULL,
  `actuator_group_id` varchar(10) NOT NULL,
  `name` varchar(100) NOT NULL,
  `parameter` varchar(100) NOT NULL,
  `value` varchar(100) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fk_actuator_group2` (`actuator_group_id`),
  CONSTRAINT `fk_actuator_group2` FOREIGN KEY (`actuator_group_id`) REFERENCES `actuatorGroupDB` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `actuatorParameterGroupDB`
--

LOCK TABLES `actuatorParameterGroupDB` WRITE;
/*!40000 ALTER TABLE `actuatorParameterGroupDB` DISABLE KEYS */;
INSERT INTO `actuatorParameterGroupDB` VALUES ('PAPG-SSACN','PAG-OJA3Z','Baudrate','baudrate','9600','2025-06-01 22:49:43','2025-07-09 00:55:00'),('PAPG-VDRD0','PAG-OJA3Z','Port','port','3','2025-06-01 22:49:28','2025-06-02 10:13:42');
/*!40000 ALTER TABLE `actuatorParameterGroupDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `actuatorParameterListDB`
--

DROP TABLE IF EXISTS `actuatorParameterListDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actuatorParameterListDB` (
  `id` varchar(10) NOT NULL,
  `actuator_list_id` varchar(10) NOT NULL,
  `name` varchar(100) NOT NULL,
  `parameter` varchar(100) NOT NULL,
  `value` varchar(100) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fk_actuator_list` (`actuator_list_id`),
  CONSTRAINT `fk_actuator_list` FOREIGN KEY (`actuator_list_id`) REFERENCES `actuatorListDB` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `actuatorParameterListDB`
--

LOCK TABLES `actuatorParameterListDB` WRITE;
/*!40000 ALTER TABLE `actuatorParameterListDB` DISABLE KEYS */;
INSERT INTO `actuatorParameterListDB` VALUES ('PAPL-0DCV8','PAL-7NQXW','Length','length','1','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-104AK','PAL-SC4BY','Address','address','1','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-14Q2M','PAL-ELZ4W','Pin','pin','12','2025-08-14 16:57:09','2025-08-14 16:57:09'),('PAPL-165UX','PAL-LBGDB','Divider','divider','1.0','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-172DE','PAL-OC5OH','Length','length','1','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-19XCQ','PAL-6L65Z','Divider','divider','1.0','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-1C4S6','PAL-18UVI','Length','length','1','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-1J9BT','PAL-XM3CG','Divider','divider','1.0','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-2D4ND','PAL-NUQ6N','Length','length','1','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-2FY6P','PAL-QRXBX','Divider','divider','1.0','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-30EXP','PAL-18UVI','Address','address','40194','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-33KDF','PAL-LDUQ3','Length','length','1','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-367WF','PAL-UEXEB','Address','address','3','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-3EB6H','PAL-JXEO5','Address','address','3','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-3R5BP','PAL-BG8U3','Length','length','1','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-3RYXS','PAL-H93XH','Length','length','1','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-401Y1','PAL-OC5OH','Address','address','40509','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-4SWSV','PAL-18UVI','Divider','divider','1.0','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-6IB34','PAL-ZMV6F','Divider','divider','1.0','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-6SVPC','PAL-N31OS','Address','address','1','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-6TQWK','PAL-CAC3A','Address','address','40194','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-6VD4H','PAL-II0T2','Length','length','1','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-6WNDW','PAL-THXU3','Address','address','5','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-77ENY','PAL-MK274','Divider','divider','100.0','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-7C2FE','PAL-4NU2B','Divider','divider','100.0','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-7SHT2','PAL-WUGQA','Address','address','1','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-8APNF','PAL-SC4BY','Divider','divider','1.0','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-8JD9Y','PAL-THXU3','Divider','divider','1.0','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-8O18A','PAL-4NU2B','Address','address','40856','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-8VAYS','PAL-II0T2','Divider','divider','1.0','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-99CYI','PAL-LDUQ3','Divider','divider','1.0','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-A1G83','PAL-H93XH','Address','address','40509','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-ARFV0','PAL-SU9YB','Divider','divider','1.0','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-AUXIW','PAL-WUGQA','Length','length','1','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-BQ5F1','PAL-CAC3A','Divider','divider','1.0','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-C0BUG','PAL-CAC3A','Length','length','1','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-CAM6T','PAL-2U93L','Divider','divider','1.0','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-DYY62','PAL-5ZQN2','Divider','divider','1.0','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-E50XW','PAL-GJJHM','Divider','divider','100.0','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-E8WL2','PAL-YO96C','Divider','divider','100.0','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-EE623','PAL-ZMV6F','Length','length','1','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-ESK7Q','PAL-XFIO8','Length','length','1','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-FT6E0','PAL-UEXEB','Divider','divider','1.0','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-GVRRT','PAL-38N55','Address','address','3','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-H34LB','PAL-38N55','Length','length','1','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-HEYVH','PAL-67N0N','Divider','divider','1.0','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-HLIUT','PAL-WUGQA','Divider','divider','1.0','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-IAGGD','PAL-VN993','Address','address','5','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-J35L5','PAL-VN993','Length','length','1','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-JQ1D3','PAL-LBGDB','Length','length','1','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-KAJ5Z','PAL-OC5OH','Divider','divider','10.0','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-KE0L3','PAL-SC4BY','Length','length','1','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-KKSPZ','PAL-N31OS','Divider','divider','1.0','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-KQ25M','PAL-XFIO8','Divider','divider','10.0','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-KSBHV','PAL-67N0N','Address','address','4','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-LGT51','PAL-BG8U3','Divider','divider','1.0','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-LJ61D','PAL-SU9YB','Address','address','4','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-LMHBB','PAL-THXU3','Length','length','1','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-M3323','PAL-ZMV6F','Address','address','2','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-MJSYM','PAL-NUQ6N','Address','address','2','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-MUJ2P','PAL-5V7AA','Length','length','1','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-MXU37','PAL-MK274','Length','length','1','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-NGLI4','PAL-SU9YB','Length','length','1','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-NJ0LT','PAL-UEXEB','Length','length','1','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-NRRZM','PAL-H93XH','Divider','divider','10.0','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-NUN6Y','PAL-5ZQN2','Length','length','1','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-O4D7E','PAL-XM3CG','Address','address','1','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-OPDRJ','PAL-YO96C','Length','length','1','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-P33IE','PAL-4NU2B','Length','length','1','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-PJ708','PAL-2U93L','Address','address','3','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-PMY3A','PAL-GJJHM','Address','address','40856','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-Q3E4G','PAL-XFIO8','Address','address','40509','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-QOJXV','PAL-5V7AA','Address','address','40509','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-QSDPS','PAL-7NQXW','Divider','divider','1.0','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-QY91C','PAL-JXEO5','Divider','divider','1.0','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-RD0Z0','PAL-QRXBX','Length','length','1','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-RXWFJ','PAL-7NQXW','Address','address','2','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-S6R5M','PAL-YO96C','Address','address','40856','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-SRLNA','PAL-LDUQ3','Address','address','5','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-SX8RS','PAL-LBGDB','Address','address','2','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-TD0PF','PAL-XM3CG','Length','length','1','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-TQAMG','PAL-6L65Z','Length','length','1','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-U1W02','PAL-2U93L','Length','length','1','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-U4O0M','PAL-JXEO5','Length','length','1','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-UFVYZ','PAL-MK274','Address','address','40856','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-UN5SJ','PAL-5ZQN2','Address','address','4','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-UXCRT','PAL-QRXBX','Address','address','5','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-V0QLO','PAL-VN993','Divider','divider','1.0','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-VCIW2','PAL-NUQ6N','Divider','divider','1.0','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-VZNP9','PAL-6L65Z','Address','address','4','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-WKOXL','PAL-67N0N','Length','length','1','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-WM9YI','PAL-38N55','Divider','divider','1.0','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-WRBKV','PAL-5V7AA','Divider','divider','10.0','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-Y6THJ','PAL-N31OS','Length','length','1','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-YQ0YX','PAL-II0T2','Address','address','40194','2025-07-12 10:53:37','2025-07-12 10:53:37'),('PAPL-YW0IP','PAL-GJJHM','Length','length','1','2025-07-12 10:53:38','2025-07-12 10:53:38'),('PAPL-Z16O6','PAL-BG8U3','Address','address','40194','2025-07-12 10:53:37','2025-07-12 10:53:37');
/*!40000 ALTER TABLE `actuatorParameterListDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `actuatorScheduleDB`
--

DROP TABLE IF EXISTS `actuatorScheduleDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actuatorScheduleDB` (
  `id` varchar(10) NOT NULL,
  `actuator_list_id` varchar(10) NOT NULL,
  `day` varchar(20) NOT NULL,
  `time` time NOT NULL,
  `value` varchar(50) NOT NULL,
  `state` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `FK_ACTUATOR_SCHEDULE_LIST_idx` (`actuator_list_id`),
  CONSTRAINT `FK_ACTUATOR_SCHEDULE_LIST` FOREIGN KEY (`actuator_list_id`) REFERENCES `actuatorListDB` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `actuatorScheduleDB`
--

LOCK TABLES `actuatorScheduleDB` WRITE;
/*!40000 ALTER TABLE `actuatorScheduleDB` DISABLE KEYS */;
INSERT INTO `actuatorScheduleDB` VALUES ('PALS-Y6C8V','PAL-2U93L','Tuesday','11:50:00','1',0,'2025-07-15 11:48:31','2025-07-15 11:51:00');
/*!40000 ALTER TABLE `actuatorScheduleDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `calibrateFormulaDB`
--

DROP TABLE IF EXISTS `calibrateFormulaDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `calibrateFormulaDB` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `sample` int(11) NOT NULL,
  `koef_a` varchar(30) DEFAULT NULL,
  `koef_b` varchar(30) DEFAULT NULL,
  `calculate_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `calibrateFormulaDB`
--

LOCK TABLES `calibrateFormulaDB` WRITE;
/*!40000 ALTER TABLE `calibrateFormulaDB` DISABLE KEYS */;
INSERT INTO `calibrateFormulaDB` VALUES (1,'Regresi Arus',36,'0.7676','-0.0605','2024-12-11 23:45:27'),(5,'Regresi Arus 2',37,'0.766','-0.0695','2024-06-22 17:20:29');
/*!40000 ALTER TABLE `calibrateFormulaDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `calibrateSampleDB`
--

DROP TABLE IF EXISTS `calibrateSampleDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `calibrateSampleDB` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `formula_id` bigint(20) NOT NULL,
  `value_sample` varchar(30) NOT NULL,
  `value_reference` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `formula_sample` (`formula_id`)
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `calibrateSampleDB`
--

LOCK TABLES `calibrateSampleDB` WRITE;
/*!40000 ALTER TABLE `calibrateSampleDB` DISABLE KEYS */;
INSERT INTO `calibrateSampleDB` VALUES (2,1,'0.8','0.57'),(4,1,'1.05','0.75'),(5,1,'1.16','0.84'),(6,1,'1.23','0.89'),(14,1,'1.28','0.93'),(15,1,'1.56','1.12'),(16,1,'1.84','1.34'),(17,1,'2.05','1.51'),(18,1,'2.18','1.63'),(19,1,'2.31','1.69'),(20,1,'2.62','1.94'),(21,1,'2.84','2.11'),(22,1,'3.03','2.26'),(23,1,'3.37','2.52'),(24,1,'4.5','3.42'),(25,1,'6.06','4.59'),(26,1,'6.36','4.82'),(27,1,'7.02','5.33'),(28,1,'7.17','5.44'),(29,1,'7.52','5.71'),(30,1,'7.88','5.99'),(31,1,'8.13','6.18'),(32,1,'8.17','6.21'),(33,1,'8.65','6.58'),(34,1,'8.93','6.79'),(35,1,'9.21','7.01'),(36,1,'9.22','7.02'),(37,1,'9.65','7.35'),(38,1,'10.08','7.68'),(39,1,'10.23','7.79'),(40,1,'10.48','7.98'),(41,1,'10.72','8.17'),(42,1,'11.10','8.46'),(43,1,'11.53','8.79'),(44,1,'12.10','9.23'),(45,1,'12.39','9.45'),(48,5,'0.79','0.57'),(49,5,'1.04','0.76'),(50,5,'1.12','0.85'),(51,5,'1.24','0.92'),(52,5,'1.3','0.94'),(53,5,'1.55','1.11'),(54,5,'1.69','1.32'),(55,5,'1.86','1.39'),(56,5,'2.04','1.49'),(57,5,'2.18','1.6'),(58,5,'2.3','1.68'),(59,5,'2.62','1.91'),(60,5,'2.85','2.09'),(61,5,'3.04','2.23'),(62,5,'3.36','2.49'),(63,5,'4.51','3.44'),(64,5,'6.19','4.6'),(65,5,'6.31','4.73'),(66,5,'7.03','5.2'),(67,5,'7.20','5.43'),(68,5,'7.57','5.61'),(69,5,'7.97','5.96'),(70,5,'8.21','6.16'),(71,5,'8.40','6.33'),(72,5,'8.58','6.46'),(73,5,'9.12','6.85'),(74,5,'9.20','7.05'),(75,5,'9.52','7.22'),(76,5,'9.62','7.32'),(77,5,'10.18','7.67'),(78,5,'10.33','7.74'),(79,5,'10.55','8.1'),(80,5,'10.59','8.04'),(81,5,'11.21','8.52'),(82,5,'11.53','8.85'),(83,5,'11.88','9.18'),(84,5,'12.29','9.47');
/*!40000 ALTER TABLE `calibrateSampleDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deviceSettingDB`
--

DROP TABLE IF EXISTS `deviceSettingDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `deviceSettingDB` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(10) NOT NULL,
  `value` varchar(100) NOT NULL,
  `updatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deviceSettingDB`
--

LOCK TABLES `deviceSettingDB` WRITE;
/*!40000 ALTER TABLE `deviceSettingDB` DISABLE KEYS */;
INSERT INTO `deviceSettingDB` VALUES (1,'uid','e144d3309bc44babaf590d8d67ab2a8b','2025-07-12 11:05:09'),(2,'name','Nearon IoT SLB','2025-07-15 14:16:55'),(3,'version','1.0.0','2024-04-17 16:09:44');
/*!40000 ALTER TABLE `deviceSettingDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `environmentDeviceDB`
--

DROP TABLE IF EXISTS `environmentDeviceDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `environmentDeviceDB` (
  `id` varchar(50) NOT NULL,
  `number` int(11) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `method` varchar(10) DEFAULT NULL,
  `ip` varchar(255) DEFAULT NULL,
  `modbus_id` varchar(10) DEFAULT NULL,
  `port1` int(11) DEFAULT NULL,
  `port2` int(11) DEFAULT NULL,
  `port3` int(11) DEFAULT NULL,
  `port4` int(11) DEFAULT NULL,
  `port5` int(11) DEFAULT NULL,
  `port6` int(11) DEFAULT NULL,
  `port7` int(11) DEFAULT NULL,
  `port8` int(11) DEFAULT NULL,
  `state` tinyint(4) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `number` (`number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `environmentDeviceDB`
--

LOCK TABLES `environmentDeviceDB` WRITE;
/*!40000 ALTER TABLE `environmentDeviceDB` DISABLE KEYS */;
INSERT INTO `environmentDeviceDB` VALUES ('EED-VZOUQ',1,'Extension Device','0','10.19.52.89','0',2,2,0,0,0,0,0,0,1,'2025-03-12 15:44:40','2025-04-28 08:43:20');
/*!40000 ALTER TABLE `environmentDeviceDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `environmentMasterParameterDB`
--

DROP TABLE IF EXISTS `environmentMasterParameterDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `environmentMasterParameterDB` (
  `id` varchar(50) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `parameterCode` varchar(255) DEFAULT NULL,
  `createdAt` datetime DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `environmentMasterParameterDB`
--

LOCK TABLES `environmentMasterParameterDB` WRITE;
/*!40000 ALTER TABLE `environmentMasterParameterDB` DISABLE KEYS */;
INSERT INTO `environmentMasterParameterDB` VALUES ('EEMP-6Ipe7','Endpoint','endpoint','2024-09-24 11:25:25','2024-09-30 03:34:45'),('EEMP-CdHN0','waterSplash','codeString','2024-10-02 12:06:08','2024-10-02 05:06:08'),('EEMP-qrnVM','IP Address','ip','2024-09-24 11:32:56','2024-09-30 03:34:34'),('EEMP-viTDz','Device Status','device','2024-09-24 11:31:43','2024-09-30 03:35:57');
/*!40000 ALTER TABLE `environmentMasterParameterDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `environmentMasterSensorDB`
--

DROP TABLE IF EXISTS `environmentMasterSensorDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `environmentMasterSensorDB` (
  `id` varchar(50) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `sensorId` varchar(255) DEFAULT NULL,
  `createdAt` datetime DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `environmentMasterSensorDB`
--

LOCK TABLES `environmentMasterSensorDB` WRITE;
/*!40000 ALTER TABLE `environmentMasterSensorDB` DISABLE KEYS */;
INSERT INTO `environmentMasterSensorDB` VALUES ('EEMS-BpAoR','Temperature Port 1','tempP1','2024-09-24 10:34:41','2024-09-30 03:31:37'),('EEMS-c6B7f','Humidity Port 1','humidP1','2024-09-24 10:48:01','2024-09-30 03:31:48'),('EEMS-EtDdv','Water Cannon','waterCannon','2024-10-02 12:05:44','2024-10-02 05:05:44'),('EEMS-MMnXN','Humidity Port 2','humidP2','2024-09-30 10:32:10','2024-09-30 03:32:10'),('EEMS-nzEi6','Smoke Detector','inputP5','2024-09-30 10:33:10','2024-09-30 03:33:10'),('EEMS-UT6mc','Door State','inputP4','2024-09-30 10:32:58','2024-09-30 03:32:58'),('EEMS-vwooB','Temperature Port 2','tempP2','2024-09-30 10:31:57','2024-09-30 03:31:57'),('EEMS-wuXWY','Water Leak','inputP6','2024-09-30 10:33:21','2024-09-30 03:33:21');
/*!40000 ALTER TABLE `environmentMasterSensorDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `featureSettingDB`
--

DROP TABLE IF EXISTS `featureSettingDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `featureSettingDB` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `value` varchar(2) NOT NULL,
  `updatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `featureSettingDB`
--

LOCK TABLES `featureSettingDB` WRITE;
/*!40000 ALTER TABLE `featureSettingDB` DISABLE KEYS */;
INSERT INTO `featureSettingDB` VALUES (1,'routineMonitor','0','2025-07-15 13:37:30'),(2,'bufferMonitor','0','2025-07-15 13:37:30'),(3,'bufferMonitorInterval','10','2025-04-29 10:14:46'),(4,'bufferMonitorUnit','1','2024-06-06 07:31:26'),(5,'alarmMonitor','0','2025-07-15 13:37:30'),(6,'alarmMonitorInterval','5','2024-09-05 21:11:18'),(7,'alarmMonitorUnit','1','2024-06-05 11:41:43'),(8,'notification','0','2025-07-15 13:37:55'),(9,'notificationInterval','10','2025-07-15 14:21:26'),(10,'notificationUnit','1','2024-06-11 13:43:39'),(11,'notificationSensorWeb','1','2024-04-23 16:25:04'),(12,'notificationSensorWA','1','2024-06-03 09:53:42'),(13,'notificationSensorEmail','1','2024-04-23 11:30:34'),(14,'notificationSensorTelegram','1','2024-06-03 09:53:42'),(15,'notificationActuatorWeb','1','2025-06-03 10:05:07'),(16,'notificationActuatorWA','1','2025-06-03 10:05:07'),(17,'notificationActuatorEmail','1','2025-06-03 10:05:07'),(18,'notificationActuatorTelegram','1','2025-06-03 10:05:07'),(19,'notificationNodeWeb','1','2025-06-08 22:50:08'),(20,'notificationNodeWA','1','2025-06-09 16:41:45'),(21,'notificationNodeEmail','1','2025-06-09 16:40:06'),(22,'notificationNodeTelegram','1','2025-06-09 16:44:50'),(23,'synchronize','0','2025-07-15 13:37:48'),(24,'synchronizeInterval','5','2025-07-15 14:21:31'),(25,'synchronizeUnit','1','2024-04-23 16:32:41'),(26,'syncSensor','1','2025-06-02 20:05:13'),(27,'syncActuator','1','2024-12-11 22:40:47'),(28,'syncNode','1','2025-06-09 23:40:24'),(29,'log','0','2025-07-15 13:38:10'),(30,'logInterval','0','2024-03-25 14:13:15'),(31,'logUnit','0','2024-03-25 14:13:15'),(32,'durationStorageLog','14','2025-07-14 06:34:51'),(33,'durationStorageLogState','1','2025-01-10 23:10:29'),(34,'backupMonthlyLog','1','2025-01-10 23:10:29');
/*!40000 ALTER TABLE `featureSettingDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `intervalRoutineLogDB`
--

DROP TABLE IF EXISTS `intervalRoutineLogDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `intervalRoutineLogDB` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `interval` varchar(5) NOT NULL,
  `unit` varchar(30) NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime NOT NULL DEFAULT current_timestamp(),
  `state` varchar(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `intervalRoutineLogDB`
--

LOCK TABLES `intervalRoutineLogDB` WRITE;
/*!40000 ALTER TABLE `intervalRoutineLogDB` DISABLE KEYS */;
INSERT INTO `intervalRoutineLogDB` VALUES (1,'60','1','2024-04-23 13:56:21','2024-04-23 13:56:21','1');
/*!40000 ALTER TABLE `intervalRoutineLogDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `intervalRoutineMonitorDB`
--

DROP TABLE IF EXISTS `intervalRoutineMonitorDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `intervalRoutineMonitorDB` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `interval` varchar(5) NOT NULL,
  `unit` varchar(30) NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `state` varchar(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `intervalRoutineMonitorDB`
--

LOCK TABLES `intervalRoutineMonitorDB` WRITE;
/*!40000 ALTER TABLE `intervalRoutineMonitorDB` DISABLE KEYS */;
INSERT INTO `intervalRoutineMonitorDB` VALUES (1,'60','1','2024-04-23 13:56:02','2025-07-11 22:41:33','1');
/*!40000 ALTER TABLE `intervalRoutineMonitorDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logActuatorDB`
--

DROP TABLE IF EXISTS `logActuatorDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logActuatorDB` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `actuator_list_id` varchar(10) NOT NULL,
  `value` varchar(50) NOT NULL,
  `action` tinyint(1) NOT NULL,
  `action_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `FK_ACTUATOR_LOG_LIST_idx` (`actuator_list_id`),
  CONSTRAINT `FK_ACTUATOR_LOG_LIST` FOREIGN KEY (`actuator_list_id`) REFERENCES `actuatorListDB` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=451 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logActuatorDB`
--

LOCK TABLES `logActuatorDB` WRITE;
/*!40000 ALTER TABLE `logActuatorDB` DISABLE KEYS */;
/*!40000 ALTER TABLE `logActuatorDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logAlarmDB`
--

DROP TABLE IF EXISTS `logAlarmDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logAlarmDB` (
  `id` varchar(10) NOT NULL,
  `sensor_id` varchar(50) DEFAULT NULL,
  `value` varchar(200) NOT NULL,
  `tipe` int(11) NOT NULL,
  `count` int(11) NOT NULL,
  `count_time` int(11) NOT NULL,
  `tolerance` int(11) NOT NULL,
  `first_alarm` datetime NOT NULL,
  `last_alarm` datetime DEFAULT NULL,
  `flag` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `fk_logAlarm_sensor_id` (`sensor_id`),
  CONSTRAINT `fk_logAlarm_sensor_id` FOREIGN KEY (`sensor_id`) REFERENCES `sensorListDB` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logAlarmDB`
--

LOCK TABLES `logAlarmDB` WRITE;
/*!40000 ALTER TABLE `logAlarmDB` DISABLE KEYS */;
INSERT INTO `logAlarmDB` VALUES ('NML-0ZQ55','PLS-C8OCK','0.0',1,3002,122808,1,'2025-07-15 12:30:23','2025-07-15 12:30:30',2),('NML-HFYCQ','PLS-MFIK3','101',1,3760,122809,1,'2025-07-15 11:20:34','2025-07-15 11:20:34',2);
/*!40000 ALTER TABLE `logAlarmDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logErrorDB`
--

DROP TABLE IF EXISTS `logErrorDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logErrorDB` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `service` varchar(50) NOT NULL,
  `error` varchar(1000) NOT NULL,
  `file` varchar(100) NOT NULL,
  `line` varchar(50) NOT NULL,
  `timestamp` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logErrorDB`
--

LOCK TABLES `logErrorDB` WRITE;
/*!40000 ALTER TABLE `logErrorDB` DISABLE KEYS */;
/*!40000 ALTER TABLE `logErrorDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logMonitoringDB`
--

DROP TABLE IF EXISTS `logMonitoringDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logMonitoringDB` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `data` varchar(10000) DEFAULT NULL,
  `state` varchar(5) NOT NULL,
  `buffer` tinyint(1) NOT NULL,
  `timestamp` datetime NOT NULL,
  `tipe` int(11) NOT NULL,
  `attempt` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logMonitoringDB`
--

LOCK TABLES `logMonitoringDB` WRITE;
/*!40000 ALTER TABLE `logMonitoringDB` DISABLE KEYS */;
/*!40000 ALTER TABLE `logMonitoringDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logNotifDB`
--

DROP TABLE IF EXISTS `logNotifDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logNotifDB` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(10) NOT NULL,
  `sensor` varchar(50) NOT NULL,
  `conditions` varchar(50) NOT NULL,
  `notif` varchar(10) NOT NULL,
  `subject` varchar(100) NOT NULL,
  `message` varchar(10000) NOT NULL,
  `state` varchar(15) NOT NULL,
  `create_time` datetime NOT NULL,
  `send_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logNotifDB`
--

LOCK TABLES `logNotifDB` WRITE;
/*!40000 ALTER TABLE `logNotifDB` DISABLE KEYS */;
/*!40000 ALTER TABLE `logNotifDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logSensorDB`
--

DROP TABLE IF EXISTS `logSensorDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logSensorDB` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sensor_id` varchar(50) DEFAULT NULL,
  `data` varchar(200) NOT NULL,
  `timestamp` datetime NOT NULL,
  `tipe` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_logSensor_sensor_id` (`sensor_id`),
  CONSTRAINT `fk_logSensor_sensor_id` FOREIGN KEY (`sensor_id`) REFERENCES `sensorListDB` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logSensorDB`
--

LOCK TABLES `logSensorDB` WRITE;
/*!40000 ALTER TABLE `logSensorDB` DISABLE KEYS */;
/*!40000 ALTER TABLE `logSensorDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logToleranceAlarmDB`
--

DROP TABLE IF EXISTS `logToleranceAlarmDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logToleranceAlarmDB` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `value` varchar(200) NOT NULL,
  `timestamp` datetime NOT NULL,
  `alarmId` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logToleranceAlarmDB`
--

LOCK TABLES `logToleranceAlarmDB` WRITE;
/*!40000 ALTER TABLE `logToleranceAlarmDB` DISABLE KEYS */;
INSERT INTO `logToleranceAlarmDB` VALUES (1,'0.0','2025-07-15 12:30:30','NML-0ZQ55');
/*!40000 ALTER TABLE `logToleranceAlarmDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `powerDeviceDB`
--

DROP TABLE IF EXISTS `powerDeviceDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `powerDeviceDB` (
  `id` varchar(50) NOT NULL,
  `number` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `ip` varchar(20) DEFAULT NULL,
  `connection` tinyint(4) DEFAULT NULL,
  `state` tinyint(4) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `number` (`number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `powerDeviceDB`
--

LOCK TABLES `powerDeviceDB` WRITE;
/*!40000 ALTER TABLE `powerDeviceDB` DISABLE KEYS */;
/*!40000 ALTER TABLE `powerDeviceDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `powerMasterParameterDB`
--

DROP TABLE IF EXISTS `powerMasterParameterDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `powerMasterParameterDB` (
  `id` varchar(50) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `parameterCode` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `powerMasterParameterDB`
--

LOCK TABLES `powerMasterParameterDB` WRITE;
/*!40000 ALTER TABLE `powerMasterParameterDB` DISABLE KEYS */;
/*!40000 ALTER TABLE `powerMasterParameterDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `powerMasterSensorDB`
--

DROP TABLE IF EXISTS `powerMasterSensorDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `powerMasterSensorDB` (
  `id` varchar(50) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `sensorId` varchar(255) DEFAULT NULL,
  `createdAt` datetime DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `powerMasterSensorDB`
--

LOCK TABLES `powerMasterSensorDB` WRITE;
/*!40000 ALTER TABLE `powerMasterSensorDB` DISABLE KEYS */;
/*!40000 ALTER TABLE `powerMasterSensorDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rtuDeviceDB`
--

DROP TABLE IF EXISTS `rtuDeviceDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rtuDeviceDB` (
  `id` varchar(20) NOT NULL,
  `number` int(20) NOT NULL,
  `name` varchar(45) NOT NULL,
  `slave_id` int(20) NOT NULL,
  `state` varchar(20) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `number` (`number`,`name`,`slave_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rtuDeviceDB`
--

LOCK TABLES `rtuDeviceDB` WRITE;
/*!40000 ALTER TABLE `rtuDeviceDB` DISABLE KEYS */;
INSERT INTO `rtuDeviceDB` VALUES ('RTUEXT-24FL4',3,'RTU 3',3,'0','2025-07-04 09:40:51','2025-07-09 11:52:35'),('RTUEXT-8CNED',2,'RTU 2',2,'0','2025-07-04 09:40:35','2025-07-12 00:33:15'),('RTUEXT-N2IAO',4,'RTU 4',4,'0','2025-07-04 09:41:07','2025-07-09 15:53:42'),('RTUEXT-OYEJ4',1,'RTU 1',1,'1','2025-07-04 09:40:18','2025-07-11 23:13:50');
/*!40000 ALTER TABLE `rtuDeviceDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rtuParameterDB`
--

DROP TABLE IF EXISTS `rtuParameterDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rtuParameterDB` (
  `id` varchar(20) NOT NULL,
  `name` varchar(45) NOT NULL,
  `custom_id` varchar(45) NOT NULL,
  `address` int(11) NOT NULL,
  `length` int(11) DEFAULT NULL,
  `datatype` tinyint(4) DEFAULT NULL,
  `divider` float DEFAULT NULL,
  `type` tinyint(4) DEFAULT NULL,
  `type_control` tinyint(4) DEFAULT NULL,
  `unit` varchar(30) DEFAULT '#',
  `monitoring` varchar(30) DEFAULT NULL,
  `log` varchar(30) DEFAULT NULL,
  `state` varchar(1) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`),
  UNIQUE KEY `custom_id_UNIQUE` (`custom_id`),
  UNIQUE KEY `address_UNIQUE` (`address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rtuParameterDB`
--

LOCK TABLES `rtuParameterDB` WRITE;
/*!40000 ALTER TABLE `rtuParameterDB` DISABLE KEYS */;
INSERT INTO `rtuParameterDB` VALUES ('RTUPRM-05RVS','Current Run Time','currRunTime',32077,2,1,1,0,0,'#','1','1','1','2025-07-04 09:54:06','2025-07-13 12:00:53'),('RTUPRM-1JHCQ','Motor Temperature','motorTemp',32141,1,0,10,0,0,'C/F','1','1','1','2025-07-04 09:49:02','2025-07-13 11:58:10'),('RTUPRM-34U4X','Alarm 0','alarm0',32049,1,0,1,0,0,'#','1','1','1','2025-07-04 09:50:44','2025-07-13 11:58:41'),('RTUPRM-5CI2Y','Supply Voltage Low Alarm Setpoint','lowVoltSetpoint',40194,1,0,1,2,2,'V','1','1','1','2025-07-04 09:55:09','2025-07-13 11:59:07'),('RTUPRM-6UWMW','Controller Mode Hand','controlModeHand',10415,1,0,1,0,0,'#','1','1','1','2025-07-04 09:52:25','2025-07-13 11:59:17'),('RTUPRM-7455V','Supply Voltage','supplyVolt',32104,1,0,1,0,0,'#','1','1','1','2025-07-04 09:42:31','2025-07-13 11:57:22'),('RTUPRM-7OVVO','Clear Port Alarm','clearPort',2,1,0,1,1,1,'#','0','0','1','2025-07-04 09:55:40','2025-07-13 12:01:23'),('RTUPRM-93CUK','Target Running Frequency','targetRunFreq',40856,1,0,100,2,2,'Hz','1','1','1','2025-07-04 10:00:39','2025-07-13 12:02:57'),('RTUPRM-D490B','Remote Motor Stop','motorStop',1,1,0,1,1,1,'#','0','0','1','2025-07-04 09:59:30','2025-07-13 12:02:31'),('RTUPRM-DNX5Z','Total Starts','totalStart',32065,1,0,1,0,0,'#','1','1','1','2025-07-04 09:53:34','2025-07-13 12:00:06'),('RTUPRM-FGB7U','Lockout Status','lockoutState',10413,1,0,1,0,0,'#','1','1','1','2025-07-04 09:43:51','2025-07-13 11:57:29'),('RTUPRM-GI9PW','Clear Motor Lockout','clearLockout',5,1,0,1,1,1,'#','0','0','1','2025-07-04 09:57:50','2025-07-13 12:02:04'),('RTUPRM-H9JKB','Motor Running Status','motorRunState',10432,1,0,1,0,0,'#','1','1','1','2025-07-04 09:44:26','2025-07-13 11:57:34'),('RTUPRM-IJGS2','Remote Motor Start','motorStart',3,1,0,1,1,1,'#','0','0','1','2025-07-04 09:59:59','2025-07-13 12:02:42'),('RTUPRM-KBYOW','Latched Alarm 0','latchedAlarm0',32041,1,0,1,0,0,'#','1','1','1','2025-07-04 09:50:06','2025-07-13 11:58:17'),('RTUPRM-ORAWQ','Intake Pressure Low','intakePressLow',40509,1,0,10,2,2,'bar/psi','1','1','1','2025-07-11 11:28:15','2025-07-13 12:03:10'),('RTUPRM-SZ334','Current Off Time','currOffTime',32079,2,1,1,0,0,'#','1','1','1','2025-07-04 09:54:38','2025-07-13 12:01:01'),('RTUPRM-TW6VD','Controller Mode Manual','controlModeManual',10414,1,0,1,0,0,'#','1','1','1','2025-07-04 09:51:23','2025-07-13 11:58:54'),('RTUPRM-WSL5H','Running Frequency','runningFreq',32166,1,0,100,0,0,'Hz','1','1','1','2025-07-04 09:46:11','2025-07-13 11:57:49'),('RTUPRM-XS2R7','Intake Pressure','intakePress',32137,1,0,10,0,0,'bar/psi','1','1','1','2025-07-04 09:47:34','2025-07-13 11:57:54'),('RTUPRM-YT4LG','Last Shutdown Reason','lastShutdown',32089,1,0,1,0,0,'#','1','1','1','2025-07-04 09:45:12','2025-07-13 11:57:42'),('RTUPRM-YV4EL','Clear Latched Motor Alarm','clearLatch',4,1,0,1,1,1,'#','0','0','1','2025-07-04 09:56:43','2025-07-13 12:01:47'),('RTUPRM-ZX2KN','Controller Mode Auto','controlModeAuto',10416,1,0,1,0,0,'#','1','1','1','2025-07-04 09:53:02','2025-07-13 11:59:45');
/*!40000 ALTER TABLE `rtuParameterDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sensorGroupDB`
--

DROP TABLE IF EXISTS `sensorGroupDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sensorGroupDB` (
  `id` varchar(50) NOT NULL,
  `number` varchar(50) DEFAULT NULL,
  `oid` varchar(50) DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `intervals` int(11) NOT NULL,
  `unit` tinyint(1) NOT NULL,
  `frekuensi` int(11) NOT NULL,
  `service_id` int(11) NOT NULL,
  `enterAlarm` int(11) DEFAULT 1,
  `exitAlarm` int(11) DEFAULT 1,
  `errorAlarm` int(11) DEFAULT 300,
  `state` varchar(2) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sensorGroupDB`
--

LOCK TABLES `sensorGroupDB` WRITE;
/*!40000 ALTER TABLE `sensorGroupDB` DISABLE KEYS */;
INSERT INTO `sensorGroupDB` VALUES ('PGS-D768E','2','2','Internal',10,1,1,11,3600,3600,3600,'1'),('PGS-DGTF7','1','1','RTU',5,1,1,10,1,1,300,'1');
/*!40000 ALTER TABLE `sensorGroupDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sensorListDB`
--

DROP TABLE IF EXISTS `sensorListDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sensorListDB` (
  `id` varchar(50) NOT NULL,
  `sensor_id` varchar(50) NOT NULL,
  `group_id` varchar(50) DEFAULT NULL,
  `oid` bigint(20) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `value` varchar(200) DEFAULT NULL,
  `timestamp` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `calibrate` tinyint(1) DEFAULT NULL,
  `formula` bigint(20) DEFAULT NULL,
  `alarm` tinyint(1) DEFAULT 0,
  `max` varchar(30) DEFAULT '0',
  `min` varchar(30) DEFAULT '0',
  `unit` varchar(30) DEFAULT '#',
  `oid_tipe` tinyint(1) DEFAULT NULL,
  `monitor` int(11) DEFAULT 0,
  `log` int(11) DEFAULT 0,
  `alarm_type` int(11) DEFAULT 0,
  `last_sync` datetime DEFAULT NULL,
  `conditions` varchar(50) DEFAULT 'Alarm Inactive',
  `notif_state` int(11) DEFAULT 0,
  `notif_count` int(11) DEFAULT 0,
  `notif_time` int(11) NOT NULL DEFAULT 0,
  `alarmId1` varchar(10) DEFAULT '',
  `alarmId2` varchar(10) DEFAULT '',
  `state` varchar(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_sensorList_group` (`group_id`),
  CONSTRAINT `fk_sensorList_group` FOREIGN KEY (`group_id`) REFERENCES `sensorGroupDB` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sensorListDB`
--

LOCK TABLES `sensorListDB` WRITE;
/*!40000 ALTER TABLE `sensorListDB` DISABLE KEYS */;
INSERT INTO `sensorListDB` VALUES ('PLS-00JQE','motorRunStateRtu1','PGS-DGTF7',3,'Motor Running Status - RTU 1','0.0','2025-08-27 17:28:24',0,0,0,'0','0','#',0,1,1,0,'2025-07-15 13:37:47','Alarm Inactive',0,0,0,'','','1'),('PLS-0HPP4','lowVoltSetpointRtu2','PGS-DGTF7',34,'Supply Voltage Low Alarm Setpoint - RTU 2',NULL,'2025-07-14 06:44:09',0,0,0,'0','0','V',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-0KMEG','motorRunStateRtu3','PGS-DGTF7',39,'Motor Running Status - RTU 3',NULL,'2025-07-14 06:44:19',0,0,0,'0','0','#',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-0PYTG','controlModeAutoRtu3','PGS-DGTF7',48,'Controller Mode Auto - RTU 3',NULL,'2025-07-14 06:44:19',0,0,0,'0','0','#',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-1VNYM','intakePressRtu2','PGS-DGTF7',24,'Intake Pressure - RTU 2',NULL,'2025-07-14 06:44:08',0,0,0,'0','0','bar/psi',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-27DMR','runningFreqRtu4','PGS-DGTF7',59,'Running Frequency - RTU 4',NULL,'2025-07-14 06:44:42',0,0,0,'0','0','Hz',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-2ADS2','latchedAlarm0Rtu2','PGS-DGTF7',26,'Latched Alarm 0 - RTU 2',NULL,'2025-07-14 06:44:08',0,0,0,'0','0','#',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-2AFPT','latchedAlarm0Rtu3','PGS-DGTF7',44,'Latched Alarm 0 - RTU 3',NULL,'2025-07-14 06:44:19',0,0,0,'0','0','#',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-2KQ62','lastShutdownRtu1','PGS-DGTF7',4,'Last Shutdown Reason - RTU 1','0.0','2025-08-27 17:28:24',0,0,0,'0','0','#',0,1,1,0,'2025-07-15 13:37:47','Alarm Inactive',0,0,0,'','','1'),('PLS-330QL','targetRunFreqRtu4','PGS-DGTF7',71,'Target Running Frequency - RTU 4',NULL,'2025-07-14 06:44:43',0,0,0,'0','0','Hz',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-37EEA','alarm0Rtu1','PGS-DGTF7',9,'Alarm 0 - RTU 1','0.0','2025-08-27 17:28:24',0,0,0,'0','0','#',0,1,1,0,'2025-07-15 13:37:47','Alarm Inactive',0,0,0,'','','1'),('PLS-3A1F0','nearonCpuUsage','PGS-D768E',5,'Nearon CPU Usage','15.6','2025-08-27 17:28:21',0,0,0,'0','0','%',0,1,1,0,'2025-04-29 10:29:44','Alarm Inactive',0,0,0,'','','1'),('PLS-3ZPGQ','controlModeAutoRtu2','PGS-DGTF7',30,'Controller Mode Auto - RTU 2',NULL,'2025-07-14 06:44:09',0,0,0,'0','0','#',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-44PVG','motorTempRtu2','PGS-DGTF7',25,'Motor Temperature - RTU 2',NULL,'2025-07-14 06:44:08',0,0,0,'0','0','C/F',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-5J6MQ','lockoutStateRtu1','PGS-DGTF7',2,'Lockout Status - RTU 1','0.0','2025-08-27 17:28:24',0,0,0,'0','0','#',0,1,1,0,'2025-07-15 13:37:47','Alarm Inactive',0,0,0,'','','1'),('PLS-5YRJN','currRunTimeRtu1','PGS-DGTF7',14,'Current Run Time - RTU 1','N/A','2025-08-27 17:28:24',0,0,0,'0','0','#',1,1,1,0,'2025-07-15 13:37:47','Alarm Inactive',0,0,0,'','','1'),('PLS-6FC21','nearonCpuTemp','PGS-D768E',6,'Nearon CPU Temperature','57.9','2025-08-27 17:28:21',0,0,0,'0','0','°C',0,1,1,0,'2025-04-29 10:29:44','Alarm Inactive',0,0,0,'','','1'),('PLS-6I5V3','motorRunStateRtu2','PGS-DGTF7',21,'Motor Running Status - RTU 2',NULL,'2025-07-14 06:44:08',0,0,0,'0','0','#',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-81ZKB','intakePressRtu1','PGS-DGTF7',6,'Intake Pressure - RTU 1','0.0','2025-08-27 17:28:24',0,0,0,'0','0','#',0,1,1,0,'2025-07-15 13:37:47','Alarm Inactive',0,0,0,'','','1'),('PLS-86B1C','nearonMemUsage','PGS-D768E',7,'Nearon Memory Usage','17','2025-08-27 17:28:21',0,0,0,'0','0','%',0,1,1,0,'2025-04-29 10:29:44','Alarm Inactive',0,0,0,'','','1'),('PLS-8GZA2','controlModeManualRtu1','PGS-DGTF7',10,'Controller Mode Manual - RTU 1','0.0','2025-08-27 17:28:24',0,0,0,'0','0','#',0,1,1,0,'2025-07-15 13:37:47','Alarm Inactive',0,0,0,'','','1'),('PLS-971EM','supplyVoltRtu2','PGS-DGTF7',19,'Supply Voltage - RTU 2',NULL,'2025-07-14 06:44:08',0,0,0,'0','0','#',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-9C17D','nearonStorageUsage','PGS-D768E',8,'Nearon Storage Usage','15','2025-08-27 17:28:21',0,0,0,'0','0','%',0,1,1,0,'2025-04-29 10:29:44','Alarm Inactive',0,0,0,'','','1'),('PLS-A7YOJ','motorTempRtu1','PGS-DGTF7',7,'Motor Temperature - RTU 1','0.0','2025-08-27 17:28:24',0,0,0,'0','0','#',0,1,1,0,'2025-07-15 13:37:47','Alarm Inactive',0,0,0,'','','1'),('PLS-ABBL5','lowVoltSetpointRtu3','PGS-DGTF7',52,'Supply Voltage Low Alarm Setpoint - RTU 3',NULL,'2025-07-14 06:44:19',0,0,0,'0','0','V',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-B1D00','nearonVolt','PGS-D768E',1,'Nearon Input Voltage','0.0','2025-08-27 17:28:21',0,0,0,'0','0','#',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','1'),('PLS-BSSL2','lowVoltSetpointRtu4','PGS-DGTF7',70,'Supply Voltage Low Alarm Setpoint - RTU 4',NULL,'2025-07-14 06:44:43',0,0,0,'0','0','V',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-BUTSW','latchedAlarm0Rtu1','PGS-DGTF7',8,'Latched Alarm 0 - RTU 1','0.0','2025-08-27 17:28:24',0,0,0,'0','0','#',0,1,1,0,'2025-07-15 13:37:47','Alarm Inactive',0,0,0,'','','1'),('PLS-C8FB2','nearonFan','PGS-D768E',4,'Nearon Fan Speed','20','2025-08-27 17:28:21',0,0,0,'0','0','#',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','1'),('PLS-C8OCK','supplyVoltRtu1','PGS-DGTF7',1,'Supply Voltage - RTU 1','0.0','2025-08-27 17:28:24',0,0,1,'220','0','V',0,1,1,2,'2025-07-15 13:37:47','Normal',2,3002,122808,'NML-0ZQ55','NML-0ZQ55','1'),('PLS-CPQN2','totalStartRtu3','PGS-DGTF7',49,'Total Starts - RTU 3',NULL,'2025-07-14 06:44:19',0,0,0,'0','0','#',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-CQADB','controlModeAutoRtu4','PGS-DGTF7',66,'Controller Mode Auto - RTU 4',NULL,'2025-07-14 06:44:43',0,0,0,'0','0','#',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-EF22C','currRunTimeRtu4','PGS-DGTF7',68,'Current Run Time - RTU 4',NULL,'2025-07-14 06:44:43',0,0,0,'0','0','#',1,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-ETQ49','alarm0Rtu4','PGS-DGTF7',63,'Alarm 0 - RTU 4',NULL,'2025-07-14 06:44:43',0,0,0,'0','0','#',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-FD654','nearonUptime','PGS-D768E',9,'Nearon Uptime','8 hours  03 minutes  52 seconds','2025-08-27 17:28:21',0,0,0,'0','0','#',1,1,1,0,'2025-04-29 10:29:44','Alarm Inactive',0,0,0,'','','1'),('PLS-FF4CD','nearonLastBoot','PGS-D768E',10,'Nearon Last Boot','2025-08-27 09:24:23','2025-08-27 17:28:21',0,0,0,'0','0','#',1,1,1,0,'2025-04-29 10:29:44','Alarm Inactive',0,0,0,'','','1'),('PLS-FGW15','currRunTimeRtu3','PGS-DGTF7',50,'Current Run Time - RTU 3',NULL,'2025-07-14 06:44:19',0,0,0,'0','0','#',1,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-FQ5US','currOffTimeRtu3','PGS-DGTF7',51,'Current Off Time - RTU 3',NULL,'2025-07-14 06:44:19',0,0,0,'0','0','#',1,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-GP9LY','lastShutdownRtu4','PGS-DGTF7',58,'Last Shutdown Reason - RTU 4',NULL,'2025-07-14 06:44:42',0,0,0,'0','0','#',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-H0JCG','currOffTimeRtu1','PGS-DGTF7',15,'Current Off Time - RTU 1','N/A','2025-08-27 17:28:24',0,0,0,'0','0','#',1,1,1,0,'2025-07-15 13:37:47','Alarm Inactive',0,0,0,'','','1'),('PLS-H6IGH','totalStartRtu1','PGS-DGTF7',13,'Total Starts - RTU 1','0.0','2025-08-27 17:28:24',0,0,0,'0','0','#',0,1,1,0,'2025-07-15 13:37:47','Alarm Inactive',0,0,0,'','','1'),('PLS-JIBLX','currRunTimeRtu2','PGS-DGTF7',32,'Current Run Time - RTU 2',NULL,'2025-07-14 06:44:09',0,0,0,'0','0','#',1,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-K60TU','motorRunStateRtu4','PGS-DGTF7',57,'Motor Running Status - RTU 4',NULL,'2025-07-14 06:44:42',0,0,0,'0','0','#',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-KGCLM','motorTempRtu4','PGS-DGTF7',61,'Motor Temperature - RTU 4',NULL,'2025-07-14 06:44:42',0,0,0,'0','0','C/F',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-KLX5N','alarm0Rtu3','PGS-DGTF7',45,'Alarm 0 - RTU 3',NULL,'2025-07-14 06:44:19',0,0,0,'0','0','#',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-KPWEQ','intakePressRtu4','PGS-DGTF7',60,'Intake Pressure - RTU 4',NULL,'2025-07-14 06:44:42',0,0,0,'0','0','bar/psi',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-KRK26','totalStartRtu2','PGS-DGTF7',31,'Total Starts - RTU 2',NULL,'2025-07-14 06:44:09',0,0,0,'0','0','#',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-L2AJN','controlModeManualRtu3','PGS-DGTF7',46,'Controller Mode Manual - RTU 3',NULL,'2025-07-14 06:44:19',0,0,0,'0','0','#',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-L3KN4','alarm0Rtu2','PGS-DGTF7',27,'Alarm 0 - RTU 2',NULL,'2025-07-14 06:44:08',0,0,0,'0','0','#',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-LE0GA','runningFreqRtu2','PGS-DGTF7',23,'Running Frequency - RTU 2',NULL,'2025-07-14 06:44:08',0,0,0,'0','0','Hz',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-M0PA5','intakePressLowRtu3','PGS-DGTF7',54,'Intake Pressure Low - RTU 3',NULL,'2025-07-14 06:44:20',0,0,0,'0','0','bar/psi',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-MEJTN','supplyVoltRtu3','PGS-DGTF7',37,'Supply Voltage - RTU 3',NULL,'2025-07-14 06:44:19',0,0,0,'0','0','#',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-MFIK3','intakePressLowRtu1','PGS-DGTF7',18,'Intake Pressure Low - RTU 1','0.0','2025-08-27 17:28:24',0,0,1,'104','0','#',0,1,1,3,'2025-07-15 13:37:47','Normal',2,3760,122809,'NML-HFYCQ','NML-HFYCQ','1'),('PLS-MMQOZ','currOffTimeRtu2','PGS-DGTF7',33,'Current Off Time - RTU 2',NULL,'2025-07-14 06:44:09',0,0,0,'0','0','#',1,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-MW2KH','targetRunFreqRtu3','PGS-DGTF7',53,'Target Running Frequency - RTU 3',NULL,'2025-07-14 06:44:20',0,0,0,'0','0','Hz',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-NMXZF','lockoutStateRtu3','PGS-DGTF7',38,'Lockout Status - RTU 3',NULL,'2025-07-14 06:44:19',0,0,0,'0','0','#',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-NU95X','targetRunFreqRtu2','PGS-DGTF7',35,'Target Running Frequency - RTU 2',NULL,'2025-07-14 06:44:09',0,0,0,'0','0','Hz',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-NZ45A','runningFreqRtu3','PGS-DGTF7',41,'Running Frequency - RTU 3',NULL,'2025-07-14 06:44:19',0,0,0,'0','0','Hz',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-O32IX','currOffTimeRtu4','PGS-DGTF7',69,'Current Off Time - RTU 4',NULL,'2025-07-14 06:44:43',0,0,0,'0','0','#',1,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-O5SR7','lastShutdownRtu2','PGS-DGTF7',22,'Last Shutdown Reason - RTU 2',NULL,'2025-07-14 06:44:08',0,0,0,'0','0','#',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-PSDDN','motorTempRtu3','PGS-DGTF7',43,'Motor Temperature - RTU 3',NULL,'2025-07-14 06:44:19',0,0,0,'0','0','C/F',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-PXRG2','controlModeHandRtu1','PGS-DGTF7',11,'Controller Mode Hand - RTU 1','0.0','2025-08-27 17:28:24',0,0,0,'0','0','#',0,1,1,0,'2025-07-15 13:37:47','Alarm Inactive',0,0,0,'','','1'),('PLS-PZI83','lowVoltSetpointRtu1','PGS-DGTF7',16,'Supply Voltage Low Alarm Setpoint - RTU 1','0.0','2025-08-27 17:28:24',0,0,0,'0','0','V',0,1,1,0,'2025-07-15 13:37:47','Alarm Inactive',0,0,0,'','','1'),('PLS-RKIB9','controlModeHandRtu4','PGS-DGTF7',65,'Controller Mode Hand - RTU 4',NULL,'2025-07-14 06:44:43',0,0,0,'0','0','#',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-SOZFN','controlModeManualRtu2','PGS-DGTF7',28,'Controller Mode Manual - RTU 2',NULL,'2025-07-14 06:44:09',0,0,0,'0','0','#',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-SV1RJ','controlModeManualRtu4','PGS-DGTF7',64,'Controller Mode Manual - RTU 4',NULL,'2025-07-14 06:44:43',0,0,0,'0','0','#',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-SV8R8','lockoutStateRtu2','PGS-DGTF7',20,'Lockout Status - RTU 2',NULL,'2025-07-14 06:44:08',0,0,0,'0','0','#',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-T2TWG','lastShutdownRtu3','PGS-DGTF7',40,'Last Shutdown Reason - RTU 3',NULL,'2025-07-14 06:44:19',0,0,0,'0','0','#',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-TBTUN','targetRunFreqRtu1','PGS-DGTF7',17,'Target Running Frequency - RTU 1','0.0','2025-08-27 17:28:24',0,0,0,'0','0','Hz',0,1,1,0,'2025-07-15 13:37:47','Alarm Inactive',0,0,0,'','','1'),('PLS-TMYVM','runningFreqRtu1','PGS-DGTF7',5,'Running Frequency - RTU 1','0.0','2025-08-27 17:28:24',0,0,0,'0','0','Hz',0,1,1,0,'2025-07-15 13:37:47','Alarm Inactive',0,0,0,'','','1'),('PLS-UC56Z','intakePressRtu3','PGS-DGTF7',42,'Intake Pressure - RTU 3',NULL,'2025-07-14 06:44:19',0,0,0,'0','0','bar/psi',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-VAL91','latchedAlarm0Rtu4','PGS-DGTF7',62,'Latched Alarm 0 - RTU 4',NULL,'2025-07-14 06:44:42',0,0,0,'0','0','#',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-WBN5L','controlModeAutoRtu1','PGS-DGTF7',12,'Controller Mode Auto - RTU 1','0.0','2025-08-27 17:28:24',0,0,0,'0','0','#',0,1,1,0,'2025-07-15 13:37:47','Alarm Inactive',0,0,0,'','','1'),('PLS-WLG2U','totalStartRtu4','PGS-DGTF7',67,'Total Starts - RTU 4',NULL,'2025-07-14 06:44:43',0,0,0,'0','0','#',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-XJAQQ','intakePressLowRtu4','PGS-DGTF7',72,'Intake Pressure Low - RTU 4',NULL,'2025-07-14 06:44:43',0,0,0,'0','0','bar/psi',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-XW9LB','intakePressLowRtu2','PGS-DGTF7',36,'Intake Pressure Low - RTU 2',NULL,'2025-07-14 06:44:09',0,0,0,'0','0','bar/psi',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-Z42S8','supplyVoltRtu4','PGS-DGTF7',55,'Supply Voltage - RTU 4',NULL,'2025-07-14 06:44:42',0,0,0,'0','0','#',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-ZIXIL','controlModeHandRtu3','PGS-DGTF7',47,'Controller Mode Hand - RTU 3',NULL,'2025-07-14 06:44:19',0,0,0,'0','0','#',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-ZRGYW','controlModeHandRtu2','PGS-DGTF7',29,'Controller Mode Hand - RTU 2',NULL,'2025-07-14 06:44:09',0,0,0,'0','0','#',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0'),('PLS-ZTYMS','lockoutStateRtu4','PGS-DGTF7',56,'Lockout Status - RTU 4',NULL,'2025-07-14 06:44:42',0,0,0,'0','0','#',0,1,1,0,NULL,'Alarm Inactive',0,0,0,'','','0');
/*!40000 ALTER TABLE `sensorListDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sensorParameterGroupDB`
--

DROP TABLE IF EXISTS `sensorParameterGroupDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sensorParameterGroupDB` (
  `id` varchar(50) NOT NULL,
  `group_id` varchar(50) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `parameter` varchar(100) NOT NULL,
  `value` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_sensorParamGroup_group` (`group_id`),
  CONSTRAINT `fk_sensorParamGroup_group` FOREIGN KEY (`group_id`) REFERENCES `sensorGroupDB` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sensorParameterGroupDB`
--

LOCK TABLES `sensorParameterGroupDB` WRITE;
/*!40000 ALTER TABLE `sensorParameterGroupDB` DISABLE KEYS */;
INSERT INTO `sensorParameterGroupDB` VALUES ('PPG-89271','PGS-D768E','Parent OID','parent_oid','1.3.6.1.4.1.19719'),('PPG-CH3HY','PGS-DGTF7','Port','port','3'),('PPG-QK2JW','PGS-DGTF7','Parent OID','parent_oid','1.3.6.1.4.1.19719'),('PPG-USTNF','PGS-DGTF7','Baudrate','baudrate','9600');
/*!40000 ALTER TABLE `sensorParameterGroupDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sensorParameterListDB`
--

DROP TABLE IF EXISTS `sensorParameterListDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sensorParameterListDB` (
  `id` varchar(50) NOT NULL,
  `sensor_id` varchar(50) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `parameter` varchar(100) NOT NULL,
  `value` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_sensorParameterList_sensor_id` (`sensor_id`),
  CONSTRAINT `fk_sensorParameterList_sensor_id` FOREIGN KEY (`sensor_id`) REFERENCES `sensorListDB` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sensorParameterListDB`
--

LOCK TABLES `sensorParameterListDB` WRITE;
/*!40000 ALTER TABLE `sensorParameterListDB` DISABLE KEYS */;
INSERT INTO `sensorParameterListDB` VALUES ('PPL-00IAP','PLS-KPWEQ','Address','address','32137'),('PPL-04LRO','PLS-FQ5US','Length','length','2'),('PPL-05URS','PLS-00JQE','Divider','divider','1.0'),('PPL-06D10','PLS-3ZPGQ','Divider','divider','1.0'),('PPL-0C42F','PLS-0HPP4','Divider','divider','1.0'),('PPL-0KFIS','PLS-T2TWG','Length','length','1'),('PPL-0NUDA','PLS-2AFPT','Address','address','32041'),('PPL-0S4RX','PLS-NZ45A','Divider','divider','100.0'),('PPL-0SQDT','PLS-2AFPT','Divider','divider','1.0'),('PPL-0VG8H','PLS-TMYVM','Address','address','32166'),('PPL-10ED9','PLS-B1D00','Pin','pin','0'),('PPL-1167Z','PLS-JIBLX','Address','address','32077'),('PPL-16M0H','PLS-TBTUN','Divider','divider','100.0'),('PPL-1GBN3','PLS-330QL','Divider','divider','100.0'),('PPL-1K87F','PLS-00JQE','Address','address','10432'),('PPL-1NKFA','PLS-C8OCK','Divider','divider','1.0'),('PPL-1OT58','PLS-0KMEG','Length','length','1'),('PPL-1SBOR','PLS-C8OCK','Length','length','1'),('PPL-1WC1M','PLS-NZ45A','Address','address','32166'),('PPL-1ZBU6','PLS-MEJTN','Divider','divider','1.0'),('PPL-1ZOTV','PLS-XJAQQ','Length','length','1'),('PPL-25PUD','PLS-ZIXIL','Divider','divider','1.0'),('PPL-2PDJB','PLS-ABBL5','Address','address','40194'),('PPL-2QAJ4','PLS-3ZPGQ','Address','address','10416'),('PPL-314T4','PLS-A7YOJ','Address','address','32141'),('PPL-329IH','PLS-UC56Z','Length','length','1'),('PPL-3395Z','PLS-O32IX','Length','length','2'),('PPL-3KB5F','PLS-L2AJN','Address','address','10414'),('PPL-3MX2S','PLS-1VNYM','Length','length','1'),('PPL-3SIWD','PLS-EF22C','Address','address','32077'),('PPL-40R1E','PLS-NU95X','Address','address','40856'),('PPL-41FJK','PLS-SOZFN','Length','length','1'),('PPL-4297X','PLS-O32IX','Address','address','32079'),('PPL-4957N','PLS-PZI83','Divider','divider','1.0'),('PPL-4GV8W','PLS-L2AJN','Length','length','1'),('PPL-4VNFG','PLS-KLX5N','Length','length','1'),('PPL-5RX4R','PLS-CQADB','Length','length','1'),('PPL-5X7FH','PLS-PZI83','Address','address','40194'),('PPL-5XKOC','PLS-L3KN4','Address','address','32049'),('PPL-69WAO','PLS-M0PA5','Length','length','1'),('PPL-6DJ2C','PLS-2ADS2','Length','length','1'),('PPL-6H2W3','PLS-971EM','Length','length','1'),('PPL-6J2IA','PLS-NU95X','Divider','divider','100.0'),('PPL-6J4LM','PLS-K60TU','Divider','divider','1.0'),('PPL-6R4RR','PLS-O5SR7','Address','address','32089'),('PPL-6U8I3','PLS-0HPP4','Length','length','1'),('PPL-6Y0XV','PLS-330QL','Address','address','40856'),('PPL-6YZJ8','PLS-2ADS2','Address','address','32041'),('PPL-6ZP55','PLS-00JQE','Length','length','1'),('PPL-72NPQ','PLS-3ZPGQ','Length','length','1'),('PPL-782QW','PLS-C8OCK','Address','address','32104'),('PPL-7CODL','PLS-2KQ62','Address','address','32089'),('PPL-7O9LB','PLS-KRK26','Length','length','1'),('PPL-7Q58I','PLS-ZRGYW','Divider','divider','1.0'),('PPL-82FSG','PLS-BUTSW','Address','address','32041'),('PPL-86Q63','PLS-UC56Z','Divider','divider','10.0'),('PPL-89KTK','PLS-1VNYM','Address','address','32137'),('PPL-8APKF','PLS-WLG2U','Divider','divider','1.0'),('PPL-8DZT6','PLS-PZI83','Length','length','1'),('PPL-8OAGV','PLS-0HPP4','Address','address','40194'),('PPL-8OAKD','PLS-Z42S8','Length','length','1'),('PPL-8QHWB','PLS-M0PA5','Address','address','40509'),('PPL-8RIPZ','PLS-0KMEG','Divider','divider','1.0'),('PPL-8SZEI','PLS-VAL91','Divider','divider','1.0'),('PPL-95CNG','PLS-BSSL2','Divider','divider','1.0'),('PPL-99I7L','PLS-KLX5N','Divider','divider','1.0'),('PPL-9DKVX','PLS-2KQ62','Length','length','1'),('PPL-9YMOB','PLS-5YRJN','Length','length','2'),('PPL-A8DSH','PLS-NMXZF','Address','address','10413'),('PPL-AH2AO','PLS-SV1RJ','Divider','divider','1.0'),('PPL-AMHCH','PLS-ZTYMS','Length','length','1'),('PPL-ARHQU','PLS-SV1RJ','Length','length','1'),('PPL-AUACK','PLS-M0PA5','Divider','divider','10.0'),('PPL-B6U2L','PLS-ABBL5','Divider','divider','1.0'),('PPL-B9XMX','PLS-MW2KH','Divider','divider','100.0'),('PPL-BJ4XY','PLS-A7YOJ','Length','length','1'),('PPL-BL1UT','PLS-SV8R8','Address','address','10413'),('PPL-BTMDA','PLS-KGCLM','Address','address','32141'),('PPL-CMPI9','PLS-CPQN2','Address','address','32065'),('PPL-CPBT2','PLS-NZ45A','Length','length','1'),('PPL-CQ0J7','PLS-MEJTN','Address','address','32104'),('PPL-CR0E1','PLS-27DMR','Address','address','32166'),('PPL-CTDJ9','PLS-LE0GA','Length','length','1'),('PPL-D3PKR','PLS-SV8R8','Length','length','1'),('PPL-D9MM1','PLS-TMYVM','Length','length','1'),('PPL-DA189','PLS-B1D00','Offset','offset','5.3'),('PPL-DCLTH','PLS-2AFPT','Length','length','1'),('PPL-DDZFO','PLS-WLG2U','Length','length','1'),('PPL-DISU3','PLS-XW9LB','Address','address','40509'),('PPL-DKDJZ','PLS-ABBL5','Length','length','1'),('PPL-DN19P','PLS-NMXZF','Length','length','1'),('PPL-DXO3K','PLS-8GZA2','Length','length','1'),('PPL-DY7XO','PLS-JIBLX','Length','length','2'),('PPL-E5QS5','PLS-EF22C','Divider','divider','1.0'),('PPL-E8O0R','PLS-MFIK3','Divider','divider','10.0'),('PPL-EOPP9','PLS-O5SR7','Length','length','1'),('PPL-EPHXC','PLS-XW9LB','Length','length','1'),('PPL-EPOMH','PLS-XW9LB','Divider','divider','10.0'),('PPL-ESRTL','PLS-5J6MQ','Address','address','10413'),('PPL-EUA6W','PLS-WBN5L','Length','length','1'),('PPL-F041E','PLS-GP9LY','Length','length','1'),('PPL-F7QEX','PLS-MW2KH','Address','address','40856'),('PPL-FIS3I','PLS-2KQ62','Divider','divider','1.0'),('PPL-FJ31W','PLS-SV8R8','Divider','divider','1.0'),('PPL-FKPNL','PLS-PSDDN','Divider','divider','10.0'),('PPL-FX3RZ','PLS-ETQ49','Length','length','1'),('PPL-FZGKT','PLS-FQ5US','Divider','divider','1.0'),('PPL-G64MY','PLS-RKIB9','Divider','divider','1.0'),('PPL-GLQJI','PLS-ETQ49','Address','address','32049'),('PPL-GP4EG','PLS-K60TU','Length','length','1'),('PPL-HPCTV','PLS-TMYVM','Divider','divider','100.0'),('PPL-HU1CQ','PLS-SV1RJ','Address','address','10414'),('PPL-IBWAU','PLS-BSSL2','Length','length','1'),('PPL-IEDZ2','PLS-ZTYMS','Address','address','10413'),('PPL-IVNN1','PLS-L3KN4','Length','length','1'),('PPL-JBFGW','PLS-BUTSW','Length','length','1'),('PPL-JROSC','PLS-VAL91','Length','length','1'),('PPL-K8038','PLS-81ZKB','Divider','divider','10.0'),('PPL-KE2IY','PLS-XJAQQ','Divider','divider','10.0'),('PPL-KUUYV','PLS-BSSL2','Address','address','40194'),('PPL-KVQU7','PLS-MMQOZ','Divider','divider','1.0'),('PPL-KX294','PLS-UC56Z','Address','address','32137'),('PPL-L1520','PLS-MFIK3','Length','length','1'),('PPL-L1PP9','PLS-27DMR','Length','length','1'),('PPL-L3W9N','PLS-44PVG','Length','length','1'),('PPL-LCC8Y','PLS-H0JCG','Divider','divider','1.0'),('PPL-LGGKC','PLS-KRK26','Address','address','32065'),('PPL-LM3CB','PLS-5J6MQ','Length','length','1'),('PPL-LNLOL','PLS-44PVG','Divider','divider','10.0'),('PPL-LR7WL','PLS-FQ5US','Address','address','32079'),('PPL-M0GGY','PLS-LE0GA','Address','address','32166'),('PPL-M5CWC','PLS-PXRG2','Divider','divider','1.0'),('PPL-MDUBB','PLS-MW2KH','Length','length','1'),('PPL-MEMUL','PLS-EF22C','Length','length','2'),('PPL-MMC2K','PLS-H6IGH','Divider','divider','1.0'),('PPL-MNM5K','PLS-44PVG','Address','address','32141'),('PPL-MOY40','PLS-XJAQQ','Address','address','40509'),('PPL-MYSOF','PLS-971EM','Address','address','32104'),('PPL-N2E4U','PLS-ZIXIL','Length','length','1'),('PPL-NM89T','PLS-WBN5L','Divider','divider','1.0'),('PPL-NRC73','PLS-KPWEQ','Divider','divider','10.0'),('PPL-NYQ4Z','PLS-6I5V3','Length','length','1'),('PPL-O2GW7','PLS-GP9LY','Divider','divider','1.0'),('PPL-O6KQS','PLS-MMQOZ','Length','length','2'),('PPL-O6KSA','PLS-2ADS2','Divider','divider','1.0'),('PPL-OAZW2','PLS-PXRG2','Length','length','1'),('PPL-OLSGP','PLS-JIBLX','Divider','divider','1.0'),('PPL-OQXHG','PLS-FGW15','Address','address','32077'),('PPL-OT217','PLS-0PYTG','Divider','divider','1.0'),('PPL-P3ASE','PLS-SOZFN','Divider','divider','1.0'),('PPL-P4A7I','PLS-H0JCG','Length','length','2'),('PPL-P72X6','PLS-GP9LY','Address','address','32089'),('PPL-PBQS2','PLS-K60TU','Address','address','10432'),('PPL-PG0KZ','PLS-MEJTN','Length','length','1'),('PPL-PGSZH','PLS-L2AJN','Divider','divider','1.0'),('PPL-PSHEY','PLS-CQADB','Address','address','10416'),('PPL-PXA7K','PLS-VAL91','Address','address','32041'),('PPL-QBN0N','PLS-RKIB9','Length','length','1'),('PPL-QE7D5','PLS-WLG2U','Address','address','32065'),('PPL-QEQ1I','PLS-Z42S8','Address','address','32104'),('PPL-QSBAC','PLS-H6IGH','Length','length','1'),('PPL-QSQZ3','PLS-5J6MQ','Divider','divider','1.0'),('PPL-R3759','PLS-NU95X','Length','length','1'),('PPL-R47BI','PLS-T2TWG','Address','address','32089'),('PPL-RBCZG','PLS-TBTUN','Address','address','40856'),('PPL-RKL69','PLS-81ZKB','Length','length','1'),('PPL-ROP4A','PLS-81ZKB','Address','address','32137'),('PPL-RZQBD','PLS-H6IGH','Address','address','32065'),('PPL-S15ER','PLS-CPQN2','Divider','divider','1.0'),('PPL-S5CD1','PLS-KLX5N','Address','address','32049'),('PPL-S6V8N','PLS-0PYTG','Length','length','1'),('PPL-SCIBL','PLS-CPQN2','Length','length','1'),('PPL-SPHHT','PLS-5YRJN','Address','address','32077'),('PPL-SQD5I','PLS-A7YOJ','Divider','divider','10.0'),('PPL-SU3HQ','PLS-6I5V3','Divider','divider','1.0'),('PPL-T5FSS','PLS-NMXZF','Divider','divider','1.0'),('PPL-T5KC4','PLS-0PYTG','Address','address','10416'),('PPL-T6HLU','PLS-ZIXIL','Address','address','10415'),('PPL-T8WSU','PLS-330QL','Length','length','1'),('PPL-T9WDK','PLS-ZRGYW','Length','length','1'),('PPL-TA2QJ','PLS-LE0GA','Divider','divider','100.0'),('PPL-TFZL2','PLS-KGCLM','Length','length','1'),('PPL-TMN62','PLS-FGW15','Divider','divider','1.0'),('PPL-TVT2V','PLS-RKIB9','Address','address','10415'),('PPL-TZQZD','PLS-ZTYMS','Divider','divider','1.0'),('PPL-UOJ3Q','PLS-37EEA','Length','length','1'),('PPL-V4151','PLS-TBTUN','Length','length','1'),('PPL-V4TDE','PLS-PSDDN','Address','address','32141'),('PPL-V6VTR','PLS-KGCLM','Divider','divider','10.0'),('PPL-V9X6A','PLS-SOZFN','Address','address','10414'),('PPL-VB99B','PLS-971EM','Divider','divider','1.0'),('PPL-VCP6F','PLS-PSDDN','Length','length','1'),('PPL-VGRP9','PLS-8GZA2','Divider','divider','1.0'),('PPL-VJHYG','PLS-37EEA','Divider','divider','1.0'),('PPL-VVC8D','PLS-WBN5L','Address','address','10416'),('PPL-VW6KR','PLS-L3KN4','Divider','divider','1.0'),('PPL-VX6F7','PLS-MMQOZ','Address','address','32079'),('PPL-VXEYJ','PLS-6I5V3','Address','address','10432'),('PPL-W14VN','PLS-Z42S8','Divider','divider','1.0'),('PPL-W3JVE','PLS-CQADB','Divider','divider','1.0'),('PPL-WC8JY','PLS-PXRG2','Address','address','10415'),('PPL-WCSJ9','PLS-1VNYM','Divider','divider','10.0'),('PPL-WFVCY','PLS-8GZA2','Address','address','10414'),('PPL-X73Z6','PLS-FGW15','Length','length','2'),('PPL-XB2QC','PLS-5YRJN','Divider','divider','1.0'),('PPL-XGQQ6','PLS-27DMR','Divider','divider','100.0'),('PPL-XIFXO','PLS-MFIK3','Address','address','40509'),('PPL-XMFL8','PLS-ZRGYW','Address','address','10415'),('PPL-Y90C3','PLS-H0JCG','Address','address','32079'),('PPL-YKUTA','PLS-KPWEQ','Length','length','1'),('PPL-YW1KV','PLS-O32IX','Divider','divider','1.0'),('PPL-YYVQD','PLS-BUTSW','Divider','divider','1.0'),('PPL-Z622U','PLS-T2TWG','Divider','divider','1.0'),('PPL-Z97ZS','PLS-O5SR7','Divider','divider','1.0'),('PPL-ZGQ8E','PLS-0KMEG','Address','address','10432'),('PPL-ZIZVA','PLS-ETQ49','Divider','divider','1.0'),('PPL-ZK4M4','PLS-37EEA','Address','address','32049'),('PPL-ZLA23','PLS-KRK26','Divider','divider','1.0');
/*!40000 ALTER TABLE `sensorParameterListDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sensorPortConfigDB`
--

DROP TABLE IF EXISTS `sensorPortConfigDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sensorPortConfigDB` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `type` varchar(10) DEFAULT NULL,
  `modbus_id` varchar(100) DEFAULT NULL,
  `digital_pin` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sensorPortConfigDB`
--

LOCK TABLES `sensorPortConfigDB` WRITE;
/*!40000 ALTER TABLE `sensorPortConfigDB` DISABLE KEYS */;
INSERT INTO `sensorPortConfigDB` VALUES (1,'port_1','1','1','32'),(2,'port_2','0','2','33'),(3,'port_3','3','3','21'),(4,'port_4','0','4','22'),(5,'port_5','2','5','12'),(6,'port_6','0','6','24');
/*!40000 ALTER TABLE `sensorPortConfigDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `serverHttpAuthDB`
--

DROP TABLE IF EXISTS `serverHttpAuthDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `serverHttpAuthDB` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `value` varchar(10000) NOT NULL,
  `updatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `serverHttpAuthDB`
--

LOCK TABLES `serverHttpAuthDB` WRITE;
/*!40000 ALTER TABLE `serverHttpAuthDB` DISABLE KEYS */;
INSERT INTO `serverHttpAuthDB` VALUES (1,'token','eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlX2lkIjoiMiIsInBlcm1pc3Npb25zIjp7IjIyIjp0cnVlfSwicHJval9yb2xlX2lkIjoiODFiMTA4M2IyMjI1NGYzMTk1YjA5NTllYzE4M2NhNTQiLCJwcm9qX3Blcm1pc3Npb25zIjp7IjEiOnRydWUsIjEwIjp0cnVlLCIxMSI6dHJ1ZSwiMTIiOnRydWUsIjEzIjp0cnVlLCIxNCI6dHJ1ZSwiMTUiOnRydWUsIjE2Ijp0cnVlLCIxNyI6dHJ1ZSwiMTgiOnRydWUsIjE5Ijp0cnVlLCIyIjp0cnVlLCIyMCI6dHJ1ZSwiMjEiOnRydWUsIjIyIjp0cnVlLCIyMyI6dHJ1ZSwiMjQiOnRydWUsIjI1Ijp0cnVlLCIyNiI6dHJ1ZSwiMjciOnRydWUsIjI4Ijp0cnVlLCIyOSI6dHJ1ZSwiMyI6dHJ1ZSwiMzAiOnRydWUsIjM4Ijp0cnVlLCIzOSI6dHJ1ZSwiNCI6dHJ1ZSwiNDAiOnRydWUsIjQxIjp0cnVlLCI0MiI6dHJ1ZSwiNDMiOnRydWUsIjQ0Ijp0cnVlLCI0NSI6dHJ1ZSwiNDYiOnRydWUsIjQ3Ijp0cnVlLCI0OCI6dHJ1ZSwiNDkiOnRydWUsIjUiOnRydWUsIjUwIjp0cnVlLCI1MSI6dHJ1ZSwiNTIiOnRydWUsIjUzIjp0cnVlLCI1NCI6dHJ1ZSwiNTUiOnRydWUsIjU2Ijp0cnVlLCI1NyI6dHJ1ZSwiNTgiOnRydWUsIjU5Ijp0cnVlLCI2Ijp0cnVlLCI2MCI6dHJ1ZSwiNjEiOnRydWUsIjYyIjp0cnVlLCI2MyI6dHJ1ZSwiNjQiOnRydWUsIjY1Ijp0cnVlLCI2NiI6dHJ1ZSwiNjciOnRydWUsIjY4Ijp0cnVlLCI2OSI6dHJ1ZSwiNyI6dHJ1ZSwiNzAiOnRydWUsIjcxIjp0cnVlLCI3MiI6dHJ1ZSwiNzMiOnRydWUsIjgiOnRydWUsIjkiOnRydWV9LCJwcm9qZWN0cyI6WyJTWU5QUyJdLCJjb21wYW55X2lkIjoicHl3dHduemltNyIsImV4cCI6MTc1NjM0NzQxMiwiaXNzIjoiMGFlNWM2MjYzYzUyNGRiZTk1OGQ3MjI2ZDE0YmY2MjgifQ.rb0mCLzQk7Ha5eTLyQtRfSd5SUSUYRrygDBndKm9f4U','2025-08-27 09:16:52'),(2,'expire','Thu, 28 Aug 2025 02:16:52 GMT','2025-08-27 09:16:52'),(3,'state','0','2025-08-29 09:08:48');
/*!40000 ALTER TABLE `serverHttpAuthDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `serverHttpDB`
--

DROP TABLE IF EXISTS `serverHttpDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `serverHttpDB` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `parameter` varchar(30) NOT NULL,
  `type` varchar(30) NOT NULL,
  `data` varchar(100) NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `serverHttpDB`
--

LOCK TABLES `serverHttpDB` WRITE;
/*!40000 ALTER TABLE `serverHttpDB` DISABLE KEYS */;
INSERT INTO `serverHttpDB` VALUES (1,'Authentication','auth','1','/v1/auth/login/connex','2024-03-26 10:48:31','2025-03-21 11:24:40'),(2,'Receiver Data','receiver','1','/v1/projectnode/nodes/nodeid/sensors/monitoring-data','2024-03-26 10:48:31','2025-07-15 11:12:29'),(3,'Node Detail','node','1','/v1/projectnode/nodes/nodeid/connex','2024-03-26 10:48:31','2025-03-12 15:17:07'),(4,'Sensor Detail','sensor','1','/v1/projectnode/nodes/nodeid/sensors/connex','2024-03-26 10:48:31','2025-03-21 11:28:53'),(5,'Actuator Detail','actuator','1','/v1/projectnode/nodes/nodeid/actuators/connex','2024-03-26 10:48:31','2025-06-02 13:45:15'),(6,'Notification','notif','1','/v1/notification','2024-03-26 10:49:15','2025-03-13 11:02:11'),(7,'Reboot','reboot','1','/v1/projectnode/nodes/nodeid/reboot','2024-03-26 10:49:15','2025-03-12 15:18:03'),(12,'Update','update','1','/v1/monitoring/updater','2024-06-05 15:38:07','2025-03-12 15:18:24');
/*!40000 ALTER TABLE `serverHttpDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `serverMqttDB`
--

DROP TABLE IF EXISTS `serverMqttDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `serverMqttDB` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `parameter` varchar(30) NOT NULL,
  `data` varchar(30) NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `serverMqttDB`
--

LOCK TABLES `serverMqttDB` WRITE;
/*!40000 ALTER TABLE `serverMqttDB` DISABLE KEYS */;
INSERT INTO `serverMqttDB` VALUES (1,'Publish Data Sensor','data','node/nodeid/data','2024-03-26 10:52:40','2024-12-03 22:29:55'),(2,'Node Detail','node','node/nodeid','2024-03-26 10:52:40','2024-12-03 22:30:08'),(3,'Sensor Detail','sensor','node/nodeid/sensors','2024-03-26 10:52:40','2024-12-03 22:30:20'),(4,'Actuator Detail','actuator','node/nodeid/actuators','2024-03-26 10:52:40','2024-12-03 22:30:30'),(5,'Notification','notif','notifications/node/nodeid','2024-03-26 10:52:40','2024-12-03 22:30:43');
/*!40000 ALTER TABLE `serverMqttDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `serverSettingDB`
--

DROP TABLE IF EXISTS `serverSettingDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `serverSettingDB` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `server` varchar(30) NOT NULL,
  `domainAddress` varchar(30) NOT NULL,
  `ipAddress` varchar(30) NOT NULL,
  `port` varchar(5) NOT NULL,
  `username` varchar(30) NOT NULL,
  `password` varchar(100) NOT NULL,
  `updatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `serverSettingDB`
--

LOCK TABLES `serverSettingDB` WRITE;
/*!40000 ALTER TABLE `serverSettingDB` DISABLE KEYS */;
INSERT INTO `serverSettingDB` VALUES (1,'http','dev-api-nearon.synapsis.id','139.180.216.99','80','synapsis','password','2025-07-12 17:50:24'),(2,'mqtt','mqtt.synapsis.id','-','32100','synapsis','Rasp8266!','2025-01-20 13:38:08');
/*!40000 ALTER TABLE `serverSettingDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `systemServiceDB`
--

DROP TABLE IF EXISTS `systemServiceDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `systemServiceDB` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `service` varchar(20) NOT NULL,
  `enable` varchar(20) NOT NULL,
  `state` varchar(1000) DEFAULT '',
  `last_update` datetime DEFAULT NULL,
  `last_run` varchar(100) NOT NULL,
  `since` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `systemServiceDB`
--

LOCK TABLES `systemServiceDB` WRITE;
/*!40000 ALTER TABLE `systemServiceDB` DISABLE KEYS */;
INSERT INTO `systemServiceDB` VALUES (1,'nearon_auth','active','enabled','Device Authentication Already Expire','2025-08-29 09:08:48','Wed 2025-08-27 09:22:58','8h '),(2,'nearon_routine','active','enabled','Feature Routine Monitoring Setting Inactive','2025-08-27 17:28:27','Wed 2025-08-27 09:25:05','8h '),(3,'nearon_alarm','active','enabled','Feature Alarm Monitoring Setting Inactive','2025-08-29 09:08:48','Wed 2025-08-27 09:22:58','8h '),(4,'nearon_buffer','active','enabled','Feature Buffer Monitoring Setting Inactive','2025-08-27 17:28:26','Wed 2025-08-27 09:22:58','8h '),(5,'nearon_sync','active','enabled','Feature Synchronize Setting Inactive','2025-08-27 17:28:23','Wed 2025-08-27 09:22:58','8h '),(6,'nearon_notif','active','enabled','Feature Notification Setting Inactive','2025-08-29 09:08:48','Wed 2025-08-27 09:22:58','8h '),(7,'nearon_log','active','enabled','Feature Routine Internal Log Setting Inactive','2025-08-29 09:08:47','Wed 2025-08-27 09:22:58','8h '),(8,'nearon_display','active','enabled','Home Page','2025-08-29 09:08:48','Wed 2025-08-27 09:22:58','8h '),(9,'sensor1','active','enabled','18 Sensors Failed Sampling - Port N/A','2025-08-27 17:28:24','Wed 2025-08-27 09:25:06','8h '),(10,'sensor2','active','enabled','8 Sensors Success Sampling','2025-08-27 17:28:21','Wed 2025-08-27 09:25:06','8h '),(11,'actuator1','active','enabled','No Triggered Actuator by Server Remote | No Triggered Actuator by Schedule','2025-08-29 09:08:49','Wed 2025-08-27 09:22:58','8h '),(23,'actuator2','inactive','disabled','-',NULL,'-','-');
/*!40000 ALTER TABLE `systemServiceDB` ENABLE KEYS */;
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
