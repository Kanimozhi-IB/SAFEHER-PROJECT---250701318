# Test plan

Automated tests cover pure input validation. Manual DB/UI checks require a configured MySQL 8 instance:

1. Register a fictional account; verify user row and BCrypt hash (not plaintext).
2. Try duplicate email and phone; verify a safe database error and no duplicate row.
3. Sign in with correct and incorrect passwords.
4. Add, edit, list, and delete a contact; confirm user scoping.
5. Record an alert with no location, then with valid coordinates; confirm newest-first history and `CREATED` state.
6. Update state to `RESOLVED` and `CANCELLED`; restart and verify persistence.
7. Try malformed coordinates, partial coordinates, and out-of-range values.
8. Stop MySQL and confirm a safe connection error.
9. Sign in as a second account and ensure the first account's records are not visible.

Use fictional identities and do not contact real emergency services.
