SELECT *,CONVERT_TZ(event_time, 'Etc/UTC', 'Asia/Kolkata') AS local_event_time FROM mp_raw_data
-- WHERE serial_number_id=3920265
ORDER BY event_time DESC
LIMIT 1000

SELECT *, CONVERT_TZ(event_time, 'Etc/UTC', 'Asia/Kolkata') AS local_event_time 
FROM mp_raw_data 
WHERE serial_number_id=3920233 
ORDER BY id DESC LIMIT 3000;

SELECT * FROM mp_packet_process
ORDER BY event_time 

SELECT * FROM mp_raw_data
WHERE serial_number_id IN (SELECT serial_number_id FROM mp_gps_user
			WHERE user_id =  7)
ORDER BY event_time DESC

SELECT * FROM mp_vehicle
WHERE owner_id = 6


SELECT * FROM mp_raw_data
WHERE serial_number_id = 3920122
ORDER BY event_time DESC

SELECT * FROM mp_gps_device
WHERE serial_number = 3920122


SELECT *, CONVERT_TZ(event_time, 'Etc/UTC', 'Asia/Kolkata') FROM mp_raw_data
WHERE serial_number_id = 3920233
AND CONVERT_TZ(event_time, 'Etc/UTC', 'Asia/Kolkata') BETWEEN '2013-08-21 08:40:00' AND '2013-08-21 09:16:00'



 SELECT *
 FROM `mp_raw_data` 
 WHERE `mp_raw_data`.`serial_number_id` = 3920018  
 AND `mp_raw_data`.`event_time` BETWEEN '2013-08-27 18:30:00' AND '2013-08-28 18:29:59'
 
 SELECT *
 FROM `mp_raw_data` 
 WHERE `mp_raw_data`.`serial_number_id` = 3920018  
 AND `mp_raw_data`.`event_time` BETWEEN '2013-08-21 18:30:00' AND '2013-08-28 18:29:59'
 
 

SELECT * FROM mp_raw_data
WHERE serial_number_id = 3920122
AND event_time BETWEEN '' AND '' 


SELECT *,CONVERT_TZ(start_time, 'Etc/UTC', 'Asia/Kolkata') FROM mp_missed_call
WHERE caller_number LIKE '%9821732223%'



SELECT * FROM mp_vehicle
WHERE owner_id = 1


SELECT * FROM mp_raw_data
WHERE serial_number_id = 3920233
AND event_time BETWEEN '2013-08-01 00:00:00' AND '2013-08-31 23:59:00'
GROUP BY DATE(event_time),HOUR(event_time) MINUTE(event_time)
-- having MINUTE(event_time) > 5


SELECT * FROM mp_raw_data 
WHERE serial_number_id = 3920233 
AND event_time BETWEEN '2013-08-28 18:30:00+00:00' AND '2013-09-03 18:29:59.999999+00:00' 
GROUP BY DATE(event_time), HOUR(event_time), MINUTE(event_time);

SELECT * FROM mp_raw_data 
WHERE serial_number_id = 3920274 
AND event_time BETWEEN '2013-08-28 18:30:00+00:00' AND '2013-09-03 18:29:59.999999+00:00'
GROUP BY DATE(event_time),MINUTE(event_time)
ORDER BY DATE(event_time),HOUR(event_time),MINUTE(event_time)

SELECT HOUR(event_time),event_time FROM mp_raw_data

SELECT * FROM mp_raw_data
WHERE serial_number_id=3920233
AND CONVERT_TZ(event_time, 'Asia/Kolkata','Etc/UTC' ) BETWEEN DATE(NOW()) AND DATE(NOW())
ORDER BY event_time DESC
LIMIT 1000


SELECT * FROM mp_raw_data
WHERE serial_number_id = 3920233
AND event_time BETWEEN '' '09/04/13' AND '09/04/13'


SELECT * FROM mp_raw_data
WHERE serial_number_id=3920233
AND DATE(event_time) =  DATE(NOW())


