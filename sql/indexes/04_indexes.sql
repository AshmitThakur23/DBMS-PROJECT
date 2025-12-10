-- 04_indexes.sql
-- Indexes for Hospital EMR project
-- Run this from VS Code (Ctrl+Enter) with the active SQLTools connection.

-- 1) Composite index for provider schedule queries (fast lookup by provider and start_time)
CREATE INDEX IF NOT EXISTS idx_appointment_provider_start
ON appointment (provider_id, start_time);

-- 2) Partial index for "future" appointments
-- NOTE: Using now() in a predicate is not allowed (not IMMUTABLE).
-- We therefore use a safe static cutoff (all real appointment dates > '2000-01-01').
-- This still helps by avoiding scanning very old rows in typical workloads.
CREATE INDEX IF NOT EXISTS idx_appointment_future
ON appointment (start_time)
WHERE start_time > '2000-01-01';

-- Alternative (more dynamic) approach using a generated column (uncomment to use):
-- Requires PostgreSQL 12+ (you have PG 17). This stores a boolean and allows indexing on it.
-- If you enable this, remove or keep the static partial index as you prefer.
-- ALTER TABLE appointment
--     ADD COLUMN IF NOT EXISTS is_future BOOLEAN GENERATED ALWAYS AS (start_time > now()) STORED;
-- CREATE INDEX IF NOT EXISTS idx_appointment_is_future ON appointment (is_future) WHERE is_future = true;

-- 3) Patient + encounter_time index for fast history lookups
CREATE INDEX IF NOT EXISTS idx_encounter_patient_date
ON encounter (patient_id, encounter_time);

-- 4) Prescription index to speed medication/time queries (drug utilization)
CREATE INDEX IF NOT EXISTS idx_prescription_medication_date
ON prescription (medication_id, prescribed_at);

-- 5) Billing lookup by payer + creation date
CREATE INDEX IF NOT EXISTS idx_bill_payer
ON bill (payer_id, created_at);

-- 6) Helpful index: appointment status + provider (for fast no-show/reschedule queries)
CREATE INDEX IF NOT EXISTS idx_appointment_status_provider
ON appointment (status, provider_id);

-- 7) Optional: index for quick patient lookup by name (useful in UI searches)
CREATE INDEX IF NOT EXISTS idx_patient_name ON patient ((lower(first_name || ' ' || last_name)));

-- Done.
