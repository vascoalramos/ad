use shootings;

-- populate dim_race
insert into dim_race (race)
select distinct race from temp_dataset;

-- populate dim_age
insert into dim_age (age)
select distinct age from temp_dataset;

-- populate dim_gender
insert into dim_gender (gender)
select distinct gender from temp_dataset;

-- populate dim_body_camera
insert into dim_body_camera (body_camera)
select distinct body_camera from temp_dataset;

-- populate dim_address
insert into dim_address (city, state)
select distinct city, state
from temp_dataset;

-- populate dim_date
insert into dim_date (id, `year`, `month`, `day`)
select distinct date, YEAR(date), MONTH(date), DAY(date)
from temp_dataset; 

-- populate facts_fatal_police_shooting
insert into facts_fatal_police_shooting (id_dim_age, id_dim_race, id_dim_gender, id_dim_body_camera, id_dim_address, id_dim_date)
select da.id as id_dim_age, dr.id as id_dim_race, dg.id as id_dim_gender, dbc.id as id_dim_body_camera, dad.id as id_dim_address, dd.id as id_dim_date
from temp_dataset as t
	join dim_age as da on t.age = da.age
    join dim_race as dr on t.race = dr.race
	join dim_gender as dg on t.gender = dg.gender
    join dim_body_camera as dbc on t.body_camera = dbc.body_camera
    join dim_address as dad on (t.city = dad.city and t.state = dad.state)
	join dim_date as dd on t.`date` = dd.id;
    
select * from facts_fatal_police_shooting;