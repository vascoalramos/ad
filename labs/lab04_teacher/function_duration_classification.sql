DELIMITER $$
CREATE FUNCTION duration_classification (duration int,unit varchar(10))
RETURNS int
DETERMINISTIC
BEGIN
    DECLARE classification int;
    IF (duration > 1 AND duration < 120 AND unit='min') THEN
        SET classification = 1;
    ELSEIF (duration >= 120 AND duration < 240 AND unit='min') THEN
        SET classification = 2;
    ELSEIF (duration > 0 AND duration < 2 AND unit='Season') THEN
        SET classification = 3;
	ELSEIF (duration > 1 AND unit='Seasons') THEN
        SET classification = 4;
    END IF;
    RETURN (classification);
END$$
DELIMITER ;