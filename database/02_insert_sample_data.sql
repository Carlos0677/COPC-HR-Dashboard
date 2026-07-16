-- database/02_insert_sample_data.sql
-- Sample data to validate COPC HR Dashboard prototype

USE copc_hr_dashboard;

-- Companies
INSERT INTO companies (company_name, company_code, industry, country, city, phone, email, website, founded_year, employee_count, copc_certified, certification_date)
VALUES
('Acme Contact Center','ACME_CC','Contact Center','Spain','Madrid','+34-600-000-001','info@acme.cc','https://acme.cc',2010,6,TRUE,'2024-05-10'),
('Beta Support Ltd','BETA_SUP','Contact Center','Mexico','Mexico City','+52-55-0000-0002','contact@beta.mx','https://beta.mx',2015,4,FALSE,NULL);

-- Departments
INSERT INTO departments (company_id, department_name, department_code, description, manager_id, budget, location)
VALUES
(1,'Soporte Telefónico','SUP_TEL','Atención telefónica de primer nivel',NULL,120000,'Madrid'),
(1,'Calidad','QUALITY','Monitoreo y aseguramiento de calidad',NULL,60000,'Madrid'),
(2,'Soporte Digital','SUP_DIG','Chat y email',NULL,80000,'CDMX');

-- Job positions
INSERT INTO job_positions (company_id, position_name, position_code, department_id, description, salary_min, salary_max, required_experience)
VALUES
(1,'Agente Nivel 1','AG1',1,'Atención básica a clientes',15000,22000,0),
(1,'Supervisor','SUPV',1,'Supervisión de equipos',30000,45000,3),
(1,'Analista de Calidad','AN_QUAL',2,'Evaluación de interacciones',22000,35000,2),
(2,'Agente Digital','AGD',3,'Soporte por chat y email',14000,21000,0);

-- Employees
INSERT INTO employees (company_id, employee_code, first_name, last_name, email, phone, birth_date, gender, department_id, position_id, hire_date, status, is_copc_certified)
VALUES
(1,'ACME-001','María','García','m.garcia@acme.cc','+34-600-111-001','1990-02-14','FEMALE',1,1,'2020-03-01','ACTIVE',TRUE),
(1,'ACME-002','Carlos','Ramírez','c.ramirez@acme.cc','+34-600-111-002','1988-07-22','MALE',1,1,'2019-06-15','ACTIVE',TRUE),
(1,'ACME-003','Lucía','Hernández','l.hernandez@acme.cc','+34-600-111-003','1992-11-03','FEMALE',2,3,'2021-01-10','ACTIVE',FALSE),
(1,'ACME-004','Jorge','López','j.lopez@acme.cc','+34-600-111-004','1985-05-30','MALE',1,2,'2018-09-05','ACTIVE',TRUE),
(2,'BETA-001','Ana','Sánchez','a.sanchez@beta.mx','+52-55-111-001','1991-08-08','FEMALE',3,4,'2022-02-20','ACTIVE',FALSE),
(2,'BETA-002','Luis','Pérez','l.perez@beta.mx','+52-55-111-002','1987-12-12','MALE',3,4,'2021-11-01','ACTIVE',FALSE);

-- Salary templates and employee salaries
INSERT INTO salary_templates (company_id, template_name, base_salary, housing_allowance, transport_allowance, meal_allowance)
VALUES
(1,'Plantilla Base ACME',18000,1500,500,200),(2,'Plantilla Base BETA',16000,1200,400,150);

INSERT INTO employee_salaries (company_id, employee_id, template_id, base_salary, effective_date, is_active)
VALUES
(1,1,1,18000,'2024-01-01',TRUE),(1,2,1,17000,'2024-01-01',TRUE),(1,3,1,24000,'2024-01-01',TRUE),(1,4,1,32000,'2024-01-01',TRUE),(2,5,2,16000,'2024-01-01',TRUE),(2,6,2,16500,'2024-01-01',TRUE);

