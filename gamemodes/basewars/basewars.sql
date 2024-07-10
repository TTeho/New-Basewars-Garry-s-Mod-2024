-- BaseWars MySQL Structure
-- Exported from phpMyAdmin

CREATE TABLE IF NOT EXISTS `basewars` (
  `sid64` varchar(20) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `money` bigint(20) unsigned NOT NULL,
  `karma` int(8) NOT NULL DEFAULT '0',
  `time` bigint(20) unsigned NOT NULL DEFAULT '0',
  `xp` int(11) NOT NULL DEFAULT '0',
  `level` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`sid64`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
