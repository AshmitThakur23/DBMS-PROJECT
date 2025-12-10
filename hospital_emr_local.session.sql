
SELECT * FROM patient WHERE patient_id = 1;
INSERT INTO patient (patient_id, first_name, last_name, dob, gender)
VALUES (1, 'Siddharth', 'Verma', '1998-05-12', 'M');



SELECT 'patient' AS t, COUNT(*) FROM patient;
SELECT 'provider' AS t, COUNT(*) FROM provider;
SELECT 'appointment' AS t, COUNT(*) FROM appointment;
SELECT 'encounter' AS t, COUNT(*) FROM encounter;
SELECT 'diagnosis' AS t, COUNT(*) FROM diagnosis;
SELECT 'prescription' AS t, COUNT(*) FROM prescription;
SELECT 'bill' AS t, COUNT(*) FROM bill;
SELECT 'medication' AS t, COUNT(*) FROM medication;



View all patients
SELECT 
  patient_id,
  first_name || ' ' || last_name AS full_name,
  dob,
  gender
FROM patient
ORDER BY patient_id
LIMIT 50;





