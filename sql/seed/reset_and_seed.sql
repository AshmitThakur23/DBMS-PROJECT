-- reset_and_seed.sql (simple, fully fixed dataset, no random)
-- This will DELETE all existing data in these tables and insert a clean, fixed dataset.

BEGIN;

-- 1) Clean everything and restart IDs
TRUNCATE TABLE
  bill,
  prescription,
  diagnosis,
  encounter,
  appointment,
  procedure_tbl,
  medication,
  insurance,
  provider,
  specialty,
  patient
RESTART IDENTITY CASCADE;

-- After this:
-- specialty_id will start from 1
-- provider_id will start from 1
-- patient_id will start from 1
-- appointment_id, encounter_id, diagnosis_id, prescription_id, bill_id all start from 1


-- 2) SPECIALTIES (5 rows)
INSERT INTO specialty (name) VALUES
  ('General Medicine'),   -- id 1
  ('Cardiology'),         -- id 2
  ('Pediatrics'),         -- id 3
  ('Orthopedics'),        -- id 4
  ('Dermatology');        -- id 5


-- 3) PROVIDERS (15 rows, mapped to specialties by numeric IDs above)
INSERT INTO provider (first_name, last_name, specialty_id) VALUES
  ('Amit','Sharma', 1),   -- General Medicine
  ('Neha','Gupta', 2),    -- Cardiology
  ('Rohan','Verma', 3),   -- Pediatrics
  ('Anjali','Singh', 4),  -- Orthopedics
  ('Vikram','Patel', 5),  -- Dermatology
  ('Sana','Khan', 1),
  ('Rajat','Mehra', 2),
  ('Pooja','Reddy', 3),
  ('Karan','Kapoor', 4),
  ('Isha','Nair', 5),
  ('Deepak','Joshi', 1),
  ('Maya','Iyer', 2),
  ('Arjun','Desai', 3),
  ('Tara','Sharma', 4),
  ('Rahul','Khan', 5);


