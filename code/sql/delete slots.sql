SELECT * FROM os_media
WHERE  original_media_md5sum LIKE '%14ec08f3%'

SELECT * FROM os_media
WHERE  NAME LIKE '%tunna%'

SELECT * FROM os_slot
WHERE player_id = 1091

DELETE FROM os_ticker_playlist_item
WHERE playlist_id IN ( 
SELECT DISTINCT id FROM os_playlist
WHERE slot_id IN (
SELECT id FROM os_slot
WHERE player_id = 1091
AND start_time > '06:40:08'))

DELETE FROM os_playlist
WHERE slot_id IN (
DELETE FROM os_slot
WHERE player_id = 1091
AND start_time > '07:18:07')