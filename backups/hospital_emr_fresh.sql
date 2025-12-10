--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: appointment; Type: TABLE; Schema: public; Owner: emr_app
--

CREATE TABLE public.appointment (
    appointment_id integer NOT NULL,
    patient_id integer NOT NULL,
    provider_id integer NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone NOT NULL,
    status character varying(20) DEFAULT 'SCHEDULED'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT appointment_time_valid CHECK ((end_time > start_time))
);


ALTER TABLE public.appointment OWNER TO emr_app;

--
-- Name: appointment_appointment_id_seq; Type: SEQUENCE; Schema: public; Owner: emr_app
--

CREATE SEQUENCE public.appointment_appointment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.appointment_appointment_id_seq OWNER TO emr_app;

--
-- Name: appointment_appointment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: emr_app
--

ALTER SEQUENCE public.appointment_appointment_id_seq OWNED BY public.appointment.appointment_id;


--
-- Name: bill; Type: TABLE; Schema: public; Owner: emr_app
--

CREATE TABLE public.bill (
    bill_id integer NOT NULL,
    encounter_id integer,
    amount numeric(12,2) DEFAULT 0 NOT NULL,
    paid boolean DEFAULT false,
    payer_id integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT bill_amount_positive CHECK ((amount >= (0)::numeric))
);


ALTER TABLE public.bill OWNER TO emr_app;

--
-- Name: bill_bill_id_seq; Type: SEQUENCE; Schema: public; Owner: emr_app
--

CREATE SEQUENCE public.bill_bill_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bill_bill_id_seq OWNER TO emr_app;

--
-- Name: bill_bill_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: emr_app
--

ALTER SEQUENCE public.bill_bill_id_seq OWNED BY public.bill.bill_id;


--
-- Name: diagnosis; Type: TABLE; Schema: public; Owner: emr_app
--

CREATE TABLE public.diagnosis (
    diagnosis_id integer NOT NULL,
    encounter_id integer NOT NULL,
    code character varying(50),
    description text,
    is_primary boolean DEFAULT false
);


ALTER TABLE public.diagnosis OWNER TO emr_app;

--
-- Name: diagnosis_diagnosis_id_seq; Type: SEQUENCE; Schema: public; Owner: emr_app
--

CREATE SEQUENCE public.diagnosis_diagnosis_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.diagnosis_diagnosis_id_seq OWNER TO emr_app;

--
-- Name: diagnosis_diagnosis_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: emr_app
--

ALTER SEQUENCE public.diagnosis_diagnosis_id_seq OWNED BY public.diagnosis.diagnosis_id;


--
-- Name: encounter; Type: TABLE; Schema: public; Owner: emr_app
--

CREATE TABLE public.encounter (
    encounter_id integer NOT NULL,
    patient_id integer NOT NULL,
    provider_id integer,
    encounter_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    reason text,
    notes text
);


ALTER TABLE public.encounter OWNER TO emr_app;

--
-- Name: encounter_encounter_id_seq; Type: SEQUENCE; Schema: public; Owner: emr_app
--

CREATE SEQUENCE public.encounter_encounter_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.encounter_encounter_id_seq OWNER TO emr_app;

--
-- Name: encounter_encounter_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: emr_app
--

ALTER SEQUENCE public.encounter_encounter_id_seq OWNED BY public.encounter.encounter_id;


--
-- Name: insurance; Type: TABLE; Schema: public; Owner: emr_app
--

CREATE TABLE public.insurance (
    insurance_id integer NOT NULL,
    payer_name character varying(255) NOT NULL,
    plan_id character varying(100)
);


ALTER TABLE public.insurance OWNER TO emr_app;

--
-- Name: insurance_insurance_id_seq; Type: SEQUENCE; Schema: public; Owner: emr_app
--

CREATE SEQUENCE public.insurance_insurance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.insurance_insurance_id_seq OWNER TO emr_app;

--
-- Name: insurance_insurance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: emr_app
--

ALTER SEQUENCE public.insurance_insurance_id_seq OWNED BY public.insurance.insurance_id;


--
-- Name: medication; Type: TABLE; Schema: public; Owner: emr_app
--

CREATE TABLE public.medication (
    medication_id integer NOT NULL,
    name character varying(255) NOT NULL,
    ndc character varying(50)
);


ALTER TABLE public.medication OWNER TO emr_app;

--
-- Name: medication_medication_id_seq; Type: SEQUENCE; Schema: public; Owner: emr_app
--

CREATE SEQUENCE public.medication_medication_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.medication_medication_id_seq OWNER TO emr_app;

--
-- Name: medication_medication_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: emr_app
--

ALTER SEQUENCE public.medication_medication_id_seq OWNED BY public.medication.medication_id;


--
-- Name: patient; Type: TABLE; Schema: public; Owner: emr_app
--

CREATE TABLE public.patient (
    patient_id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    dob date,
    gender character varying(10),
    CONSTRAINT patient_gender_check CHECK ((((gender)::text = ANY ((ARRAY['M'::character varying, 'F'::character varying, 'O'::character varying])::text[])) OR (gender IS NULL)))
);


