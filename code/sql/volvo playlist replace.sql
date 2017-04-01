SELECT * FROM os_slot 
WHERE id IN ( SELECT slot_id FROM os_playlist 
WHERE id IN (SELECT playlist_id FROM os_media_playlist_item
WHERE media_id IN ( SELECT id FROM os_media WHERE NAME LIKE '%130610_130610_%')))


SELECT * FROM os_media
WHERE player_media_transfer = 0
OR thumbnail_transfer = 0
AND preview_transfer = 0 


SELECT * FROM os_media
WHERE NAME LIKE '%avja%'
OR NAME LIKE '%wifi%'
OR NAME LIKE '%safe%'


SELECT * FROM os_media_playlist_item
WHERE media_id IN (133,147,150)