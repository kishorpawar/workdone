SELECT o.start_date,m.name,m.duration,m.size FROM os_media m, os_slot o
WHERE  m.id IN ( SELECT media_id FROM os_media_playlist_item
	      WHERE playlist_id IN ( SELECT id FROM os_playlist
				     WHERE slot_id IN (	SELECT id FROM os_slot
							WHERE player_id = 1011)))
ORDER BY o.start_date