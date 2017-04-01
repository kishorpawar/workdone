-- media according to first media started on a day

SELECT * FROM os_media
WHERE id IN (SELECT media_id,start_time FROM os_player_status 
		WHERE slot_id = (SELECT DISTINCT(id) FROM os_slot
					WHERE player_id = 1222
					AND DATE(start_date) = DATE(NOW()))
		AND DATE(start_time)=DATE(NOW()))
LIMIT 1


-- media id and time of ping according to first media started on a day

SELECT media_id,start_time FROM os_player_status 
WHERE slot_id = (SELECT DISTINCT(id) FROM os_slot
		WHERE player_id = 1078
		AND DATE(start_date) = DATE(NOW()))
AND DATE(start_time)=DATE(NOW())


SELECT * FROM os_player
WHERE id = 1031

SELECT * FROM os_ping
WHERE DATE(ping_on_time)=DATE(NOW())
AND player_id = 1147


SELECT * FROM os_logs
WHERE player = 1247
AND DATE(start_time) = DATE(NOW())

SELECT * FROM os_ping
WHERE player_id = 1007
ORDER BY ping_on_time ASC

SELECT * FROM os_player p, os_player_group g
WHERE p.id = g.player_id 
AND g.group_id = 3
AND p.id NOT IN (
SELECT DISTINCT(player_id) FROM os_event_log
WHERE DATE(occurred_on) =  DATE(NOW())
-- AND DATE(occurred_on) = DATE(NOW())
AND event_data LIKE '%memory_size%'
AND player_id IN ( SELECT player_id FROM os_player_group WHERE group_id = 3) )

ORDER BY player_id

-- players group wise 
SELECT * FROM os_player
WHERE id IN (
	SELECT player_id FROM os_player_group 
	WHERE group_id IN ( 
		SELECT id FROM os_group 
		WHERE NAME = 'SM'))
 -- groups 
 -- SM  , CHM
 -- Group-1 ,Group-2 , Group-3 Group-4
 -- DTDC 
 -- Airtel , Reliance
 
-- p.id "PLAYER ID", 

SELECT  ps.start_time "FIRST SONG PING TODAY", ol.start_time "FIRST LOG PING TODAY", op.ping_on_time "FIRST ONLINE PING TODAY"
FROM  os_player p, os_player_status ps, os_logs ol, os_ping op
WHERE p.id = 1147
AND ps.slot_id = (SELECT DISTINCT(id) FROM os_slot
		WHERE player_id = p.id
		AND DATE(start_date) = DATE(NOW()))
AND ol.player = p.id
	AND DATE(ol.start_time) = DATE(NOW())
AND DATE(op.ping_on_time)=DATE(NOW())
	AND op.player_id = p.id
LIMIT 1



SELECT * FROM OPENDATASOURCE

SELECT * 
FROM OPENROWSET('Microsoft.Jet.OLEDB.4.0',
                'Excel 8.0;Database=/home/aspade/Downloads/store.xls',
                'SELECT * FROM [Sheet1$]')
                
 SELECT start_time FROM os_player_status WHERE slot_id = (SELECT DISTINCT(id) FROM os_slot WHERE player_id = 1074 AND DATE(start_date) = DATE(NOW())) LIMIT 1
 
 
SELECT a.member_id, a.name
FROM a INNER JOIN b
USING (member_id, NAME)
 
SELECT * FROM os_player_group
WHERE group_id = 4  						-- 4:67

; --
 
 SELECT * FROM os_player_group
 WHERE group_id = 3
 
 
SELECT * FROM os_player_group g2 ,os_player_group dt 
-- where g2.group_id = dt.group_id
WHERE g2.group_id = 4
AND dt.group_id = 7
-- and g2.player_id != dt.player_id



SELECT op.player_id,p.name,op.ping_on_time,IF(ping_on_time >= '2013-10-25 02:05:00', 'ALREADY ONLINE', "NEWLY ONLINE") "Online_status","delivery_status"
FROM os_ping op, os_player p
WHERE op.player_id = p.id
AND player_id IN (SELECT player_id FROM os_player_group WHERE group_id = 3)
AND DATE(ping_on_time) = DATE(NOW())
-- and player_id = 1091
GROUP BY player_id



SELECT * FROM os_player
-- WHERE city LIKE '%DEl%'
WHERE id = 1121

SELECT * FROM os_event_log WHERE player_id=1255 ORDER BY occurred_on DESC;
SELECT * FROM os_ping WHERE player_id=1136 ORDER BY ping_on_time DESC;

SELECT id "STORE ID", NAME "NAME", city "CITY", state "STATE", contact_person "CONTACT PERSON", contact_no "CONTACT PERSON"
FROM os_player 
WHERE UPPER(contact_person)
IN ('PRAVEEN','VRINDA','ABHISHEK DUBEY','GEORGE PUNNOSE','MADAN KUMAR','SANDEEP SAGAR','RANJANA TAMHANE','MANISH SODA','PUSHPENDER','AJAY GILL','VIVEK KANT','CHARAN KAMAL KAUR','MOHD IBRAHIM','NITIN TUKARAM','SATISH')