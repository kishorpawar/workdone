SELECT * FROM os_media
WHERE NAME LIKE '%130601%'


SELECT SUM(duration) FROM os_media
WHERE NAME LIKE '%130601%'

-- 3588
SELECT 3588/60 -- 59.8000


SELECT * FROM os_media
WHERE NAME LIKE '%130610%'

SELECT SUM(duration) FROM os_media
WHERE NAME LIKE '%130610%'

-- 270

SELECT 270/60  -- 4.5000

 
SELECT 17*60*60*60 -- 61200

SELECT 61200 - (10*270) -- 59850
 
SELECT 60*60*17