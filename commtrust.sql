-- MySQL dump 10.16  Distrib 10.1.44-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: commtrust
-- ------------------------------------------------------
-- Server version	10.1.44-MariaDB-0+deb9u1

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
  `approved_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `approved_with` blob,
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
  `evidence` blob,
  `source` varchar(200) DEFAULT NULL,
  `proved_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `loa` varchar(10) DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`assertion_id`),
  KEY `assertions_FK` (`user_id`),
  KEY `assertions_FK_1` (`claim_id`),
  CONSTRAINT `assertions_FK` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `assertions_FK_1` FOREIGN KEY (`claim_id`) REFERENCES `claims` (`claim_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assertions`
--

LOCK TABLES `assertions` WRITE;
/*!40000 ALTER TABLE `assertions` DISABLE KEYS */;
INSERT INTO `assertions` VALUES (1,1,3,'{\"urn:mace:terena.org:attribute-def:schacDateOfBirth\":[\"197*\"],\"urn:mace:terena.org:attribute-def:schacGender\":[\"MAL*\"],\"urn:mace:dir:attribute-def:cn\":[\"GOM*\"],\"urn:mace:terena.org:attribute-def:schacPersonalUniqueID\":[\"302*\"],\"urn:mace:terena.org:attribute-def:schacPlaceOfBirth\":[\"BAR*\"],\"urn:mace:dir:attribute-def:sn\":[\"GOM*\"],\"urn:mace:dir:attribute-def:givenName\":[\"SER*\"]}','\"https://readid-idp.webapps.uco.es/saml/metadata\"','2020-06-23 11:26:13',NULL,NULL),(2,1,7,'{\"name\":[\"John Doe\"],\"shoesize\":[\"48\"]}','\"SELF\"','2020-06-23 13:49:00',NULL,NULL);
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
INSERT INTO `att2claims` VALUES (1,1),(2,7),(3,3),(4,9);
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
INSERT INTO `attestations` VALUES (1,'External Attributes'),(2,'Self Asserted'),(3,'ID document'),(4,'Token');
/*!40000 ALTER TABLE `attestations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audit_log`
--

DROP TABLE IF EXISTS `audit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `audit_log` (
  `timestamp` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `actor_id` int(10) unsigned NOT NULL,
  `subject_id` int(10) unsigned DEFAULT NULL,
  `assertion_id` int(10) unsigned DEFAULT NULL,
  `message` blob,
  KEY `audit_log_FK` (`actor_id`),
  KEY `audit_log_FK_1` (`subject_id`),
  KEY `audit_log_FK_2` (`assertion_id`),
  CONSTRAINT `audit_log_FK` FOREIGN KEY (`actor_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `audit_log_FK_1` FOREIGN KEY (`subject_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_log`
--

LOCK TABLES `audit_log` WRITE;
/*!40000 ALTER TABLE `audit_log` DISABLE KEYS */;
INSERT INTO `audit_log` VALUES ('2020-06-23 11:26:13.076',1,NULL,1,'User 1 completed evidence on assertion 1 from source \"https://readid-idp.webapps.uco.es/saml/metadata\"'),('2020-06-23 13:49:00.963',1,NULL,2,'User 1 completed evidence on assertion 2 from source \"SELF\"');
/*!40000 ALTER TABLE `audit_log` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `claim_types`
--

LOCK TABLES `claim_types` WRITE;
/*!40000 ALTER TABLE `claim_types` DISABLE KEYS */;
INSERT INTO `claim_types` VALUES (1,'saml','saml_handler'),(2,'cripl','cripl_handler'),(3,'oidc','oidc_handler'),(4,'self','self_handler'),(5,'totp','totp_handler');
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
  `config` blob,
  PRIMARY KEY (`claim_id`),
  KEY `attestations_FK` (`type_id`),
  CONSTRAINT `attestations_FK` FOREIGN KEY (`type_id`) REFERENCES `claim_types` (`type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `claims`
--

LOCK TABLES `claims` WRITE;
/*!40000 ALTER TABLE `claims` DISABLE KEYS */;
INSERT INTO `claims` VALUES (1,'Federated R&S ID',2,'{\n	\"sp\":\"claims-sp\",\n	\"idp\":\"https://idp3.incubator.geant.org/saml2/idp/metadata.php\",\n	\"card\":[\"uid\",\"displayName\",\"schacHomeOrganization\",\"givenName\"]\n}'),(2,'ORCID identifier',1,'{\n	\"sp\":\"claims-sp\",\n	\"idp\":\"https://idp3.incubator.geant.org/saml2/idp/metadata.php\",\n	\"card\":[\"uid\",\"mail\",\"schacHomeOrganization\",\"isMemberOf\"]\n}'),(3,'ReadID',2,'{ \"sp\": \"claims-sp\",\n  \"idp\":\"https://readid-idp.webapps.uco.es/saml/metadata\",\n  \"card\":[\"urn:mace:dir:attribute-def:cn\", \"urn:mace:terena.org:attribute-def:schacPersonalUniqueID\", \"urn:mace:terena.org:attribute-def:schacDateOfBirth\"]\n  }'),(6,'OIDC Test OP',3,'{\n	\"rp\":\"claims-rp\",\n	\"op\": {\n		\"client_id\": \"commtrust\",\n        \"token_endpoint\": \"http://op.commtrust.local/token\",\n        \"user_info_endpoint\": \"http://op.commtrust.local/userinfo\",\n        \"authorization_endpoint\": \"http://op.commtrust.local/auth\",\n        \"authentication_info\":{\n        	\"method\": \"client_secret_post\",\n        	\"params\": {\n        		\"client_secret\": \"commtrust_secret\"\n        	}\n        }\n	},\n	\"card\":[\"name\",\"mail\"]\n}'),(7,'DIY identifier',4,'{\n	\"inputs\": [\n		\"name\",\n		\"shoesize\"\n	],\n	\"card\": [\"name\", \"shoesize\"]\n}'),(8,'Personal',4,'{  \"inputs\": [   \"hobbies\",   \"color\"  ],  \"card\": [\"hobbies\", \"color\"] }'),(9,'TOTP',5,'{  \"card\": [\"secret\"] }');
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
  `last_seen` datetime DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `users_UN` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=2877 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'student1','Student One',NULL,'2020-06-23 13:41:00'),(2,'jweeler','Joseph Weeler',1,'2020-06-23 10:05:16'),(3,'student2','Student Two',NULL,'2020-06-11 08:34:04'),(4,'student3','Student Three',NULL,NULL);
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

-- Dump completed on 2020-06-23 13:49:20
