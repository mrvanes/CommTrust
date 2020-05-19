-- MySQL dump 10.17  Distrib 10.3.22-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: commtrust
-- ------------------------------------------------------
-- Server version	10.3.22-MariaDB-0+deb10u1

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
-- Table structure for table `approvals`
--

DROP TABLE IF EXISTS `approvals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `approvals` (
  `assertion_id` int(10) unsigned NOT NULL,
  `approved_by` int(10) unsigned NOT NULL,
  `approved_at` datetime NOT NULL DEFAULT current_timestamp(),
  `approved_with` blob DEFAULT NULL,
  KEY `approvals_FK_1` (`approved_by`),
  KEY `approvals_FK` (`assertion_id`),
  CONSTRAINT `approvals_FK` FOREIGN KEY (`assertion_id`) REFERENCES `assertions` (`assertion_id`) ON DELETE CASCADE,
  CONSTRAINT `approvals_FK_1` FOREIGN KEY (`approved_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `approvals`
--

LOCK TABLES `approvals` WRITE;
/*!40000 ALTER TABLE `approvals` DISABLE KEYS */;
INSERT INTO `approvals` VALUES (124,2,'2020-05-18 15:19:15','[]');
/*!40000 ALTER TABLE `approvals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assertions`
--

DROP TABLE IF EXISTS `assertions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assertions` (
  `assertion_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `claim_id` int(10) unsigned NOT NULL,
  `evidence` blob DEFAULT NULL,
  `source` varchar(200) DEFAULT NULL,
  `proved_at` datetime DEFAULT current_timestamp(),
  `loa` varchar(10) DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`assertion_id`),
  KEY `assertions_FK` (`user_id`),
  KEY `assertions_FK_1` (`claim_id`),
  CONSTRAINT `assertions_FK` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `assertions_FK_1` FOREIGN KEY (`claim_id`) REFERENCES `claims` (`claim_id`)
) ENGINE=InnoDB AUTO_INCREMENT=126 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assertions`
--

LOCK TABLES `assertions` WRITE;
/*!40000 ALTER TABLE `assertions` DISABLE KEYS */;
INSERT INTO `assertions` VALUES (124,1,7,'{\"name\":[\"Martin\"],\"shoesize\":[\"41\"]}','\"SELF\"','2020-05-18 15:19:10',NULL,NULL),(125,1,7,'{\"name\":[\"Martin\"],\"shoesize\":[\"42\"]}','\"SELF\"','2020-05-18 15:19:25',NULL,NULL);
/*!40000 ALTER TABLE `assertions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `att2claims`
--

DROP TABLE IF EXISTS `att2claims`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `att2claims` (
  `attestation_id` int(10) unsigned NOT NULL,
  `claim_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`attestation_id`,`claim_id`),
  KEY `att2ass_FK` (`claim_id`),
  CONSTRAINT `att2ass_FK` FOREIGN KEY (`claim_id`) REFERENCES `claims` (`claim_id`),
  CONSTRAINT `att2ass_FK_1` FOREIGN KEY (`attestation_id`) REFERENCES `attestations` (`attestation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `att2claims`
--

LOCK TABLES `att2claims` WRITE;
/*!40000 ALTER TABLE `att2claims` DISABLE KEYS */;
INSERT INTO `att2claims` VALUES (1,1),(1,2),(1,6),(2,7),(3,3),(4,1),(4,8);
/*!40000 ALTER TABLE `att2claims` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attestations`
--

DROP TABLE IF EXISTS `attestations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attestations` (
  `attestation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`attestation_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attestations`
--

LOCK TABLES `attestations` WRITE;
/*!40000 ALTER TABLE `attestations` DISABLE KEYS */;
INSERT INTO `attestations` VALUES (1,'External Attributes'),(2,'DIY Attributes'),(3,'Liveness'),(4,'Gold Award');
/*!40000 ALTER TABLE `attestations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `claim_types`
--

DROP TABLE IF EXISTS `claim_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `claim_types` (
  `type_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `handler` varchar(100) NOT NULL,
  PRIMARY KEY (`type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `claim_types`
--

LOCK TABLES `claim_types` WRITE;
/*!40000 ALTER TABLE `claim_types` DISABLE KEYS */;
INSERT INTO `claim_types` VALUES (1,'saml','saml_handler'),(2,'readid','readid_handler'),(3,'oidc','oidc_handler'),(4,'self','self_handler');
/*!40000 ALTER TABLE `claim_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `claims`
--

DROP TABLE IF EXISTS `claims`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `claims` (
  `claim_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `type_id` int(10) unsigned NOT NULL,
  `config` blob DEFAULT NULL,
  PRIMARY KEY (`claim_id`),
  KEY `attestations_FK` (`type_id`),
  CONSTRAINT `attestations_FK` FOREIGN KEY (`type_id`) REFERENCES `claim_types` (`type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `claims`
--

LOCK TABLES `claims` WRITE;
/*!40000 ALTER TABLE `claims` DISABLE KEYS */;
INSERT INTO `claims` VALUES (1,'Federated R&S ID',1,'{\n	\"sp\":\"attestation-sp\",\n	\"idp\":\"http://idp2.commtrust.local/simplesaml/saml2/idp/metadata.php\",\n	\"card\":[\"uid\",\"displayName\",\"schacHomeOrganization\",\"givenName\"]\n}'),(2,'ORCID identifier',1,'{\n	\"sp\":\"attestation-sp\",\n	\"idp\":\"http://idp2.commtrust.local/simplesaml/saml2/idp/metadata.php\",\n	\"card\":[\"uid\",\"mail\",\"schacHomeOrganization\",\"isMemberOf\"]\n}'),(3,'Passport',2,'{\"sp\":\"attestation-sp\",\"idp\":\"http://dummy/metadata.php\"}'),(6,'OIDC Test OP',3,'{\n	\"rp\":\"attestation-rp\",\n	\"op\": {\n		\"client_id\": \"commtrust\",\n        \"token_endpoint\": \"http://op.commtrust.local/token\",\n        \"user_info_endpoint\": \"http://op.commtrust.local/userinfo\",\n        \"authorization_endpoint\": \"http://op.commtrust.local/auth\",\n        \"authentication_info\":{\n        	\"method\": \"client_secret_post\",\n        	\"params\": {\n        		\"client_secret\": \"commtrust_secret\"\n        	}\n        }\n	},\n	\"card\":[\"name\",\"mail\"]\n}'),(7,'DIY identifier',4,'{\n	\"inputs\": [\n		\"name\",\n		\"shoesize\"\n	],\n	\"card\": [\"name\", \"shoesize\"]\n}'),(8,'Personal',4,'{  \"inputs\": [   \"hobbies\",   \"color\"  ],  \"card\": [\"hobbies\", \"color\"] }');
/*!40000 ALTER TABLE `claims` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `user_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` varchar(100) NOT NULL,
  `display_name` varchar(100) DEFAULT NULL,
  `ra` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `users_UN` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=2511 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'student1','Student One',NULL),(2,'jweeler','Joseph Weeler',1),(3,'student2','Student Two',NULL),(4,'student3','Student Three',NULL),(1030,'oburton','Oscar Burton',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-05-19  6:46:32
