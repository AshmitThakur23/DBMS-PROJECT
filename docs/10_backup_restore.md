# 10 — Backup & Restore (PostgreSQL)

This document describes how to make logical backups, simulate accidental delete, restore data, and verify.

## A. Make a full logical SQL dump (human-readable)
Run in PowerShell (postgreSQL bin path explicit):

"C:\Program Files\PostgreSQL\17\bin\pg_dump.exe" -U postgres -d hospital_emr -F p -f "D:\dbms-project-hospital-emr\backups\hospital_emr_backup.sql"

Notes:
- `-F p` = plain SQL file (can be restored with psql).
- The file will be saved to the `backups` folder (create it if missing).

## B. Make a compressed/custom dump (recommended for selective restores)
"C:\Program Files\PostgreSQL\17\bin\pg_dump.exe" -U postgres -d hospital_emr -F c -f "D:\dbms-project-hospital-emr\backups\hospital_emr_backup.dump"

Notes:
- `-F c` = custom format, good for `pg_restore --table` selective restores.

## C. Simulate accidental delete (example)
1. Connect as emr_app or postgres and run:
   DELETE FROM patient WHERE patient_id = 1;

2. Verify:
   SELECT * FROM patient WHERE patient_id = 1;

3. If deleted, proceed to restore.

## D. Restore from plain SQL dump (fast, full restore)
"C:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres -d hospital_emr -f "D:\dbms-project-hospital-emr\backups\hospital_emr_backup.sql"

This will reapply all SQL statements in the dump and restore rows.

## E. Restore a single table from custom dump (selective restore)
1. Create a new test DB (optional)
   "C:\Program Files\PostgreSQL\17\bin\createdb.exe" -U postgres hospital_emr_restore

2. Restore only `patient`:
   "C:\Program Files\PostgreSQL\17\bin\pg_restore.exe" -U postgres -d hospital_emr -t patient "D:\dbms-project-hospital-emr\backups\hospital_emr_backup.dump"

Notes:
- `pg_restore` with `-t` writes only specified table(s).
- When restoring to a live DB, consider disabling FK checks or restore carefully.

## F. Verification
Run:
SELECT * FROM patient WHERE patient_id = 1;
or check row counts before/after `SELECT table_name, COUNT(*) FROM ...`.

## G. Scheduling and best practice (dev)
- Keep daily dumps, rotate by date.
- Keep at least 3 historical backups.
- Test restores monthly.

