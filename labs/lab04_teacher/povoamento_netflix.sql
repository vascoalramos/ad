CALL insert_all_dates('1944-01-01','2000-11-01');
CALL insert_all_genres(',');
CALL insert_all_countries(',');
CALL insert_all_actors(',');
CALL insert_all_directors(',');

-- dim_duration
insert into dim_duration (id_interval_duration,class_duration) values (1,'Duration up to two hours');
insert into dim_duration (id_interval_duration,class_duration) values (2,'Duration between two and four hours');
insert into dim_duration (id_interval_duration,class_duration) values (3,'Duration of 1 season');
insert into dim_duration (id_interval_duration,class_duration) values (4,'Duration of more than 1 season');

-- dim rating
insert into dim_rating (rating)
select distinct rating from netflix_dataset;

-- dim_type
insert into dim_type (type)
select distinct type from netflix_dataset;

-- dim_show
INSERT INTO dim_show (show_id,show_title,show_description,id_release_year,id_duration)
SELECT show_id,title,description,a1.id_date,duration_classification(duration,duration_type) from netflix_dataset 
inner join dim_date a1 on a1.date =  STR_TO_DATE(CONCAT(release_year,'01','01'),'%Y%m%d');

-- fact_netflix
INSERT INTO fact_netflix (show_id,id_type,id_date_added,imdb_rating,imdb_rating_votes,id_rating)
select a4.show_id,a1.id_type,a2.id_date,a4.imdb_rating,a4.imdb_rating_votes,a3.id_rating
from netflix_dataset a4
inner join dim_type a1 on a1.type=a4.type
inner join dim_date a2 on a2.date = STR_TO_DATE(a4.date_added, '%d/%m/%Y')
inner join dim_rating a3 on a3.rating=a4.rating;

-- show_actors
CALL insert_show_actors(',');

-- show_directors
CALL insert_show_directors(',');

-- netflix_genre
CALL insert_netflix_genre(',');

-- netflix_countries
CALL insert_netflix_countries(',');
