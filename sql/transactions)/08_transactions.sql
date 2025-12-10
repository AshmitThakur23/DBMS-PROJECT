-- 08_transactions.sql
-- Demonstration of atomic appointment booking + billing
-- and a deadlock scenario with the fixed solution.

--------------------------------------------------------
-- 1) ATOMIC WORKFLOW: book appointment + create bill
--------------------------------------------------------

-- Example: patient 1 with provider 1 at a specific time
BEGIN;

-- Insert appointment
INSERT INTO appointment (patient_id, provider_id, start_time, end_time, status)
VALUES (
    1, 
    1,
    now() + interval '4 hours',
    now() + interval '4 hours' + interval '30 minutes',
    'SCHEDULED'
)
RETURNING appointment_id;

-- Create bill in same atomic unit
INSERT INTO bill (encounter_id, amount, paid, payer_id)
VALUES (
    NULL,        -- real app links encounter after visit
    1000.00, 
    false, 
    NULL
);

COMMIT;


--------------------------------------------------------
-- 2) DEADLOCK DEMO (RUN THESE IN TWO SEPARATE VS CODE QUERIES)
--------------------------------------------------------

-- SESSION A (Tab 1)
-- Lock appointment first, then bill
BEGIN;
SELECT * FROM appointment WHERE appointment_id = 1 FOR UPDATE;
-- Wait 10 seconds before next step to allow Session B to lock bill
-- (You can simulate wait by manually delaying)
UPDATE bill SET amount = amount + 10 WHERE bill_id = 1;
COMMIT;


-- SESSION B (Tab 2)
-- Lock bill first, then appointment (opposite order)
BEGIN;
SELECT * FROM bill WHERE bill_id = 1 FOR UPDATE;
-- Wait 10 seconds to allow Session A to lock appointment
UPDATE appointment SET status = 'RESCHEDULED' WHERE appointment_id = 1;
COMMIT;

-- If you run these in opposite order, PostgreSQL will detect deadlock:
-- ERROR: deadlock detected


--------------------------------------------------------
-- 3) DEADLOCK FIX — CONSISTENT LOCK ORDERING
--------------------------------------------------------

-- Both sessions lock in the same order:
-- 1) lock appointment
-- 2) lock bill

-- FIXED SESSION A (Tab 1)
BEGIN;
SELECT * FROM appointment WHERE appointment_id = 1 FOR UPDATE;
SELECT * FROM bill        WHERE bill_id = 1        FOR UPDATE;
UPDATE appointment SET status = 'DONE' WHERE appointment_id = 1;
UPDATE bill        SET amount = amount + 10 WHERE bill_id = 1;
COMMIT;


-- FIXED SESSION B (Tab 2)
BEGIN;
SELECT * FROM appointment WHERE appointment_id = 1 FOR UPDATE;
SELECT * FROM bill        WHERE bill_id = 1        FOR UPDATE;
UPDATE appointment SET status = 'CANCELLED' WHERE appointment_id = 1;
UPDATE bill        SET amount = amount + 5 WHERE bill_id = 1;
COMMIT;

-- RESULT: No deadlock, because both sessions lock resources in same sequence.
