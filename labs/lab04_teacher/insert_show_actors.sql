CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_show_actors`(bound VARCHAR(255))
BEGIN

DECLARE id INT;
DECLARE value TEXT;
DECLARE occurance INT DEFAULT 0;
DECLARE id_unic_actor INT DEFAULT 0;
DECLARE show_actors_exist INT;
DECLARE i INT DEFAULT 0;
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
	  SET id_unic_actor = (SELECT id_actor FROM dim_actors where actor=splitted_value);
      SET show_actors_exist = (SELECT id_actor from show_actors where show_id=id and id_actor=id_unic_actor);
      IF show_actors_exist IS NULL THEN
		INSERT INTO show_actors (show_id,id_actor) VALUES (id, id_unic_actor);
      END IF;
      SET i = i + 1;
    END WHILE;
  END LOOP;
 CLOSE cur1;
 END