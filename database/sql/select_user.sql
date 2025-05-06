SELECT user_id, group_name
FROM internal_user
WHERE user_login = '${login}'
AND user_password = '${password}';