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
-- Table structure for table `fitness_weight`
--

DROP TABLE IF EXISTS `fitness_weight`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fitness_weight` (
  `fitness_weight_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(30) NOT NULL,
  `fitness_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fitness_menu_id` int(11) NOT NULL,
  `fitness_seconds` int(11) NOT NULL,
  `used_calorie` double NOT NULL,
  PRIMARY KEY (`fitness_weight_id`),
  KEY `user_id` (`user_id`),
  KEY `fitness_menu_id` (`fitness_menu_id`),
  CONSTRAINT `fitness_weight_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `fitness_weight_ibfk_2` FOREIGN KEY (`fitness_menu_id`) REFERENCES `fitness_menu` (`fitness_menu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fitness_weight`
--

LOCK TABLES `fitness_weight` WRITE;
/*!40000 ALTER TABLE `fitness_weight` DISABLE KEYS */;
INSERT INTO `fitness_weight` VALUES (1,'spider','2019-06-30 15:00:00',19,600,96),(2,'spider','2019-06-30 15:00:00',20,600,90),(3,'spider','2019-06-30 15:00:00',22,600,90),(4,'spider','2019-06-30 15:00:00',38,300,51),(5,'spider','2019-06-30 15:00:00',43,600,90),(6,'spider','2019-06-30 15:00:00',48,300,75),(7,'spider','2019-06-30 15:00:00',58,600,132),(8,'spider','2019-06-30 15:00:00',62,600,56.4),(9,'spider','2019-07-01 15:00:00',21,600,96),(10,'spider','2019-07-01 15:00:00',31,600,90),(11,'spider','2019-07-01 15:00:00',27,600,90),(12,'spider','2019-07-01 15:00:00',38,600,102),(13,'spider','2019-07-01 15:00:00',42,600,90),(14,'spider','2019-07-01 15:00:00',48,300,75),(15,'spider','2019-07-01 15:00:00',50,600,60),(16,'spider','2019-07-01 15:00:00',61,600,56.4),(17,'spider','2019-07-02 15:00:00',32,600,96),(18,'spider','2019-07-02 15:00:00',35,600,31.2),(19,'spider','2019-07-02 15:00:00',31,300,18),(20,'spider','2019-07-02 15:00:00',38,600,102),(21,'spider','2019-07-02 15:00:00',39,600,36),(22,'spider','2019-07-02 15:00:00',48,300,75),(23,'spider','2019-07-02 15:00:00',50,600,60),(24,'spider','2019-07-02 15:00:00',63,600,56.4),(25,'spider','2019-07-03 15:00:00',41,600,96),(26,'spider','2019-07-03 15:00:00',45,600,90),(27,'spider','2019-07-03 15:00:00',22,600,90),(28,'spider','2019-07-03 15:00:00',38,300,51),(29,'spider','2019-07-03 15:00:00',43,600,90),(30,'spider','2019-07-03 15:00:00',48,300,75),(31,'spider','2019-07-03 15:00:00',58,600,132),(32,'spider','2019-07-03 15:00:00',62,600,56.4),(33,'spider','2019-07-04 15:00:00',19,600,96),(34,'spider','2019-07-04 15:00:00',25,600,31.2),(35,'spider','2019-07-04 15:00:00',31,300,18),(36,'spider','2019-07-04 15:00:00',38,600,102),(37,'spider','2019-07-04 15:00:00',39,600,36),(38,'spider','2019-07-04 15:00:00',48,300,75),(39,'spider','2019-07-04 15:00:00',50,600,60),(40,'spider','2019-07-04 15:00:00',63,600,56.4),(41,'spider','2019-07-05 15:00:00',26,600,96),(42,'spider','2019-07-05 15:00:00',31,600,90),(43,'spider','2019-07-05 15:00:00',27,600,90),(44,'spider','2019-07-05 15:00:00',38,600,102),(45,'spider','2019-07-05 15:00:00',42,600,90),(46,'spider','2019-07-05 15:00:00',48,300,75),(47,'spider','2019-07-05 15:00:00',50,600,60),(48,'spider','2019-07-05 15:00:00',61,600,56.4),(49,'spider','2019-07-06 15:00:00',32,600,96),(50,'spider','2019-07-06 15:00:00',35,600,90),(51,'spider','2019-07-06 15:00:00',22,600,90),(52,'spider','2019-07-06 15:00:00',38,300,51),(53,'spider','2019-07-06 15:00:00',43,600,90),(54,'spider','2019-07-06 15:00:00',48,300,75),(55,'spider','2019-07-06 15:00:00',58,600,132),(56,'spider','2019-07-06 15:00:00',62,600,56.4);
/*!40000 ALTER TABLE `fitness_weight` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-07-09 13:57:36
