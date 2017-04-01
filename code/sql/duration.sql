SELECT * FROM mp_vehicle
WHERE registration_number = 'efg567'

SELECT * FROM mp_raw_data
WHERE serial_number_id IN (SELECT serial_number_id FROM mp_vehicle
WHERE registration_number = 'efg567')
/*
"id"	"registration_number"	"owner_id"	"serial_number_id"	"make"	"model"	"color"	"year_of_manufacture"	"engine_size"	"fuel_type"	"mileage"	"vehicle_identification_number"
"1"	"abc123"	"1"	"3805993"	\N	\N	\N	\N	\N	\N	\N	\N
"2"	"bcd234"	"1"	"3854100"	\N	\N	\N	\N	\N	\N	\N	\N
"4"	"cde345"	"1"	"3920018"	\N	\N	\N	\N	\N	\N	\N	\N
"5"	"def456"	"1"	"3920122"	\N	\N	\N	\N	\N	\N	\N	\N
"6"	"efg567"	"1"	"3920141"	\N	\N	\N	\N	\N	\N	\N	\N
"7"	"fgh678"	"1"	"3920233"	\N	\N	\N	\N	\N	\N	\N	\N

3920018
*/


SELECT ignition_state,MIN(event_time), MAX(event_time) FROM mp_raw_data
WHERE serial_number_id = 3920122
AND speed_mps <=0
GROUP BY DATE(event_time),ignition_state

SELECT speed_mps,event_time FROM mp_raw_data
WHERE serial_number_id = 3920018
AND speed_mps <=0
AND DATE(event_time) = '2013-05-23'
UNION 
SELECT speed_mps,event_time FROM mp_raw_data
WHERE serial_number_id = 3920018
AND speed_mps >0
AND DATE(event_time) = '2013-05-23'
ORDER BY event_time