-- 4) PATIENTS (80 fixed rows, IDs will be 1..80 in this order)
INSERT INTO patient (first_name, last_name, dob, gender) VALUES
('Siddharth','Verma','1998-05-12','M'),
('Priya','Singh','2002-11-03','F'),
('Manish','Kumar','1975-02-20','M'),
('Aanya','Sharma','1999-01-15','F'),
('Rohit','Patel','1990-06-10','M'),
('Simran','Khan','1995-03-25','F'),
('Aditya','Joshi','1988-11-08','M'),
('Neha','Reddy','1996-07-21','F'),
('Vishal','Mehra','1985-09-14','M'),
('Ishita','Nair','1997-08-17','F'),
('Kunal','Kapoor','1992-04-19','M'),
('Rhea','Desai','2000-02-11','F'),
('Arjun','Iyer','1993-12-30','M'),
('Deepa','Roy','1987-10-04','F'),
('Ankit','Bhat','1994-05-18','M'),
('Sonal','Chaudhary','1998-09-09','F'),
('Nikhil','Prasad','1989-01-29','M'),
('Anushka','Agarwal','2001-05-05','F'),
('Vikram','Saxena','1984-07-23','M'),
('Meera','Gupta','1996-06-16','F'),
('Pooja','Singh','1997-06-02','F'),
('Rajat','Verma','1999-12-22','M'),
('Maya','Patel','1994-02-15','F'),
('Kabir','Sharma','1991-03-12','M'),
('Tara','Kapoor','1998-10-27','F'),
('Sana','Bhat','1995-04-01','F'),
('Karan','Roy','1993-02-09','M'),
('Isha','Prasad','1997-08-03','F'),
('Asha','Chaudhary','1986-01-07','F'),
('Ravi','Agarwal','1983-05-29','M'),
('Anita','Saxena','1990-09-19','F'),
('Hemant','Gupta','1982-06-05','M'),
('Ritu','Singh','1995-11-25','F'),
('Soham','Patel','2000-03-30','M'),
('Naina','Sharma','1999-04-10','F'),
('Kavya','Joshi','1998-08-20','F'),
('Aarav','Reddy','1995-12-11','M'),
('Dev','Verma','1993-03-16','M'),
('Srishti','Mehra','1999-09-09','F'),
('Harsh','Nair','1991-10-28','M'),
('Sneha','Iyer','1997-06-17','F'),
('Om','Kapoor','1988-11-02','M'),
('Jiya','Desai','2002-01-14','F'),
('Yash','Roy','1996-02-26','M'),
('Lavanya','Bhat','1997-05-13','F'),
('Arnav','Agarwal','1994-09-08','M'),
('Diya','Saxena','1998-03-22','F'),
('Harshit','Gupta','1991-07-29','M'),
('Muskan','Singh','2000-10-05','F'),
('Pranav','Patel','1992-06-18','M'),
('Roshni','Sharma','1995-12-10','F'),
('Sahil','Joshi','1993-07-03','M'),
('Alisha','Reddy','2001-09-25','F'),
('Mohan','Verma','1985-03-14','M'),
('Kritika','Nair','1998-04-23','F'),
('Suresh','Iyer','1989-02-12','M'),
('Divya','Kapoor','1996-12-01','F'),
('Abhay','Desai','1994-01-17','M'),
('Shreya','Roy','1997-11-06','F'),
('Parth','Bhat','1992-08-01','M'),
('Bhavya','Prasad','1999-05-15','F'),
('Gaurav','Agarwal','1987-07-30','M'),
('Shweta','Saxena','1998-09-19','F'),
('Yuvraj','Gupta','1995-02-05','M'),
('Vaishali','Singh','2000-08-22','F'),
('Tejas','Patel','1993-01-09','M'),
('Mahima','Sharma','1996-11-12','F'),
('Abhinav','Joshi','1992-02-15','M'),
('Tanvi','Reddy','1998-03-09','F'),
('Nitin','Verma','1990-05-07','M'),
('Roshika','Mehra','1999-07-29','F'),
('Adarsh','Nair','1994-11-03','M'),
('Chhavi','Iyer','1998-06-14','F'),
('Devansh','Kapoor','1993-10-18','M'),
('Shruti','Desai','1999-01-25','F'),
('Ishaan','Roy','1995-12-02','M'),
('Payal','Bhat','1998-07-07','F'),
('Krish','Prasad','1991-09-16','M'),
('Ritika','Verma','1994-04-21','F'),
('Manu','Sharma','1997-02-28','M');


-- 5) MEDICATIONS (25)
INSERT INTO medication (name, ndc) VALUES
('Paracetamol','NDC001'),
('Aspirin','NDC002'),
('Amoxicillin','NDC003'),
('Metformin','NDC004'),
('Atorvastatin','NDC005'),
('Omeprazole','NDC006'),
('Cetirizine','NDC007'),
('Ibuprofen','NDC008'),
('Losartan','NDC009'),
('Amlodipine','NDC010'),
('Salbutamol','NDC011'),
('Prednisone','NDC012'),
('Warfarin','NDC013'),
('Levothyroxine','NDC014'),
('Lisinopril','NDC015'),
('Clopidogrel','NDC016'),
('Ciprofloxacin','NDC017'),
('Azithromycin','NDC018'),
('Hydrochlorothiazide','NDC019'),
('Gabapentin','NDC020'),
('Tramadol','NDC021'),
('Fluoxetine','NDC022'),
('Sertraline','NDC023'),
('Montelukast','NDC024'),
('Ranitidine','NDC025');


-- 6) INSURANCE PAYERS (6)
INSERT INTO insurance (payer_name, plan_id) VALUES
('BlueShield','BS-P1'),
('UnitedHealth','UH-P2'),
('Medicare','MC-P3'),
('Aetna','AE-P4'),
('Cigna','CG-P5'),
('Self Pay','SELF');


