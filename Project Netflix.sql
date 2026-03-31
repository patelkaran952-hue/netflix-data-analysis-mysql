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
from netflix;


-- Remove duplicates

select *,
row_number() over(partition by `type`, title, director, cast, release_year) as row_num
from netflix;

with duplicate_cte as 
(
select *,
row_number() over(partition by `type`, title, director, cast, release_year) as row_num
from netflix
)
select * 
from duplicate_cte
where row_num > 1;

select * 
from netflix
where title = 'Esperando la carroza';

delete
from netflix
where show_id = 's304';


-- Standardise Data

select type, count(*) as total_content
from netflix
group by type;

select country, count(*) as total_country
from netflix
group by country
order by total_country desc;

update netflix
set country = "Undisclosed Location"
where country = '';

select*
from netflix;

select listed_in, count(*) as total_listed
from netflix
group by listed_in
order by total_listed desc;

select type, rating, count(*) as total_rating
from netflix
group by type, rating
order by total_rating desc;

select distinct rating
from netflix;

select *
from netflix 
where rating = '66 min';

update netflix
set duration = '66 min'
where rating = '66 min';

update netflix
set rating = ''
where rating = '66 min';

select listed_in, count(*) as total_listed
from netflix
group by listed_in
order by total_listed desc;

select title, duration, type
from netflix
order by duration desc;

select distinct duration
from netflix;



-- Spliting duration into two columns beacuse of mixed datatype

ALTER TABLE netflix ADD duration_length INT;
ALTER TABLE netflix ADD duration_type VARCHAR(20);

UPDATE netflix
SET 
duration_length = CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED),
duration_type = SUBSTRING_INDEX(duration, ' ', -1);

ALTER TABLE netflix DROP COLUMN duration;

ALTER TABLE netflix
RENAME COLUMN duration_int TO duration;


-- Replacing empty values with null

select *
from netflix;

select *
from netflix
where date_added = '';

update netflix
set director = null
where director = '';

update netflix
set cast = null
where cast = '';

update netflix
set rating = null
where rating = '';

update netflix
set date_added = null
where date_added = '';


-- Fix Date Format

UPDATE netflix
SET date_added = STR_TO_DATE(date_added, '%M %d, %Y');

ALTER TABLE netflix
MODIFY COLUMN date_added DATE;



-- Exploratory Data Analysis

-- Time Analysis
SELECT YEAR(date_added), COUNT(*)
FROM netflix
GROUP BY YEAR(date_added)
ORDER BY 2 desc;

SELECT country, COUNT(*) as total
FROM netflix
GROUP BY country
ORDER BY total DESC
limit 10;

SELECT listed_in, COUNT(*)
FROM netflix
GROUP BY listed_in
ORDER BY 2 DESC
LIMIT 10;

SELECT cast, COUNT(*) 
FROM netflix
GROUP BY cast
ORDER BY 2 DESC
LIMIT 10;


-- Content added every month
SELECT YEAR(date_added), MONTH(date_added), type, COUNT(*)
FROM netflix
GROUP BY YEAR(date_added), MONTH(date_added), type;

-- Movies longer than 2 hours
SELECT title, duration
FROM netflix
WHERE duration_type = 'min' AND duration > 120
ORDER BY duration desc;

-- TV Shows longer than 5 seasons 
SELECT title, duration, duration_type
FROM netflix
WHERE duration_type = 'Seasons' AND duration > 5
ORDER BY duration desc;


-- Percentage of Movies vs TV Shows
SELECT 
type,
COUNT(*) * 100.0 / (SELECT COUNT(*) FROM netflix) AS percentage
FROM netflix
GROUP BY type;

-- Percentage of Movies vs TV Shows by year
SELECT 
YEAR(date_added) AS year,
type,
COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY YEAR(date_added)) AS percentage
FROM netflix
GROUP BY year, type
ORDER BY year desc, type;


-- Most common genres
SELECT listed_in, COUNT(*)
FROM netflix
GROUP BY listed_in
ORDER BY 2 DESC
LIMIT 10;


-- Content growth trend
SELECT year(date_added), COUNT(*)
FROM netflix
GROUP BY year(date_added)
ORDER BY year(date_added);


-- Apply Database Normalization

-- Creating actors table
CREATE TABLE actors (
    actor_id INT AUTO_INCREMENT PRIMARY KEY,
    actor_name VARCHAR(255)
);

INSERT INTO actors (actor_name)
SELECT DISTINCT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(cast, ',', numbers.n), ',', -1)) AS actor
FROM netflix
JOIN (
    SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
) numbers
ON CHAR_LENGTH(cast) - CHAR_LENGTH(REPLACE(cast, ',', '')) >= numbers.n - 1;

select * from actors;

ALTER TABLE netflix
ADD PRIMARY KEY (show_id);

DESCRIBE netflix;

-- Creating mapping table
CREATE TABLE show_actors (
    show_id VARCHAR(20),
    actor_id INT,
    FOREIGN KEY (show_id) REFERENCES netflix(show_id),
    FOREIGN KEY (actor_id) REFERENCES actors(actor_id)
);

INSERT INTO show_actors (show_id, actor_id)
SELECT 
n.show_id,
a.actor_id
FROM netflix n
JOIN actors a 
ON FIND_IN_SET(a.actor_name, n.cast)
WHERE n.show_id BETWEEN 's1' AND 's1000';


-- Creating Genres table

CREATE TABLE genres (
    genre_id INT AUTO_INCREMENT PRIMARY KEY,
    genre_name VARCHAR(100)
);

INSERT INTO genres (genre_name)
SELECT DISTINCT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', numbers.n), ',', -1))
FROM netflix
JOIN (
    SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
) numbers
ON CHAR_LENGTH(listed_in) - CHAR_LENGTH(REPLACE(listed_in, ',', '')) >= numbers.n - 1;


-- Creating Mapping table

CREATE TABLE show_genres (
    show_id VARCHAR(20),
    genre_id INT,
    FOREIGN KEY (show_id) REFERENCES netflix(show_id),
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);

INSERT INTO show_genres (show_id, genre_id)
SELECT 
n.show_id,
g.genre_id
FROM netflix n
JOIN genres g
ON FIND_IN_SET(g.genre_name, n.listed_in);



-- Creating country table

CREATE TABLE countries (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100)
);

INSERT INTO countries (country_name)
SELECT DISTINCT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(country, ',', numbers.n), ',', -1))
FROM netflix
JOIN (
    SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
) numbers
ON CHAR_LENGTH(country) - CHAR_LENGTH(REPLACE(country, ',', '')) >= numbers.n - 1
WHERE country IS NOT NULL;


-- Creating mapping table

CREATE TABLE show_countries (
    show_id VARCHAR(20),
    country_id INT,
    FOREIGN KEY (show_id) REFERENCES netflix(show_id),
    FOREIGN KEY (country_id) REFERENCES countries(country_id)
);

INSERT INTO show_countries (show_id, country_id)
SELECT 
n.show_id,
c.country_id
FROM netflix n
JOIN countries c
ON FIND_IN_SET(c.country_name, n.country);

select * from countries;




SELECT a.actor_name, COUNT(sa.show_id) AS total_shows
FROM actors a
JOIN show_actors sa ON a.actor_id = sa.actor_id
GROUP BY a.actor_name
ORDER BY total_shows DESC;






























