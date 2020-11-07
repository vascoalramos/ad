use shootings_star;

-- top 5 states with more number of incidents
select state, count(victim_id) as `#incidents`
from facts_fatal_police_shooting as f
	join dim_address as da on f.id_dim_address = da.id
group by state
order by `#incidents` desc
limit 5;

-- list the number of incidents in each city, per race and sex
select city, race, count(victim_id) as `#incidents`
from facts_fatal_police_shooting as f
	join dim_address as da on f.id_dim_address = da.id
    join dim_race as dr on f.id_dim_race = dr.id
group by city, race
order by `#incidents` desc;