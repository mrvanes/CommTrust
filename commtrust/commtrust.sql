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
INSERT INTO `approvals` VALUES (192,2,'2020-06-04 10:12:47','[]'),(193,2,'2020-06-04 10:20:14','[]'),(188,2,'2020-06-11 08:33:34','[]');
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
) ENGINE=InnoDB AUTO_INCREMENT=195 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assertions`
--

LOCK TABLES `assertions` WRITE;
/*!40000 ALTER TABLE `assertions` DISABLE KEYS */;
INSERT INTO `assertions` VALUES (188,3,3,'{\"@odata.context\":\"https://ready.readid.com/odata/v1/ODataServlet/$metadata#Sessions/$entity\",\"app\":{\"appVersion\":\"3.6.4\",\"customerName\":\"ReadID Ready\",\"packageName\":\"com.readid.ready\",\"timestamp\":1584518365815},\"chip\":{\"chipRead\":true,\"chipTypes\":[\"IsoDep\",\"NfcB\"],\"timestamp\":1584518365811},\"clientId\":\"com.readid.ready\",\"consolidatedIdentityData\":{\"chipCloneDetection\":\"SUCCEEDED\",\"chipCloneDetectionSource\":\"CHIP\",\"chipCloneDetectionSourceName\":\"ReadID NFC\",\"chipVerification\":\"SUCCEEDED\",\"chipVerificationSource\":\"CHIP\",\"chipVerificationSourceName\":\"ReadID NFC\",\"creationDate\":\"2020-03-18T07:59:27.111Z\",\"dateOfBirth\":\"YYMMDD\",\"dateOfBirthSource\":\"CHIP\",\"dateOfBirthSourceName\":\"ReadID NFC\",\"dateOfExpiry\":\"YYMMDD\",\"dateOfExpirySource\":\"CHIP\",\"dateOfExpirySourceName\":\"ReadID NFC\",\"documentCode\":\"ID\",\"documentCodeSource\":\"CHIP\",\"documentCodeSourceName\":\"ReadID NFC\",\"documentNumber\":\"ABC000000\",\"documentNumberSource\":\"CHIP\",\"documentNumberSourceName\":\"ReadID NFC\",\"documentType\":\"I\",\"documentTypeSource\":\"CHIP\",\"documentTypeSourceName\":\"ReadID NFC\",\"gender\":\"MALE\",\"genderSource\":\"CHIP\",\"genderSourceName\":\"ReadID NFC\",\"issuingCountry\":\"US\",\"issuingCountrySource\":\"CHIP\",\"issuingCountrySourceName\":\"ReadID NFC\",\"nameOfHolder\":\"JOHN DOE\",\"nameOfHolderSource\":\"CHIP\",\"nameOfHolderSourceName\":\"ReadID NFC\",\"nationality\":\"US\",\"nationalitySource\":\"CHIP\",\"nationalitySourceName\":\"ReadID NFC\",\"personalNumber\":\"00000000X\",\"personalNumberSource\":\"CHIP\",\"personalNumberSourceName\":\"ReadID NFC\",\"placeOfBirth\":null,\"placeOfBirthSource\":null,\"placeOfBirthSourceName\":null,\"primaryIdentifier\":\"DOE\",\"primaryIdentifierSource\":\"CHIP\",\"primaryIdentifierSourceName\":\"ReadID NFC\",\"secondaryIdentifier\":\"JOHN\",\"secondaryIdentifierSource\":\"CHIP\",\"secondaryIdentifierSourceName\":\"ReadID NFC\",\"selfieVerificationProfile\":null,\"selfieVerificationProfileSource\":null,\"selfieVerificationProfileSourceName\":null,\"selfieVerificationStatus\":null,\"selfieVerificationStatusSource\":null,\"selfieVerificationStatusSourceName\":null,\"sessionId\":\"1d4ab816-f8b0-466d-8403-77f7692f7142\",\"version\":1,\"visualVerification\":null,\"visualVerificationSource\":null,\"visualVerificationSourceName\":null},\"creationDate\":\"2020-03-18T07:59:27.111Z\",\"customerApplicationReference\":\"SUBMITTER-DEMO-JOHN\",\"deviceId\":\"0000000000000000\",\"deviceInfo\":{\"brand\":\"Xiaomi\",\"extendedLengthApduSupported\":true,\"manufacturer\":\"Xiaomi\",\"maxTransceiveLength\":65279,\"model\":\"Mi 9T\",\"OSVersion\":\"10\",\"platform\":\"android\",\"timestamp\":1584518365815},\"documentContent\":{\"@odata.type\":\"#nl.innovalor.mrtd.model.ICAODocumentContent\",\"datagroupNumbers\":[1,2,3,7,11,13,14],\"dateOfBirth\":\"YYMMDD\",\"dateOfExpiry\":\"YYMMDD\",\"dateOfIssue\":null,\"documentNumber\":\"ABC000000\",\"faceImages\":[{\"colorSpace\":\"UNSPECIFIED\",\"height\":378,\"image\":\"https://ready.readid.com/odata/v1/Streams/1d4ab816-*****/faceImage/0\",\"mimeType\":\"image/jp2\",\"original\":\"https://ready.readid.com/odata/v1/Streams/1d4ab816-******/faceImage/0/original\",\"originalImageBytes\":null,\"source\":\"UNSPECIFIED\",\"width\":307}],\"fullDateOfBirth\":\"YYYY-MM-DDT00:00:00Z\",\"interpretedDateOfBirth\":\"DD.MM.YYYY\",\"interpretedDateOfExpiry\":\"DD.MM.YYYY\",\"interpretedIssuingCountry\":\"United States\",\"issuingAuthority\":null,\"issuingCountry\":\"US\",\"ldsVersion\":\"1.7\",\"nameOfHolder\":\"DOE, JOHN\",\"personalNumber\":\"00000000X\",\"primaryIdentifier\":\"DOE\",\"secondaryIdentifier\":\"JOHN\",\"signatureImages\":[{\"colorSpace\":null,\"height\":0,\"image\":\"https://ready.readid.com/odata/v1/Streams/1d4ab816-******/signatureImage/0\",\"mimeType\":\"image/jpeg\",\"original\":\"https://ready.readid.com/odata/v1/Streams/1d4ab816-******/signatureImage/0/original\",\"source\":null,\"width\":0}],\"custodian\":null,\"documentCode\":\"ID\",\"gender\":\"MALE\",\"interpretedNationality\":\"American\",\"mrzPrimaryIdentifier\":\"DOE\",\"mrzSecondaryIdentifier\":\"JOHN\",\"MRZString\":\"****\",\"nationality\":\"US\",\"otherNames\":[],\"permanentAddress\":[\"Address\",\"City\",\"State/Province\"],\"placeOfBirth\":\"City, State\",\"placeOfBirthList\":[\"City\",\"State\"],\"profession\":null,\"telephone\":null,\"title\":null,\"unicodeVersion\":\"4.0.0\"},\"exceptions\":[],\"expiryDate\":\"YYYY-MM-DDT12:59:27.111Z\",\"instanceId\":\"651a06b0-1020-4f29-bd66-b13db272e79b\",\"iProovSession\":{\"attempts\":null,\"enrolmentPod\":null,\"enrolmentToken\":null,\"errorString\":null,\"finished\":null,\"hasError\":null,\"passed\":null,\"riskProfile\":null,\"verifyToken\":[]},\"lib\":{\"coreVersion\":\"1.33.0\",\"mobileCountryCode\":\"us\",\"mrtdConfiguration\":{\"AAEnabled\":true,\"allowedFids\":[],\"BACByDefaultEnabled\":true,\"clientServerBaseURL\":\"https://ready.readid.com/odata/v1/ODataServlet/\",\"clientServerHttpRetries\":5,\"clientServerHttpWaitPeriod\":30000,\"CSCAKeyStoreTypeName\":null,\"debugModeEnabled\":false,\"documentType\":\"ICAO_MRTD\",\"DSCSEnabled\":true,\"EACCAEnabled\":true,\"extendedLengthAPDUEnabled\":false,\"extendedLengthMaxBufferBlockSize\":64000,\"NFCForegroundDispatchMuteTime\":0,\"NFCMinimalIsoDepTimeout\":30000,\"NFCReaderModePresenceCheckDelay\":4200,\"PACEEnabled\":false,\"timestamp\":1584518353107},\"nfcVersion\":\"1.33.0\",\"ocrConfiguration\":{\"allowedSizes\":[\"3x30\",\"2x44\",\"2x36\"],\"defaultCorrectnessCriterionUsed\":true,\"diligence\":5,\"focusMode\":\"continuous-picture\",\"scaleMode\":\"ASPECT_FIT\",\"timestamp\":1584518352994},\"ocrVersion\":\"3.28.0\",\"timestamp\":1584518365819},\"mitekSession\":{\"url\":null},\"mrzOCR\":null,\"NFC\":null,\"nfcSession\":{\"accessControlStatus\":{\"BAC\":\"PRESENT_SUCCEEDED\",\"BACReason\":\"SUCCEEDED\",\"EACTA\":\"UNKNOWN\",\"EACTAReason\":\"UNKNOWN\",\"PACE\":\"PRESENT_NOT_PERFORMED\",\"PACEReason\":\"PRESENCE_DETECTED\"},\"data\":[],\"documentType\":\"ICAO_MRTD\",\"features\":[\"BAC\",\"PACE\",\"EAC\"],\"verificationStatus\":{\"AA\":\"NOT_PRESENT\",\"AAReason\":\"NOT_SUPPORTED\",\"AAResult\":null,\"CAResult\":{\"encryptedResponseBytes\":null,\"keyId\":null,\"oid\":\"0.4.0.127.0.7.2.2.3.2.1\",\"pcdPrivateKeyBytes\":null,\"pcdPublicKeyBytes\":null},\"CS\":\"PRESENT_SUCCEEDED\",\"CSReason\":\"FOUND_A_CHAIN_SUCCEEDED\",\"DS\":\"PRESENT_SUCCEEDED\",\"DSReason\":\"SIGNATURE_CHECKED\",\"EACCA\":\"PRESENT_SUCCEEDED\",\"EACCAReason\":\"SUCCEEDED\",\"HT\":\"PRESENT_SUCCEEDED\",\"HTReason\":\"ALL_HASHES_MATCH\"}},\"ocrSession\":{\"mrz\":\"****\",\"mrzImage\":{\"height\":170,\"mimeType\":\"image/png\",\"sha256Sum\":\"2gE+m/HkGTvc0wNDoYyEoqPu5KlAy1/rq47937sGsYw=\",\"width\":1117},\"mrzType\":\"TD1\"},\"opaqueId\":null,\"readySession\":{\"opaqueId\":\"40170d6f-****\",\"readySessionId\":\"74ce5690-****\"},\"serverVersion\":\"1.57.10\",\"sessionId\":\"1d4ab816-****\",\"vizSession\":{\"backImage\":{\"height\":1280,\"mimeType\":\"image/jpeg\",\"sha256Sum\":\"tIxHaippZYzguXDme58kXdXdUbl+dj08kTSNknEx6Gg=\",\"width\":960},\"frontImage\":null}}','\"readid\"','2020-05-28 09:38:16',NULL,NULL),(192,1,3,'{\"@odata.context\":\"https://ready.readid.com/odata/v1/ODataServlet/$metadata#Sessions/$entity\",\"app\":{\"appVersion\":\"3.6.4\",\"customerName\":\"ReadID Ready\",\"packageName\":\"com.readid.ready\",\"timestamp\":1584518365815},\"chip\":{\"chipRead\":true,\"chipTypes\":[\"IsoDep\",\"NfcB\"],\"timestamp\":1584518365811},\"clientId\":\"com.readid.ready\",\"consolidatedIdentityData\":{\"chipCloneDetection\":\"SUCCEEDED\",\"chipCloneDetectionSource\":\"CHIP\",\"chipCloneDetectionSourceName\":\"ReadID NFC\",\"chipVerification\":\"SUCCEEDED\",\"chipVerificationSource\":\"CHIP\",\"chipVerificationSourceName\":\"ReadID NFC\",\"creationDate\":\"2020-03-18T07:59:27.111Z\",\"dateOfBirth\":\"YYMMDD\",\"dateOfBirthSource\":\"CHIP\",\"dateOfBirthSourceName\":\"ReadID NFC\",\"dateOfExpiry\":\"YYMMDD\",\"dateOfExpirySource\":\"CHIP\",\"dateOfExpirySourceName\":\"ReadID NFC\",\"documentCode\":\"ID\",\"documentCodeSource\":\"CHIP\",\"documentCodeSourceName\":\"ReadID NFC\",\"documentNumber\":\"ABC000000\",\"documentNumberSource\":\"CHIP\",\"documentNumberSourceName\":\"ReadID NFC\",\"documentType\":\"I\",\"documentTypeSource\":\"CHIP\",\"documentTypeSourceName\":\"ReadID NFC\",\"gender\":\"MALE\",\"genderSource\":\"CHIP\",\"genderSourceName\":\"ReadID NFC\",\"issuingCountry\":\"US\",\"issuingCountrySource\":\"CHIP\",\"issuingCountrySourceName\":\"ReadID NFC\",\"nameOfHolder\":\"JOHN DOE\",\"nameOfHolderSource\":\"CHIP\",\"nameOfHolderSourceName\":\"ReadID NFC\",\"nationality\":\"US\",\"nationalitySource\":\"CHIP\",\"nationalitySourceName\":\"ReadID NFC\",\"personalNumber\":\"00000000X\",\"personalNumberSource\":\"CHIP\",\"personalNumberSourceName\":\"ReadID NFC\",\"placeOfBirth\":null,\"placeOfBirthSource\":null,\"placeOfBirthSourceName\":null,\"primaryIdentifier\":\"DOE\",\"primaryIdentifierSource\":\"CHIP\",\"primaryIdentifierSourceName\":\"ReadID NFC\",\"secondaryIdentifier\":\"JOHN\",\"secondaryIdentifierSource\":\"CHIP\",\"secondaryIdentifierSourceName\":\"ReadID NFC\",\"selfieVerificationProfile\":null,\"selfieVerificationProfileSource\":null,\"selfieVerificationProfileSourceName\":null,\"selfieVerificationStatus\":null,\"selfieVerificationStatusSource\":null,\"selfieVerificationStatusSourceName\":null,\"sessionId\":\"1d4ab816-f8b0-466d-8403-77f7692f7142\",\"version\":1,\"visualVerification\":null,\"visualVerificationSource\":null,\"visualVerificationSourceName\":null},\"creationDate\":\"2020-03-18T07:59:27.111Z\",\"customerApplicationReference\":\"SUBMITTER-DEMO-JOHN\",\"deviceId\":\"0000000000000000\",\"deviceInfo\":{\"brand\":\"Xiaomi\",\"extendedLengthApduSupported\":true,\"manufacturer\":\"Xiaomi\",\"maxTransceiveLength\":65279,\"model\":\"Mi 9T\",\"OSVersion\":\"10\",\"platform\":\"android\",\"timestamp\":1584518365815},\"documentContent\":{\"@odata.type\":\"#nl.innovalor.mrtd.model.ICAODocumentContent\",\"datagroupNumbers\":[1,2,3,7,11,13,14],\"dateOfBirth\":\"YYMMDD\",\"dateOfExpiry\":\"YYMMDD\",\"dateOfIssue\":null,\"documentNumber\":\"ABC000000\",\"faceImages\":[{\"colorSpace\":\"UNSPECIFIED\",\"height\":378,\"image\":\"https://ready.readid.com/odata/v1/Streams/1d4ab816-*****/faceImage/0\",\"mimeType\":\"image/jp2\",\"original\":\"https://ready.readid.com/odata/v1/Streams/1d4ab816-******/faceImage/0/original\",\"originalImageBytes\":null,\"source\":\"UNSPECIFIED\",\"width\":307}],\"fullDateOfBirth\":\"YYYY-MM-DDT00:00:00Z\",\"interpretedDateOfBirth\":\"DD.MM.YYYY\",\"interpretedDateOfExpiry\":\"DD.MM.YYYY\",\"interpretedIssuingCountry\":\"United States\",\"issuingAuthority\":null,\"issuingCountry\":\"US\",\"ldsVersion\":\"1.7\",\"nameOfHolder\":\"DOE, JOHN\",\"personalNumber\":\"00000000X\",\"primaryIdentifier\":\"DOE\",\"secondaryIdentifier\":\"JOHN\",\"signatureImages\":[{\"colorSpace\":null,\"height\":0,\"image\":\"https://ready.readid.com/odata/v1/Streams/1d4ab816-******/signatureImage/0\",\"mimeType\":\"image/jpeg\",\"original\":\"https://ready.readid.com/odata/v1/Streams/1d4ab816-******/signatureImage/0/original\",\"source\":null,\"width\":0}],\"custodian\":null,\"documentCode\":\"ID\",\"gender\":\"MALE\",\"interpretedNationality\":\"American\",\"mrzPrimaryIdentifier\":\"DOE\",\"mrzSecondaryIdentifier\":\"JOHN\",\"MRZString\":\"****\",\"nationality\":\"US\",\"otherNames\":[],\"permanentAddress\":[\"Address\",\"City\",\"State/Province\"],\"placeOfBirth\":\"City, State\",\"placeOfBirthList\":[\"City\",\"State\"],\"profession\":null,\"telephone\":null,\"title\":null,\"unicodeVersion\":\"4.0.0\"},\"exceptions\":[],\"expiryDate\":\"YYYY-MM-DDT12:59:27.111Z\",\"instanceId\":\"651a06b0-1020-4f29-bd66-b13db272e79b\",\"iProovSession\":{\"attempts\":null,\"enrolmentPod\":null,\"enrolmentToken\":null,\"errorString\":null,\"finished\":null,\"hasError\":null,\"passed\":null,\"riskProfile\":null,\"verifyToken\":[]},\"lib\":{\"coreVersion\":\"1.33.0\",\"mobileCountryCode\":\"us\",\"mrtdConfiguration\":{\"AAEnabled\":true,\"allowedFids\":[],\"BACByDefaultEnabled\":true,\"clientServerBaseURL\":\"https://ready.readid.com/odata/v1/ODataServlet/\",\"clientServerHttpRetries\":5,\"clientServerHttpWaitPeriod\":30000,\"CSCAKeyStoreTypeName\":null,\"debugModeEnabled\":false,\"documentType\":\"ICAO_MRTD\",\"DSCSEnabled\":true,\"EACCAEnabled\":true,\"extendedLengthAPDUEnabled\":false,\"extendedLengthMaxBufferBlockSize\":64000,\"NFCForegroundDispatchMuteTime\":0,\"NFCMinimalIsoDepTimeout\":30000,\"NFCReaderModePresenceCheckDelay\":4200,\"PACEEnabled\":false,\"timestamp\":1584518353107},\"nfcVersion\":\"1.33.0\",\"ocrConfiguration\":{\"allowedSizes\":[\"3x30\",\"2x44\",\"2x36\"],\"defaultCorrectnessCriterionUsed\":true,\"diligence\":5,\"focusMode\":\"continuous-picture\",\"scaleMode\":\"ASPECT_FIT\",\"timestamp\":1584518352994},\"ocrVersion\":\"3.28.0\",\"timestamp\":1584518365819},\"mitekSession\":{\"url\":null},\"mrzOCR\":null,\"NFC\":null,\"nfcSession\":{\"accessControlStatus\":{\"BAC\":\"PRESENT_SUCCEEDED\",\"BACReason\":\"SUCCEEDED\",\"EACTA\":\"UNKNOWN\",\"EACTAReason\":\"UNKNOWN\",\"PACE\":\"PRESENT_NOT_PERFORMED\",\"PACEReason\":\"PRESENCE_DETECTED\"},\"data\":[],\"documentType\":\"ICAO_MRTD\",\"features\":[\"BAC\",\"PACE\",\"EAC\"],\"verificationStatus\":{\"AA\":\"NOT_PRESENT\",\"AAReason\":\"NOT_SUPPORTED\",\"AAResult\":null,\"CAResult\":{\"encryptedResponseBytes\":null,\"keyId\":null,\"oid\":\"0.4.0.127.0.7.2.2.3.2.1\",\"pcdPrivateKeyBytes\":null,\"pcdPublicKeyBytes\":null},\"CS\":\"PRESENT_SUCCEEDED\",\"CSReason\":\"FOUND_A_CHAIN_SUCCEEDED\",\"DS\":\"PRESENT_SUCCEEDED\",\"DSReason\":\"SIGNATURE_CHECKED\",\"EACCA\":\"PRESENT_SUCCEEDED\",\"EACCAReason\":\"SUCCEEDED\",\"HT\":\"PRESENT_SUCCEEDED\",\"HTReason\":\"ALL_HASHES_MATCH\"}},\"ocrSession\":{\"mrz\":\"****\",\"mrzImage\":{\"height\":170,\"mimeType\":\"image/png\",\"sha256Sum\":\"2gE+m/HkGTvc0wNDoYyEoqPu5KlAy1/rq47937sGsYw=\",\"width\":1117},\"mrzType\":\"TD1\"},\"opaqueId\":null,\"readySession\":{\"opaqueId\":\"40170d6f-****\",\"readySessionId\":\"74ce5690-****\"},\"serverVersion\":\"1.57.10\",\"sessionId\":\"1d4ab816-****\",\"vizSession\":{\"backImage\":{\"height\":1280,\"mimeType\":\"image/jpeg\",\"sha256Sum\":\"tIxHaippZYzguXDme58kXdXdUbl+dj08kTSNknEx6Gg=\",\"width\":960},\"frontImage\":null}}','\"readid\"','2020-06-04 10:12:20',NULL,NULL),(193,1,9,'{\"secret\":[\"4J6FPW7CGMUS35ZK\"]}','\"TOTP\"','2020-06-04 10:18:41',NULL,NULL),(194,1,8,'{\"hobbies\":[\"aa\"],\"color\":[\"bb\"]}','\"SELF\"','2020-06-16 06:48:47',NULL,NULL);
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
INSERT INTO `att2claims` VALUES (1,1),(1,2),(1,6),(2,7),(2,8),(3,3),(4,1),(4,8),(4,9);
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
-- Table structure for table `audit_log`
--

DROP TABLE IF EXISTS `audit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `audit_log` (
  `timestamp` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `actor_id` int(10) unsigned NOT NULL,
  `subject_id` int(10) unsigned DEFAULT NULL,
  `assertion_id` int(10) unsigned DEFAULT NULL,
  `message` blob DEFAULT NULL,
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
INSERT INTO `audit_log` VALUES ('2020-05-25 07:46:00.901',1,NULL,169,'User 1 completed evidence on assertion 169 from source \"SELF\"'),('2020-05-25 07:48:23.127',1,NULL,169,'User 1 completed evidence on assertion 169 from source \"SELF\"'),('2020-05-25 08:25:00.081',1,NULL,172,'User 1 completed evidence on assertion 172 from source \"readid\"'),('2020-05-25 08:26:09.126',1,NULL,172,'User 1 completed evidence on assertion 172 from source \"readid\"'),('2020-05-25 08:27:14.973',1,NULL,172,'User 1 completed evidence on assertion 172 from source \"readid\"'),('2020-05-25 08:35:15.159',1,NULL,175,'User 1 completed evidence on assertion 175 from source \"readid\"'),('2020-05-25 08:37:03.584',1,NULL,175,'User 1 completed evidence on assertion 175 from source \"readid\"'),('2020-05-25 08:37:38.278',1,NULL,169,'User 1 completed evidence on assertion 169 from source \"SELF\"'),('2020-05-25 08:55:47.620',1,NULL,175,'User 1 completed evidence on assertion 175 from source \"readid\"'),('2020-05-25 09:05:08.573',1,NULL,176,'User 1 completed evidence on assertion 176 from source \"readid\"'),('2020-05-25 09:05:27.140',2,1,176,'User 2 approved assertion 176 for user 1'),('2020-05-25 09:08:24.428',1,NULL,177,'User 1 completed evidence on assertion 177 from source \"readid\"'),('2020-05-25 09:09:00.967',2,1,177,'User 2 approved assertion 177 for user 1'),('2020-05-25 09:15:46.939',1,NULL,178,'User 1 completed evidence on assertion 178 from source \"readid\"'),('2020-05-25 09:22:55.062',1,NULL,179,'User 1 completed evidence on assertion 179 from source \"readid\"'),('2020-05-25 09:23:28.682',2,1,179,'User 2 approved assertion 179 for user 1'),('2020-05-25 09:25:19.271',1,NULL,180,'User 1 completed evidence on assertion 180 from source \"readid\"'),('2020-05-25 09:25:38.287',2,1,180,'User 2 approved assertion 180 for user 1'),('2020-05-25 10:03:32.098',3,NULL,181,'User 3 completed evidence on assertion 181 from source \"readid\"'),('2020-05-25 10:18:44.972',1,NULL,182,'User 1 completed evidence on assertion 182 from source \"SELF\"'),('2020-05-25 10:43:09.801',2,1,182,'User 2 approved assertion 182 for user 1'),('2020-05-25 12:07:18.481',1,NULL,183,'User 1 completed evidence on assertion 183 from source \"SELF\"'),('2020-05-25 12:07:46.476',2,1,183,'User 2 approved assertion 183 for user 1'),('2020-05-25 12:24:54.832',1,NULL,184,'User 1 completed evidence on assertion 184 from source \"readid\"'),('2020-05-25 12:25:14.338',2,1,184,'User 2 approved assertion 184 for user 1'),('2020-05-28 09:16:02.464',1,NULL,185,'User 1 completed evidence on assertion 185 from source \"http://idp2.commtrust.local/simplesaml/saml2/idp/metadata.php\"'),('2020-05-28 09:17:09.620',2,1,185,'User 2 approved assertion 185 for user 1'),('2020-05-28 09:18:41.467',1,NULL,186,'User 1 completed evidence on assertion 186 from source \"readid\"'),('2020-05-28 09:19:25.357',2,1,186,'User 2 approved assertion 186 for user 1'),('2020-05-28 09:35:53.781',1,NULL,187,'User 1 completed evidence on assertion 187 from source \"TOTP\"'),('2020-05-28 09:36:50.137',2,1,187,'User 2 approved assertion 187 for user 1'),('2020-05-28 09:38:16.658',3,NULL,188,'User 3 completed evidence on assertion 188 from source \"readid\"'),('2020-06-04 09:35:27.044',1,NULL,189,'User 1 completed evidence on assertion 189 from source \"SELF\"'),('2020-06-04 09:35:54.226',2,1,189,'User 2 approved assertion 189 for user 1'),('2020-06-04 09:42:11.962',1,NULL,190,'User 1 completed evidence on assertion 190 from source \"TOTP\"'),('2020-06-04 09:42:48.204',2,1,190,'User 2 approved assertion 190 for user 1'),('2020-06-04 10:10:14.873',1,NULL,191,'User 1 completed evidence on assertion 191 from source \"TOTP\"'),('2020-06-04 10:12:20.927',1,NULL,192,'User 1 completed evidence on assertion 192 from source \"readid\"'),('2020-06-04 10:12:47.681',2,1,192,'User 2 approved assertion 192 for user 1'),('2020-06-04 10:18:41.320',1,NULL,193,'User 1 completed evidence on assertion 193 from source \"TOTP\"'),('2020-06-04 10:20:14.738',2,1,193,'User 2 approved assertion 193 for user 1'),('2020-06-11 08:33:34.728',2,3,188,'User 2 approved assertion 188 for user 3'),('2020-06-16 06:48:47.542',1,NULL,194,'User 1 completed evidence on assertion 194 from source \"SELF\"');
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
INSERT INTO `claim_types` VALUES (1,'saml','saml_handler'),(2,'readid','readid_handler'),(3,'oidc','oidc_handler'),(4,'self','self_handler'),(5,'totp','totp_handler');
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `claims`
--

LOCK TABLES `claims` WRITE;
/*!40000 ALTER TABLE `claims` DISABLE KEYS */;
INSERT INTO `claims` VALUES (1,'Federated R&S ID',1,'{\n	\"sp\":\"attestation-sp\",\n	\"idp\":\"http://idp2.commtrust.local/simplesaml/saml2/idp/metadata.php\",\n	\"card\":[\"uid\",\"displayName\",\"schacHomeOrganization\",\"givenName\"]\n}'),(2,'ORCID identifier',1,'{\n	\"sp\":\"attestation-sp\",\n	\"idp\":\"http://idp2.commtrust.local/simplesaml/saml2/idp/metadata.php\",\n	\"card\":[\"uid\",\"mail\",\"schacHomeOrganization\",\"isMemberOf\"]\n}'),(3,'Passport',2,'{\"sp\":\"attestation-sp\",\"idp\":\"http://dummy/metadata.php\"}'),(6,'OIDC Test OP',3,'{\n	\"rp\":\"attestation-rp\",\n	\"op\": {\n		\"client_id\": \"commtrust\",\n        \"token_endpoint\": \"http://op.commtrust.local/token\",\n        \"user_info_endpoint\": \"http://op.commtrust.local/userinfo\",\n        \"authorization_endpoint\": \"http://op.commtrust.local/auth\",\n        \"authentication_info\":{\n        	\"method\": \"client_secret_post\",\n        	\"params\": {\n        		\"client_secret\": \"commtrust_secret\"\n        	}\n        }\n	},\n	\"card\":[\"name\",\"mail\"]\n}'),(7,'DIY identifier',4,'{\n	\"inputs\": [\n		\"name\",\n		\"shoesize\"\n	],\n	\"card\": [\"name\", \"shoesize\"]\n}'),(8,'Personal',4,'{  \"inputs\": [   \"hobbies\",   \"color\"  ],  \"card\": [\"hobbies\", \"color\"] }'),(9,'TOTP',5,'{  \"card\": [\"secret\"] }');
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
) ENGINE=InnoDB AUTO_INCREMENT=2870 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'student1','Student One',NULL,'2020-06-04 10:39:55'),(2,'jweeler','Joseph Weeler',1,'2020-06-11 08:33:38'),(3,'student2','Student Two',NULL,'2020-06-11 08:34:04'),(4,'student3','Student Three',NULL,NULL);
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

-- Dump completed on 2020-06-16  6:52:14
