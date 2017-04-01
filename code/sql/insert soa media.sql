CREATE TABLE test_media 
SELECT * FROM os_media
WHERE 1=2



INSERT INTO `ossitedb_SOA`.`os_media` (`user_id`,`name`,`type_id`,`size`,`duration`,`uploaded_location`,`upload_on`,`upload_method`,`original_media_uri`, 
					`local_preview_uri`,`local_thumbnail_uri`,`cloud_player_media_uri`,`cloud_preview_uri`,`cloud_thumbnail_uri`,`original_media_md5sum`, 
					`is_active`,`start_date`,`expiry_date`,`player_media_transfer`,`thumbnail_transfer`,`preview_transfer`,`campaign_id`)
SELECT user_id,NAME,type_id,size,duration,uploaded_location,upload_on,upload_method,original_media_uri,local_preview_uri,local_thumbnail_uri,cloud_player_media_uri,cloud_preview_uri,
	cloud_thumbnail_uri,original_media_md5sum,is_active,start_date,expiry_date,player_media_transfer,thumbnail_transfer,preview_transfer,campaign_id
FROM test_media


SELECT * FROM os_media
WHERE NAME LIKE '%130701%'