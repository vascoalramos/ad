use covid_korea;

-- -----------------------------------------------------
-- Get the 5 provinces of Korea most affected by covid 19
-- -----------------------------------------------------
select province, count(facts.id) as `#cases`
from facts_patient_info as facts
	inner join dim_infection_site on id_dim_infection_site=dim_infection_site.id
group by
	province
order by
	`#cases` desc
limit 5;

-- -----------------------------------------------------
-- Get the 10 profiles of people most affected by covid 19 in Korea
-- -----------------------------------------------------
select age_range, sex, count(facts.id) as `#cases`
from facts_patient_info as facts
	inner join dim_sex on id_dim_sex=dim_sex.id
    inner join dim_age on id_dim_age=dim_age.id
where
	age_range != 'N/A' and sex != 'N/A'
group by
	age_range,
    sex
order by
	`#cases` desc
limit 10;