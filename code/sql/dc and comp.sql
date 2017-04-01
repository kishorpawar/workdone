SELECT  * FROM os_component
WHERE id IN  (60,61,62,63,64,65)

CREATE TABLE test_dc(
SELECT * FROM os_component
WHERE display_config_id  IN (24,25))

SELECT * FROM os_component
WHERE display_config_id  IN (24,25)

SELECT * FROM os_theme
WHERE id IN (SELECT theme_id FROM os_display_config WHERE id =25)

SELECT * FROM os_player
WHERE id = 1029 


SELECT * FROM os_media
WHERE NAME LIKE '%ticke%'