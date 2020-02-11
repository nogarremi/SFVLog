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
CREATE DATABASE IF NOT EXISTS `sfv_log` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `sfv_log`;

-- Dumping structure for table sfv_log.characters
CREATE TABLE IF NOT EXISTS `characters` (
  `char_id` tinyint(2) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `char_name` varchar(8) NOT NULL,
  `createdAt` timestamp NULL DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`char_id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
-- Dumping structure for table sfv_log.matches
CREATE TABLE IF NOT EXISTS `matches` (
  `match_id` int(8) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `season` int(4) unsigned NOT NULL,
  `match_type` tinyint(1) unsigned NOT NULL,
  `my_char_id` tinyint(2) unsigned zerofill NOT NULL,
  `opp_id` int(8) unsigned zerofill NOT NULL,
  `opp_char_id` tinyint(2) unsigned zerofill NOT NULL,
  `result` tinyint(1) unsigned NOT NULL,
  `createdAt` timestamp NULL DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`match_id`),
  KEY `my_char_id` (`my_char_id`),
  KEY `opp_char_id` (`opp_char_id`),
  KEY `opp_id` (`opp_id`),
  CONSTRAINT `FK_my_char` FOREIGN KEY (`my_char_id`) REFERENCES `characters` (`char_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_opp` FOREIGN KEY (`opp_id`) REFERENCES `opponents` (`opp_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_opp_char` FOREIGN KEY (`opp_char_id`) REFERENCES `characters` (`char_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
-- Dumping structure for table sfv_log.opponents
CREATE TABLE IF NOT EXISTS `opponents` (
  `opp_id` int(8) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `opp_name` varchar(16) NOT NULL,
  `opp_rank_id` tinyint(2) unsigned zerofill NOT NULL,
  `createdAt` timestamp NULL DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`opp_id`),
  KEY `FK_opp_rank_id` (`opp_rank_id`),
  CONSTRAINT `FK_rank` FOREIGN KEY (`opp_rank_id`) REFERENCES `ranks` (`rank_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
-- Dumping structure for table sfv_log.ranks
CREATE TABLE IF NOT EXISTS `ranks` (
  `rank_id` tinyint(2) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `rank_name` varchar(21) NOT NULL,
  `createdAt` timestamp NULL DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`rank_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
