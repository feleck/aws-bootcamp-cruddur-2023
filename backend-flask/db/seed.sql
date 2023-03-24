INSERT INTO public.users (display_name, handle, email, cognito_user_id)
VALUES
  ('Mike Notandrew', 'araaargggggh', 'ab@email.com' ,'MOCK'),
  ('Andrew Bayko', 'bayko', 'ba@email.com', 'MOCK'),
  ('Londo Mollari', 'londo', 'lmollari@centari.com', 'MOCK'),
  ('Another User', 'auser', 'testin@email.com', 'MOCK');
INSERT INTO public.activities (user_uuid, message, expires_at)
VALUES
  (
    (SELECT uuid from public.users WHERE users.handle = 'araaargggggh' LIMIT 1),
    'This was imported as seed data!',
    current_timestamp + interval '10 day'
  )