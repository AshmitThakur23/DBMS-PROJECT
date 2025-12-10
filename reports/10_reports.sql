-- 10_reports.sql
-- Reports to export (run with SQLTools in VS Code or via psql)

-- R1: No-show rate trend by day (last 30 days)
SELECT
  date_trunc('day', start_time) AS day,
  COUNT(*) FILTER (WHERE status = 'NOSHOW') AS no_shows,
  COUNT(*) AS total,
  ROUND(100.0 * COUNT(*) FILTER (WHERE status = 'NOSHOW') / NULLIF(COUNT(*),0),2) AS no_show_pct
FROM appointment
WHERE start_time >= now() - interval '30 days'
GROUP BY day
ORDER BY day;

-- R2: Top 10 diagnoses (most frequent)
SELECT d.code, d.description, COUNT(*) AS occurrences
FROM diagnosis d
GROUP BY d.code, d.description
ORDER BY occurrences DESC
LIMIT 10;

-- R3: Drug utilization counts by month (last 12 months)
SELECT
  date_trunc('month', pr.prescribed_at) AS month,
  m.name AS medication,
  COUNT(*) AS prescriptions
FROM prescription pr
JOIN medication m ON pr.medication_id = m.medication_id
WHERE pr.prescribed_at >= now() - interval '12 months'
GROUP BY month, m.name
ORDER BY month DESC, prescriptions DESC;

-- R4: Patients with >=3 encounters in last 12 months (chronic)
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

-- R5: Revenue by payer (insurance)
SELECT
  COALESCE(i.payer_name, 'SELF PAY') AS payer,
  COUNT(b.bill_id) AS bills,
  SUM(b.amount) AS total_amount,
  SUM(CASE WHEN b.paid THEN b.amount ELSE 0 END) AS total_paid
FROM bill b
LEFT JOIN insurance i ON b.payer_id = i.insurance_id
GROUP BY payer
ORDER BY total_amount DESC;

-- R6: Provider daily schedule (for a specific date)
-- Replace '2025-11-29' with desired date or use date_trunc('day', now())
SELECT a.appointment_id, p.first_name || ' ' || p.last_name AS patient,
       pr.first_name || ' ' || pr.last_name AS provider,
       a.start_time, a.end_time, a.status
FROM appointment a
JOIN patient p ON a.patient_id = p.patient_id
JOIN provider pr ON a.provider_id = pr.provider_id
WHERE a.start_time::date = CURRENT_DATE
ORDER BY a.start_time;
