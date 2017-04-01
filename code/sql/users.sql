
SELECT * FROM auth_user
WHERE id IN (SELECT user_id FROM mp_gps_user HAVING COUNT(user_id)<5)
AND id IN (SELECT user_id FROM mp_gps_user WHERE )