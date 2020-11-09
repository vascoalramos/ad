use shootings_star;

-- top 5 states with more number of incidents
select state, count(victim_id) as `#incidents`
from facts_fatal_police_shooting as f
	join dim_address as da on f.id_dim_address = da.id
group by state
order by `#incidents` desc
limit 5;

-- list the number of incidents in each city, per race and sex
select city, race, gender, count(victim_id) as `#incidents`
from facts_fatal_police_shooting as f
	join dim_address as da on f.id_dim_address = da.id
    join dim_race as dr on f.id_dim_race = dr.id
    join dim_gender as dg on f.id_dim_gender = dg.id
group by city, race, gender
order by `#incidents` desc;

-- see the percentage of incidents that occur depending on whether the police officer has the body camera on or not
select body_camera, (count(victim_id) / temp.total_incidents) * 100 as `incidents (%)`
from facts_fatal_police_shooting as f
	join dim_body_camera as dbc on f.id_dim_body_camera = dbc.id
    join (select count(*) as `total_incidents` from facts_fatal_police_shooting) as temp
group by body_camera, temp.total_incidents;

-- list the number of cases with corellation with (the victim was armed, fleeing, or presented a high level of threat to the officer)
select armed, flee, threat_level, count(victim_id) as `#incidents`
from facts_fatal_police_shooting as f
	join dim_risk as dr on f.id_dim_risk = dr.id
group by armed, flee, threat_level
order by `#incidents` desc;

-- check the evolution of the number of shootings over the last years, taking the rising level of
-- indivualism and polarity present in the USA (discrimnation, xenophobia, ...)
select `year`, `month`,  count(victim_id) as `#incidents`
from facts_fatal_police_shooting as f
	join dim_date as dd on f.id_dim_date = dd.id
group by `year`, `month`
order by `year`, `month` asc;