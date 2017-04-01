SELECT MONTH(p.ping_on_time), pl.name,p.player_id, COUNT(MONTH(p.ping_on_time)),COUNT(MONTH(p.ping_on_time))*5
FROM os_ping p, os_player pl
WHERE p.player_id = pl.id
GROUP BY MONTH(p.ping_on_time),p.player_id WITH ROLLUP 



SELECT p.ping_on_time,DAY(p.ping_on_time), pl.name,p.player_id, COUNT(DAY(p.ping_on_time))
FROM os_ping p, os_player pl
WHERE p.player_id = pl.id
GROUP BY DAY(p.ping_on_time),p.player_id WITH ROLLUP 
