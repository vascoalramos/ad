CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_all_actors`(bound VARCHAR(255))
BEGIN

DECLARE id INT DEFAULT 0;
DECLARE value TEXT;
DECLARE occurance INT DEFAULT 0;
DECLARE i INT DEFAULT 0;
DECLARE COUNT INT;
DECLARE splitted_value VARCHAR(255);
DECLARE done INT DEFAULT 0;
DECLARE cur1 CURSOR FOR SELECT distinct t1.show_id, t1.cast
                                     FROM netflix_dataset t1;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

OPEN cur1;
  read_loop: LOOP
    FETCH cur1 INTO id, value;
    IF done THEN
      LEAVE read_loop;
    END IF;

    SET occurance = (SELECT LENGTH(value) - LENGTH(REPLACE(value, bound, '')) + 1);
    SET i=1;
    WHILE i <= occurance DO
      SET splitted_value = (SELECT LTRIM(REPLACE(SUBSTRING(SUBSTRING_INDEX(value, bound, i), CHAR_LENGTH(SUBSTRING_INDEX(value, bound, i - 1)) + 1), ',', '')));
	  SET COUNT = (SELECT COUNT(*) FROM dim_actors WHERE actor=splitted_value);
      IF COUNT = 0 THEN
		INSERT INTO dim_actors (actor) VALUES (splitted_value);
      END IF;
      SET i = i + 1;
    END WHILE;
  END LOOP;

  SELECT * FROM dim_actors;-- opcional
 CLOSE cur1;
 END