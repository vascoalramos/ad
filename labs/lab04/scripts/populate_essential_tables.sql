USE netflix;

-- populate dim_date
INSERT INTO dim_date (`date`)
SELECT distinct date_added FROM netflix_dataset ORDER BY date_added;

-- populate dim_type
INSERT INTO dim_type (`type`)
SELECT distinct `type` FROM netflix_dataset;

-- populate dim_rating
INSERT INTO dim_rating (rating)
SELECT distinct rating FROM netflix_dataset;

-- populate dim_details
INSERT INTO dim_details (title, `description`, duration, id_rating)
SELECT distinct title, `description`, duration, dim_rating.id
FROM netflix_dataset
	INNER JOIN dim_rating on netflix_dataset.rating = dim_rating.rating;
    
-- populate fact_netflix_data
INSERT INTO fact_netflix_data (id, release_year, id_added_date, id_dim_type, id_dim_details, imdb_rating, imdb_rating_votes)
SELECT show_id, release_year, dim_date.id, dim_type.id, dim_details.id, IMDB_rating, IMDB_rating_votes
FROM netflix_dataset
	INNER JOIN dim_date on netflix_dataset.date_added = dim_date.`date`
    INNER JOIN dim_type on netflix_dataset.`type` = dim_type.`type`
    INNER JOIN dim_details on netflix_dataset.title = dim_details.title
		AND netflix_dataset.`description` = dim_details.`description`
        AND netflix_dataset.duration = dim_details.duration
	INNER JOIN dim_rating on dim_details.id_rating = dim_rating.id
ORDER BY show_id;