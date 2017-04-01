SELECT username AS USERNAME, DATE(acctstarttime) AS START_DATE, TIME(acctstarttime) AS START_TIME,
        DATE(acctstoptime) AS STOP_DATE, TIME(acctstoptime) AS STOP_TIME, SEC_TO_TIME(TIMEDIFF(acctstoptime,acctstarttime)) AS TOTAL_TIME,
        acctinputoctets/(1024*1024) AS 'DOWNLOAD(MB)', acctoutputoctets/(1024*1024) AS 'UPLOAD(MB)'
FROM radacct
WHERE username NOT LIKE '%aspade%'


SELECT r.name, r.email, r.phone, p.name, DATE(r.reg_datetime), TIME(r.reg_datetime)
FROM registration r, test.os_player p
WHERE r.nas_id = p.id
AND email NOT LIKE '%aspade%'
AND reg_datetime BETWEEN '2013-09-01 00:00:00' AND '2013-10-09 23:59:00'