-- 7) APPOINTMENTS (20 fixed examples)
-- After inserts above:
--   patient_id is 1..80
--   provider_id is 1..15
INSERT INTO appointment (patient_id, provider_id, start_time, end_time, status, created_at) VALUES
(1,  1, '2025-11-01 09:00', '2025-11-01 09:30', 'COMPLETED',  '2025-10-25 10:00'),
(2,  2, '2025-11-01 09:30', '2025-11-01 10:00', 'SCHEDULED',  '2025-10-25 10:05'),
(3,  3, '2025-11-01 10:00', '2025-11-01 10:30', 'NOSHOW',     '2025-10-25 10:10'),
(4,  4, '2025-11-01 10:30', '2025-11-01 11:00', 'COMPLETED',  '2025-10-25 10:15'),
(5,  5, '2025-11-01 11:00', '2025-11-01 11:30', 'RESCHEDULED','2025-10-25 10:20'),
(6,  6, '2025-11-01 11:30', '2025-11-01 12:00', 'COMPLETED',  '2025-10-25 10:25'),
(7,  7, '2025-11-01 12:00', '2025-11-01 12:30', 'SCHEDULED',  '2025-10-25 10:30'),
(8,  8, '2025-11-01 12:30', '2025-11-01 13:00', 'COMPLETED',  '2025-10-25 10:35'),
(9,  9, '2025-11-01 13:00', '2025-11-01 13:30', 'NOSHOW',     '2025-10-25 10:40'),
(10,10, '2025-11-01 13:30', '2025-11-01 14:00', 'COMPLETED',  '2025-10-25 10:45'),

(11,11, '2025-11-02 09:00', '2025-11-02 09:30', 'COMPLETED',  '2025-10-26 10:00'),
(12,12, '2025-11-02 09:30', '2025-11-02 10:00', 'SCHEDULED',  '2025-10-26 10:05'),
(13,13, '2025-11-02 10:00', '2025-11-02 10:30', 'COMPLETED',  '2025-10-26 10:10'),
(14,14, '2025-11-02 10:30', '2025-11-02 11:00', 'RESCHEDULED','2025-10-26 10:15'),
(15,15, '2025-11-02 11:00', '2025-11-02 11:30', 'COMPLETED',  '2025-10-26 10:20'),
(16,1,  '2025-11-02 11:30', '2025-11-02 12:00', 'COMPLETED',  '2025-10-26 10:25'),
(17,2,  '2025-11-02 12:00', '2025-11-02 12:30', 'NOSHOW',     '2025-10-26 10:30'),
(18,3,  '2025-11-02 12:30', '2025-11-02 13:00', 'SCHEDULED',  '2025-10-26 10:35'),
(19,4,  '2025-11-02 13:00', '2025-11-02 13:30', 'COMPLETED',  '2025-10-26 10:40'),
(20,5,  '2025-11-02 13:30', '2025-11-02 14:00', 'COMPLETED',  '2025-10-26 10:45');


-- 8) ENCOUNTERS (10 rows) - one per first 10 patients
INSERT INTO encounter (patient_id, provider_id, encounter_time, reason, notes) VALUES
(1,  1, '2025-11-01 09:10', 'Fever and cough',           'Initial visit for fever'),
(2,  2, '2025-11-01 09:40', 'Chest pain',                'ECG advised'),
(3,  3, '2025-11-01 10:10', 'Child vaccination',         'Pediatrics vaccination'),
(4,  4, '2025-11-01 10:40', 'Knee pain',                 'Orthopedic evaluation'),
(5,  5, '2025-11-01 11:10', 'Skin rash',                 'Dermatology consult'),
(6,  6, '2025-11-01 11:40', 'Headache',                  'General medicine consult'),
(7,  7, '2025-11-01 12:10', 'Diabetes check',            'Routine diabetes follow-up'),
(8,  8, '2025-11-01 12:40', 'Hypertension follow-up',    'BP monitoring'),
(9,  9, '2025-11-01 13:10', 'Asthma review',             'Inhaler technique check'),
(10,10,'2025-11-01 13:40', 'General checkup',            'Annual health check');


