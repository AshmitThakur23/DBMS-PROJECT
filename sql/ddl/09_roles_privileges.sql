-- 09_roles_privileges.sql
-- Role-based access control (RBAC) for Hospital EMR system

---------------------------------------------------------
-- 1) CREATE ROLES
---------------------------------------------------------
CREATE ROLE admin_role;
CREATE ROLE provider_role;
CREATE ROLE frontdesk_role;
CREATE ROLE billing_role;
CREATE ROLE auditor_role;

---------------------------------------------------------
-- 2) DEFAULT PRIVILEGE CLEANUP (optional but good)
---------------------------------------------------------
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM PUBLIC;

---------------------------------------------------------
-- 3) ASSIGN PRIVILEGES TO ROLES
---------------------------------------------------------

-- ADMIN: full access
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin_role;

-- PROVIDER: can read/write clinical data
GRANT SELECT, INSERT, UPDATE ON
    patient,
    encounter,
    diagnosis,
    prescription
TO provider_role;

-- FRONTDESK: patient registration + appointment
GRANT SELECT, INSERT, UPDATE ON
    patient,
    appointment
TO frontdesk_role;

-- BILLING: only bills + insurance
GRANT SELECT, INSERT, UPDATE ON
    bill,
    insurance
TO billing_role;

-- AUDITOR: read-only everywhere
GRANT SELECT ON ALL TABLES IN SCHEMA public TO auditor_role;

---------------------------------------------------------
-- 4) ASSIGN YOUR USER (emr_app) AS ADMIN
---------------------------------------------------------
GRANT admin_role TO emr_app;
