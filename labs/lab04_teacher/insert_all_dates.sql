DROP PROCEDURE IF EXISTS filldates;
DELIMITER |
CREATE PROCEDURE insert_all_dates(dateStart DATE, dateEnd DATE)
BEGIN
  WHILE dateStart <= dateEnd DO
    INSERT INTO dim_date (datE) VALUES (dateStart);
    SET dateStart = date_add(dateStart, INTERVAL 1 DAY);
  END WHILE;
END;
|
DELIMITER ;