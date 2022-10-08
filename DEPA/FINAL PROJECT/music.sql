DROP DATABASE IF exists `music`;
CREATE DATABASE `music`;

USE `music`;

DROP TABLE IF EXISTS `artists`;

CREATE TABLE IF NOT EXISTS `artists` (
    `artist_id` INT(10) NOT NULL,
    `artist_name` VARCHAR(45) NOT NULL,
    `artist_followers` INT(20),
    `artist_genre` VARCHAR(45),
    `artist_popularity` INT(20),
    PRIMARY KEY (`artist_id`)
)  ENGINE=INNODB DEFAULT CHARACTER SET=UTF8;

DROP TABLE IF EXISTS `albums`;

CREATE TABLE IF NOT EXISTS `albums` (
    `album_id` INT(10) NOT NULL,
    `artist_id` INT(10) NOT NULL,
    `album_title` VARCHAR(45) NOT NULL,
    `album_genre` VARCHAR(45),
    `album_year_of_pub` INT,
    `album_num_of_tracks` INT,
    `album_num_of_sales` INT,
    `album_rolling_stone_critic` DOUBLE,
    `album_mtv_critic` DOUBLE NULL DEFAULT NULL,
    `album_music_maniac_critic` INT,
    PRIMARY KEY (`album_id`),
    CONSTRAINT `artist_album_fk` FOREIGN KEY (`artist_id`) REFERENCES `artists` (`artist_id`)
)  ENGINE=INNODB DEFAULT CHARACTER SET=UTF8;


DROP TABLE IF EXISTS `playlists`;

CREATE TABLE IF NOT EXISTS `playlists` (
    `playlist_id` INT(10) NOT NULL,
    `playlist_name` VARCHAR(50) NOT NULL,
    `playlist_genre` VARCHAR(50) NOT NULL,
    `playlist_subgenre` VARCHAR(50) NOT NULL,
    PRIMARY KEY (`playlist_id`)
)  ENGINE=INNODB DEFAULT CHARACTER SET=UTF8;


DROP TABLE IF EXISTS `tracks`;

CREATE TABLE IF NOT EXISTS `tracks` (
    `track_id` INT(10) NOT NULL,
    `track_name` VARCHAR(100) NOT NULL,
    `artist_id` INT(10)  NOT NULL,
    `album_id` INT(10)  NOT NULL,
    `playlist_id` INT(10)  NOT NULL,
    `track_popularity` DOUBLE NOT NULL,
    `danceability` DOUBLE NOT NULL,
    `energy` DOUBLE NOT NULL,
    `key` DOUBLE NOT NULL,
    `loudness` DOUBLE NOT NULL,
    `mode` DOUBLE NOT NULL,
    `speechiness` DOUBLE NOT NULL,
    `acousticness` DOUBLE NOT NULL,
    `instrumentalness` DOUBLE NOT NULL,
    `liveness` DOUBLE NOT NULL,
    `valence` DOUBLE NOT NULL,
    `tempo` DOUBLE NOT NULL,
    `duration_ms` DOUBLE NOT NULL,
    PRIMARY KEY (`track_id`),
    CONSTRAINT `artist_track_fk` FOREIGN KEY (`artist_id`) REFERENCES `artists` (`artist_id`),
	CONSTRAINT `album_track_fk` FOREIGN KEY (`album_id`) REFERENCES `albums` (`album_id`)
    #CONSTRAINT `playlist_track_fk` FOREIGN KEY (`playlist_id`) REFERENCES `playlists` (`playlist_id`)
)  ENGINE=INNODB DEFAULT CHARACTER SET=UTF8;

DROP TABLE IF EXISTS `track_playlist`;

CREATE TABLE track_playlist (
  track_id INT(10) NOT NULL,
  playlist_id INT(10) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (track_id, playlist_id),
  CONSTRAINT fk_track_playlist_track FOREIGN KEY (track_id) REFERENCES tracks (track_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_track_playlist_playlist FOREIGN KEY (playlist_id) REFERENCES playlists (playlist_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARACTER SET=UTF8;


DROP TABLE IF EXISTS `chart`;

CREATE TABLE IF NOT EXISTS `chart` (
    `chart_id` INT(10) NOT NULL,
	`rank` INT NULL DEFAULT NULL,
	`track_id` INT(10) NULL DEFAULT NULL,
	`artist_id` INT(10)  NULL DEFAULT NULL,
    `album_id` INT(10)  NULL DEFAULT NULL,
    `playlist_id` INT(10)  NULL DEFAULT NULL,
	`last-week` INT NULL DEFAULT NULL,
	`peak-rank` INT NULL DEFAULT NULL,
	`weeks-on-board` INT NULL DEFAULT NULL,
	`dateId` BIGINT(20) NOT NULL,
    PRIMARY KEY (`chart_id`),
    CONSTRAINT `track_chart_fk` FOREIGN KEY (`track_id`) REFERENCES `tracks` (`track_id`),
    CONSTRAINT `artist_chart_fk` FOREIGN KEY (`artist_id`) REFERENCES `artists` (`artist_id`),
	CONSTRAINT `album_chart_fk` FOREIGN KEY (`album_id`) REFERENCES `albums` (`album_id`),
	CONSTRAINT `playlist_chart_fk` FOREIGN KEY (`playlist_id`) REFERENCES `playlists` (`playlist_id`),
    CONSTRAINT `time_chart_fk` FOREIGN KEY (`dateId`) REFERENCES `time` (`dateId`)
)  ENGINE=INNODB DEFAULT CHARACTER SET=UTF8;


DROP TABLE IF EXISTS `time`;

CREATE TABLE IF NOT EXISTS `time` (
  `dateId` BIGINT(20) NOT NULL,
  `date` DATE NOT NULL,
  `timestamp` BIGINT(20) NULL DEFAULT NULL,
  `weekend` CHAR(10) NOT NULL DEFAULT 'Weekday',
  `day_of_week` CHAR(10) NULL DEFAULT NULL,
  `month` CHAR(10) NULL DEFAULT NULL,
  `month_day` INT(11) NULL DEFAULT NULL,
  `year` INT(11) NULL DEFAULT NULL,
  `week_starting_monday` CHAR(2) NULL DEFAULT NULL,
  PRIMARY KEY (`dateId`),
  UNIQUE INDEX `date` (`date` ASC),
  INDEX `year_week` (`year` ASC, `week_starting_monday` ASC)
  )
ENGINE = InnoDB DEFAULT CHARACTER SET = utf8;
