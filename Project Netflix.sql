SET GLOBAL local_infile = 1;

SHOW VARIABLES LIKE 'local_infile';

USE project_netflix;

CREATE TABLE netflix_titles (
    show_id VARCHAR(10),
    type VARCHAR(20),
    title TEXT,
    director TEXT,
    cast TEXT,
    country TEXT,
    date_added TEXT,
    release_year INT,
    rating VARCHAR(10),
    duration VARCHAR(20),
    listed_in TEXT,
    description TEXT
);

LOAD DATA LOCAL INFILE 'D:/SQL Projects/Project Netflix/netflix_titles.csv'
INTO TABLE netflix_titles
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select *
from netflix_titles;

create table netflix
like netflix_titles;

insert netflix
select *
from netflix_titles;

select * 
from netflix



