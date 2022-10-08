CREATE SCHEMA IF NOT EXISTS music_snowflake ;

SHOW DATABASES;

USE music_snowflake;


CREATE TABLE IF NOT EXISTS `music_snowflake`.`dim_artist` (
    `artist_id` INT(10) NOT NULL AUTO_INCREMENT,
    `artist_name` VARCHAR(45) NOT NULL,
    `artist_followers` INT(20),
    `artist_genre` VARCHAR(45),
    `artist_popularity` INT(20),
    PRIMARY KEY (`artist_id`)
)  ENGINE=INNODB DEFAULT CHARACTER SET=UTF8;


CREATE TABLE IF NOT EXISTS `music_snowflake`.`dim_album` (
    `album_id` INT(10) NOT NULL AUTO_INCREMENT,
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
    CONSTRAINT `dim_artist_album_fk`
    FOREIGN KEY (`artist_id`)
    REFERENCES `music_snowflake`.`dim_artist` (`artist_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)  ENGINE=INNODB DEFAULT CHARACTER SET=UTF8;


CREATE INDEX `dim_artist_album_fk` ON `music_snowflake`.`dim_artist` (`artist_id` ASC);

CREATE TABLE IF NOT EXISTS `music_snowflake`.`dim_playlist` (
    `playlist_id` INT(10) NOT NULL,
    `playlist_name` VARCHAR(50) NOT NULL,
    `playlist_genre` VARCHAR(50) NOT NULL,
    `playlist_subgenre` VARCHAR(50) NOT NULL,
    PRIMARY KEY (`playlist_id`)
)  ENGINE=INNODB DEFAULT CHARACTER SET=UTF8;


CREATE TABLE IF NOT EXISTS `music_snowflake`.`dim_track` (
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
    CONSTRAINT `dim_artist_track_fk`
    FOREIGN KEY (`artist_id`)
    REFERENCES `music_snowflake`.`dim_artist` (`artist_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
	CONSTRAINT `dim_album_track_fk`
    FOREIGN KEY (`album_id`)
    REFERENCES `music_snowflake`.`dim_album` (`album_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
	CONSTRAINT `dim_playlist_track_fk`
    FOREIGN KEY (`playlist_id`)
    REFERENCES `music_snowflake`.`dim_playlist` (`playlist_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)  ENGINE=INNODB DEFAULT CHARACTER SET=UTF8;


CREATE INDEX `dim_artist_track_fk` ON `music_snowflake`.`dim_artist` (`artist_id` ASC);
CREATE INDEX `dim_album_track_fk` ON `music_snowflake`.`dim_album` (`album_id` ASC);
CREATE INDEX `dim_playlist_track_fk` ON `music_snowflake`.`dim_playlist` (`playlist_id` ASC);


CREATE TABLE IF NOT EXISTS `music_snowflake`.`fact_chart` (
    `chart_id` INT(10) NOT NULL AUTO_INCREMENT,
	`rank` INT NULL DEFAULT NULL,
	`track_id` INT(10) NULL DEFAULT NULL,
	`artist_id` INT(10)  NULL DEFAULT NULL,
    `album_id` INT(10)  NULL DEFAULT NULL,
    `playlist_id` INT(10)  NULL DEFAULT NULL,
	`last-week` INT NULL DEFAULT NULL,
	`peak-rank` INT NULL DEFAULT NULL,
	`weeks-on-board` INT NULL DEFAULT NULL,
	`date` DATETIME NULL DEFAULT NULL,
    PRIMARY KEY (`chart_id`),
    CONSTRAINT `dim_track_fact_chart_fk`
    FOREIGN KEY (`track_id`)
    REFERENCES `music_snowflake`.`dim_track` (`track_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `dim_artist_fact_chart_fk`
    FOREIGN KEY (`artist_id`)
    REFERENCES `music_snowflake`.`dim_artist` (`artist_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
	CONSTRAINT `dim_album_fact_chart_fk`
    FOREIGN KEY (`album_id`)
    REFERENCES `music_snowflake`.`dim_album` (`album_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
	CONSTRAINT `dim_playlist_fact_chart_fk`
    FOREIGN KEY (`playlist_id`)
    REFERENCES `music_snowflake`.`dim_playlist` (`playlist_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)  ENGINE=INNODB DEFAULT CHARACTER SET=UTF8;

CREATE INDEX `dim_track_fact_chart_fk` ON `music_snowflake`.`dim_track` (`track_id` ASC);
CREATE INDEX `dim_artist_fact_chart_fk` ON `music_snowflake`.`dim_artist` (`artist_id` ASC);
CREATE INDEX `dim_album_fact_chart_fk` ON `music_snowflake`.`dim_album` (`album_id` ASC);
CREATE INDEX `dim_playlist_fact_chart_fk` ON `music_snowflake`.`dim_playlist` (`playlist_id` ASC);
