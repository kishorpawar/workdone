SELECT * FROM mp_raw_data
WHERE serial_number_id = 3920122
AND speed_mps > 0
WHERE speed_mps > 100



SELECT * FROM mp_raw_data
WHERE speed_mps > 0
AND ignition_state = 0

INSERT INTO mp_raw_data(serial_number_id,event_time,latitude,longitude,loc_age,reason_code,ignition_state,speed_mps,veh_heg_degrees,odometer,altitude,unique_id) 
VALUES(000003920122,STR_TO_DATE('05/23/2013 13:22:46','%m/%d/%Y %H:%i:%s'),19.12973,72.83225,0,6,0,0,16,436.77,30,56342)

SELECT * FROM mp_raw_data WHERE loc_age > 0 ORDER BY serial_number_id;