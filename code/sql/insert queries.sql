SELECT * FROM auth_group



INSERT INTO `matchsitedb`.`auth_group` (`name`)
SELECT NAME FROM `matchsitedb_v6`.auth_group

INSERT INTO `matchsitedb`.`mp_geocoding_cache`(`latitude`,`longitude`,`address`)
SELECT `latitude`,`longitude`,`address` FROM `matchsitedb_v6`.`mp_geocoding_cache`
	
INSERT INTO `matchsitedb`.`mp_gps_device`(`serial_number`,`phoneNo`,`paired_on`,`paired_by_id`)
SELECT * FROM `matchsitedb_v6`.mp_gps_device


INSERT INTO `matchsitedb`.`mp_gps_user` (`serial_number_id`,`user_id`)
SELECT `serial_number_id`,`user_id` FROM `matchsitedb_v6`.mp_gps_user

INSERT INTO `matchsitedb`.`mp_raw_data`(`serial_number_id`,`event_time`,`latitude`,`longitude`,`loc_age`,`reason_code`,`ignition_state`,`speed_mps`,`veh_heg_degrees`,`odometer`,`altitude`,`unique_id`)
SELECT `serial_number_id`,`event_time`,`latitude`,`longitude`,`loc_age`,`reason_code`,`ignition_state`,`speed_mps`,`veh_heg_degrees`,`odometer`,`altitude`,`unique_id`
FROM `matchsitedb_v6`.`mp_raw_data`


INSERT INTO `matchsitedb`.`mp_raw_gps_device`(`serial_number`,`imei_number`,`Firmware_Version`,`is_paird`)
SELECT serial_number,imei_number,Firmware_Version,is_paird FROM `matchsitedb_v6`.`mp_raw_gps_device`


INSERT INTO `matchsitedb`.`mp_raw_phone_number`(`phoneNo`,`imsi`,`is_paird`)
SELECT `phoneNo`,`imsi`,`is_paird` FROM `matchsitedb_v6`.`mp_raw_phone_number`


INSERT INTO `matchsitedb`.`mp_vehicle`(`registration_number`,`owner_id`,`serial_number_id`,`make`,`model`,`color`,`year_of_manufacture`,`engine_size`,`fuel_type`,`mileage`,`vehicle_identification_number`)
SELECT `registration_number`,`owner_id`,`serial_number_id`,`make`,`model`,`color`,`year_of_manufacture`,`engine_size`,`fuel_type`,`mileage`,`vehicle_identification_number`
FROM `matchsitedb_v6`.`mp_vehicle`