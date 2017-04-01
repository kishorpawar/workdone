SELECT * FROM os_ping
WHERE player_id = 1049
AND DATE(ping_on_time) BETWEEN '2013-04-22' AND '2013-04-30' 

SELECT DATE(ping_on_time),MIN(ping_on_time), MAX(ping_on_time) FROM os_ping
WHERE player_id = 1045
AND DATE(ping_on_time) BETWEEN '2013-04-22' AND '2013-04-30' 
GROUP BY DATE(ping_on_time)