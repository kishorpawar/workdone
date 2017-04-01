TRUNCATE TABLE os_gps_raw_data
SELECT * FROM os_gps_raw_data
WHERE DATE(TIME) < '3013-05-07'
AND player_id NOT IN (SELECT DISTINCT player_id FROM os_player_version_logs WHERE client_version = 'r130331_beta_gpsd_u3')


SELECT * FROM os_gps_raw_data
WHERE player_id = 1012
WHERE DATE(TIME) = '2013-05-09' AND DATE(TIME) = '2013-05-07' AND DATE(TIME) = '2013-05-08'


SELECT player_id, DATE(TIME), COUNT(DATE(TIME)) FROM os_gps_raw_data
-- order by time desc
WHERE DATE(TIME) BETWEEN '2013-05-07' AND '2013-05-09'
GROUP BY player_id, DATE(TIME)

SELECT DISTINCT player_id FROM os_gps_raw_data
WHERE DATE(TIME) > '3013-05-07'

DELETE  FROM os_gps_raw_data
SELECT COUNT(*) FROM os_gps_raw_data
WHERE DATE(TIME) < '3013-05-07'
AND player_id IN (1016,1028,1029,1048,1049,1051,1055,1080,1098,1102)

SELECT ID, NAME FROM os_player
WHERE id IN (1016,1028,1029,1048,1049,1051,1055,1080,1098,1102)



SELECT * FROM os_player_version_logs 
WHERE player_id IN (1016,1028,1029,1048,1049,1051,1055,1080,1098,1102)



DELETE  FROM os_gps_raw_data
-- SELECT * FROM os_gps_raw_data
WHERE DATE(TIME) < '2013-05-07'
AND player_id NOT IN (1012,1029)