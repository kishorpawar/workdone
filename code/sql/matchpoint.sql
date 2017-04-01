SELECT * FROM gps_raw_data

INSERT INTO gps_raw_data(serial_number_id,event_time,latitude,longitude,loc_age,reason_code,ignition_state,speed,veh_heg_degrees,odometer,altitude,FW_version) VALUES(000003920122,'2103-04-29 06:57:53',19.12952,72.83138,0,6,'OFF',0,4,162.71,-1,'06:29:01 Apr 23 2013
000003920122')

SELECT UTC_TIMESTAMP()

CREATE TABLE t1 (ts TIMESTAMP NULL DEFAULT '0000-00-00 00:00:00');

INSERT INTO t1 VALUES (NOW());

INSERT INTO t1 VALUES ('2103-04-29 06:57:53');
'04/29/2013 06:58:33'
SELECT NOW()

INSERT INTO t1 VALUES (DATETIME('04/29/2013 06:58:33'));


INSERT INTO gps_raw_data(serial_number_id,event_time,latitude,longitude,loc_age,reason_code,ignition_state,speed,veh_heg_degrees,odometer,altitude,FW_version) 
VALUES(000003920122,'04/29/2013 06:57:53',19.12952,72.83138,0,6,'OFF',0,4,162.71,-1,'06:29:01 Apr 23 2013 000003920122')


SELECT STR_TO_DATE('04/29/2013 06:57:53','%y/%d/%Y ')

SELECT STR_TO_DATE('01-5-2013','%d-%m-%Y');


INSERT INTO gps_raw_data(serial_number_id,event_time,latitude,longitude,loc_age,reason_code,ignition_state,speed,veh_heg_degrees,odometer,altitude,FW_version)
VALUES(000003920122,STR_TO_DATE('04/29/2013 06:57:53','%m/%d/%Y %h:%i:%s'),19.12952,72.83138,0,6,'OFF',0,4,162.71,-1,'06:29:01 Apr 23 2013 000003920122')
 
INSERT INTO gps_raw_data(serial_number_id,event_time,latitude,longitude,loc_age,reason_code,ignition_state,speed,veh_heg_degrees,odometer,altitude,FW_version) 
VALUES(000003920122,STR_TO_DATE('04/29/2013 06:57:53','%m/%d/%Y %h:%i:%s'),19.12952,72.83138,0,6,'OFF',0,4,162.71,-1,'06:29:01 Apr 23 2013 000003920122')


INSERT INTO `matchsitedb`.`mp_raw_data` (serial_number_id,event_time,latitude,longitude,loc_age,reason_code,ignition_state,speed,veh_heg_degrees,odometer,altitude,unique_id)
SELECT serial_number_id,event_time,latitude,longitude,loc_age,reason_code,ignition_state,speed_mps,veh_heg_degrees,odometer,altitude,unique_id
FROM `matchpoint_v5`.mp_raw_data


INSERT INTO `matchsitedb`.`mp_vehicle` (`name`,`registration_number`,`owner_id`,`serial_number_id`,`make`,`model`,`color`,`year_of_manufacture`,`engine_size`,`fuel_type`,`mileage`,`vehicle_identification_number`)
SELECT registration_number,registration_number,owner_id,serial_number_id,make,model,color,year_of_manufacture,engine_size,fuel_type,mileage,vehicle_identification_number
FROM `matchpoint_v5`.mp_vehicle

