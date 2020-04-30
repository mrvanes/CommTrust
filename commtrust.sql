-- MySQL dump 10.17  Distrib 10.3.22-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: commtrust
-- ------------------------------------------------------
-- Server version       10.3.22-MariaDB-0+deb10u1

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
-- Table structure for table `attestation_types`
--

DROP TABLE IF EXISTS `attestation_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attestation_types` (
  `type_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `handler` varchar(100) NOT NULL,
  PRIMARY KEY (`type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attestation_types`
--

LOCK TABLES `attestation_types` WRITE;
/*!40000 ALTER TABLE `attestation_types` DISABLE KEYS */;
INSERT INTO `attestation_types` VALUES (1,'saml','saml_handler'),(2,'readid','readid_handler');
/*!40000 ALTER TABLE `attestation_types` ENABLE KEYS */;
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
  `type_id` int(10) unsigned NOT NULL,
  `config` blob DEFAULT NULL,
  PRIMARY KEY (`attestation_id`),
  KEY `attestations_FK` (`type_id`),
  CONSTRAINT `attestations_FK` FOREIGN KEY (`type_id`) REFERENCES `attestation_types` (`type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attestations`
--

LOCK TABLES `attestations` WRITE;
/*!40000 ALTER TABLE `attestations` DISABLE KEYS */;
INSERT INTO `attestations` VALUES (1,'Federated R&S ID',1,'{\n  \"sp\":\"attestation-sp\",\n    \"idp\":\"http://idp2.commtrust.local/simplesaml/saml2/idp/metadata.php\",\n    \"card\":[\"uid\",\"displayName\",\"schacHomeOrganization\",\"givenName\"]\n}'),(2,'ORCID identifier',1,'{\n       \"sp\":\"attestation-sp\",\n    \"idp\":\"http://idp2.commtrust.local/simplesaml/saml2/idp/metadata.php\",\n    \"card\":[\"uid\",\"mail\",\"schacHomeOrganization\",\"isMemberOf\"]\n}'),(3,'Passport',2,'{\"sp\":\"attestation-sp\",\"idp\":\"http://dummy/metadata.php\"}');
/*!40000 ALTER TABLE `attestations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proofs`
--

DROP TABLE IF EXISTS `proofs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `proofs` (
  `proof_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `attestation_id` int(10) unsigned NOT NULL,
  `proof` blob DEFAULT NULL,
  `proved_at` datetime DEFAULT NULL,
  `approved_by` int(10) unsigned DEFAULT NULL,
  `approved_at` datetime DEFAULT NULL,
  `source` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`proof_id`),
  UNIQUE KEY `proofs_UN` (`user_id`,`attestation_id`),
  KEY `proofs_FK_1` (`attestation_id`),
  KEY `proofs_FK_2` (`approved_by`),
  CONSTRAINT `proofs_FK` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `proofs_FK_1` FOREIGN KEY (`attestation_id`) REFERENCES `attestations` (`attestation_id`),
  CONSTRAINT `proofs_FK_2` FOREIGN KEY (`approved_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proofs`
--

LOCK TABLES `proofs` WRITE;
/*!40000 ALTER TABLE `proofs` DISABLE KEYS */;
INSERT INTO `proofs` VALUES (49,1,1,'{\"uid\":[\"jweeler\"],\"schacHomeOrganization\":[\"university-example.org\"],\"eduPersonPrincipalName\":[\"jweeler@university-example.edu\"],\"cn\":[\"Joseph Weeler\"],\"givenName\":[\"Joseph\"],\"sn\":[\"Weeler\"],\"displayName\":[\"Joseph Weeler\"],\"mail\":[\"Joseph+Weeler@university-example.org\"],\"eduPersonAffiliation\":[\"employee\",\"member\",\"staff\"],\"eduPersonScopedAffiliation\":[\"employee@huniversity-example.org\",\"staff@university-example.org\",\"member@university-example.org\"],\"isMemberOf\":[\"urn:collab:org:aarc-project.eu\"]}',NULL,NULL,'\"http://idp2.commtrust.local/simplesaml/saml2/idp/metadata.php\"','2020-04-29 13:56:02'),(50,1,2,'{\"uid\":[\"student2\"],\"schacHomeOrganization\":[\"diy.surfconext.nl\"],\"eduPersonPrincipalName\":[\"student2@diy.surfconext.nl\"],\"cn\":[\"Student Two\"],\"givenName\":[\"Student\"],\"sn\":[\"Two\"],\"displayName\":[\"Student Two\"],\"mail\":[\"s1869831907@example.org\"],\"eduPersonAffiliation\":[\"student\",\"member\"],\"eduPersonScopedAffiliation\":[\"member@diy.surfconext.nl\",\"student@diy.surfconext.nl\"],\"isMemberOf\":[\"urn:collab:org:aarc-project.eu\"]}',2,'2020-04-29 15:37:26','\"http://idp2.commtrust.local/simplesaml/saml2/idp/metadata.php\"','2020-04-29 14:31:01');
/*!40000 ALTER TABLE `proofs` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=1243 DEFAULT CHARSET=utf8mb4;
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

-- Dump completed on 2020-04-29 15:40:36
