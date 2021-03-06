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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attestation_types`
--

LOCK TABLES `attestation_types` WRITE;
/*!40000 ALTER TABLE `attestation_types` DISABLE KEYS */;
INSERT INTO `attestation_types` VALUES (1,'saml','saml_handler'),(2,'readid','readid_handler'),(3,'oidc','oidc_handler'),(4,'self','self_handler');
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attestations`
--

LOCK TABLES `attestations` WRITE;
/*!40000 ALTER TABLE `attestations` DISABLE KEYS */;
INSERT INTO `attestations` VALUES (1,'Federated R&S ID',1,'{\n	\"sp\":\"attestation-sp\",\n	\"idp\":\"http://idp2.commtrust.local/simplesaml/saml2/idp/metadata.php\",\n	\"card\":[\"uid\",\"displayName\",\"schacHomeOrganization\",\"givenName\"]\n}'),(2,'ORCID identifier',1,'{\n	\"sp\":\"attestation-sp\",\n	\"idp\":\"http://idp2.commtrust.local/simplesaml/saml2/idp/metadata.php\",\n	\"card\":[\"uid\",\"mail\",\"schacHomeOrganization\",\"isMemberOf\"]\n}'),(3,'Passport',2,'{\"sp\":\"attestation-sp\",\"idp\":\"http://dummy/metadata.php\"}'),(6,'OIDC Test OP',3,'{\n	\"rp\":\"attestation-rp\",\n	\"op\": {\n		\"client_id\": \"commtrust\",\n        \"token_endpoint\": \"http://op.commtrust.local/token\",\n        \"user_info_endpoint\": \"http://op.commtrust.local/userinfo\",\n        \"authorization_endpoint\": \"http://op.commtrust.local/auth\",\n        \"authentication_info\":{\n        	\"method\": \"client_secret_post\",\n        	\"params\": {\n        		\"client_secret\": \"commtrust_secret\"\n        	}\n        }\n	},\n	\"card\":[\"name\",\"mail\"]\n}'),(7,'Self Asserted',4,'{\n	\"inputs\": [\n		\"name\",\n		\"shoesize\"\n	],\n	\"card\": [\"name\", \"shoesize\"]\n}');
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
  `approved_by` int(10) unsigned DEFAULT NULL,
  `approved_at` datetime DEFAULT NULL,
  `source` varchar(200) DEFAULT NULL,
  `proved_at` datetime DEFAULT NULL,
  `approved_with` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`proof_id`),
  UNIQUE KEY `proofs_UN` (`user_id`,`attestation_id`),
  KEY `proofs_FK_1` (`attestation_id`),
  KEY `proofs_FK_2` (`approved_by`),
  CONSTRAINT `proofs_FK` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `proofs_FK_1` FOREIGN KEY (`attestation_id`) REFERENCES `attestations` (`attestation_id`),
  CONSTRAINT `proofs_FK_2` FOREIGN KEY (`approved_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=96 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proofs`
--

LOCK TABLES `proofs` WRITE;
/*!40000 ALTER TABLE `proofs` DISABLE KEYS */;
INSERT INTO `proofs` VALUES (53,1,3,'{\"@odata.context\":\"https://ready.readid.com/odata/v1/ODataServlet/$metadata#Sessions/$entity\",\"app\":{\"appVersion\":\"3.6.4\",\"customerName\":\"ReadID Ready\",\"packageName\":\"com.readid.ready\",\"timestamp\":1584518365815},\"chip\":{\"chipRead\":true,\"chipTypes\":[\"IsoDep\",\"NfcB\"],\"timestamp\":1584518365811},\"clientId\":\"com.readid.ready\",\"consolidatedIdentityData\":{\"chipCloneDetection\":\"SUCCEEDED\",\"chipCloneDetectionSource\":\"CHIP\",\"chipCloneDetectionSourceName\":\"ReadID NFC\",\"chipVerification\":\"SUCCEEDED\",\"chipVerificationSource\":\"CHIP\",\"chipVerificationSourceName\":\"ReadID NFC\",\"creationDate\":\"2020-03-18T07:59:27.111Z\",\"dateOfBirth\":\"YYMMDD\",\"dateOfBirthSource\":\"CHIP\",\"dateOfBirthSourceName\":\"ReadID NFC\",\"dateOfExpiry\":\"YYMMDD\",\"dateOfExpirySource\":\"CHIP\",\"dateOfExpirySourceName\":\"ReadID NFC\",\"documentCode\":\"ID\",\"documentCodeSource\":\"CHIP\",\"documentCodeSourceName\":\"ReadID NFC\",\"documentNumber\":\"ABC000000\",\"documentNumberSource\":\"CHIP\",\"documentNumberSourceName\":\"ReadID NFC\",\"documentType\":\"I\",\"documentTypeSource\":\"CHIP\",\"documentTypeSourceName\":\"ReadID NFC\",\"gender\":\"MALE\",\"genderSource\":\"CHIP\",\"genderSourceName\":\"ReadID NFC\",\"issuingCountry\":\"ESP\",\"issuingCountrySource\":\"CHIP\",\"issuingCountrySourceName\":\"ReadID NFC\",\"nameOfHolder\":\"GOMEZ BACHILLER, SERGIO\",\"nameOfHolderSource\":\"CHIP\",\"nameOfHolderSourceName\":\"ReadID NFC\",\"nationality\":\"ESP\",\"nationalitySource\":\"CHIP\",\"nationalitySourceName\":\"ReadID NFC\",\"personalNumber\":\"00000000X\",\"personalNumberSource\":\"CHIP\",\"personalNumberSourceName\":\"ReadID NFC\",\"placeOfBirth\":null,\"placeOfBirthSource\":null,\"placeOfBirthSourceName\":null,\"primaryIdentifier\":\"GOMEZ BACHILLER\",\"primaryIdentifierSource\":\"CHIP\",\"primaryIdentifierSourceName\":\"ReadID NFC\",\"secondaryIdentifier\":\"SERGIO\",\"secondaryIdentifierSource\":\"CHIP\",\"secondaryIdentifierSourceName\":\"ReadID NFC\",\"selfieVerificationProfile\":null,\"selfieVerificationProfileSource\":null,\"selfieVerificationProfileSourceName\":null,\"selfieVerificationStatus\":null,\"selfieVerificationStatusSource\":null,\"selfieVerificationStatusSourceName\":null,\"sessionId\":\"1d4ab816-f8b0-466d-8403-77f7692f7142\",\"version\":1,\"visualVerification\":null,\"visualVerificationSource\":null,\"visualVerificationSourceName\":null},\"creationDate\":\"2020-03-18T07:59:27.111Z\",\"customerApplicationReference\":\"SUBMITTER-DEMO-SERGIO\",\"deviceId\":\"0000000000000000\",\"deviceInfo\":{\"brand\":\"Xiaomi\",\"extendedLengthApduSupported\":true,\"manufacturer\":\"Xiaomi\",\"maxTransceiveLength\":65279,\"model\":\"Mi 9T\",\"OSVersion\":\"10\",\"platform\":\"android\",\"timestamp\":1584518365815},\"documentContent\":{\"@odata.type\":\"#nl.innovalor.mrtd.model.ICAODocumentContent\",\"datagroupNumbers\":[1,2,3,7,11,13,14],\"dateOfBirth\":\"YYMMDD\",\"dateOfExpiry\":\"YYMMDD\",\"dateOfIssue\":null,\"documentNumber\":\"ABC000000\",\"faceImages\":[{\"colorSpace\":\"UNSPECIFIED\",\"height\":378,\"image\":\"https://ready.readid.com/odata/v1/Streams/1d4ab816-f8b0-466d-8403-77f7692f7142/faceImage/0\",\"mimeType\":\"image/jp2\",\"original\":\"https://ready.readid.com/odata/v1/Streams/1d4ab816-f8b0-466d-8403-77f7692f7142/faceImage/0/original\",\"originalImageBytes\":null,\"source\":\"UNSPECIFIED\",\"width\":307}],\"fullDateOfBirth\":\"YYYY-MM-DDT00:00:00Z\",\"interpretedDateOfBirth\":\"DD.MM.YYYY\",\"interpretedDateOfExpiry\":\"DD.MM.YYYY\",\"interpretedIssuingCountry\":\"Spain\",\"issuingAuthority\":null,\"issuingCountry\":\"ESP\",\"ldsVersion\":\"1.7\",\"nameOfHolder\":\"GOMEZ BACHILLER, SERGIO\",\"personalNumber\":\"00000000X\",\"primaryIdentifier\":\"GOMEZ BACHILLER\",\"secondaryIdentifier\":\"SERGIO\",\"signatureImages\":[{\"colorSpace\":null,\"height\":0,\"image\":\"https://ready.readid.com/odata/v1/Streams/1d4ab816-f8b0-466d-8403-77f7692f7142/signatureImage/0\",\"mimeType\":\"image/jpeg\",\"original\":\"https://ready.readid.com/odata/v1/Streams/1d4ab816-f8b0-466d-8403-77f7692f7142/signatureImage/0/original\",\"source\":null,\"width\":0}],\"custodian\":null,\"documentCode\":\"ID\",\"gender\":\"MALE\",\"interpretedNationality\":\"Spanish\",\"mrzPrimaryIdentifier\":\"GOMEZ BACHILLER\",\"mrzSecondaryIdentifier\":\"SERGIO\",\"MRZString\":\"****\",\"nationality\":\"ESP\",\"otherNames\":[],\"permanentAddress\":[\"Address\",\"City\",\"State/Province\"],\"placeOfBirth\":\"City, State\",\"placeOfBirthList\":[\"City\",\"State\"],\"profession\":null,\"telephone\":null,\"title\":null,\"unicodeVersion\":\"4.0.0\"},\"exceptions\":[],\"expiryDate\":\"YYYY-MM-DDT12:59:27.111Z\",\"instanceId\":\"651a06b0-1020-4f29-bd66-b13db272e79b\",\"iProovSession\":{\"attempts\":null,\"enrolmentPod\":null,\"enrolmentToken\":null,\"errorString\":null,\"finished\":null,\"hasError\":null,\"passed\":null,\"riskProfile\":null,\"verifyToken\":[]},\"lib\":{\"coreVersion\":\"1.33.0\",\"mobileCountryCode\":\"es\",\"mrtdConfiguration\":{\"AAEnabled\":true,\"allowedFids\":[],\"BACByDefaultEnabled\":true,\"clientServerBaseURL\":\"https://ready.readid.com/odata/v1/ODataServlet/\",\"clientServerHttpRetries\":5,\"clientServerHttpWaitPeriod\":30000,\"CSCAKeyStoreTypeName\":null,\"debugModeEnabled\":false,\"documentType\":\"ICAO_MRTD\",\"DSCSEnabled\":true,\"EACCAEnabled\":true,\"extendedLengthAPDUEnabled\":false,\"extendedLengthMaxBufferBlockSize\":64000,\"NFCForegroundDispatchMuteTime\":0,\"NFCMinimalIsoDepTimeout\":30000,\"NFCReaderModePresenceCheckDelay\":4200,\"PACEEnabled\":false,\"timestamp\":1584518353107},\"nfcVersion\":\"1.33.0\",\"ocrConfiguration\":{\"allowedSizes\":[\"3x30\",\"2x44\",\"2x36\"],\"defaultCorrectnessCriterionUsed\":true,\"diligence\":5,\"focusMode\":\"continuous-picture\",\"scaleMode\":\"ASPECT_FIT\",\"timestamp\":1584518352994},\"ocrVersion\":\"3.28.0\",\"timestamp\":1584518365819},\"mitekSession\":{\"url\":null},\"mrzOCR\":null,\"NFC\":null,\"nfcSession\":{\"accessControlStatus\":{\"BAC\":\"PRESENT_SUCCEEDED\",\"BACReason\":\"SUCCEEDED\",\"EACTA\":\"UNKNOWN\",\"EACTAReason\":\"UNKNOWN\",\"PACE\":\"PRESENT_NOT_PERFORMED\",\"PACEReason\":\"PRESENCE_DETECTED\"},\"data\":[],\"documentType\":\"ICAO_MRTD\",\"features\":[\"BAC\",\"PACE\",\"EAC\"],\"verificationStatus\":{\"AA\":\"NOT_PRESENT\",\"AAReason\":\"NOT_SUPPORTED\",\"AAResult\":null,\"CAResult\":{\"encryptedResponseBytes\":null,\"keyId\":null,\"oid\":\"0.4.0.127.0.7.2.2.3.2.1\",\"pcdPrivateKeyBytes\":null,\"pcdPublicKeyBytes\":null},\"CS\":\"PRESENT_SUCCEEDED\",\"CSReason\":\"FOUND_A_CHAIN_SUCCEEDED\",\"DS\":\"PRESENT_SUCCEEDED\",\"DSReason\":\"SIGNATURE_CHECKED\",\"EACCA\":\"PRESENT_SUCCEEDED\",\"EACCAReason\":\"SUCCEEDED\",\"HT\":\"PRESENT_SUCCEEDED\",\"HTReason\":\"ALL_HASHES_MATCH\"}},\"ocrSession\":{\"mrz\":\"****\",\"mrzImage\":{\"height\":170,\"mimeType\":\"image/png\",\"sha256Sum\":\"2gE+m/HkGTvc0wNDoYyEoqPu5KlAy1/rq47937sGsYw=\",\"width\":1117},\"mrzType\":\"TD1\"},\"opaqueId\":null,\"readySession\":{\"opaqueId\":\"40170d6f-d68e-4496-af9a-7ef4ee386d03\",\"readySessionId\":\"74ce5690-6b80-4486-8641-4129b1c314ac\"},\"serverVersion\":\"1.57.10\",\"sessionId\":\"1d4ab816-f8b0-466d-8403-77f7692f7142\",\"vizSession\":{\"backImage\":{\"height\":1280,\"mimeType\":\"image/jpeg\",\"sha256Sum\":\"tIxHaippZYzguXDme58kXdXdUbl+dj08kTSNknEx6Gg=\",\"width\":960},\"frontImage\":null}}',2,'2020-05-01 12:38:09','\"readid\"','2020-04-30 08:19:17','{\"in_person\":\"1\"}'),(92,1,7,'{\"name\":[\"sdfa\"],\"shoesize\":[\"awda\"]}',2,'2020-05-01 11:25:23','\"SELF\"','2020-05-01 11:22:42',NULL),(93,1,2,'{\"uid\":[\"oburton\"],\"schacHomeOrganization\":[\"university-example.org\"],\"eduPersonPrincipalName\":[\"oburton@university-example.edu\"],\"cn\":[\"Oscar Burton\"],\"givenName\":[\"Oscar\"],\"sn\":[\"Burton\"],\"displayName\":[\"Oscar Burton\"],\"mail\":[\"Osc@r__Burton@university-example.org\"],\"eduPersonAffiliation\":[\"employee\",\"member\",\"staff\"],\"eduPersonScopedAffiliation\":[\"employee@huniversity-example.org\",\"staff@university-example.org\",\"member@university-example.org\"],\"isMemberOf\":[\"urn:collab:org:aarc-project.eu\"]}',NULL,NULL,'\"http://idp2.commtrust.local/simplesaml/saml2/idp/metadata.php\"','2020-05-01 11:50:59',NULL),(94,1,6,'{\"uid\":[\"1a08411743e829c787a0152d004c6d48a14e921ed5023a65bb39ad72661cca78\"],\"mail\":[\"alice@wonderland.com\"],\"picture\":[\"http://op.commtrust.local/phpOp/profiles/smiling_woman.jpg\"],\"sub\":[\"1a08411743e829c787a0152d004c6d48a14e921ed5023a65bb39ad72661cca78\"],\"birthdate\":[\"2000-08-08\"],\"email\":[\"alice@wonderland.com\"],\"email_verified\":[true],\"family_name\":[\"Yamada\"],\"gender\":[\"female\"],\"given_name\":[\"Alice\"],\"locale\":[\"en\"],\"middle_name\":[null],\"name\":[\"Alice Yamada\"],\"nickname\":[\"Standard Alice Nickname\"],\"preferred_username\":[\"AlicePreferred\"],\"profile\":[\"http://www.wonderland.com/alice\"],\"updated_at\":[\"23453453\"],\"website\":[\"http://www.wonderland.com\"],\"zoneinfo\":[\"America/Los Angeles\"]}',NULL,NULL,'\"commtrust\"','2020-05-01 11:52:19',NULL),(95,1,1,'{\"uid\":[\"student1\"],\"schacHomeOrganization\":[\"diy.surfconext.nl\"],\"eduPersonPrincipalName\":[\"student1@diy.surfconext.nl\"],\"cn\":[\"Student One\"],\"givenName\":[\"Student\"],\"sn\":[\"One\"],\"displayName\":[\"Student One\"],\"mail\":[\"student1@diy.surfconext.nl\"],\"eduPersonAffiliation\":[\"employee\",\"member\",\"staff\",\"student\"],\"eduPersonScopedAffiliation\":[\"employee@diy.surfconext.nl\",\"staff@diy.surfconext.nl\",\"member@diy.surfconext.nl\",\"student@diy.surfconext.nl\"],\"isMemberOf\":[\"urn:collab:org:aarc-project.eu\"]}',NULL,NULL,'\"http://idp2.commtrust.local/simplesaml/saml2/idp/metadata.php\"','2020-05-01 11:53:14',NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=1714 DEFAULT CHARSET=utf8mb4;
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

-- Dump completed on 2020-05-01 14:46:28