-- Leave types and balances
INSERT INTO leave_types (company_id, leave_type_name, days_per_year, is_paid)
VALUES
(1,'Vacaciones',20,TRUE),(1,'Enfermedad',10,TRUE),(2,'Vacaciones',15,TRUE);

INSERT INTO leave_balances (company_id, employee_id, leave_type_id, fiscal_year, entitled_days, taken_days, carried_over_days)
VALUES
(1,1,1,2026,20,2,0),(1,2,1,2026,20,5,0),(1,3,1,2026,20,0,0),(2,5,3,2026,15,1,0);

-- Leave requests
INSERT INTO leave_requests (company_id, employee_id, leave_type_id, start_date, end_date, total_days, reason, status, approved_by, approval_date)
VALUES
(1,2,1,'2026-06-14','2026-06-18',5,'Vacaciones programadas','APPROVED',4,'2026-06-10 09:00:00'),
(1,3,2,'2026-06-20','2026-06-21',2,'Baja por enfermedad','PENDING',NULL,NULL);

-- Review cycles and performance reviews
INSERT INTO review_cycles (company_id, cycle_name, start_date, end_date, status)
VALUES
(1,'Ciclo Semestral 2026','2026-01-01','2026-06-30','CLOSED');

INSERT INTO performance_reviews (company_id, employee_id, reviewer_id, cycle_id, review_date, performance_rating, quality_score, productivity_score, attendance_score, customer_satisfaction_score, copc_compliance_score, comments, status)
VALUES
(1,1,4,1,'2026-06-25',4.5,4.6,4.4,4.8,4.7,4.5,'Buen desempeño general','APPROVED'),
(1,2,4,1,'2026-06-25',3.8,3.5,3.9,3.6,3.7,3.8,'Necesita mejorar calidad','APPROVED');

-- Training programs and records
INSERT INTO training_programs (company_id, program_name, program_type, duration_hours, is_mandatory)
VALUES
(1,'Certificación COPC Nivel 1','COPC_CERTIFICATION',24,TRUE),(1,'Comunicación Efectiva','SOFT_SKILLS',8,FALSE);

INSERT INTO training_records (company_id, employee_id, program_id, start_date, end_date, hours_completed, certification_obtained, certification_date, status)
VALUES
(1,1,1,'2025-11-01','2025-11-03',24,TRUE,'2025-11-03','COMPLETED'),
(1,2,2,'2026-03-05','2026-03-05',8,FALSE,NULL,'COMPLETED');

-- Operational metrics (sample daily metrics)
INSERT INTO operational_metrics (company_id, department_id, metric_date, total_interactions, quality_score, compliance_score, customer_satisfaction_score, employee_satisfaction_score, productivity_score, copc_score)
VALUES
(1,1,'2026-06-01',120,4.5,4.6,4.4,4.2,4.3,4.4),(1,1,'2026-06-02',110,4.3,4.5,4.2,4.1,4.0,4.2),(1,2,'2026-06-01',30,4.8,4.9,4.7,4.6,4.5,4.8);

-- Attendance (sample few entries)
INSERT INTO attendance (company_id, employee_id, attendance_date, clock_in, clock_out, hours_worked, overtime_hours, attendance_status)
VALUES
(1,1,'2026-06-01','2026-06-01 09:00:00','2026-06-01 17:00:00',8.0,0,'PRESENT'),
(1,2,'2026-06-01','2026-06-01 09:15:00','2026-06-01 17:00:00',7.75,0,'LATE'),
(1,3,'2026-06-01',NULL,NULL,0,0,'ABSENT');

-- Employee history
INSERT INTO employee_history (company_id, employee_id, change_type, old_value, new_value, effective_date, notes, changed_by)
VALUES
(1,2,'PROMOTION','Agente Nivel 1','Supervisor','2024-09-01','Promovido por desempeño',4);

-- Update company employee_count approximations
UPDATE companies SET employee_count = (SELECT COUNT(*) FROM employees e WHERE e.company_id = companies.company_id);

-- End of sample data
