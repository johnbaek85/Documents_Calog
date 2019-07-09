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
-- Table structure for table `fitness_menu`
--

DROP TABLE IF EXISTS `fitness_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fitness_menu` (
  `fitness_menu_id` int(11) NOT NULL AUTO_INCREMENT,
  `fitness_menu_name` varchar(50) NOT NULL,
  `fitness_menu_image` varchar(200) NOT NULL,
  `unit_calorie` double NOT NULL,
  `fitness_type_id` int(11) NOT NULL,
  PRIMARY KEY (`fitness_menu_id`),
  KEY `fitness_type_id` (`fitness_type_id`),
  CONSTRAINT `fitness_menu_ibfk_1` FOREIGN KEY (`fitness_type_id`) REFERENCES `fitness_type` (`fitness_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fitness_menu`
--

LOCK TABLES `fitness_menu` WRITE;
/*!40000 ALTER TABLE `fitness_menu` DISABLE KEYS */;
INSERT INTO `fitness_menu` VALUES (1,'걷기-4.2km/h','https://www.jefit.com/images/exercises/800_600/1288.jpg',0.05,1),(2,'빠른걷기-6km/h','https://www.jefit.com/images/exercises/800_600/1288.jpg',0.06,1),(3,'등산','http://health.chosun.com/site/data/img_dir/2019/03/29/2019032901549_0.jpg',0.083,1),(4,'달리기(조깅)-8km/h','https://www.jefit.com/images/exercises/800_600/1268.jpg',0.163,1),(5,'달리기-10km/h','https://www.jefit.com/images/exercises/800_600/1268.jpg',0.204,1),(6,'달리기-11km/h','https://www.jefit.com/images/exercises/800_600/1268.jpg',0.245,1),(7,'달리기-13km/h','https://www.jefit.com/images/exercises/800_600/1268.jpg',0.276,1),(8,'달리기-14km/h','https://www.jefit.com/images/exercises/800_600/1268.jpg',0.306,1),(9,'달리기-16km/h','https://www.jefit.com/images/exercises/800_600/1268.jpg',0.327,1),(10,'자전거(싸이클)','https://www.jefit.com/images/exercises/800_600/1260.jpg',0.163,1),(11,'자전거(중간속도)-21km/h','https://www.jefit.com/images/exercises/800_600/1260.jpg',0.163,1),(12,'자전거(빠른속도)-24km/h','https://www.jefit.com/images/exercises/800_600/1260.jpg',0.204,1),(13,'자전거(매우빠른속도)-28km/h','https://www.jefit.com/images/exercises/800_600/1260.jpg',0.245,1),(14,'산악자전거','https://www.jefit.com/images/exercises/800_600/1252.jpg',0.163,1),(15,'계단오르기','https://www.jefit.com/images/exercises/800_600/1276.jpg',0.163,1),(16,'계단 뛰어오르기','http://hub.zum.com/view/photo?url=http%3A%2F%2Fstatic.hubzum.zumst.com%2Fhubzum%2F2017%2F10%2F25%2F14%2F188bb592e79740d780dce38daaa585c6.jpg',0.237,1),(17,'인라인스케이팅','https://www.jefit.com/images/exercises/800_600/3752.jpg',0.204,1),(18,'줄넘기','https://www.jefit.com/images/exercises/800_600/3708.jpg',0.204,1),(19,'가슴, 1 Leg Pushup','https://www.jefit.com/images/exercises/800_600/4213.jpg',0.16,2),(20,'가슴, Clap Push Up','https://www.jefit.com/images/exercises/800_600/2909.jpg',0.16,2),(21,'가슴, Close Hand Pushup','https://www.jefit.com/images/exercises/800_600/3441.jpg',0.1,2),(22,'가슴, Push Up','https://www.jefit.com/images/exercises/800_600/189.jpg',0.095,2),(23,'가슴, Push Up to Side Plank','https://www.jefit.com/images/exercises/800_600/3433.jpg',0.1,2),(24,'가슴, Wide Hand Pushup','https://www.jefit.com/images/exercises/800_600/3445.jpg',0.095,2),(25,'등, Hyperextensions With No Bench','https://www.jefit.com/images/exercises/800_600/1417.jpg',0.052,2),(26,'등, Spine Twist','https://www.jefit.com/images/exercises/800_600/2725.jpg',0.052,2),(27,'복근, Ab Draw Leg Slide','https://www.jefit.com/images/exercises/800_600/2681.jpg',0.15,2),(28,'복근, Abdominal Pendulum','https://www.jefit.com/images/exercises/800_600/3869.jpg',0.15,2),(29,'복근, Air Bike','https://www.jefit.com/images/exercises/800_600/228.jpg',0.15,2),(30,'복근, Alternate Heel Touchers','https://www.jefit.com/images/exercises/800_600/232.jpg',0.15,2),(31,'복근, Alternate Leg Bridge','https://www.jefit.com/images/exercises/800_600/2440.jpg',0.15,2),(32,'복근, Alternate Reach and Catch','https://www.jefit.com/images/exercises/800_600/3872.jpg',0.15,2),(33,'복근, Alternating Arm Cobra','https://www.jefit.com/images/exercises/800_600/2504.jpg',0.15,2),(34,'복근, Bent Knee Hip Raise','https://www.jefit.com/images/exercises/800_600/1225.jpg',0.15,2),(35,'복근, Bent Knee Hundreds','https://www.jefit.com/images/exercises/800_600/2569.jpg',0.15,2),(36,'복근, Butt-Ups','https://www.jefit.com/images/exercises/800_600/1309.jpg',0.15,2),(37,'복근, Cobra','https://www.jefit.com/images/exercises/800_600/2501.jpg',0.15,2),(38,'복근, Cross Body Crunch','https://www.jefit.com/images/exercises/800_600/281.jpg',0.15,2),(39,'복근, Crunch with Hands Overhead','https://www.jefit.com/images/exercises/800_600/1313.jpg',0.15,2),(40,'복근, Crunches','https://www.jefit.com/images/exercises/800_600/309.jpg',0.15,2),(41,'복근, Double Leg Hundreds','https://www.jefit.com/images/exercises/800_600/2565.jpg',0.15,2),(42,'복근, Frog Sit Ups','https://www.jefit.com/images/exercises/800_600/277.jpg',0.15,2),(43,'복근, Jackknife Sit up','https://www.jefit.com/images/exercises/800_600/253.jpg',0.15,2),(44,'복근, Janda Sit Up','https://www.jefit.com/images/exercises/800_600/1325.jpg',0.15,2),(45,'복근, Leg Raise','https://www.jefit.com/images/exercises/800_600/177.jpg',0.15,2),(46,'복근, Lying Alternate Floor Leg Raise','https://www.jefit.com/images/exercises/800_600/3933.jpg',0.15,2),(47,'복근, Lying Floor Knee Raise','https://www.jefit.com/images/exercises/800_600/3945.jpg',0.15,2),(48,'복근, Lying to Side Plank','https://www.jefit.com/images/exercises/800_600/2533.jpg',0.15,2),(49,'복근, Plank','https://www.jefit.com/images/exercises/800_600/2524.jpg',0.06,2),(50,'복근, Plank with Side Kick','https://www.jefit.com/images/exercises/800_600/2513.jpg',0.06,2),(51,'복근, Sit Up','https://www.jefit.com/images/exercises/800_600/1381.jpg',0.15,2),(52,'복근, Tuck Crunch','https://www.jefit.com/images/exercises/800_600/285.jpg',0.15,2),(53,'복근, Twisting Floor Crunch','https://www.jefit.com/images/exercises/800_600/4001.jpg',0.15,2),(54,'복근, Two Leg Slide','https://www.jefit.com/images/exercises/800_600/2353.jpg',0.15,2),(55,'복근, V Ups','https://www.jefit.com/images/exercises/800_600/2745.jpg',0.06,2),(56,'팔뚝, Modified Push Up to Forearms','https://www.jefit.com/images/exercises/800_600/2509.jpg',0.17,2),(57,'둔근, Bridge','https://www.jefit.com/images/exercises/800_600/777.jpg',0.06,2),(58,'둔근, Flutter Kick','https://www.jefit.com/images/exercises/800_600/793.jpg',0.15,2),(59,'둔근, Glute Kickback','https://www.jefit.com/images/exercises/800_600/1549.jpg',0.15,2),(60,'둔근, Leg Lift','https://www.jefit.com/images/exercises/800_600/781.jpg',0.15,2),(61,'둔근, One Leg Kickback','https://www.jefit.com/images/exercises/800_600/785.jpg',0.15,2),(62,'둔근, Single Leg Glute Bridge','https://www.jefit.com/images/exercises/800_600/3461.jpg',0.06,2),(63,'둔근, Standing Adductor','https://www.jefit.com/images/exercises/800_600/2984.jpg',0.1,2),(64,'둔근, Standing Glute Kickback','https://www.jefit.com/images/exercises/800_600/4405.jpg',0.15,2),(65,'둔근, Straight Leg Outer Hip Abductor','https://www.jefit.com/images/exercises/800_600/2989.jpg',0.15,2),(66,'어깨, Handstand Pushups','https://www.jefit.com/images/exercises/800_600/3501.jpg',0.25,2),(67,'삼두근, Close Triceps Pushup','https://www.jefit.com/images/exercises/800_600/961.jpg',0.15,2),(68,'허벅지, Bodyweight Lunge','https://www.jefit.com/images/exercises/800_600/4861.jpg',0.1,2),(69,'허벅지, Bodyweight Side Lunge','https://www.jefit.com/images/exercises/800_600/4881.jpg',0.1,2),(70,'허벅지, Bodyweight Walking Lunge','https://www.jefit.com/images/exercises/800_600/4889.jpg',0.1,2),(71,'허벅지, Bodyweight Wall Squat','https://www.jefit.com/images/exercises/800_600/4837.jpg',0.15,2),(72,'허벅지, Freehand Jump Squat','https://www.jefit.com/images/exercises/800_600/1905.jpg',0.22,2),(73,'허벅지, One Leg Bodyweight Squat','https://www.jefit.com/images/exercises/800_600/4825.jpg',0.22,2),(74,'허벅지, Prisoner Squat','https://www.jefit.com/images/exercises/800_600/3001.jpg',0.15,2),(75,'허벅지, Rear Bodyweight Lunge','https://www.jefit.com/images/exercises/800_600/4877.jpg',0.1,2),(76,'허벅지, Rocket Jump','https://www.jefit.com/images/exercises/800_600/3697.jpg',0.22,2),(77,'허벅지, Sit Squat','https://www.jefit.com/images/exercises/800_600/1973.jpg',0.15,2),(78,'허벅지, Star Jump','https://www.jefit.com/images/exercises/800_600/3813.jpg',0.131,2),(79,'종아리, Bodyweight Standing Calf Raise','https://www.jefit.com/images/exercises/800_600/4909.jpg',0.094,2),(80,'종아리, One Leg Floor Calf Raise','https://www.jefit.com/images/exercises/800_600/4945.jpg',0.094,2),(81,'종아리, Standing One Leg Bodyweight Calf Raise','https://www.jefit.com/images/exercises/800_600/4945.jpg',0.094,2);
/*!40000 ALTER TABLE `fitness_menu` ENABLE KEYS */;
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