ALTER TABLE public.patient OWNER TO emr_app;

--
-- Name: patient_patient_id_seq; Type: SEQUENCE; Schema: public; Owner: emr_app
--

CREATE SEQUENCE public.patient_patient_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patient_patient_id_seq OWNER TO emr_app;

--
-- Name: patient_patient_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: emr_app
--

ALTER SEQUENCE public.patient_patient_id_seq OWNED BY public.patient.patient_id;


--
-- Name: prescription; Type: TABLE; Schema: public; Owner: emr_app
--

CREATE TABLE public.prescription (
    prescription_id integer NOT NULL,
    encounter_id integer,
    medication_id integer,
    dosage character varying(100),
    frequency character varying(100),
    duration_days integer,
    prescribed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT prescription_duration_valid CHECK ((duration_days >= 0))
);


ALTER TABLE public.prescription OWNER TO emr_app;

--
-- Name: prescription_prescription_id_seq; Type: SEQUENCE; Schema: public; Owner: emr_app
--

CREATE SEQUENCE public.prescription_prescription_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.prescription_prescription_id_seq OWNER TO emr_app;

--
-- Name: prescription_prescription_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: emr_app
--

ALTER SEQUENCE public.prescription_prescription_id_seq OWNED BY public.prescription.prescription_id;


--
-- Name: procedure_tbl; Type: TABLE; Schema: public; Owner: emr_app
--

CREATE TABLE public.procedure_tbl (
    procedure_id integer NOT NULL,
    encounter_id integer,
    code character varying(50),
    description text,
    performed_at timestamp without time zone
);


ALTER TABLE public.procedure_tbl OWNER TO emr_app;

--
-- Name: procedure_tbl_procedure_id_seq; Type: SEQUENCE; Schema: public; Owner: emr_app
--

CREATE SEQUENCE public.procedure_tbl_procedure_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.procedure_tbl_procedure_id_seq OWNER TO emr_app;

--
-- Name: procedure_tbl_procedure_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: emr_app
--

ALTER SEQUENCE public.procedure_tbl_procedure_id_seq OWNED BY public.procedure_tbl.procedure_id;


--
-- Name: provider; Type: TABLE; Schema: public; Owner: emr_app
--

CREATE TABLE public.provider (
    provider_id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    specialty_id integer
);


ALTER TABLE public.provider OWNER TO emr_app;

--
-- Name: provider_provider_id_seq; Type: SEQUENCE; Schema: public; Owner: emr_app
--

CREATE SEQUENCE public.provider_provider_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.provider_provider_id_seq OWNER TO emr_app;

--
-- Name: provider_provider_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: emr_app
--

ALTER SEQUENCE public.provider_provider_id_seq OWNED BY public.provider.provider_id;


--
-- Name: specialty; Type: TABLE; Schema: public; Owner: emr_app
--

