SELECT * FROM mp_raw_data
WHERE serial_number_id = 3920213
LIMIT 1


SELECT * FROM mp_vehicle
WHERE  NAME LIKE '%bhagwan%'

SELECT * FROM mp_gps_user
WHERE serial_number_id = 3920249, 3920263


SELECT * FROM mp_vehicle
WHERE serial_number_id IN (3920249, 3920263)


SELECT * FROM mp_missed_call
WHERE caller_number LIKE '%9820309504%'

SELECT * FROM mp_missed_call
WHERE caller_number LIKE '%8082282002%'


SELECT * FROM mp_user_profile
WHERE mobile LIKE '%8082282002%'