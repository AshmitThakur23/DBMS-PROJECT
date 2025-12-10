-- Patients table
CREATE TABLE IF NOT EXISTS patient (
    patient_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name  VARCHAR(100) NOT NULL,
    dob DATE,
    gender VARCHAR(10)
);

-- Specialty table
CREATE TABLE IF NOT EXISTS specialty (
    specialty_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

-- Provider table
CREATE TABLE IF NOT EXISTS provider (
    provider_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name  VARCHAR(100) NOT NULL,
    specialty_id INT REFERENCES specialty(specialty_id)
);

-- Appointment table
CREATE TABLE IF NOT EXISTS appointment (
    appointment_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES patient(patient_id),
    provider_id INT REFERENCES provider(provider_id),
    start_time TIMESTAMP NOT NULL,
    end_time   TIMESTAMP NOT NULL,
    status VARCHAR(50) DEFAULT 'SCHEDULED',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Encounter table
CREATE TABLE IF NOT EXISTS encounter (
    encounter_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES patient(patient_id) ON DELETE CASCADE,
    provider_id INT REFERENCES provider(provider_id),
    encounter_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reason TEXT,
    notes TEXT
);

-- Diagnosis
CREATE TABLE IF NOT EXISTS diagnosis (
    diagnosis_id SERIAL PRIMARY KEY,
    encounter_id INT REFERENCES encounter(encounter_id) ON DELETE CASCADE,
    code VARCHAR(50),
    description TEXT,
    is_primary BOOLEAN DEFAULT FALSE
);

-- Procedure
CREATE TABLE IF NOT EXISTS procedure_tbl (
    procedure_id SERIAL PRIMARY KEY,
    encounter_id INT REFERENCES encounter(encounter_id) ON DELETE CASCADE,
    code VARCHAR(50),
    description TEXT,
    performed_at TIMESTAMP
);

-- Medication
CREATE TABLE IF NOT EXISTS medication (
    medication_id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    ndc VARCHAR(50)
);

-- Prescription
CREATE TABLE IF NOT EXISTS prescription (
    prescription_id SERIAL PRIMARY KEY,
    encounter_id INT REFERENCES encounter(encounter_id),
    medication_id INT REFERENCES medication(medication_id),
    dosage VARCHAR(100),
    frequency VARCHAR(100),
    duration_days INT,
    prescribed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insurance
CREATE TABLE IF NOT EXISTS insurance (
    insurance_id SERIAL PRIMARY KEY,
    payer_name VARCHAR(255) NOT NULL,
    plan_id VARCHAR(100)
);

-- Bill
CREATE TABLE IF NOT EXISTS bill (
    bill_id SERIAL PRIMARY KEY,
    encounter_id INT REFERENCES encounter(encounter_id),
    amount NUMERIC(12,2) DEFAULT 0,
    paid BOOLEAN DEFAULT FALSE,
    payer_id INT REFERENCES insurance(insurance_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
