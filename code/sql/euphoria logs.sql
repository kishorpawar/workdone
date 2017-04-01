SELECT p.name AS PLAYER, m.name AS MEDIA, l.start_time, l.end_time
FROM os_logs l, os_media m, os_player p
WHERE p.id=l.player
AND m.id=l.media_id
AND m.id = 1401
AND DATE(start_time) BETWEEN '2013-05-05' AND '2013-07-25'

SELECT p.name AS PLAYER, m.name AS MEDIA, l.start_time, l.end_time
FROM os_logs l, os_media m, os_player p
WHERE p.id=l.player
AND m.id=l.media_id
AND m.id = 1391
AND DATE(start_time) BETWEEN '2013-05-05' AND '2013-07-25'

SELECT p.name AS PLAYER, m.name AS MEDIA, l.start_time, l.end_time
FROM os_logs l, os_media m, os_player p
WHERE p.id=l.player
AND m.id=l.media_id
AND m.id = 1361
AND DATE(start_time) BETWEEN '2013-05-05' AND '2013-07-25'

SELECT p.name AS PLAYER, m.name AS MEDIA, l.start_time, l.end_time
FROM os_logs l, os_media m, os_player p
WHERE p.id=l.player
AND m.id=l.media_id
AND m.id = 1431
AND DATE(start_time) BETWEEN '2013-05-05' AND '2013-07-25'

SELECT p.name AS PLAYER, m.name AS MEDIA, l.start_time, l.end_time
FROM os_logs l, os_media m, os_player p
WHERE p.id=l.player
AND m.id=l.media_id
AND m.id = 1428
AND DATE(start_time) BETWEEN '2013-05-05' AND '2013-07-25'

SELECT p.name AS PLAYER, m.name AS MEDIA, l.start_time, l.end_time
FROM os_logs l, os_media m, os_player p
WHERE p.id=l.player
AND m.id=l.media_id
AND m.id = 1415
AND DATE(start_time) BETWEEN '2013-05-05' AND '2013-07-25'

SELECT * FROM os_media
WHERE NAME LIKE '%NEW_24713_WMV_V8.wmv%'


SELECT NAME,upload_on,start_date,expiry_date FROM os_media
WHERE NAME LIKE '%kala_kendra%'

SELECT * FROM os_playlist_log
WHERE DATA LIKE '%kala_kendra%'

SELECT * FROM wal_activity_log
WHERE DATA LIKE '%MP_SLIDE_1_2.avi%'


SELECT * FROM os_media
WHERE id IN (1460,1459,1458,1454)
 -- 1460,1459,1458,1454
  
SELECT p.name AS PLAYER, m.name AS MEDIA, DATE(l.start_time) DATE,COUNT(l.start_time) AS 'COUNT'
FROM os_logs l, os_media m, os_player p
WHERE p.id=l.player
AND m.id=l.media_id
AND m.id = 1468
AND DATE(start_time) BETWEEN '2013-08-01' AND '2013-08-31'
GROUP BY p.name, m.name,DATE(start_time)


SELECT p.name AS PLAYER, m.name AS MEDIA, l.start_time
FROM os_logs l, os_media m, os_player p
WHERE p.id=l.player
AND m.id=l.media_id
AND m.id = 1460
AND DATE(start_time) BETWEEN '2013-07-14' AND '2013-08-12'
GROUP BY p.name, m.name,DATE(start_time)

-- 1042 - 1052
SELECT COUNT(*) FROM os_logs
WHERE player = 1052
AND media_id = 1454

SELECT * FROM os_media
WHERE id IN (1460,1459,1458,1454);
SELECT * FROM os_player 
WHERE id BETWEEN 1042 AND 1052



SELECT * FROM mp_raw_data WHERE table.id MOD 5 = 0;