CREATE TABLE public.specialty (
    specialty_id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.specialty OWNER TO emr_app;

--
-- Name: specialty_specialty_id_seq; Type: SEQUENCE; Schema: public; Owner: emr_app
--

CREATE SEQUENCE public.specialty_specialty_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.specialty_specialty_id_seq OWNER TO emr_app;

--
-- Name: specialty_specialty_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: emr_app
--

ALTER SEQUENCE public.specialty_specialty_id_seq OWNED BY public.specialty.specialty_id;


--
-- Name: test_conn; Type: TABLE; Schema: public; Owner: emr_app
--

CREATE TABLE public.test_conn (
    id integer NOT NULL,
    note text
);


ALTER TABLE public.test_conn OWNER TO emr_app;

--
-- Name: test_conn_id_seq; Type: SEQUENCE; Schema: public; Owner: emr_app
--

CREATE SEQUENCE public.test_conn_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.test_conn_id_seq OWNER TO emr_app;

--
-- Name: test_conn_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: emr_app
--

ALTER SEQUENCE public.test_conn_id_seq OWNED BY public.test_conn.id;


--
-- Name: vw_patient_summary; Type: VIEW; Schema: public; Owner: emr_app
--

CREATE VIEW public.vw_patient_summary AS
 SELECT p.patient_id,
    (((p.first_name)::text || ' '::text) || (p.last_name)::text) AS patient_name,
    p.dob,
    (EXTRACT(year FROM age((p.dob)::timestamp with time zone)))::integer AS age,
    count(DISTINCT e.encounter_id) AS total_encounters,
    count(DISTINCT a.appointment_id) AS total_appointments,
    COALESCE(sum(b.amount), (0)::numeric) AS total_billed
   FROM ((((public.patient p
     LEFT JOIN public.encounter e ON ((e.patient_id = p.patient_id)))
     LEFT JOIN public.appointment a ON ((a.patient_id = p.patient_id)))
     LEFT JOIN public.encounter e2 ON ((e2.patient_id = p.patient_id)))
     LEFT JOIN public.bill b ON ((b.encounter_id = e2.encounter_id)))
  GROUP BY p.patient_id, p.first_name, p.last_name, p.dob;


ALTER VIEW public.vw_patient_summary OWNER TO emr_app;

--
-- Name: appointment appointment_id; Type: DEFAULT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.appointment ALTER COLUMN appointment_id SET DEFAULT nextval('public.appointment_appointment_id_seq'::regclass);


--
-- Name: bill bill_id; Type: DEFAULT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.bill ALTER COLUMN bill_id SET DEFAULT nextval('public.bill_bill_id_seq'::regclass);


--
-- Name: diagnosis diagnosis_id; Type: DEFAULT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.diagnosis ALTER COLUMN diagnosis_id SET DEFAULT nextval('public.diagnosis_diagnosis_id_seq'::regclass);


--
-- Name: encounter encounter_id; Type: DEFAULT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.encounter ALTER COLUMN encounter_id SET DEFAULT nextval('public.encounter_encounter_id_seq'::regclass);


--
-- Name: insurance insurance_id; Type: DEFAULT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.insurance ALTER COLUMN insurance_id SET DEFAULT nextval('public.insurance_insurance_id_seq'::regclass);


--
-- Name: medication medication_id; Type: DEFAULT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.medication ALTER COLUMN medication_id SET DEFAULT nextval('public.medication_medication_id_seq'::regclass);


--
-- Name: patient patient_id; Type: DEFAULT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.patient ALTER COLUMN patient_id SET DEFAULT nextval('public.patient_patient_id_seq'::regclass);


--
-- Name: prescription prescription_id; Type: DEFAULT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.prescription ALTER COLUMN prescription_id SET DEFAULT nextval('public.prescription_prescription_id_seq'::regclass);


--
-- Name: procedure_tbl procedure_id; Type: DEFAULT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.procedure_tbl ALTER COLUMN procedure_id SET DEFAULT nextval('public.procedure_tbl_procedure_id_seq'::regclass);


--
-- Name: provider provider_id; Type: DEFAULT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.provider ALTER COLUMN provider_id SET DEFAULT nextval('public.provider_provider_id_seq'::regclass);


--
-- Name: specialty specialty_id; Type: DEFAULT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.specialty ALTER COLUMN specialty_id SET DEFAULT nextval('public.specialty_specialty_id_seq'::regclass);


--
-- Name: test_conn id; Type: DEFAULT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.test_conn ALTER COLUMN id SET DEFAULT nextval('public.test_conn_id_seq'::regclass);


--
-- Data for Name: appointment; Type: TABLE DATA; Schema: public; Owner: emr_app
--

COPY public.appointment (appointment_id, patient_id, provider_id, start_time, end_time, status, created_at) FROM stdin;
1	1	1	2025-11-01 09:00:00	2025-11-01 09:30:00	COMPLETED	2025-10-25 10:00:00
2	2	2	2025-11-01 09:30:00	2025-11-01 10:00:00	SCHEDULED	2025-10-25 10:05:00
3	3	3	2025-11-01 10:00:00	2025-11-01 10:30:00	NOSHOW	2025-10-25 10:10:00
4	4	4	2025-11-01 10:30:00	2025-11-01 11:00:00	COMPLETED	2025-10-25 10:15:00
5	5	5	2025-11-01 11:00:00	2025-11-01 11:30:00	RESCHEDULED	2025-10-25 10:20:00
6	6	6	2025-11-01 11:30:00	2025-11-01 12:00:00	COMPLETED	2025-10-25 10:25:00
7	7	7	2025-11-01 12:00:00	2025-11-01 12:30:00	SCHEDULED	2025-10-25 10:30:00
8	8	8	2025-11-01 12:30:00	2025-11-01 13:00:00	COMPLETED	2025-10-25 10:35:00
9	9	9	2025-11-01 13:00:00	2025-11-01 13:30:00	NOSHOW	2025-10-25 10:40:00
10	10	10	2025-11-01 13:30:00	2025-11-01 14:00:00	COMPLETED	2025-10-25 10:45:00
11	11	11	2025-11-02 09:00:00	2025-11-02 09:30:00	COMPLETED	2025-10-26 10:00:00
12	12	12	2025-11-02 09:30:00	2025-11-02 10:00:00	SCHEDULED	2025-10-26 10:05:00
13	13	13	2025-11-02 10:00:00	2025-11-02 10:30:00	COMPLETED	2025-10-26 10:10:00
14	14	14	2025-11-02 10:30:00	2025-11-02 11:00:00	RESCHEDULED	2025-10-26 10:15:00
15	15	15	2025-11-02 11:00:00	2025-11-02 11:30:00	COMPLETED	2025-10-26 10:20:00
16	16	1	2025-11-02 11:30:00	2025-11-02 12:00:00	COMPLETED	2025-10-26 10:25:00
17	17	2	2025-11-02 12:00:00	2025-11-02 12:30:00	NOSHOW	2025-10-26 10:30:00
18	18	3	2025-11-02 12:30:00	2025-11-02 13:00:00	SCHEDULED	2025-10-26 10:35:00
19	19	4	2025-11-02 13:00:00	2025-11-02 13:30:00	COMPLETED	2025-10-26 10:40:00
20	20	5	2025-11-02 13:30:00	2025-11-02 14:00:00	COMPLETED	2025-10-26 10:45:00
\.


--
-- Data for Name: bill; Type: TABLE DATA; Schema: public; Owner: emr_app
--

COPY public.bill (bill_id, encounter_id, amount, paid, payer_id, created_at) FROM stdin;
1	1	800.00	t	1	2025-11-01 11:00:00
2	2	2500.00	f	2	2025-11-01 11:00:00
3	3	600.00	t	3	2025-11-01 11:00:00
4	4	1500.00	t	4	2025-11-01 11:00:00
5	5	900.00	f	5	2025-11-01 11:00:00
6	6	700.00	t	6	2025-11-01 11:00:00
7	7	2200.00	t	1	2025-11-01 11:00:00
8	8	1900.00	f	2	2025-11-01 11:00:00
9	9	1300.00	t	3	2025-11-01 11:00:00
10	10	1100.00	t	6	2025-11-01 11:00:00
\.


--
-- Data for Name: diagnosis; Type: TABLE DATA; Schema: public; Owner: emr_app
--

COPY public.diagnosis (diagnosis_id, encounter_id, code, description, is_primary) FROM stdin;
1	1	J10	Influenza	t
2	1	R50	Fever	f
3	2	I20	Angina	t
4	2	R07	Chest pain	f
5	3	Z00	Health check-up of child	t
6	3	Z23	Encounter for immunization	f
7	4	M17	Knee osteoarthritis	t
8	4	M25	Joint pain	f
9	5	L20	Dermatitis	t
10	5	L30	Skin inflammation	f
11	6	R51	Headache	t
12	6	G44	Tension-type headache	f
13	7	E11	Type 2 diabetes mellitus	t
14	7	Z13	Screening for metabolic disorder	f
15	8	I10	Essential hypertension	t
16	8	Z09	Follow-up examination	f
17	9	J45	Asthma	t
18	9	Z79	Long-term (current) use of drugs	f
19	10	Z00	General medical examination	t
20	10	E78	Disorders of lipoprotein metabolism	f
\.


--
-- Data for Name: encounter; Type: TABLE DATA; Schema: public; Owner: emr_app
--

COPY public.encounter (encounter_id, patient_id, provider_id, encounter_time, reason, notes) FROM stdin;
1	1	1	2025-11-01 09:10:00	Fever and cough	Initial visit for fever
2	2	2	2025-11-01 09:40:00	Chest pain	ECG advised
3	3	3	2025-11-01 10:10:00	Child vaccination	Pediatrics vaccination
4	4	4	2025-11-01 10:40:00	Knee pain	Orthopedic evaluation
5	5	5	2025-11-01 11:10:00	Skin rash	Dermatology consult
6	6	6	2025-11-01 11:40:00	Headache	General medicine consult
7	7	7	2025-11-01 12:10:00	Diabetes check	Routine diabetes follow-up
8	8	8	2025-11-01 12:40:00	Hypertension follow-up	BP monitoring
9	9	9	2025-11-01 13:10:00	Asthma review	Inhaler technique check
10	10	10	2025-11-01 13:40:00	General checkup	Annual health check
\.


--
-- Data for Name: insurance; Type: TABLE DATA; Schema: public; Owner: emr_app
--

COPY public.insurance (insurance_id, payer_name, plan_id) FROM stdin;
1	BlueShield	BS-P1
2	UnitedHealth	UH-P2
3	Medicare	MC-P3
4	Aetna	AE-P4
5	Cigna	CG-P5
6	Self Pay	SELF
\.


--
-- Data for Name: medication; Type: TABLE DATA; Schema: public; Owner: emr_app
--

COPY public.medication (medication_id, name, ndc) FROM stdin;
1	Paracetamol	NDC001
2	Aspirin	NDC002
3	Amoxicillin	NDC003
4	Metformin	NDC004
5	Atorvastatin	NDC005
6	Omeprazole	NDC006
7	Cetirizine	NDC007
8	Ibuprofen	NDC008
9	Losartan	NDC009
10	Amlodipine	NDC010
11	Salbutamol	NDC011
12	Prednisone	NDC012
13	Warfarin	NDC013
14	Levothyroxine	NDC014
15	Lisinopril	NDC015
16	Clopidogrel	NDC016
17	Ciprofloxacin	NDC017
18	Azithromycin	NDC018
19	Hydrochlorothiazide	NDC019
20	Gabapentin	NDC020
21	Tramadol	NDC021
22	Fluoxetine	NDC022
23	Sertraline	NDC023
24	Montelukast	NDC024
25	Ranitidine	NDC025
\.


--
-- Data for Name: patient; Type: TABLE DATA; Schema: public; Owner: emr_app
--

COPY public.patient (patient_id, first_name, last_name, dob, gender) FROM stdin;
1	Siddharth	Verma	1998-05-12	M
2	Priya	Singh	2002-11-03	F
3	Manish	Kumar	1975-02-20	M
4	Aanya	Sharma	1999-01-15	F
5	Rohit	Patel	1990-06-10	M
6	Simran	Khan	1995-03-25	F
7	Aditya	Joshi	1988-11-08	M
8	Neha	Reddy	1996-07-21	F
9	Vishal	Mehra	1985-09-14	M
10	Ishita	Nair	1997-08-17	F
11	Kunal	Kapoor	1992-04-19	M
12	Rhea	Desai	2000-02-11	F
13	Arjun	Iyer	1993-12-30	M
14	Deepa	Roy	1987-10-04	F
15	Ankit	Bhat	1994-05-18	M
16	Sonal	Chaudhary	1998-09-09	F
17	Nikhil	Prasad	1989-01-29	M
18	Anushka	Agarwal	2001-05-05	F
19	Vikram	Saxena	1984-07-23	M
20	Meera	Gupta	1996-06-16	F
21	Pooja	Singh	1997-06-02	F
22	Rajat	Verma	1999-12-22	M
23	Maya	Patel	1994-02-15	F
24	Kabir	Sharma	1991-03-12	M
25	Tara	Kapoor	1998-10-27	F
26	Sana	Bhat	1995-04-01	F
27	Karan	Roy	1993-02-09	M
28	Isha	Prasad	1997-08-03	F
29	Asha	Chaudhary	1986-01-07	F
30	Ravi	Agarwal	1983-05-29	M
31	Anita	Saxena	1990-09-19	F
32	Hemant	Gupta	1982-06-05	M
33	Ritu	Singh	1995-11-25	F
34	Soham	Patel	2000-03-30	M
35	Naina	Sharma	1999-04-10	F
36	Kavya	Joshi	1998-08-20	F
37	Aarav	Reddy	1995-12-11	M
38	Dev	Verma	1993-03-16	M
39	Srishti	Mehra	1999-09-09	F
40	Harsh	Nair	1991-10-28	M
41	Sneha	Iyer	1997-06-17	F
42	Om	Kapoor	1988-11-02	M
43	Jiya	Desai	2002-01-14	F
44	Yash	Roy	1996-02-26	M
45	Lavanya	Bhat	1997-05-13	F
46	Arnav	Agarwal	1994-09-08	M
47	Diya	Saxena	1998-03-22	F
48	Harshit	Gupta	1991-07-29	M
49	Muskan	Singh	2000-10-05	F
50	Pranav	Patel	1992-06-18	M
51	Roshni	Sharma	1995-12-10	F
52	Sahil	Joshi	1993-07-03	M
53	Alisha	Reddy	2001-09-25	F
54	Mohan	Verma	1985-03-14	M
55	Kritika	Nair	1998-04-23	F
56	Suresh	Iyer	1989-02-12	M
57	Divya	Kapoor	1996-12-01	F
58	Abhay	Desai	1994-01-17	M
59	Shreya	Roy	1997-11-06	F
60	Parth	Bhat	1992-08-01	M
61	Bhavya	Prasad	1999-05-15	F
62	Gaurav	Agarwal	1987-07-30	M
63	Shweta	Saxena	1998-09-19	F
64	Yuvraj	Gupta	1995-02-05	M
65	Vaishali	Singh	2000-08-22	F
66	Tejas	Patel	1993-01-09	M
67	Mahima	Sharma	1996-11-12	F
68	Abhinav	Joshi	1992-02-15	M
69	Tanvi	Reddy	1998-03-09	F
70	Nitin	Verma	1990-05-07	M
71	Roshika	Mehra	1999-07-29	F
72	Adarsh	Nair	1994-11-03	M
73	Chhavi	Iyer	1998-06-14	F
74	Devansh	Kapoor	1993-10-18	M
75	Shruti	Desai	1999-01-25	F
76	Ishaan	Roy	1995-12-02	M
77	Payal	Bhat	1998-07-07	F
78	Krish	Prasad	1991-09-16	M
79	Ritika	Verma	1994-04-21	F
80	Manu	Sharma	1997-02-28	M
\.


--
-- Data for Name: prescription; Type: TABLE DATA; Schema: public; Owner: emr_app
--

COPY public.prescription (prescription_id, encounter_id, medication_id, dosage, frequency, duration_days, prescribed_at) FROM stdin;
1	1	1	500 mg	Thrice daily	5	2025-11-01 09:15:00
2	1	7	10 mg	Once daily	7	2025-11-01 09:15:00
3	2	9	50 mg	Once daily	30	2025-11-01 09:45:00
4	3	3	250 mg	Twice daily	3	2025-11-01 10:15:00
5	4	8	400 mg	Twice daily	10	2025-11-01 10:45:00
6	5	20	100 mg	Once daily	7	2025-11-01 11:15:00
7	6	22	20 mg	Once daily	14	2025-11-01 11:45:00
8	7	4	500 mg	Twice daily	30	2025-11-01 12:15:00
9	7	5	10 mg	Once daily	30	2025-11-01 12:15:00
10	8	10	5 mg	Once daily	30	2025-11-01 12:45:00
11	9	11	2 puffs	As needed	15	2025-11-01 13:15:00
12	10	24	10 mg	Once daily	30	2025-11-01 13:45:00
13	10	5	10 mg	Once daily	30	2025-11-01 13:45:00
14	2	2	75 mg	Once daily	30	2025-11-01 09:45:00
15	8	15	10 mg	Once daily	30	2025-11-01 12:45:00
\.


--
-- Data for Name: procedure_tbl; Type: TABLE DATA; Schema: public; Owner: emr_app
--

COPY public.procedure_tbl (procedure_id, encounter_id, code, description, performed_at) FROM stdin;
\.


--
-- Data for Name: provider; Type: TABLE DATA; Schema: public; Owner: emr_app
--

COPY public.provider (provider_id, first_name, last_name, specialty_id) FROM stdin;
1	Amit	Sharma	1
2	Neha	Gupta	2
3	Rohan	Verma	3
4	Anjali	Singh	4
5	Vikram	Patel	5
6	Sana	Khan	1
7	Rajat	Mehra	2
8	Pooja	Reddy	3
9	Karan	Kapoor	4
10	Isha	Nair	5
11	Deepak	Joshi	1
12	Maya	Iyer	2
13	Arjun	Desai	3
14	Tara	Sharma	4
15	Rahul	Khan	5
\.


--
-- Data for Name: specialty; Type: TABLE DATA; Schema: public; Owner: emr_app
--

COPY public.specialty (specialty_id, name) FROM stdin;
1	General Medicine
2	Cardiology
3	Pediatrics
4	Orthopedics
5	Dermatology
\.


--
-- Data for Name: test_conn; Type: TABLE DATA; Schema: public; Owner: emr_app
--

COPY public.test_conn (id, note) FROM stdin;
1	ok
\.


--
-- Name: appointment_appointment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: emr_app
--

SELECT pg_catalog.setval('public.appointment_appointment_id_seq', 20, true);


--
-- Name: bill_bill_id_seq; Type: SEQUENCE SET; Schema: public; Owner: emr_app
--

SELECT pg_catalog.setval('public.bill_bill_id_seq', 10, true);


--
-- Name: diagnosis_diagnosis_id_seq; Type: SEQUENCE SET; Schema: public; Owner: emr_app
--

SELECT pg_catalog.setval('public.diagnosis_diagnosis_id_seq', 20, true);


--
-- Name: encounter_encounter_id_seq; Type: SEQUENCE SET; Schema: public; Owner: emr_app
--

SELECT pg_catalog.setval('public.encounter_encounter_id_seq', 10, true);


--
-- Name: insurance_insurance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: emr_app
--

SELECT pg_catalog.setval('public.insurance_insurance_id_seq', 6, true);


--
-- Name: medication_medication_id_seq; Type: SEQUENCE SET; Schema: public; Owner: emr_app
--

SELECT pg_catalog.setval('public.medication_medication_id_seq', 25, true);


--
-- Name: patient_patient_id_seq; Type: SEQUENCE SET; Schema: public; Owner: emr_app
--

SELECT pg_catalog.setval('public.patient_patient_id_seq', 80, true);


--
-- Name: prescription_prescription_id_seq; Type: SEQUENCE SET; Schema: public; Owner: emr_app
--

SELECT pg_catalog.setval('public.prescription_prescription_id_seq', 15, true);


--
-- Name: procedure_tbl_procedure_id_seq; Type: SEQUENCE SET; Schema: public; Owner: emr_app
--

SELECT pg_catalog.setval('public.procedure_tbl_procedure_id_seq', 1, false);


--
-- Name: provider_provider_id_seq; Type: SEQUENCE SET; Schema: public; Owner: emr_app
--

SELECT pg_catalog.setval('public.provider_provider_id_seq', 15, true);


--
-- Name: specialty_specialty_id_seq; Type: SEQUENCE SET; Schema: public; Owner: emr_app
--

SELECT pg_catalog.setval('public.specialty_specialty_id_seq', 5, true);


--
-- Name: test_conn_id_seq; Type: SEQUENCE SET; Schema: public; Owner: emr_app
--

SELECT pg_catalog.setval('public.test_conn_id_seq', 1, true);


--
-- Name: appointment appointment_pkey; Type: CONSTRAINT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.appointment
    ADD CONSTRAINT appointment_pkey PRIMARY KEY (appointment_id);


--
-- Name: bill bill_pkey; Type: CONSTRAINT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.bill
    ADD CONSTRAINT bill_pkey PRIMARY KEY (bill_id);


--
-- Name: diagnosis diagnosis_pkey; Type: CONSTRAINT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.diagnosis
    ADD CONSTRAINT diagnosis_pkey PRIMARY KEY (diagnosis_id);


--
-- Name: encounter encounter_pkey; Type: CONSTRAINT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.encounter
    ADD CONSTRAINT encounter_pkey PRIMARY KEY (encounter_id);


--
-- Name: insurance insurance_pkey; Type: CONSTRAINT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.insurance
    ADD CONSTRAINT insurance_pkey PRIMARY KEY (insurance_id);


--
-- Name: medication medication_name_key; Type: CONSTRAINT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.medication
    ADD CONSTRAINT medication_name_key UNIQUE (name);


--
-- Name: medication medication_pkey; Type: CONSTRAINT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.medication
    ADD CONSTRAINT medication_pkey PRIMARY KEY (medication_id);


--
-- Name: patient patient_pkey; Type: CONSTRAINT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.patient
    ADD CONSTRAINT patient_pkey PRIMARY KEY (patient_id);


--
-- Name: prescription prescription_pkey; Type: CONSTRAINT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.prescription
    ADD CONSTRAINT prescription_pkey PRIMARY KEY (prescription_id);


--
-- Name: procedure_tbl procedure_tbl_pkey; Type: CONSTRAINT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.procedure_tbl
    ADD CONSTRAINT procedure_tbl_pkey PRIMARY KEY (procedure_id);


--
-- Name: provider provider_pkey; Type: CONSTRAINT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.provider
    ADD CONSTRAINT provider_pkey PRIMARY KEY (provider_id);


--
-- Name: specialty specialty_name_key; Type: CONSTRAINT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.specialty
    ADD CONSTRAINT specialty_name_key UNIQUE (name);


--
-- Name: specialty specialty_name_unique; Type: CONSTRAINT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.specialty
    ADD CONSTRAINT specialty_name_unique UNIQUE (name);


--
-- Name: specialty specialty_pkey; Type: CONSTRAINT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.specialty
    ADD CONSTRAINT specialty_pkey PRIMARY KEY (specialty_id);


--
-- Name: test_conn test_conn_pkey; Type: CONSTRAINT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.test_conn
    ADD CONSTRAINT test_conn_pkey PRIMARY KEY (id);


--
-- Name: idx_appointment_future; Type: INDEX; Schema: public; Owner: emr_app
--

CREATE INDEX idx_appointment_future ON public.appointment USING btree (start_time) WHERE (start_time > '2000-01-01 00:00:00'::timestamp without time zone);


--
-- Name: idx_appointment_provider_start; Type: INDEX; Schema: public; Owner: emr_app
--

CREATE INDEX idx_appointment_provider_start ON public.appointment USING btree (provider_id, start_time);


--
-- Name: idx_appointment_status_provider; Type: INDEX; Schema: public; Owner: emr_app
--

CREATE INDEX idx_appointment_status_provider ON public.appointment USING btree (status, provider_id);


--
-- Name: idx_bill_payer; Type: INDEX; Schema: public; Owner: emr_app
--

CREATE INDEX idx_bill_payer ON public.bill USING btree (payer_id, created_at);


--
-- Name: idx_encounter_patient_date; Type: INDEX; Schema: public; Owner: emr_app
--

CREATE INDEX idx_encounter_patient_date ON public.encounter USING btree (patient_id, encounter_time);


--
-- Name: idx_patient_name; Type: INDEX; Schema: public; Owner: emr_app
--

CREATE INDEX idx_patient_name ON public.patient USING btree (lower((((first_name)::text || ' '::text) || (last_name)::text)));


--
-- Name: idx_prescription_medication_date; Type: INDEX; Schema: public; Owner: emr_app
--

CREATE INDEX idx_prescription_medication_date ON public.prescription USING btree (medication_id, prescribed_at);


--
-- Name: appointment appointment_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.appointment
    ADD CONSTRAINT appointment_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.patient(patient_id) ON DELETE RESTRICT;


--
-- Name: appointment appointment_provider_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.appointment
    ADD CONSTRAINT appointment_provider_id_fkey FOREIGN KEY (provider_id) REFERENCES public.provider(provider_id) ON DELETE RESTRICT;


--
-- Name: bill bill_encounter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.bill
    ADD CONSTRAINT bill_encounter_id_fkey FOREIGN KEY (encounter_id) REFERENCES public.encounter(encounter_id) ON DELETE SET NULL;


--
-- Name: bill bill_payer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.bill
    ADD CONSTRAINT bill_payer_id_fkey FOREIGN KEY (payer_id) REFERENCES public.insurance(insurance_id) ON DELETE SET NULL;


--
-- Name: diagnosis diagnosis_encounter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.diagnosis
    ADD CONSTRAINT diagnosis_encounter_id_fkey FOREIGN KEY (encounter_id) REFERENCES public.encounter(encounter_id) ON DELETE CASCADE;


--
-- Name: encounter encounter_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.encounter
    ADD CONSTRAINT encounter_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.patient(patient_id) ON DELETE CASCADE;


--
-- Name: encounter encounter_provider_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.encounter
    ADD CONSTRAINT encounter_provider_id_fkey FOREIGN KEY (provider_id) REFERENCES public.provider(provider_id) ON DELETE SET NULL;


--
-- Name: prescription prescription_encounter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.prescription
    ADD CONSTRAINT prescription_encounter_id_fkey FOREIGN KEY (encounter_id) REFERENCES public.encounter(encounter_id) ON DELETE SET NULL;


--
-- Name: prescription prescription_medication_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.prescription
    ADD CONSTRAINT prescription_medication_id_fkey FOREIGN KEY (medication_id) REFERENCES public.medication(medication_id) ON DELETE RESTRICT;


--
-- Name: procedure_tbl procedure_tbl_encounter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.procedure_tbl
    ADD CONSTRAINT procedure_tbl_encounter_id_fkey FOREIGN KEY (encounter_id) REFERENCES public.encounter(encounter_id) ON DELETE CASCADE;


--
-- Name: provider provider_specialty_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: emr_app
--

ALTER TABLE ONLY public.provider
    ADD CONSTRAINT provider_specialty_id_fkey FOREIGN KEY (specialty_id) REFERENCES public.specialty(specialty_id) ON DELETE SET NULL;


--
-- Name: TABLE appointment; Type: ACL; Schema: public; Owner: emr_app
--

GRANT ALL ON TABLE public.appointment TO admin_role;
GRANT SELECT,INSERT,UPDATE ON TABLE public.appointment TO frontdesk_role;
GRANT SELECT ON TABLE public.appointment TO auditor_role;


--
-- Name: TABLE bill; Type: ACL; Schema: public; Owner: emr_app
--

GRANT ALL ON TABLE public.bill TO admin_role;
GRANT SELECT,INSERT,UPDATE ON TABLE public.bill TO billing_role;
GRANT SELECT ON TABLE public.bill TO auditor_role;


--
-- Name: TABLE diagnosis; Type: ACL; Schema: public; Owner: emr_app
--

GRANT ALL ON TABLE public.diagnosis TO admin_role;
GRANT SELECT,INSERT,UPDATE ON TABLE public.diagnosis TO provider_role;
GRANT SELECT ON TABLE public.diagnosis TO auditor_role;


--
-- Name: TABLE encounter; Type: ACL; Schema: public; Owner: emr_app
--

GRANT ALL ON TABLE public.encounter TO admin_role;
GRANT SELECT,INSERT,UPDATE ON TABLE public.encounter TO provider_role;
GRANT SELECT ON TABLE public.encounter TO auditor_role;


--
-- Name: TABLE insurance; Type: ACL; Schema: public; Owner: emr_app
--

GRANT ALL ON TABLE public.insurance TO admin_role;
GRANT SELECT,INSERT,UPDATE ON TABLE public.insurance TO billing_role;
GRANT SELECT ON TABLE public.insurance TO auditor_role;


--
-- Name: TABLE medication; Type: ACL; Schema: public; Owner: emr_app
--

GRANT ALL ON TABLE public.medication TO admin_role;
GRANT SELECT ON TABLE public.medication TO auditor_role;


--
-- Name: TABLE patient; Type: ACL; Schema: public; Owner: emr_app
--

GRANT ALL ON TABLE public.patient TO admin_role;
GRANT SELECT,INSERT,UPDATE ON TABLE public.patient TO provider_role;
GRANT SELECT,INSERT,UPDATE ON TABLE public.patient TO frontdesk_role;
GRANT SELECT ON TABLE public.patient TO auditor_role;


--
-- Name: TABLE prescription; Type: ACL; Schema: public; Owner: emr_app
--

GRANT ALL ON TABLE public.prescription TO admin_role;
GRANT SELECT,INSERT,UPDATE ON TABLE public.prescription TO provider_role;
GRANT SELECT ON TABLE public.prescription TO auditor_role;


--
-- Name: TABLE procedure_tbl; Type: ACL; Schema: public; Owner: emr_app
--

GRANT ALL ON TABLE public.procedure_tbl TO admin_role;
GRANT SELECT ON TABLE public.procedure_tbl TO auditor_role;


--
-- Name: TABLE provider; Type: ACL; Schema: public; Owner: emr_app
--

GRANT ALL ON TABLE public.provider TO admin_role;
GRANT SELECT ON TABLE public.provider TO auditor_role;


--
-- Name: TABLE specialty; Type: ACL; Schema: public; Owner: emr_app
--

GRANT ALL ON TABLE public.specialty TO admin_role;
GRANT SELECT ON TABLE public.specialty TO auditor_role;


--
-- Name: TABLE test_conn; Type: ACL; Schema: public; Owner: emr_app
--

GRANT ALL ON TABLE public.test_conn TO admin_role;
GRANT SELECT ON TABLE public.test_conn TO auditor_role;


--
-- Name: TABLE vw_patient_summary; Type: ACL; Schema: public; Owner: emr_app
--

GRANT ALL ON TABLE public.vw_patient_summary TO admin_role;
GRANT SELECT ON TABLE public.vw_patient_summary TO auditor_role;


--
-- PostgreSQL database dump complete
--

