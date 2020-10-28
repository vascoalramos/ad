use covid;

-- -----------------------------------------------------
-- Get Portugal daily stats of week 43
-- -----------------------------------------------------
select day, population,`#cases`, `#deaths`, `#cumulativePer100`
from dayStats
	join country on countryId=country.id
where
	countryId='PT' and weekNr=43;
    
-- -----------------------------------------------------
-- Get Portugal weekly stats
-- -----------------------------------------------------
select weekNr, `#newCases`, `#testsDone`, `testingRate`, `positivityRate`
from weekStats
	join country on countryId=country.id
where
	countryId='PT';
    
    
-- -----------------------------------------------------
-- Get overall covid mortality rate in each country
-- -----------------------------------------------------
select name, (totalOfDeaths/totalOfCases)*100 as `mortalityRate`
from (
	select countryId, sum(`#deaths`) as totalOfDeaths, sum(`#cases`) as totalOfCases
	from dayStats
    group by countryId
) as totalStats
	join country on countryId=country.id
order by mortalityRate desc;