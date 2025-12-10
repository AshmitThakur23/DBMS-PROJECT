-- Q1: Daily Provider Schedule with patient names
SELECT 
    a.appointment_id,
    p.first_name || ' ' || p.last_name AS patient,
    pr.first_name || ' ' || pr.last_name AS provider,
    a.start_time,
    a.end_time,
    a.status
FROM appointment a
JOIN patient p ON a.patient_id = p.patient_id
JOIN provider pr ON a.provider_id = pr.provider_id
ORDER BY a.start_time;


-- Q2: Appointment count per provider
SELECT 
    pr.first_name || ' ' || pr.last_name AS provider,
    COUNT(*) AS total_appointments
FROM appointment a
JOIN provider pr ON a.provider_id = pr.provider_id
GROUP BY provider
ORDER BY total_appointments DESC;



-- Q3: Patients seen by each provider
SELECT DISTINCT
    pr.first_name || ' ' || pr.last_name AS provider,
    p.first_name || ' ' || p.last_name AS patient
FROM appointment a
JOIN provider pr ON a.provider_id = pr.provider_id
JOIN patient p ON a.patient_id = p.patient_id
ORDER BY provider, patient;




-- Q4: No-show rate by provider (clinic approximate by provider's specialty)
-- no-show = status = 'NOSHOW'
SELECT
  s.name AS specialty,
  pr.first_name || ' ' || pr.last_name AS provider,
  COUNT(*) FILTER (WHERE a.status = 'NOSHOW') AS no_shows,
  COUNT(*) AS total_appts,
  ROUND(100.0 * COUNT(*) FILTER (WHERE a.status = 'NOSHOW') / NULLIF(COUNT(*),0),2) AS no_show_pct
FROM appointment a
JOIN provider pr ON a.provider_id = pr.provider_id
LEFT JOIN specialty s ON pr.specialty_id = s.specialty_id
GROUP BY s.name, provider
ORDER BY no_show_pct DESC;

-- Q5: Average wait time per specialty (assumes encounter_time is check-in and appointment.start_time is scheduled)
-- avg_wait = actual_checkin - scheduled_start; here we approximate using encounter.encounter_time
SELECT
  s.name AS specialty,
  ROUND(AVG(EXTRACT(EPOCH FROM (e.encounter_time - a.start_time)))/60.0,2) AS avg_wait_minutes,
  COUNT(*) AS sample_size
FROM appointment a
JOIN encounter e ON e.patient_id = a.patient_id AND e.encounter_time::date = a.start_time::date
JOIN provider pr ON a.provider_id = pr.provider_id
LEFT JOIN specialty s ON pr.specialty_id = s.specialty_id
WHERE e.encounter_time >= a.start_time - interval '1 day' -- join heuristic
GROUP BY s.name
ORDER BY avg_wait_minutes DESC;

-- Q6: Most common diagnoses by age band (0-17,18-35,36-60,61+)
SELECT
  CASE
    WHEN EXTRACT(YEAR FROM age(p.dob)) <= 17 THEN '0-17'
    WHEN EXTRACT(YEAR FROM age(p.dob)) BETWEEN 18 AND 35 THEN '18-35'
    WHEN EXTRACT(YEAR FROM age(p.dob)) BETWEEN 36 AND 60 THEN '36-60'
    ELSE '61+'
  END AS age_band,
  d.code,
  d.description,
  COUNT(*) AS occurrences
FROM diagnosis d
JOIN encounter e ON d.encounter_id = e.encounter_id
JOIN patient p ON e.patient_id = p.patient_id
GROUP BY age_band, d.code, d.description
ORDER BY age_band, occurrences DESC;

-- Q7: Drug utilization counts by month (medication prescriptions)
SELECT
  date_trunc('month', pr.prescribed_at) AS month,
  m.name AS medication,
  COUNT(*) AS prescriptions
FROM prescription pr
JOIN medication m ON pr.medication_id = m.medication_id
GROUP BY month, m.name
ORDER BY month DESC, prescriptions DESC;

-- Q8: Patients with >= 3 chronic encounters in last 12 months
-- we treat 'chronic' as encounters with same patient > =3 in last 12 months
SELECT
  p.patient_id,
  p.first_name || ' ' || p.last_name AS patient,
  COUNT(*) AS encounters_last_12mo
FROM encounter e
JOIN patient p ON e.patient_id = p.patient_id
WHERE e.encounter_time >= now() - interval '12 months'
GROUP BY p.patient_id, patient
HAVING COUNT(*) >= 3
ORDER BY encounters_last_12mo DESC;

-- Q9: Revenue by payer (insurance) — sum of bills per payer
SELECT
  i.payer_name AS payer,
  COUNT(b.bill_id) AS bills,
  SUM(b.amount) AS total_amount,
  SUM(CASE WHEN b.paid THEN b.amount ELSE 0 END) AS total_paid
FROM bill b
LEFT JOIN insurance i ON b.payer_id = i.insurance_id
GROUP BY payer
ORDER BY total_amount DESC;

-- Q10: Appointments rescheduled within 24h of original start (assumes we track reschedule events via status 'RESCHEDULED' and created_at)
-- Note: this is heuristic — shows appts created/updated within 24 hours of start
SELECT
  a.appointment_id,
  p.first_name || ' ' || p.last_name AS patient,
  pr.first_name || ' ' || pr.last_name AS provider,
  a.start_time,
  a.status,
  a.created_at,
  (a.created_at >= (a.start_time - interval '24 hours')) AS rescheduled_within_24h
FROM appointment a
JOIN patient p ON a.patient_id = p.patient_id
JOIN provider pr ON a.provider_id = pr.provider_id
WHERE a.status = 'RESCHEDULED'
ORDER BY a.created_at DESC;

-- Q11: Prescriptions without follow-up encounter (no encounter after prescription in next X days -> data-quality)
-- find prescriptions where there is no encounter for the same patient in 30 days after prescription date
SELECT
  pr.prescription_id,
  pr.prescribed_at,
  m.name AS medication,
  p.patient_id,
  p.first_name || ' ' || p.last_name AS patient
FROM prescription pr
JOIN medication m ON pr.medication_id = m.medication_id
JOIN encounter e ON pr.encounter_id = e.encounter_id
JOIN patient p ON e.patient_id = p.patient_id
WHERE NOT EXISTS (
  SELECT 1 FROM encounter e2 
  WHERE e2.patient_id = p.patient_id
    AND e2.encounter_time > pr.prescribed_at
    AND e2.encounter_time <= pr.prescribed_at + interval '30 days'
)
ORDER BY pr.prescribed_at DESC;

-- Q12: Providers exceeding 90th percentile in patient load (appointments per provider in last 30 days)
WITH provider_load AS (
  SELECT pr.provider_id, pr.first_name || ' ' || pr.last_name AS provider,
         COUNT(*) AS appts_last_30d
  FROM appointment a
  JOIN provider pr ON a.provider_id = pr.provider_id
  WHERE a.start_time >= now() - interval '30 days'
  GROUP BY pr.provider_id, provider
),
percentile AS (
  SELECT percentile_disc(0.90) WITHIN GROUP (ORDER BY appts_last_30d) AS p90 FROM provider_load
)
SELECT pl.*, p90.p90
FROM provider_load pl, (SELECT percentile_disc(0.90) WITHIN GROUP (ORDER BY appts_last_30d) AS p90 FROM provider_load) p90
WHERE pl.appts_last_30d >= p90.p90
ORDER BY pl.appts_last_30d DESC;

-- Q13: View: vw_patient_summary (a reusable patient summary view)
CREATE OR REPLACE VIEW vw_patient_summary AS
SELECT
  p.patient_id,
  p.first_name || ' ' || p.last_name AS patient_name,
  p.dob,
  EXTRACT(YEAR FROM age(p.dob))::INT AS age,
  COUNT(DISTINCT e.encounter_id) AS total_encounters,
  COUNT(DISTINCT a.appointment_id) AS total_appointments,
  COALESCE(SUM(b.amount),0) AS total_billed
FROM patient p
LEFT JOIN encounter e ON e.patient_id = p.patient_id
LEFT JOIN appointment a ON a.patient_id = p.patient_id
LEFT JOIN encounter e2 ON e2.patient_id = p.patient_id
LEFT JOIN bill b ON b.encounter_id = e2.encounter_id
GROUP BY p.patient_id, p.first_name, p.last_name, p.dob;

