CREATE DATABASE  IF NOT EXISTS `advertising` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `advertising`;
-- MySQL dump 10.13  Distrib 8.0.36, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: advertising
-- ------------------------------------------------------
-- Server version	8.4.3

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Schedule`
--

DROP TABLE IF EXISTS `Schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Schedule` (
  `id_schedule` int NOT NULL AUTO_INCREMENT,
  `Start_month` int DEFAULT NULL,
  `End_month` int DEFAULT NULL,
  `Billboard` int DEFAULT NULL,
  PRIMARY KEY (`id_schedule`),
  KEY `Billboard` (`Billboard`),
  CONSTRAINT `Schedule_ibfk_1` FOREIGN KEY (`Billboard`) REFERENCES `billboard` (`id_billboard`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Schedule`
--

LOCK TABLES `Schedule` WRITE;
/*!40000 ALTER TABLE `Schedule` DISABLE KEYS */;
INSERT INTO `Schedule` VALUES (1,11,12,1),(2,11,12,2),(3,12,1,3),(4,11,12,4),(5,12,1,5),(6,11,12,6),(7,12,1,7),(8,11,12,8),(9,12,1,9),(10,11,12,10),(11,12,1,11),(12,12,1,12),(13,11,1,13),(14,11,1,14),(15,12,1,15);
/*!40000 ALTER TABLE `Schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `billboard`
--

DROP TABLE IF EXISTS `billboard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `billboard` (
  `id_billboard` int NOT NULL AUTO_INCREMENT,
  `Price` int DEFAULT NULL,
  `Size` varchar(45) DEFAULT NULL,
  `Address` varchar(45) DEFAULT NULL,
  `Quality` varchar(45) DEFAULT NULL,
  `Owner` int DEFAULT NULL,
  PRIMARY KEY (`id_billboard`),
  KEY `Owner` (`Owner`),
  CONSTRAINT `billboard_ibfk_1` FOREIGN KEY (`Owner`) REFERENCES `owner` (`id_owner`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `billboard`
--

LOCK TABLES `billboard` WRITE;
/*!40000 ALTER TABLE `billboard` DISABLE KEYS */;
INSERT INTO `billboard` VALUES (1,5000,'3x6','ул. Ленина, 12','Хорошее',1),(2,6000,'3x6','пр. Мира, 20','Отличное',2),(3,4000,'3x6','ул. Гагарина, 7','Среднее',3),(4,7000,'6x3','ул. Пушкина, 15','Хорошее',4),(5,5500,'3x6','ул. Космонавтов, 10','Отличное',5),(6,4500,'3x6','ул. Кирова, 20','Среднее',6),(7,6500,'6x3','ул. Московская, 32','Хорошее',7),(8,5200,'3x6','ул. Советская, 6','Отличное',8),(9,3800,'3x6','ул. 8 марта, 18','Среднее',9),(10,7200,'6x3','ул. Первомайская, 4','Хорошее',10),(11,5800,'3x6','ул. Юбилейная, 22','Отличное',11),(12,4200,'3x6','ул. Спортивная, 9','Среднее',12),(13,6200,'6x3','ул. Школьная, 13','Хорошее',13),(14,4800,'3x6','ул. Парковая, 24','Отличное',14),(15,5100,'3x6','ул. Набережная, 11','Среднее',1);
/*!40000 ALTER TABLE `billboard` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `internal_user`
--

DROP TABLE IF EXISTS `internal_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `internal_user` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `user_login` varchar(45) DEFAULT NULL,
  `user_password` varchar(45) DEFAULT NULL,
  `group_name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  KEY `group_name` (`group_name`),
  CONSTRAINT `internal_user_ibfk_1` FOREIGN KEY (`group_name`) REFERENCES `user_group` (`group_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `internal_user`
--

LOCK TABLES `internal_user` WRITE;
/*!40000 ALTER TABLE `internal_user` DISABLE KEYS */;
INSERT INTO `internal_user` VALUES (1,'admin1','admin1','admin'),(2,'manager1','manager1','manager'),(3,'analyst1','analyst1','analyst');
/*!40000 ALTER TABLE `internal_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order`
--

DROP TABLE IF EXISTS `order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order` (
  `id_order` int NOT NULL AUTO_INCREMENT,
  `Date` date DEFAULT NULL,
  `FullCost` int DEFAULT NULL,
  `Rentor` int DEFAULT NULL,
  PRIMARY KEY (`id_order`),
  KEY `Rentor` (`Rentor`),
  CONSTRAINT `order_ibfk_1` FOREIGN KEY (`Rentor`) REFERENCES `rentor` (`id_rentor`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order`
--

LOCK TABLES `order` WRITE;
/*!40000 ALTER TABLE `order` DISABLE KEYS */;
INSERT INTO `order` VALUES (1,'2024-11-05',12000,1),(2,'2024-11-10',15000,2),(3,'2024-11-15',10000,3),(4,'2024-11-20',18000,4),(5,'2024-11-25',13000,5),(6,'2024-11-30',11000,6),(7,'2024-12-05',16000,7),(8,'2024-12-10',14000,8),(9,'2024-12-15',9000,9),(10,'2024-12-20',17000,10),(11,'2024-12-25',12500,11),(12,'2024-12-30',14500,12),(13,'2025-01-05',13500,13),(14,'2025-01-10',16500,1),(15,'2025-01-15',15500,2),(19,'2024-12-27',NULL,1);
/*!40000 ALTER TABLE `order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `owner`
--

DROP TABLE IF EXISTS `owner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `owner` (
  `id_owner` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(45) DEFAULT NULL,
  `Adress` varchar(45) DEFAULT NULL,
  `Birthday` date DEFAULT NULL,
  `PhoneNumber` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_owner`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `owner`
--

LOCK TABLES `owner` WRITE;
/*!40000 ALTER TABLE `owner` DISABLE KEYS */;
INSERT INTO `owner` VALUES (1,'Иванов Иван Иванович','ул. Зеленая, 15','1980-05-10','+79112223344'),(2,'Петрова Анна Сергеевна','ул. Сиреневая, 8','1975-12-25','+79223334455'),(3,'Сидоров Петр Алексеевич','ул. Красная, 22','1992-08-18','+79334445566'),(4,'Козлова Мария Ивановна','ул. Березовая, 3','1988-03-01','+79445556677'),(5,'Смирнов Алексей Петрович','ул. Солнечная, 11','1970-06-30','+79556667788'),(6,'Васильева Елена Андреевна','ул. Луговая, 4','1995-09-12','+79667778899'),(7,'Новиков Дмитрий Сергеевич','ул. Цветочная, 2','1985-02-28','+79778889900'),(8,'Морозова Ольга Викторовна','ул. Морская, 17','1982-11-05','+79889990011'),(9,'Кузнецов Сергей Николаевич','ул. Лесная, 9','1978-07-20','+79990001122'),(10,'Попова Екатерина Дмитриевна','ул. Осенняя, 13','1990-01-15','+79101112233'),(11,'Соколов Андрей Владимирович','ул. Зимняя, 5','1987-04-02','+79202223344'),(12,'Михайлова Наталья Юрьевна','ул. Весенняя, 10','1973-10-28','+79303334455'),(13,'Лебедев Роман Михайлович','ул. Летняя, 7','1998-06-08','+79404445566'),(14,'Федорова Светлана Ивановна','ул. Радужная, 19','1979-03-16','+79505556677');
/*!40000 ALTER TABLE `owner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rentor`
--

DROP TABLE IF EXISTS `rentor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rentor` (
  `id_rentor` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(45) DEFAULT NULL,
  `PhoneNumber` varchar(45) DEFAULT NULL,
  `Adress` varchar(45) DEFAULT NULL,
  `BusArea` varchar(45) DEFAULT NULL,
  `user_login` varchar(45) DEFAULT NULL,
  `user_password` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_rentor`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rentor`
--

LOCK TABLES `rentor` WRITE;
/*!40000 ALTER TABLE `rentor` DISABLE KEYS */;
INSERT INTO `rentor` VALUES (1,'ООО \"Ромашка\"','+79123456789','ул. Ленина, 10','Реклама','1','1'),(2,'ИП Иванов А.И.','+79234567890','пр. Мира, 25','Торговля',NULL,NULL),(3,'ООО \"Солнышко\"','+79345678901','ул. Гагарина, 5','Услуги',NULL,NULL),(4,'ИП Петров В.В.','+79456789012','ул. Пушкина, 12','Медицина',NULL,NULL),(5,'ООО \"Звезда\"','+79567890123','ул. Космонавтов, 8','Развлечения',NULL,NULL),(6,'ИП Сидоров С.С.','+79678901234','ул. Кирова, 18','Образование',NULL,NULL),(7,'ООО \"Радуга\"','+79789012345','ул. Московская, 30','Строительство',NULL,NULL),(8,'ИП Козлов Д.А.','+79890123456','ул. Советская, 4','Продукты',NULL,NULL),(9,'ООО \"Весна\"','+79901234567','ул. 8 марта, 15','Транспорт',NULL,NULL),(10,'ИП Новиков И.И.','+79112233445','ул. Первомайская, 2','Одежда',NULL,NULL),(11,'ООО \"Лето\"','+79223344556','ул. Юбилейная, 20','Мебель',NULL,NULL),(12,'ИП Смирнов А.В.','+79334455667','ул. Спортивная, 7','Туризм',NULL,NULL),(13,'ООО \"Осень\"','+79445566778','ул. Школьная, 11','Книги',NULL,NULL),(14,'ИП Васильев П.П.','+79556677889','ул. Парковая, 22','Электроника',NULL,NULL);
/*!40000 ALTER TABLE `rentor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `report1`
--

DROP TABLE IF EXISTS `report1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `report1` (
  `report_year` int DEFAULT NULL,
  `report_month` int DEFAULT NULL,
  `id_rentor` int DEFAULT NULL,
  `Name` varchar(45) DEFAULT NULL,
  `PhoneNumber` varchar(45) DEFAULT NULL,
  `Adress` varchar(45) DEFAULT NULL,
  `BusArea` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `report1`
--

LOCK TABLES `report1` WRITE;
/*!40000 ALTER TABLE `report1` DISABLE KEYS */;
INSERT INTO `report1` VALUES (1,1,1,'ООО \"Ромашка\"','+79123456789','ул. Ленина, 10','Реклама'),(1,1,2,'ИП Иванов А.И.','+79234567890','пр. Мира, 25','Торговля'),(1,1,3,'ООО \"Солнышко\"','+79345678901','ул. Гагарина, 5','Услуги'),(1,1,4,'ИП Петров В.В.','+79456789012','ул. Пушкина, 12','Медицина'),(1,1,5,'ООО \"Звезда\"','+79567890123','ул. Космонавтов, 8','Развлечения'),(1,1,6,'ИП Сидоров С.С.','+79678901234','ул. Кирова, 18','Образование'),(1,1,7,'ООО \"Радуга\"','+79789012345','ул. Московская, 30','Строительство'),(1,1,8,'ИП Козлов Д.А.','+79890123456','ул. Советская, 4','Продукты'),(1,1,9,'ООО \"Весна\"','+79901234567','ул. 8 марта, 15','Транспорт'),(1,1,10,'ИП Новиков И.И.','+79112233445','ул. Первомайская, 2','Одежда'),(1,1,11,'ООО \"Лето\"','+79223344556','ул. Юбилейная, 20','Мебель'),(1,1,12,'ИП Смирнов А.В.','+79334455667','ул. Спортивная, 7','Туризм'),(1,1,13,'ООО \"Осень\"','+79445566778','ул. Школьная, 11','Книги'),(1,1,14,'ИП Васильев П.П.','+79556677889','ул. Парковая, 22','Электроника');
/*!40000 ALTER TABLE `report1` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `string`
--

DROP TABLE IF EXISTS `string`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `string` (
  `id_string` int NOT NULL AUTO_INCREMENT,
  `Date_start` date DEFAULT NULL,
  `Date_end` date DEFAULT NULL,
  `Cost` int DEFAULT NULL,
  `Billboard` int DEFAULT NULL,
  `Order` int DEFAULT NULL,
  PRIMARY KEY (`id_string`),
  KEY `Billboard` (`Billboard`),
  KEY `Order` (`Order`),
  CONSTRAINT `string_ibfk_1` FOREIGN KEY (`Billboard`) REFERENCES `billboard` (`id_billboard`),
  CONSTRAINT `string_ibfk_2` FOREIGN KEY (`Order`) REFERENCES `order` (`id_order`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `string`
--

LOCK TABLES `string` WRITE;
/*!40000 ALTER TABLE `string` DISABLE KEYS */;
INSERT INTO `string` VALUES (1,'2024-11-01','2024-11-30',4000,1,1),(2,'2024-11-05','2024-12-05',5000,2,2),(3,'2024-12-01','2024-12-31',3500,3,3),(4,'2024-11-10','2024-12-10',6000,4,4),(5,'2024-12-05','2025-01-05',4500,5,5),(6,'2024-11-15','2024-12-15',3800,6,6),(7,'2024-12-10','2025-01-10',5500,7,7),(8,'2024-11-20','2024-12-20',4200,8,8),(9,'2024-12-15','2025-01-15',3000,9,9),(10,'2024-11-25','2024-12-25',5200,10,10),(11,'2024-12-20','2025-01-20',4800,11,11),(12,'2024-12-25','2025-01-25',5800,12,12),(13,'2024-11-30','2025-01-31',4000,13,13),(14,'2024-12-31','2025-01-31',6200,14,14),(15,'2025-01-05','2025-01-31',4900,15,15),(16,'2025-01-01','2025-01-15',70000,1,19),(17,'2025-01-01','2025-01-15',84000,2,19),(18,'2025-01-01','2025-01-15',56000,3,19),(19,'2025-01-01','2025-01-15',98000,4,19),(20,'2025-01-01','2025-01-15',77000,5,19),(21,'2025-01-01','2025-01-15',63000,6,19),(22,'2025-01-01','2025-01-15',91000,7,19),(23,'2025-01-01','2025-01-15',72800,8,19),(24,'2025-01-01','2025-01-15',100800,10,19),(25,'2025-01-01','2025-01-15',71400,15,19);
/*!40000 ALTER TABLE `string` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_group`
--

DROP TABLE IF EXISTS `user_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_group` (
  `group_name` varchar(45) NOT NULL,
  PRIMARY KEY (`group_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_group`
--

LOCK TABLES `user_group` WRITE;
/*!40000 ALTER TABLE `user_group` DISABLE KEYS */;
INSERT INTO `user_group` VALUES ('admin'),('analyst'),('manager');
/*!40000 ALTER TABLE `user_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'advertising'
--

--
-- Dumping routines for database 'advertising'
--
/*!50003 DROP PROCEDURE IF EXISTS `report1_creator` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `report1_creator`(in yearr int, in monthh int)
begin
  declare amount_of_reports int;
  declare amount_of_records int;

  select count(*) into amount_of_reports
    from report1
    where report_year = yearr and report_month = monthh;

  select count(*) into amount_of_records
	FROM
    rentor r
	WHERE
		NOT EXISTS (
			SELECT 1
			FROM `order` o
			WHERE r.id_rentor = o.Rentor
			AND year(o.Date) = yearr AND month(o.Date) = monthh
		);

  if amount_of_reports > 0 then
    select 'report already exists' as message;

  elseif amount_of_records = 0 then
    select 'nothing to create a report from' as message;

  else
	insert into report1
    SELECT
		yearr,
        monthh,
        r.id_rentor,
		r.Name,
		r.PhoneNumber,
		r.Adress,
		r.BusArea
    FROM
		rentor r
	WHERE
		NOT EXISTS (
			SELECT 1
			FROM `order` o
			WHERE r.id_rentor = o.Rentor
			AND year(o.Date) = yearr AND month(o.Date) = monthh
		);

	select 'report successfully created' as message;

  end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-27 20:11:43
