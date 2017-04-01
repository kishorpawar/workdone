SELECT DISTINCT phoneNo
FROM mp_gps_device

SELECT NOW()

SELECT serial_number_id,event_time,ignition_state,speed
FROM mp_raw_data
WHERE serial_number_id = 3920122
AND DATE(event_time) = DATE(NOW())


SELECT rd.serial_number_id,rd.event_time,rd.ignition_state,rd.speed
FROM mp_raw_data rd
INNER JOIN (SELECT ignition_state FROM mp_raw_data
	    GROUP BY ignition_state HAVING COUNT(id) > 1) dup 
ON rd.ignition_state = dup.ignition_state


SELECT rd.serial_number_id,rd.event_time,rd.ignition_state
FROM mp_raw_data rd
INNER JOIN mp_raw_data dr
ON rd.ignition_state = dr.ignition_state
WHERE rd.id <> dr.id
AND rd.serial_number_id = 3920122


SELECT serial_number_id,event_time,ignition_state
FROM mp_raw_data
WHERE serial_number_id = 3920122
AND DATE(event_time) = DATE(NOW())


SELECT SUM(TIME(event_time)),ignition_state
FROM mp_raw_data
WHERE serial_number_id = 3920122
AND DATE(event_time)= DATE(NOW())
GROUP BY ignition_state


SELECT SEC_TO_TIME(3569621)


CREATE PROCEDURE curdemo()
BEGIN
   DECLARE ig,dur INT;
   DECLARE evt_dte DATETIME ;
   DECLARE cur1 CURSOR FOR SELECT event_time,ignition_state FROM mp_raw_data WHERE serial_number_id = 3920122 AND DATE(event_time) = DATE(NOW());
   
   OPEN cur1;
   
   read_loop: LOOP
	FETCH cur1 INTO evt_dte,ig;
   END LOOP;
   
   CLOSE cur1;
 END;
 
 
 
 
CREATE PROCEDURE curdemo()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE a CHAR(16);
  DECLARE b, c INT;
  DECLARE cur1 CURSOR FOR SELECT event_time,ignition_state FROM mp_raw_data;
  
  OPEN cur1;
  
  read_loop: LOOP
    FETCH cur1 INTO a, b;
  END LOOP;

  CLOSE cur1;
  CLOSE cur2;
END;