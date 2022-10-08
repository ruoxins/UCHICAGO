DROP database IF EXISTS music;
CREATE DATABASE music CHARACTER SET utf8
  COLLATE utf8_general_ci;

SHOW DATABASES;

USE music;

DROP TABLE IF EXISTS spotify_songs;
CREATE TABLE spotify_songs (
    track_id VARCHAR(50) NOT NULL,
    track_name VARCHAR(100) NOT NULL,
    track_artist VARCHAR(50) NOT NULL,
    track_popularity DOUBLE NOT NULL,
    track_album_id VARCHAR(50) NOT NULL,
    track_album_name VARCHAR(50) NOT NULL,
    track_album_release_date VARCHAR(50) NOT NULL,
    playlist_name VARCHAR(50) NOT NULL,
    playlist_id VARCHAR(50) NOT NULL,
    playlist_genre VARCHAR(50) NOT NULL,
    playlist_subgenre VARCHAR(50) NOT NULL,
    danceability DOUBLE NOT NULL,
    energy DOUBLE NOT NULL,
    song_key DOUBLE NOT NULL,
    loudness DOUBLE NOT NULL,
    mode DOUBLE NOT NULL,
    speechiness DOUBLE NOT NULL,
    acousticness DOUBLE NOT NULL,
    instrumentalness DOUBLE NOT NULL,
    liveness DOUBLE NOT NULL,
    valence DOUBLE NOT NULL,
    tempo DOUBLE NOT NULL,
    duration_ms DOUBLE NOT NULL,
    PRIMARY KEY (track_id)
);

select * from spotify_songs;


SHOW GLOBAL VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 'ON';
SHOW GLOBAL VARIABLES LIKE 'local_infile';


LOAD DATA LOCAL INFILE 'C:/Users/60357/Downloads/spotify_songs.csv' INTO TABLE spotify_songs 
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' 
IGNORE 1 ROWS 
(
    track_id,
    track_name,
    track_artist,
    track_popularity,
    track_album_id,
    track_album_name,
    @track_album_release_date,
    playlist_name,
    playlist_id,
    playlist_genre,
    playlist_subgenre,
    danceability,
    energy,
    song_key,
    loudness,
    mode,
    speechiness,
    acousticness,
    instrumentalness,
    liveness,
    valence,
    tempo,
    duration_ms)
SET track_album_release_date  = STR_TO_DATE(@track_album_release_date, '%m/%d/%y');