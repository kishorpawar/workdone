SELECT * FROM mp_raw_data
WHERE serial_number_id = 3920106
LIMIT 1


SELECT DISTINCT(r.serial_number_id), d.serial_number
FROM mp_raw_data r, mp_gps_device d
WHERE r.serial_number_id = d.serial_number

SELECT mp_raw_data.serial_number_id, mp_gps_device.serial_number
FROM mp_raw_data
FULL OUTER JOIN mp_gps_device 
ON mp_raw_data.serial_number_id = mp_gps_device.serial_number;



SELECT DISTINCT(mp_raw_data.serial_number_id),mp_gps_device.serial_number FROM mp_raw_data
LEFT JOIN mp_gps_device 
ON mp_raw_data.serial_number_id = mp_gps_device.serial_number;
UNION
SELECT mp_gps_device.serial_number FROM mp_raw_data
RIGHT JOIN mp_gps_device 
ON mp_raw_data.serial_number_id = mp_gps_device.serial_number;


SELECT * FROM mp_raw_data
ORDER BY event_time DESC 
LIMIT 20

SELECT * FROM mp_alerts
WHERE user_id = 3


SELECT DISTINCT(serial_number_id)
FROM mp_raw_data 
WHERE serial_number_id NOT IN (SELECT DISTINCT(serial_number)
FROM mp_gps_device)

SELECT DISTINCT(serial_number)
FROM mp_gps_device
WHERE serial_number NOT IN (SELECT DISTINCT(serial_number_id )
FROM mp_raw_data )

SELECT * FROM mp_raw_data
WHERE serial_number_id IS NULL


UPDATE mp_user_profile
SET timeformat = '%I:%M %p'
WHERE timeformat != "%H:%M"