-- After this, encounter_id will be 1..10 in this order.


-- 9) DIAGNOSIS (20 rows - 2 per encounter)
INSERT INTO diagnosis (encounter_id, code, description, is_primary) VALUES
(1, 'J10', 'Influenza', true),
(1, 'R50', 'Fever', false),

(2, 'I20', 'Angina', true),
(2, 'R07', 'Chest pain', false),

(3, 'Z00', 'Health check-up of child', true),
(3, 'Z23', 'Encounter for immunization', false),

(4, 'M17', 'Knee osteoarthritis', true),
(4, 'M25', 'Joint pain', false),

(5, 'L20', 'Dermatitis', true),
(5, 'L30', 'Skin inflammation', false),

(6, 'R51', 'Headache', true),
(6, 'G44', 'Tension-type headache', false),

(7, 'E11', 'Type 2 diabetes mellitus', true),
(7, 'Z13', 'Screening for metabolic disorder', false),

(8, 'I10', 'Essential hypertension', true),
(8, 'Z09', 'Follow-up examination', false),

(9, 'J45', 'Asthma', true),
(9, 'Z79', 'Long-term (current) use of drugs', false),

(10,'Z00', 'General medical examination', true),
(10,'E78', 'Disorders of lipoprotein metabolism', false);


-- 10) PRESCRIPTIONS (15 rows)
-- Uses encounter_id 1..10 and medication_id 1..25
INSERT INTO prescription (encounter_id, medication_id, dosage, frequency, duration_days, prescribed_at) VALUES
(1, 1, '500 mg', 'Thrice daily', 5,  '2025-11-01 09:15'),
(1, 7, '10 mg',  'Once daily',   7,  '2025-11-01 09:15'),

(2, 9, '50 mg',  'Once daily',   30, '2025-11-01 09:45'),

(3, 3, '250 mg', 'Twice daily',  3,  '2025-11-01 10:15'),

(4, 8, '400 mg', 'Twice daily',  10, '2025-11-01 10:45'),

(5, 20, '100 mg','Once daily',   7,  '2025-11-01 11:15'),

(6, 22, '20 mg', 'Once daily',   14, '2025-11-01 11:45'),

(7, 4, '500 mg', 'Twice daily',  30, '2025-11-01 12:15'),
(7, 5, '10 mg',  'Once daily',   30, '2025-11-01 12:15'),

(8, 10,'5 mg',   'Once daily',   30, '2025-11-01 12:45'),

(9, 11,'2 puffs','As needed',    15, '2025-11-01 13:15'),

(10,24,'10 mg',  'Once daily',   30, '2025-11-01 13:45'),
(10,5, '10 mg',  'Once daily',   30, '2025-11-01 13:45'),

(2, 2, '75 mg',  'Once daily',   30, '2025-11-01 09:45'),
(8, 15,'10 mg',  'Once daily',   30, '2025-11-01 12:45');


-- 11) BILLS (10 rows - one per encounter)
-- Uses insurance_id 1..6
INSERT INTO bill (encounter_id, amount, paid, payer_id, created_at) VALUES
(1,  800.00, true,  1, '2025-11-01 11:00'),
(2, 2500.00, false, 2, '2025-11-01 11:00'),
(3,  600.00, true,  3, '2025-11-01 11:00'),
(4, 1500.00, true,  4, '2025-11-01 11:00'),
(5,  900.00, false, 5, '2025-11-01 11:00'),
(6,  700.00, true,  6, '2025-11-01 11:00'),
(7, 2200.00, true,  1, '2025-11-01 11:00'),
(8, 1900.00, false, 2, '2025-11-01 11:00'),
(9, 1300.00, true,  3, '2025-11-01 11:00'),
(10,1100.00, true,  6, '2025-11-01 11:00');

COMMIT;
