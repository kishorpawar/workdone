
INSERT INTO `ossitedb`.`os_player` (`name`,`address`,`city`,`state`,`timezone`,`zone_id`,`start_date`,`end_date`,`is_active`,`orientation`,`screen_resolution_id`,`created_on`,`ip_address`,
					`ip_address_update_on`,`system_uuid`,`check_uuid`,`clone_id`,`config_file`,`contact_no`,`contact_person`,`screen_switch_on_command`,`screen_switch_off_command`, 
					`ram`,`harddisk`,`internet`,`motherboard`,`public_ip`)
VALUES('viva city mall 1','Thane','Thane','maharashtra','Asia/Kolkata','4',NOW(),'2099-01-01',1,90,1,NOW(),'ip_address',NOW()-1,UUID(),0,NULL,'','123','abcd',
	'N/A','N/A',NULL,NULL,NULL,NULL,0),
	('viva city mall 1','Thane','Thane','maharashtra','Asia/Kolkata','4',NOW(),'2099-01-01',1,90,1,NOW(),'ip_address',NOW()-1,UUID(),0,NULL,'','123','abcd',
	'N/A','N/A',NULL,NULL,NULL,NULL,0),
	('viva city mall 1','Thane','Thane','maharashtra','Asia/Kolkata','4',NOW(),'2099-01-01',1,90,1,NOW(),'ip_address',NOW()-1,UUID(),0,NULL,'','123','abcd',
	'N/A','N/A',NULL,NULL,NULL,NULL,0);



INSERT INTO `ossitedb`.`os_player_manager`(`user_id`,`player_id`)
VALUES(1,1081),(2,1081),(1,1082),(2,1082),(1,1083),(2,1083);
