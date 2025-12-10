-- 09_constraints.sql (final, error-free, works on all PostgreSQL versions)

---------------------------------------------------------
-- 1) Appointment cannot end before it starts
---------------------------------------------------------
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'appointment_time_valid'
    ) THEN
        ALTER TABLE appointment
        ADD CONSTRAINT appointment_time_valid
        CHECK (end_time > start_time);
    END IF;
END $$;

---------------------------------------------------------
-- 2) Gender allowed values
---------------------------------------------------------
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'patient_gender_check'
    ) THEN
        ALTER TABLE patient
        ADD CONSTRAINT patient_gender_check
        CHECK (gender IN ('M','F','O') OR gender IS NULL);
    END IF;
END $$;

---------------------------------------------------------
-- 3) Bill amount cannot be negative
---------------------------------------------------------
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'bill_amount_positive'
    ) THEN
        ALTER TABLE bill
        ADD CONSTRAINT bill_amount_positive
        CHECK (amount >= 0);
    END IF;
END $$;

---------------------------------------------------------
-- 4) Prescription duration must be >= 0
---------------------------------------------------------
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'prescription_duration_valid'
    ) THEN
        ALTER TABLE prescription
        ADD CONSTRAINT prescription_duration_valid
        CHECK (duration_days >= 0);
    END IF;
END $$;

---------------------------------------------------------
-- 5) Specialty name must be unique
---------------------------------------------------------
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'specialty_name_unique'
    ) THEN
        ALTER TABLE specialty
        ADD CONSTRAINT specialty_name_unique UNIQUE (name);
    END IF;
END $$;
