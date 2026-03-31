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

select *
from netflix










