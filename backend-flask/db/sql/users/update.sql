UPDATE public.users
SET
  bio = %(bio)s,
  display_name = %(display_name)s
WHERE
  user.cognito_user_id = %(cognito_user_id)s
RETURNING handle;