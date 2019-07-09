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
-- Table structure for table `diet`
--

DROP TABLE IF EXISTS `diet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `diet` (
  `diet_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(30) NOT NULL,
  `diet_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `diet_type_id` int(11) NOT NULL,
  `diet_menu_id` int(11) NOT NULL,
  `diet_amount` int(11) NOT NULL,
  `sum_calorie` int(11) NOT NULL,
  PRIMARY KEY (`diet_id`),
  KEY `user_id` (`user_id`),
  KEY `diet_type_id` (`diet_type_id`),
  KEY `diet_menu_id` (`diet_menu_id`),
  CONSTRAINT `diet_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `diet_ibfk_2` FOREIGN KEY (`diet_type_id`) REFERENCES `diet_type` (`diet_type_id`),
  CONSTRAINT `diet_ibfk_3` FOREIGN KEY (`diet_menu_id`) REFERENCES `diet_menu` (`diet_menu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `diet`
--

LOCK TABLES `diet` WRITE;
/*!40000 ALTER TABLE `diet` DISABLE KEYS */;
INSERT INTO `diet` VALUES (1,'spider','2019-06-30 15:00:00',1,94,1,150),(2,'spider','2019-06-30 15:00:00',1,660,1,32),(3,'spider','2019-06-30 15:00:00',1,662,1,37),(4,'spider','2019-06-30 15:00:00',1,665,1,41),(5,'spider','2019-06-30 15:00:00',1,2889,1,61),(6,'spider','2019-06-30 15:00:00',2,2928,1,175),(7,'spider','2019-06-30 15:00:00',2,2711,1,38),(8,'spider','2019-06-30 15:00:00',2,1396,2,62),(9,'spider','2019-06-30 15:00:00',3,1586,2,938),(10,'spider','2019-06-30 15:00:00',3,2763,2,356),(11,'spider','2019-06-30 15:00:00',3,95,1,152),(12,'spider','2019-06-30 15:00:00',3,2908,1,37),(13,'spider','2019-06-30 15:00:00',4,2986,1,192),(14,'spider','2019-07-01 15:00:00',1,2935,1,161),(15,'spider','2019-07-01 15:00:00',1,2936,1,172),(16,'spider','2019-07-01 15:00:00',1,2715,1,46),(17,'spider','2019-07-01 15:00:00',2,2973,1,122),(18,'spider','2019-07-01 15:00:00',2,2010,1,266),(19,'spider','2019-07-01 15:00:00',3,94,1,150),(20,'spider','2019-07-01 15:00:00',3,652,1,38),(21,'spider','2019-07-01 15:00:00',3,747,1,118),(22,'spider','2019-07-01 15:00:00',3,1030,1,10),(23,'spider','2019-07-01 15:00:00',3,1376,1,53),(24,'spider','2019-07-01 15:00:00',3,2907,1,175),(25,'spider','2019-07-01 15:00:00',3,2756,2,92),(26,'spider','2019-07-01 15:00:00',4,2910,1,151),(27,'spider','2019-07-02 15:00:00',1,1333,1,84),(28,'spider','2019-07-02 15:00:00',1,2010,1,266),(29,'spider','2019-07-02 15:00:00',2,2901,1,156),(30,'spider','2019-07-02 15:00:00',2,2715,1,46),(31,'spider','2019-07-02 15:00:00',3,1652,1,387),(32,'spider','2019-07-02 15:00:00',3,2762,2,254),(33,'spider','2019-07-02 15:00:00',3,2756,2,92),(34,'spider','2019-07-02 15:00:00',3,655,1,25),(35,'spider','2019-07-02 15:00:00',3,2895,1,69),(36,'spider','2019-07-02 15:00:00',4,2915,1,189),(37,'spider','2019-07-03 15:00:00',1,2986,1,192),(38,'spider','2019-07-03 15:00:00',1,2936,1,172),(39,'spider','2019-07-03 15:00:00',1,2711,1,38),(40,'spider','2019-07-03 15:00:00',2,2990,1,32),(41,'spider','2019-07-03 15:00:00',2,2715,2,92),(42,'spider','2019-07-03 15:00:00',3,2947,1,67),(43,'spider','2019-07-03 15:00:00',3,2763,1,178),(44,'spider','2019-07-03 15:00:00',3,655,1,25),(45,'spider','2019-07-03 15:00:00',4,2887,1,161),(46,'spider','2019-07-03 15:00:00',4,2739,1,40),(47,'spider','2019-07-04 15:00:00',1,2941,1,218),(48,'spider','2019-07-04 15:00:00',1,2609,1,65),(49,'spider','2019-07-04 15:00:00',1,2715,1,46),(50,'spider','2019-07-04 15:00:00',2,2946,1,79),(51,'spider','2019-07-04 15:00:00',2,2715,1,46),(52,'spider','2019-07-04 15:00:00',3,94,1,150),(53,'spider','2019-07-04 15:00:00',3,651,1,88),(54,'spider','2019-07-04 15:00:00',3,652,1,38),(55,'spider','2019-07-04 15:00:00',3,1627,1,201),(56,'spider','2019-07-04 15:00:00',3,1834,1,143),(57,'spider','2019-07-04 15:00:00',3,2756,3,138),(58,'spider','2019-07-04 15:00:00',3,2908,1,37),(59,'spider','2019-07-04 15:00:00',4,1396,1,31),(60,'spider','2019-07-04 15:00:00',4,2745,1,38),(61,'spider','2019-07-05 15:00:00',1,2990,1,32),(62,'spider','2019-07-05 15:00:00',1,655,1,25),(63,'spider','2019-07-05 15:00:00',2,3005,1,229),(64,'spider','2019-07-05 15:00:00',2,2745,1,38),(65,'spider','2019-07-05 15:00:00',3,1586,2,938),(66,'spider','2019-07-05 15:00:00',3,667,1,30),(67,'spider','2019-07-05 15:00:00',3,2762,3,381),(68,'spider','2019-07-05 15:00:00',4,2914,1,101),(69,'spider','2019-07-05 15:00:00',4,2756,1,46),(70,'spider','2019-07-06 15:00:00',1,1844,1,149),(71,'spider','2019-07-06 15:00:00',1,2947,1,67),(72,'spider','2019-07-06 15:00:00',1,2711,1,38),(73,'spider','2019-07-06 15:00:00',2,3005,1,229),(74,'spider','2019-07-06 15:00:00',2,2745,1,38),(75,'spider','2019-07-06 15:00:00',3,92,1,415),(76,'spider','2019-07-06 15:00:00',3,666,1,49),(77,'spider','2019-07-06 15:00:00',3,748,1,113),(78,'spider','2019-07-06 15:00:00',3,1080,1,10),(79,'spider','2019-07-06 15:00:00',3,1396,1,31),(80,'spider','2019-07-06 15:00:00',3,1834,1,143),(81,'spider','2019-07-06 15:00:00',3,2756,2,92),(82,'spider','2019-07-06 15:00:00',4,3000,1,233),(83,'spider','2019-07-06 15:00:00',4,2745,1,38);
/*!40000 ALTER TABLE `diet` ENABLE KEYS */;
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
