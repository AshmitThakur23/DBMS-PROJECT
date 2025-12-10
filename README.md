# 🏥 Hospital EMR Database System

## Complete Guide from Database Setup to Advanced Queries

> **A PostgreSQL-based Electronic Medical Records system for managing hospital operations including patients, providers, appointments, encounters, diagnoses, prescriptions, and billing.**

---

## 📖 Table of Contents

1. [Database Architecture](#database-architecture)
2. [Project File Structure](#project-file-structure)
3. [Database Schema Diagram](#database-schema-diagram)
4. [Setup Instructions](#setup-instructions)
5. [File-by-File Documentation](#file-by-file-documentation)
6. [Data Flow Diagrams](#data-flow-diagrams)
7. [Query Examples by Complexity](#query-examples-by-complexity)

---

## 🏗️ Database Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                   HOSPITAL EMR SYSTEM                       │
│                                                             │
│  ┌──────────┐      ┌──────────┐      ┌──────────┐        │
│  │ PATIENTS │──────│ENCOUNTERS│──────│PROVIDERS │        │
│  └──────────┘      └──────────┘      └──────────┘        │
│       │                  │                  │              │
│       │                  │                  │              │
│       ├─────────┐        ├────┬────┬────────┤              │
│       │         │        │    │    │        │              │
│  ┌────▼───┐ ┌──▼────┐ ┌─▼──┐ │ ┌──▼───┐ ┌──▼────┐       │
│  │APPOINT-│ │ BILLS │ │DIAG│ │ │PRESC-│ │SPECIAL│       │
│  │ MENTS  │ └───────┘ │NOSIS│ │ │RIPT- │ │  TY   │       │
│  └────────┘           └────┘ │ │ IONS │ └───────┘       │
│                              │ └──────┘                   │
│                              │                            │
│                         ┌────▼──────┐                     │
│                         │MEDICATION │                     │
│                         └───────────┘                     │
└─────────────────────────────────────────────────────────────┘
```

---

## 📁 Project File Structure

```
DBMS-PROJECT/
│
├── sql/
│   ├── schema/                    # Database table definitions
│   │   └── (Schema creation files)
│   │
│   ├── seed/                      # Sample data
│   │   └── reset_and_seed.sql    # Main data loading file
│   │
│   ├── queries/                   # Query examples
│   │
│   └── transactions/              # Transaction demos
│       └── 08_transactions. sql   # Concurrency examples
│
├── docs/                          # Documentation
│   ├── 08_concurrency_demo.md    # Transaction guide
│   └── 10_backup_restore.md      # Backup guide
│
├── backups/                       # Database backups
├── reports/                       # Generated reports
├── hospital_emr_local. session.sql # Test queries
└── run_all. sql                   # Master setup script
```

---

## 🗄️ Database Schema Diagram

### **Core Tables and Relationships**

```
┌──────────────────┐
│    specialty     │
│──────────────────│
│ specialty_id (PK)│
│ name             │
└────────┬─────────┘
         │
         │ 1:N
         │
┌────────▼─────────┐         ┌──────────────────┐
│    provider      │         │     patient      │
│──────────────────│         │──────────────────│
│ provider_id (PK) │         │ patient_id (PK)  │
│ first_name       │         │ first_name       │
│ last_name        │         │ last_name        │
│ specialty_id(FK) │         │ dob              │
│ license_number   │         │ gender           │
└────────┬─────────┘         └────────┬─────────┘
         │                            │
         │                            │
         └────────┬───────────────────┘
                  │
                  │ N:1
                  │
         ┌────────▼─────────┐
         │   appointment    │
         │──────────────────│
         │ appointment_id(PK│
         │ patient_id (FK)  │
         │ provider_id (FK) │
         │ start_time       │
         │ end_time         │
         │ status           │
         │ created_at       │
         └──────────────────┘

         ┌────────▼─────────┐
         │   encounter      │
         │──────────────────│
         │ encounter_id (PK)│
         │ patient_id (FK)  │
         │ provider_id (FK) │
         │ encounter_time   │
         │ reason           │
         │ notes            │
         └────┬──┬──┬───────┘
              │  │  │
    ┌─────────┘  │  └─────────┐
    │            │            │
┌───▼──────┐ ┌──▼────────┐ ┌─▼─────────┐
│diagnosis │ │prescription│ │   bill    │
│──────────│ │────────────│ │───────────│
│diagnosis │ │prescript.   │ │ bill_id   │
│_id (PK)  │ │_id (PK)    │ │ encounter │
│encounter │ │encounter   │ │ _id (FK)  │
│_id (FK)  │ │_id (FK)    │ │ amount    │
│code      │ │medication  │ │ paid      │
│descript.  │ │_id (FK)    │ │ payer_id  │
│is_primary│ │dosage      │ │ created_at│
└──────────┘ │frequency   │ └───────────┘
             │duration    │
             └──────┬─────┘
                    │
             ┌──────▼─────┐
             │ medication │
             │────────────│
             │medication  │
             │_id (PK)    │
             │name        │
             │ndc         │
             └────────────┘

┌──────────────────┐
│   insurance      │
│──────────────────│
│ payer_id (PK)    │
│ payer_name       │
│ plan_id          │
└──────────────────┘
```

---

## 🚀 Setup Instructions

### **Step 1: Install PostgreSQL**

Download and install PostgreSQL from [postgresql. org](https://www.postgresql.org/download/)

### **Step 2: Clone Repository**

```bash
git clone https://github.com/AshmitThakur23/DBMS-PROJECT.git
cd DBMS-PROJECT
```

### **Step 3: Create Database**

```bash
psql -U postgres

CREATE DATABASE hospital_emr;
\c hospital_emr
\q
```

### **Step 4: Load Schema & Data**

```bash
psql -U postgres -d hospital_emr -f sql/seed/reset_and_seed.sql
```

**✅ Database is now ready with sample data!**

---

## 📄 File-by-File Documentation

---

### **FILE 1: `sql/seed/reset_and_seed.sql`**

**📌 Purpose:** This is the MAIN file that creates and populates your entire database with sample data.

**🔧 What It Does:**

#### **PART 1: Clean Slate (Lines 1-19)**

```sql
BEGIN;

TRUNCATE TABLE
  bill, prescription, diagnosis, encounter,
  appointment, procedure_tbl, medication,
  insurance, provider, specialty, patient
RESTART IDENTITY CASCADE;
```

**⚡ What Happens:**
- Deletes ALL existing data from all tables
- Resets auto-increment IDs back to 1
- Ensures clean database state

---

#### **PART 2: Insert Specialties (Lines 29-34)**

```sql
INSERT INTO specialty (name) VALUES
  ('General Medicine'),   -- specialty_id = 1
  ('Cardiology'),         -- specialty_id = 2
  ('Pediatrics'),         -- specialty_id = 3
  ('Orthopedics'),        -- specialty_id = 4
  ('Dermatology');        -- specialty_id = 5
```

**⚡ What Happens:**
- Creates 5 medical specialties
- IDs automatically assigned:  1, 2, 3, 4, 5

**📊 Result:**
```
specialty_id | name
-------------+-----------------
     1       | General Medicine
     2       | Cardiology
     3       | Pediatrics
     4       | Orthopedics
     5       | Dermatology
```

---

#### **PART 3: Insert Providers (Lines 37-53)**

```sql
INSERT INTO provider (first_name, last_name, specialty_id) VALUES
  ('Amit','Sharma', 1),    -- General Medicine doctor
  ('Neha','Gupta', 2),     -- Cardiology doctor
  ('Rohan','Verma', 3),    -- Pediatrics doctor
  ...  (15 total providers)
```

**⚡ What Happens:**
- Creates 15 healthcare providers (doctors)
- Links each to a specialty via `specialty_id`
- Provider IDs:  1-15

**📊 Result:**
```
provider_id | first_name | last_name | specialty_id
------------+------------+-----------+-------------
     1      | Amit       | Sharma    |      1
     2      | Neha       | Gupta     |      2
     3      | Rohan      | Verma     |      3
```

---

#### **PART 4: Insert Patients (Lines 56-138)**

```sql
INSERT INTO patient (first_name, last_name, dob, gender) VALUES
('Siddharth','Verma','1998-05-12','M'),
('Priya','Singh','2002-11-03','F'),
('Manish','Kumar','1975-02-20','M'),
... (80 total patients)
```

**⚡ What Happens:**
- Creates 80 patient records
- Each has: first name, last name, date of birth, gender
- Patient IDs: 1-80

**📊 Result:**
```
patient_id | first_name | last_name | dob        | gender
-----------+------------+-----------+------------+-------
     1     | Siddharth  | Verma     | 1998-05-12 |   M
     2     | Priya      | Singh     | 2002-11-03 |   F
```

---

#### **PART 5: Insert Medications (Lines 141-165)**

```sql
INSERT INTO medication (name, ndc) VALUES
('Paracetamol','NDC001'),
('Aspirin','NDC002'),
('Amoxicillin','NDC003'),
... (25 total medications)
```

**⚡ What Happens:**
- Creates medication inventory
- NDC = National Drug Code (unique identifier)
- Medication IDs: 1-25

**📊 Result:**
```
medication_id | name        | ndc
--------------+-------------+--------
      1       | Paracetamol | NDC001
      2       | Aspirin     | NDC002
      3       | Amoxicillin | NDC003
```

---

#### **PART 6: Insert Insurance (Lines 168-176)**

```sql
INSERT INTO insurance (payer_name, plan_id) VALUES
('BlueShield','BS-P1'),
('UnitedHealth','UH-P2'),
('Medicare','MC-P3'),
... (6 total insurance companies)
```

**⚡ What Happens:**
- Creates 6 insurance payers
- Used for billing

**📊 Result:**
```
payer_id | payer_name     | plan_id
---------+----------------+---------
    1    | BlueShield     | BS-P1
    2    | UnitedHealth   | UH-P2
```

---

#### **PART 7: Insert Appointments (Lines 183-209)**

```sql
INSERT INTO appointment (patient_id, provider_id, start_time, end_time, status, created_at) VALUES
(1, 1, '2025-11-01 09:00', '2025-11-01 09:30', 'COMPLETED', '2025-10-25 10:00'),
(2, 2, '2025-11-01 09:30', '2025-11-01 10:00', 'SCHEDULED', '2025-10-25 10:05'),
(3, 3, '2025-11-01 10:00', '2025-11-01 10:30', 'NOSHOW', '2025-10-25 10:10'),
... (20 total appointments)
```

**⚡ What Happens:**
- Books 20 appointments between patients and providers
- Status types: COMPLETED, SCHEDULED, NOSHOW, RESCHEDULED

**📊 Result:**
```
appointment_id | patient_id | provider_id | start_time          | status
---------------+------------+-------------+---------------------+-----------
      1        |     1      |      1      | 2025-11-01 09:00:00 | COMPLETED
      2        |     2      |      2      | 2025-11-01 09:30:00 | SCHEDULED
```

---

#### **PART 8: Insert Encounters (Lines 212-218)**

```sql
INSERT INTO encounter (patient_id, provider_id, encounter_time, reason, notes) VALUES
(1, 1, '2025-11-01 09:10', 'Fever and cough', 'Initial visit for fever'),
(2, 2, '2025-11-01 09:40', 'Chest pain', 'ECG advised'),
...  (10 total encounters)
```

**⚡ What Happens:**
- Creates 10 actual medical visit records
- Each has reason for visit and doctor's notes
- These are COMPLETED appointments

**📊 Result:**
```
encounter_id | patient_id | provider_id | reason          | notes
-------------+------------+-------------+-----------------+----------------------
      1      |     1      |      1      | Fever and cough | Initial visit for... 
      2      |     2      |      2      | Chest pain      | ECG advised
```

---

#### **PART 9: Insert Diagnoses (Lines 225-259)**

```sql
INSERT INTO diagnosis (encounter_id, code, description, is_primary) VALUES
(1, 'J10', 'Influenza', true),      -- Primary diagnosis
(1, 'R50', 'Fever', false),         -- Secondary diagnosis

(2, 'I20', 'Angina', true),
(2, 'R07', 'Chest pain', false),
...  (20 total diagnoses - 2 per encounter)
```

**⚡ What Happens:**
- Each encounter gets 2 diagnoses (1 primary + 1 secondary)
- Uses ICD-10 codes (J10, I20, etc.)
- Total:  20 diagnosis records

**📊 Result:**
```
diagnosis_id | encounter_id | code | description | is_primary
-------------+--------------+------+-------------+-----------
      1      |      1       | J10  | Influenza   |   true
      2      |      1       | R50  | Fever       |   false
```

---

#### **PART 10: Insert Prescriptions (Lines 262-286)**

```sql
INSERT INTO prescription (encounter_id, medication_id, dosage, frequency, duration_days, prescribed_at) VALUES
(1, 1, '500 mg', 'Thrice daily', 5, '2025-11-01 09:15'),  -- Paracetamol
(1, 7, '10 mg', 'Once daily', 7, '2025-11-01 09:15'),     -- Cetirizine
... (15 total prescriptions)
```

**⚡ What Happens:**
- Links encounters to medications
- Specifies:  dosage, frequency, duration
- Some encounters have multiple prescriptions

**📊 Result:**
```
prescription_id | encounter_id | medication_id | dosage  | frequency     | duration_days
----------------+--------------+---------------+---------+---------------+--------------
       1        |      1       |       1       | 500 mg  | Thrice daily  |      5
       2        |      1       |       7       | 10 mg   | Once daily    |      7
```

---

#### **PART 11: Insert Bills (Lines 289-301)**

```sql
INSERT INTO bill (encounter_id, amount, paid, payer_id, created_at) VALUES
(1, 800. 00, true, 1, '2025-11-01 11:00'),     -- Paid via insurance 1
(2, 2500.00, false, 2, '2025-11-01 11:00'),   -- UNPAID
... (10 total bills)
```

**⚡ What Happens:**
- Generates bill for each encounter
- Tracks payment status (true = paid, false = unpaid)
- Links to insurance payer

**📊 Result:**
```
bill_id | encounter_id | amount  | paid  | payer_id
--------+--------------+---------+-------+---------
   1    |      1       | 800.00  | true  |    1
   2    |      2       | 2500.00 | false |    2
```

---

#### **FINAL STEP:  Commit Transaction**

```sql
COMMIT;
```

**⚡ What Happens:**
- Saves all changes permanently
- Database now has complete sample dataset

---

### **FILE 2: `hospital_emr_local.session. sql`**

**📌 Purpose:** Quick test queries to verify database setup

#### **Query 1: Select Patient by ID**

```sql
SELECT * FROM patient WHERE patient_id = 1;
```

**⚡ What It Does:** Retrieves all data for patient #1  
**📊 Output:** Shows Siddharth Verma's complete record

---

#### **Query 2: Insert Patient**

```sql
INSERT INTO patient (patient_id, first_name, last_name, dob, gender)
VALUES (1, 'Siddharth', 'Verma', '1998-05-12', 'M');
```

**⚡ What It Does:** Adds or updates patient record  
**📊 Output:** Patient added to database

---

#### **Query 3: Count All Records**

```sql
SELECT 'patient' AS t, COUNT(*) FROM patient;
SELECT 'provider' AS t, COUNT(*) FROM provider;
SELECT 'appointment' AS t, COUNT(*) FROM appointment;
SELECT 'encounter' AS t, COUNT(*) FROM encounter;
SELECT 'diagnosis' AS t, COUNT(*) FROM diagnosis;
SELECT 'prescription' AS t, COUNT(*) FROM prescription;
SELECT 'bill' AS t, COUNT(*) FROM bill;
SELECT 'medication' AS t, COUNT(*) FROM medication;
```

**⚡ What It Does:** Counts rows in each table to verify data loaded  
**📊 Expected Output:**
```
      t        | count
---------------+-------
patient        |   80
provider       |   15
appointment    |   20
encounter      |   10
diagnosis      |   20
prescription   |   15
bill           |   10
medication     |   25
```

---

#### **Query 4: View Patients with Full Names**

```sql
SELECT 
  patient_id,
  first_name || ' ' || last_name AS full_name,
  dob,
  gender
FROM patient
ORDER BY patient_id
LIMIT 50;
```

**⚡ What It Does:** 
- Concatenates first + last name
- Shows first 50 patients
- Ordered by ID

**📊 Output:**
```
patient_id | full_name        | dob        | gender
-----------+------------------+------------+-------
    1      | Siddharth Verma  | 1998-05-12 |   M
    2      | Priya Singh      | 2002-11-03 |   F
```

---

### **FILE 3: `sql/transactions/08_transactions.sql`**

**📌 Purpose:** Demonstrates database transactions and concurrency control

#### **Part 1: Atomic Transaction Example**

```sql
BEGIN;

INSERT INTO appointment (patient_id, provider_id, start_time, end_time, status)
VALUES (1, 1, now() + interval '4 hours', now() + interval '4 hours' + interval '30 minutes', 'SCHEDULED')
RETURNING appointment_id;

INSERT INTO bill (encounter_id, amount, paid, payer_id)
VALUES (NULL, 1000.00, false, NULL);

COMMIT;
```

**⚡ What It Does:**
- Books appointment AND creates bill together
- Either BOTH succeed or BOTH fail
- Ensures data consistency

**📊 Use Case:** When booking appointment fails, bill won't be created

---

#### **Part 2: Deadlock Demonstration**

Shows what happens when two users try to update different tables in opposite order.

**❌ Problem:** Can cause database deadlock  
**✅ Solution:** Always lock tables in same order

---

### **FILE 4: `docs/08_concurrency_demo.md`**

**📌 Purpose:** Documentation explaining transaction concepts

**Topics Covered:**
- Atomic operations (all-or-nothing)
- Deadlock scenarios
- How to fix deadlocks
- Best practices for concurrent access

---

### **FILE 5: `docs/10_backup_restore.md`**

**📌 Purpose:** Complete backup and restore guide

#### **Create Backup**

```bash
"C:\Program Files\PostgreSQL\17\bin\pg_dump.exe" -U postgres -d hospital_emr -F p -f "backups/hospital_emr_backup. sql"
```

**⚡ What It Does:**
- Creates SQL dump of entire database
- Saves to `backups/` folder
- Human-readable format

---

#### **Restore Backup**

```bash
"C:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres -d hospital_emr -f "backups/hospital_emr_backup.sql"
```

**⚡ What It Does:**
- Restores database from backup file
- Recovers deleted data
- Returns database to previous state

---

### **FILE 6: `run_all. sql`**

**📌 Purpose:** Master script to run all setup files in order (currently empty - needs population)

**Suggested Content:**

```sql
-- Run all setup scripts in correct order
\echo 'Starting Hospital EMR Database Setup...'

\echo 'Step 1: Loading schema...'
\i sql/schema/create_tables.sql

\echo 'Step 2: Loading sample data...'
\i sql/seed/reset_and_seed. sql

\echo 'Step 3: Verifying data.. .'
SELECT 'patient' AS table_name, COUNT(*) FROM patient
UNION ALL
SELECT 'provider', COUNT(*) FROM provider;

\echo 'Setup complete!'
```

---

## 🔄 Data Flow Diagrams

### **Patient Visit Workflow**

```
┌─────────────────────────────────────────────────────────────┐
│                    PATIENT JOURNEY                          │
└─────────────────────────────────────────────────────────────┘

STEP 1: PATIENT REGISTRATION
┌──────────────┐
│ New patient  │
│ walks in     │
└──────┬───────┘
       │
       ▼
┌──────────────────────────────────────┐
│ INSERT INTO patient                  │
│ (first_name, last_name, dob, gender) │
└──────┬───────────────────────────────┘
       │
       │ patient_id = 81 assigned
       │
       
STEP 2: BOOK APPOINTMENT
       │
       ▼
┌──────────────────────────────────────┐
│ INSERT INTO appointment              │
│ (patient_id=81, provider_id=2,       │
│  start_time, end_time, status)       │
└──────┬───────────────────────────────┘
       │
       │ appointment_id = 21 assigned
       │
       
STEP 3: PATIENT ARRIVES
       │
       ▼
┌──────────────────────────────────────┐
│ UPDATE appointment                   │
│ SET status = 'COMPLETED'             │
│ WHERE appointment_id = 21            │
└──────┬───────────────────────────────┘
       │
       ▼
┌──────────────────────────────────────┐
│ INSERT INTO encounter                │
│ (patient_id=81, provider_id=2,       │
│  reason='Chest pain', notes=...)     │
└──────┬───────────────────────────────┘
       │
       │ encounter_id = 11 assigned
       │
       
STEP 4: DOCTOR DIAGNOSES
       │
       ▼
┌──────────────────────────────────────┐
│ INSERT INTO diagnosis                │
│ (encounter_id=11, code='I20',        │
│  description='Angina', primary=true) │
└──────┬───────────────────────────────┘
       │
       
STEP 5: PRESCRIBE MEDICATION
       │
       ▼
┌──────────────────────────────────────┐
│ INSERT INTO prescription             │
│ (encounter_id=11, medication_id=9,   │
│  dosage='50mg', frequency='daily')   │
└──────┬───────────────────────────────┘
       │
       
STEP 6: GENERATE BILL
       │
       ▼
┌──────────────────────────────────────┐
│ INSERT INTO bill                     │
│ (encounter_id=11, amount=2500,       │
│  paid=false, payer_id=2)             │
└──────────────────────────────────────┘

✅ PATIENT VISIT COMPLETE! 
```

---

## 📊 Query Examples by Complexity

### **BEGINNER LEVEL**

#### **1. View All Patients**

```sql
SELECT * FROM patient;
```

**Output:** All 80 patients with complete details

---

#### **2. Count Patients by Gender**

```sql
SELECT gender, COUNT(*) as total
FROM patient
GROUP BY gender;
```

**Output:**
```
gender | total
-------+------
  M    |  40
  F    |  40
```

---

#### **3. List All Medications**

```sql
SELECT medication_id, name, ndc
FROM medication
ORDER BY name;
```

**Output:** Alphabetical list of all 25 medications

---

### **INTERMEDIATE LEVEL**

#### **4. Patient Full Name with Age**

```sql
SELECT 
  patient_id,
  first_name || ' ' || last_name AS full_name,
  dob,
  EXTRACT(YEAR FROM AGE(dob)) AS age,
  gender
FROM patient
ORDER BY age DESC;
```

**⚡ What It Does:**
- Combines first + last name
- Calculates age from date of birth
- Sorts by age (oldest first)

**Output:**
```
patient_id | full_name       | dob        | age | gender
-----------+-----------------+------------+-----+-------
    3      | Manish Kumar    | 1975-02-20 | 49  |   M
   33      | Ravi Agarwal    | 1983-05-29 | 41  |   M
```

---

#### **5. Appointments by Status**

```sql
SELECT 
  status,
  COUNT(*) as count,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) as percentage
FROM appointment
GROUP BY status
ORDER BY count DESC;
```

**⚡ What It Does:**
- Counts appointments by status
- Calculates percentage distribution
- Shows most common status first

**Output:**
```
status      | count | percentage
------------+-------+-----------
COMPLETED   |   10  |  50.00
SCHEDULED   |    5  |  25.00
NOSHOW      |    3  |  15.00
RESCHEDULED |    2  |  10.00
```

---

#### **6. Provider Workload**

```sql
SELECT 
  p.first_name || ' ' || p.last_name AS provider_name,
  s.name AS specialty,
  COUNT(a.appointment_id) AS total_appointments,
  COUNT(CASE WHEN a.status = 'COMPLETED' THEN 1 END) AS completed,
  COUNT(CASE WHEN a.status = 'NOSHOW' THEN 1 END) AS no_shows
FROM provider p
JOIN specialty s ON p.specialty_id = s.specialty_id
LEFT JOIN appointment a ON p.provider_id = a.provider_id
GROUP BY p.provider_id, p.first_name, p.last_name, s.name
ORDER BY total_appointments DESC;
```

**⚡ What It Does:**
- Shows each provider's appointment load
- Breaks down by status
- Identifies busiest providers

**Output:**
```
provider_name | specialty        | total_appointments | completed | no_shows
--------------+------------------+--------------------+-----------+---------
Amit Sharma   | General Medicine |         5          |     4     |    1
Neha Gupta    | Cardiology       |         4          |     3     |    0
```

---

### **ADVANCED LEVEL**

#### **7. Complete Patient Medical History**

```sql
SELECT 
  pt.patient_id,
  pt.first_name || ' ' || pt.last_name AS patient_name,
  e.encounter_time,
  pr.first_name || ' ' || pr. last_name AS provider,
  s.name AS specialty,
  e.reason AS visit_reason,
  d.code AS diagnosis_code,
  d.description AS diagnosis,
  d.is_primary,
  m.name AS medication,
  p.dosage,
  p.frequency,
  b.amount AS bill_amount,
  b.paid AS bill_paid
FROM patient pt
LEFT JOIN encounter e ON pt.patient_id = e.patient_id
LEFT JOIN provider pr ON e.provider_id = pr.provider_id
LEFT JOIN specialty s ON pr.specialty_id = s. specialty_id
LEFT JOIN diagnosis d ON e.encounter_id = d.encounter_id
LEFT JOIN prescription p ON e.encounter_id = p.encounter_id
LEFT JOIN medication m ON p.medication_id = m.medication_id
LEFT JOIN bill b ON e.encounter_id = b.encounter_id
WHERE pt.patient_id = 1
ORDER BY e.encounter_time DESC;
```

**⚡ What It Does:**
- Shows COMPLETE medical history for one patient
- Includes:  visits, diagnoses, prescriptions, bills
- Joins 8 different tables
- Most recent visits first

**Output:** Full medical record for patient #1

---

#### **8. Revenue Analysis**

```sql
SELECT 
  DATE(e.encounter_time) AS visit_date,
  COUNT(DISTINCT e.encounter_id) AS total_encounters,
  SUM(b.amount) AS total_billed,
  SUM(CASE WHEN b.paid THEN b.amount ELSE 0 END) AS collected,
  SUM(CASE WHEN NOT b.paid THEN b.amount ELSE 0 END) AS outstanding,
  ROUND(
    SUM(CASE WHEN b.paid THEN b.amount ELSE 0 END) * 100.0 / 
    NULLIF(SUM(b.amount), 0), 
    2
  ) AS collection_rate
FROM encounter e
LEFT JOIN bill b ON e.encounter_id = b.encounter_id
GROUP BY DATE(e.encounter_time)
ORDER BY visit_date;
```

**⚡ What It Does:**
- Daily financial summary
- Shows:  billed vs collected vs outstanding
- Calculates collection rate percentage

**Output:**
```
visit_date | total_encounters | total_billed | collected | outstanding | collection_rate
-----------+------------------+--------------+-----------+-------------+----------------
2025-11-01 |        10        |   11900. 00   |  7100.00  |   4800.00   |     59.66
```

---

#### **9. Most Prescribed Medications**

```sql
SELECT 
  m.name AS medication,
  m.ndc,
  COUNT(p.prescription_id) AS times_prescribed,
  COUNT(DISTINCT e.patient_id) AS unique_patients,
  ROUND(AVG(p.duration_days), 1) AS avg_duration,
  STRING_AGG(DISTINCT p.dosage, ', ' ORDER BY p.dosage) AS common_dosages,
  STRING_AGG(DISTINCT p.frequency, ', ' ORDER BY p.frequency) AS common_frequencies
FROM medication m
LEFT JOIN prescription p ON m.medication_id = p.medication_id
LEFT JOIN encounter e ON p.encounter_id = e.encounter_id
GROUP BY m.medication_id, m.name, m.ndc
HAVING COUNT(p.prescription_id) > 0
ORDER BY times_prescribed DESC
LIMIT 10;
```

**⚡ What It Does:**
- Analyzes prescription patterns
- Shows most commonly prescribed drugs
- Average treatment duration
- Common dosages

**Output:**
```
medication  | ndc    | times_prescribed | unique_patients | avg_duration | common_dosages
------------+--------+------------------+-----------------+--------------+---------------
Atorvastatin| NDC005 |        3         |        3        |    30.0      | 10 mg
Paracetamol | NDC001 |        2         |        2        |     6.0      | 500 mg
```

---

#### **10. Patient No-Show Risk Analysis**

```sql
WITH patient_stats AS (
  SELECT 
    pt.patient_id,
    pt.first_name || ' ' || pt.last_name AS patient_name,
    COUNT(a.appointment_id) AS total_appointments,
    COUNT(CASE WHEN a.status = 'NOSHOW' THEN 1 END) AS no_shows,
    COUNT(CASE WHEN a.status = 'COMPLETED' THEN 1 END) AS completed,
    MIN(a.start_time) AS first_appointment,
    MAX(a.start_time) AS last_appointment
  FROM patient pt
  LEFT JOIN appointment a ON pt.patient_id = a. patient_id
  GROUP BY pt.patient_id, pt.first_name, pt.last_name
)
SELECT 
  patient_name,
  total_appointments,
  completed,
  no_shows,
  ROUND(no_shows * 100.0 / NULLIF(total_appointments, 0), 2) AS no_show_rate,
  CASE 
    WHEN no_shows * 100.0 / NULLIF(total_appointments, 0) > 50 THEN 'HIGH RISK'
    WHEN no_shows * 100.0 / NULLIF(total_appointments, 0) > 25 THEN 'MEDIUM RISK'
    ELSE 'LOW RISK'
  END AS risk_category
FROM patient_stats
WHERE total_appointments > 0
ORDER BY no_show_rate DESC;
```

**⚡ What It Does:**
- Identifies unreliable patients
- Calculates no-show percentage
- Categorizes risk level
- Helps scheduling optimization

**Output:**
```
patient_name     | total_appointments | completed | no_shows | no_show_rate | risk_category
-----------------+--------------------+-----------+----------+--------------+--------------
Manish Kumar     |         1          |     0     |    1     |   100.00     | HIGH RISK
Siddharth Verma  |         2          |     2     |    0     |     0.00     | LOW RISK
```

---

## 🎯 Common Use Cases

### **Use Case 1: Book New Appointment**

```sql
-- Step 1: Check provider availability
SELECT provider_id, first_name, last_name, specialty_id
FROM provider
WHERE specialty_id = 2;  -- Cardiology

-- Step 2: Book appointment
INSERT INTO appointment (patient_id, provider_id, start_time, end_time, status, created_at)
VALUES (5, 2, '2025-12-15 10:00', '2025-12-15 10:30', 'SCHEDULED', NOW());

-- Step 3: Verify booking
SELECT * FROM appointment WHERE appointment_id = (SELECT MAX(appointment_id) FROM appointment);
```

---

### **Use Case 2: Complete Patient Visit**

```sql
-- Step 1: Create encounter
INSERT INTO encounter (patient_id, provider_id, encounter_time, reason, notes)
VALUES (5, 2, NOW(), 'Chest pain', 'Patient reports intermittent chest pain for 2 days');

-- Step 2: Add diagnosis
INSERT INTO diagnosis (encounter_id, code, description, is_primary)
VALUES (
  (SELECT MAX(encounter_id) FROM encounter),
  'I20',
  'Angina pectoris',
  true
);

-- Step 3: Prescribe medication
INSERT INTO prescription (encounter_id, medication_id, dosage, frequency, duration_days, prescribed_at)
VALUES (
  (SELECT MAX(encounter_id) FROM encounter),
  9,  -- Losartan
  '50 mg',
  'Once daily',
  30,
  NOW()
);

-- Step 4: Generate bill
INSERT INTO bill (encounter_id, amount, paid, payer_id, created_at)
VALUES (
  (SELECT MAX(encounter_id) FROM encounter),
  2500.00,
  false,
  2,  -- UnitedHealth insurance
  NOW()
);
```

---

### **Use Case 3: Search Patients**

```sql
-- By name (partial match)
SELECT * FROM patient 
WHERE first_name ILIKE '%raj%' OR last_name ILIKE '%raj%';

-- By age range
SELECT *, EXTRACT(YEAR FROM AGE(dob)) AS age
FROM patient
WHERE EXTRACT(YEAR FROM AGE(dob)) BETWEEN 25 AND 35
ORDER BY dob;

-- Patients with upcoming appointments
SELECT DISTINCT 
  pt.patient_id,
  pt.first_name || ' ' || pt.last_name AS name,
  a.start_time
FROM patient pt
JOIN appointment a ON pt.patient_id = a.patient_id
WHERE a.status = 'SCHEDULED' AND a.start_time > NOW()
ORDER BY a.start_time;
```

---

## ✅ Verification Checklist

After setup, run these queries to verify everything works: 

```sql
-- ✅ Check all tables have data
SELECT 'specialty' AS table_name, COUNT(*) FROM specialty
UNION ALL SELECT 'provider', COUNT(*) FROM provider
UNION ALL SELECT 'patient', COUNT(*) FROM patient
UNION ALL SELECT 'medication', COUNT(*) FROM medication
UNION ALL SELECT 'insurance', COUNT(*) FROM insurance
UNION ALL SELECT 'appointment', COUNT(*) FROM appointment
UNION ALL SELECT 'encounter', COUNT(*) FROM encounter
UNION ALL SELECT 'diagnosis', COUNT(*) FROM diagnosis
UNION ALL SELECT 'prescription', COUNT(*) FROM prescription
UNION ALL SELECT 'bill', COUNT(*) FROM bill;

-- ✅ Check foreign key relationships
SELECT 
  COUNT(*) AS appointments_with_valid_patients
FROM appointment a
JOIN patient p ON a.patient_id = p.patient_id
JOIN provider pr ON a.provider_id = pr.provider_id;

-- ✅ Check data integrity
SELECT 
  'Encounters without diagnosis' AS check_type,
  COUNT(*) AS count
FROM encounter e
LEFT JOIN diagnosis d ON e. encounter_id = d.encounter_id
WHERE d.diagnosis_id IS NULL;
```

**Expected Results:**
- All tables should have data (counts > 0)
- All foreign keys should match
- No orphaned records

---

## 📚 Additional Resources

- **PostgreSQL Documentation:** https://www.postgresql.org/docs/
- **ICD-10 Diagnosis Codes:** https://www.cdc.gov/nchs/icd/icd-10-cm.htm
- **NDC Medication Codes:** https://www.fda.gov/drugs/drug-approvals-and-databases/national-drug-code-directory

---

## 🙋 FAQ

**Q: How do I reset the database?**  
A: Run `sql/seed/reset_and_seed.sql` again - it will truncate and reload all data.

**Q: Can I add more sample data?**  
A: Yes!  Just add more INSERT statements to `reset_and_seed.sql` following the same pattern.

**Q:  How do I backup my database?**  
A: See `docs/10_backup_restore.md` for complete instructions.

**Q: What if I get foreign key errors?**  
A:  Make sure you insert data in the correct order:  specialty → provider → patient → appointments → encounters → diagnoses/prescriptions/bills

---

## 🎓 Learning Path

1. **Beginner:** Start with basic SELECT queries on single tables
2. **Intermediate:** Practice JOIN queries combining 2-3 tables
3. **Advanced:** Write complex queries with CTEs, window functions, and aggregations
4. **Expert:** Implement transactions, stored procedures, and optimization

---

**🎉 You're all set!  Your Hospital EMR Database is ready to use.**

For questions or issues, refer to the documentation files in the `docs/` folder. 
