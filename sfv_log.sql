-- --------------------------------------------------------
-- Host:                         sfvlog.cwgxxuhgsu0i.us-east-1.rds.amazonaws.com
-- Server version:               10.3.13-MariaDB - Source distribution
-- Server OS:                    Linux
-- HeidiSQL Version:             9.4.0.5125
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping database structure for sfv_log
CREATE DATABASE `sfv_log` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `sfv_log`;

-- Dumping structure for table sfv_log.characters
CREATE TABLE IF NOT EXISTS `characters` (
  `char_id` tinyint(2) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `char_name` varchar(8) NOT NULL,
  `createdAt` timestamp NULL DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`char_id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=latin1;

-- Dumping data for table sfv_log.characters: ~40 rows (approximately)
/*!40000 ALTER TABLE `characters` DISABLE KEYS */;
INSERT INTO `characters` (`char_id`, `char_name`, `createdAt`, `updatedAt`) VALUES
	(01, 'Ryu', NULL, NULL),
	(02, 'Chun-Li', NULL, NULL),
	(03, 'Nash', NULL, NULL),
	(04, 'Dictator', NULL, NULL),
	(05, 'Cammy', NULL, NULL),
	(06, 'Birdie', NULL, NULL),
	(07, 'Ken', NULL, NULL),
	(08, 'Necalli', NULL, NULL),
	(09, 'Claw', NULL, NULL),
	(10, 'R. Mika', NULL, NULL),
	(11, 'Rashid', NULL, NULL),
	(12, 'Karin', NULL, NULL),
	(13, 'Zangief', NULL, NULL),
	(14, 'Laura', NULL, NULL),
	(15, 'Dhalsim', NULL, NULL),
	(16, 'F.A.N.G', NULL, NULL),
	(17, 'Alex', NULL, NULL),
	(18, 'Guile', NULL, NULL),
	(19, 'Ibuki', NULL, NULL),
	(20, 'Boxer', NULL, NULL),
	(21, 'Juri', NULL, NULL),
	(22, 'Urien', NULL, NULL),
	(23, 'Akuma', NULL, NULL),
	(24, 'Kolin', NULL, NULL),
	(25, 'Ed', NULL, NULL),
	(26, 'Abigail', NULL, NULL),
	(27, 'Menat', NULL, NULL),
	(28, 'Zeku', NULL, NULL),
	(29, 'Sakura', NULL, NULL),
	(30, 'Blanka', NULL, NULL),
	(31, 'Falke', NULL, NULL),
	(32, 'Cody', NULL, NULL),
	(33, 'G', NULL, NULL),
	(34, 'Sagat', NULL, NULL),
	(35, 'Kage', NULL, NULL),
	(36, 'E. Honda', NULL, NULL),
	(37, 'Lucia', NULL, NULL),
	(38, 'Poison', NULL, NULL),
	(39, 'Gill', NULL, NULL),
	(40, 'Seth', NULL, NULL);
/*!40000 ALTER TABLE `characters` ENABLE KEYS */;

-- Dumping structure for table sfv_log.matches
CREATE TABLE IF NOT EXISTS `matches` (
  `match_id` int(8) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `season` int(4) unsigned NOT NULL,
  `match_type` tinyint(1) unsigned NOT NULL,
  `my_char_id` tinyint(2) unsigned zerofill NOT NULL,
  `opp_id` int(8) unsigned zerofill NOT NULL,
  `opp_char_id` tinyint(2) unsigned zerofill NOT NULL,
  `opp_rank_id` tinyint(2) unsigned zerofill NOT NULL,
  `result` tinyint(1) unsigned NOT NULL,
  `createdAt` timestamp NULL DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`match_id`),
  KEY `my_char_id` (`my_char_id`),
  KEY `opp_char_id` (`opp_char_id`),
  KEY `opp_id` (`opp_id`),
  KEY `FK_opp_rank_id` (`opp_rank_id`),
  CONSTRAINT `FK_my_char` FOREIGN KEY (`my_char_id`) REFERENCES `characters` (`char_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_opp` FOREIGN KEY (`opp_id`) REFERENCES `opponents` (`opp_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_opp_char` FOREIGN KEY (`opp_char_id`) REFERENCES `characters` (`char_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_rank` FOREIGN KEY (`opp_rank_id`) REFERENCES `ranks` (`rank_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping structure for table sfv_log.opponents
CREATE TABLE IF NOT EXISTS `opponents` (
  `opp_id` int(8) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `opp_name` varchar(16) NOT NULL,
  `createdAt` timestamp NULL DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`opp_id`),
  KEY `FK_opp_rank_id` (`opp_rank_id`),
  CONSTRAINT `FK_rank` FOREIGN KEY (`opp_rank_id`) REFERENCES `ranks` (`rank_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping structure for table sfv_log.ranks
CREATE TABLE IF NOT EXISTS `ranks` (
  `rank_id` tinyint(2) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `rank_name` varchar(21) NOT NULL,
  `createdAt` timestamp NULL DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`rank_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;

-- Dumping data for table sfv_log.ranks: ~20 rows (approximately)
/*!40000 ALTER TABLE `ranks` DISABLE KEYS */;
INSERT INTO `ranks` (`rank_id`, `rank_name`, `createdAt`, `updatedAt`) VALUES
	(01, 'Rookie', NULL, NULL),
	(02, 'Bronze', NULL, NULL),
	(03, 'Super Bronze', NULL, NULL),
	(04, 'Ultra Bronze', NULL, NULL),
	(05, 'Silver', NULL, NULL),
	(06, 'Super Silver', NULL, NULL),
	(07, 'Ultra Silver', NULL, NULL),
	(08, 'Gold', NULL, NULL),
	(09, 'Super Gold', NULL, NULL),
	(10, 'Ultra Gold', NULL, NULL),
	(11, 'Platinum', NULL, NULL),
	(12, 'Super Platinum', NULL, NULL),
	(13, 'Ultra Platinum', NULL, NULL),
	(14, 'Diamond', NULL, NULL),
	(15, 'Super Diamond', NULL, NULL),
	(16, 'Ultra Diamond', NULL, NULL),
	(17, 'Master', NULL, NULL),
	(18, 'Grand Master', NULL, NULL),
	(19, 'Ultimate Grand Master', NULL, NULL),
	(20, 'Warlord', NULL, NULL);
/*!40000 ALTER TABLE `ranks` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
