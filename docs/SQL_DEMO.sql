-- Inspect newest local prototype records.
SELECT alert_id, user_id, alert_type, created_at, status
FROM emergency_alerts ORDER BY created_at DESC;

-- Join each alert to its account (avoid showing password_hash in demos).
SELECT u.full_name, a.alert_id, a.created_at, a.status
FROM users u JOIN emergency_alerts a ON a.user_id = u.user_id
ORDER BY a.created_at DESC;

-- CRUD examples (replace ids and values with fictional demo data).
INSERT INTO emergency_contacts(user_id, contact_name, phone, relationship_label)
VALUES (1, 'Alex Example', '+1 555 0100', 'Friend');
UPDATE emergency_contacts SET phone = '+1 555 0101' WHERE contact_id = 1 AND user_id = 1;
DELETE FROM emergency_contacts WHERE contact_id = 1 AND user_id = 1;
