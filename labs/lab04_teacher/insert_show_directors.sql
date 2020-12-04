CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_show_directors`(bound VARCHAR(255))
BEGIN

DECLARE id INT DEFAULT 0;
DECLARE value TEXT;
DECLARE occurance INT DEFAULT 0;
DECLARE id_unic_director INT DEFAULT 0;
DECLARE show_directors_exist INT;
DECLARE i INT DEFAULT 0;
DECLARE COUNT INT;
DECLARE splitted_value VARCHAR(255);
DECLARE done INT DEFAULT 0;
DECLARE cur1 CURSOR FOR SELECT distinct t1.show_id, t1.director
                                     FROM netflix_dataset t1
                                     WHERE t1.director != '';
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
	  SET id_unic_director = (SELECT id_director FROM dim_directors where director=splitted_value);
      SET show_directors_exist = (SELECT id_director from show_directors where show_id=id and id_director=id_unic_director);
      IF show_directors_exist IS NULL THEN
		INSERT INTO show_directors (show_id,id_director) VALUES (id, id_unic_director);
      END IF;
      SET i = i + 1;
    END WHILE;
  END LOOP;
 CLOSE cur1;
 END