-- MySQL dump 10.13  Distrib 5.7.13, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: project
-- ------------------------------------------------------
-- Server version	5.7.13-log

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
-- Table structure for table `fitness_cardio`
--

DROP TABLE IF EXISTS `fitness_cardio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fitness_cardio` (
  `fitness_cardio_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(30) NOT NULL,
  `fitness_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fitness_menu_id` int(11) NOT NULL,
  `fitness_seconds` int(11) NOT NULL,
  `distance` int(11) NOT NULL,
  `number_steps` int(11) NOT NULL,
  `used_calorie` double NOT NULL,
  PRIMARY KEY (`fitness_cardio_id`),
  KEY `user_id` (`user_id`),
  KEY `fitness_menu_id` (`fitness_menu_id`),
  CONSTRAINT `fitness_cardio_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `fitness_cardio_ibfk_2` FOREIGN KEY (`fitness_menu_id`) REFERENCES `fitness_menu` (`fitness_menu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fitness_cardio`
--

LOCK TABLES `fitness_cardio` WRITE;
/*!40000 ALTER TABLE `fitness_cardio` DISABLE KEYS */;
INSERT INTO `fitness_cardio` VALUES (1,'spider','2019-06-30 15:00:00',1,1800,2100,3500,90),(2,'spider','2019-07-01 15:00:00',4,3600,8000,7800,586.8),(3,'spider','2019-07-02 15:00:00',2,3600,6000,7200,216),(4,'spider','2019-07-03 15:00:00',5,1800,5000,7000,367.2),(5,'spider','2019-07-04 15:00:00',12,1800,12000,14400,367.2),(6,'spider','2019-07-05 15:00:00',16,1200,2500,4000,284.4),(7,'spider','2019-07-06 15:00:00',1,3600,4200,7000,180);
/*!40000 ALTER TABLE `fitness_cardio` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-07-09 13:57:37
