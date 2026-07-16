-- ======================================================================
-- COPC HR DASHBOARD - COMPLETE DATABASE SCHEMA
-- Sistema Integral de Gestión de Recursos Humanos
-- ======================================================================

-- 1. CREAR BASE DE DATOS
-- ======================================================================
CREATE DATABASE IF NOT EXISTS copc_hr_dashboard;
USE copc_hr_dashboard;

-- ======================================================================
-- TABLA 1: EMPRESAS (MULTI-TENANT)
-- ======================================================================
CREATE TABLE IF NOT EXISTS companies (
    company_id INT PRIMARY KEY AUTO_INCREMENT,
    company_name VARCHAR(150) NOT NULL UNIQUE,
    company_code VARCHAR(50) NOT NULL UNIQUE,
    industry VARCHAR(100),
    country VARCHAR(100),
    city VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    website VARCHAR(100),
    founded_year INT,
    employee_count INT DEFAULT 0,
    copc_certified BOOLEAN DEFAULT FALSE,
    certification_date DATE,
    status ENUM('ACTIVE', 'INACTIVE', 'SUSPENDED') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_company_code (company_code),
    INDEX idx_status (status)
);

-- ======================================================================
-- TABLA 2: DEPARTAMENTOS
-- ======================================================================
CREATE TABLE IF NOT EXISTS departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT NOT NULL,
    department_name VARCHAR(100) NOT NULL,
    department_code VARCHAR(50) NOT NULL,
    description TEXT,
    manager_id INT,
    budget DECIMAL(15,2),
    location VARCHAR(100),
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES companies(company_id),
    UNIQUE KEY unique_dept_code (company_id, department_code),
    INDEX idx_company_id (company_id),
    INDEX idx_status (status)
);

-- ======================================================================
-- TABLA 3: POSICIONES/ROLES
-- ======================================================================
CREATE TABLE IF NOT EXISTS job_positions (
    position_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT NOT NULL,
    position_name VARCHAR(100) NOT NULL,
    position_code VARCHAR(50) NOT NULL,
    department_id INT NOT NULL,
    description TEXT,
    salary_min DECIMAL(12,2),
    salary_max DECIMAL(12,2),
    required_experience INT,
    required_qualifications TEXT,
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES companies(company_id),
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    UNIQUE KEY unique_position_code (company_id, position_code),
    INDEX idx_company_id (company_id),
    INDEX idx_department_id (department_id)
);

-- ======================================================================
-- TABLA 4: EMPLEADOS (CORE)
-- ======================================================================
CREATE TABLE IF NOT EXISTS employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT NOT NULL,
    employee_code VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    national_id VARCHAR(50),
    birth_date DATE,
    gender ENUM('MALE', 'FEMALE', 'OTHER') DEFAULT 'MALE',
    marital_status ENUM('SINGLE', 'MARRIED', 'DIVORCED', 'WIDOWED') DEFAULT 'SINGLE',
    blood_type VARCHAR(5),
    address VARCHAR(255),
    city VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(20),
    department_id INT NOT NULL,
    position_id INT NOT NULL,
    manager_id INT,
    employment_type ENUM('FULL_TIME', 'PART_TIME', 'CONTRACT', 'TEMPORARY') DEFAULT 'FULL_TIME',
    hire_date DATE NOT NULL,
    end_date DATE,
    status ENUM('ACTIVE', 'INACTIVE', 'ON_LEAVE', 'SUSPENDED') DEFAULT 'ACTIVE',
    is_copc_certified BOOLEAN DEFAULT FALSE,
    certification_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES companies(company_id),
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    FOREIGN KEY (position_id) REFERENCES job_positions(position_id),
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id),
    UNIQUE KEY unique_emp_code (company_id, employee_code),
    INDEX idx_company_id (company_id),
    INDEX idx_department_id (department_id),
    INDEX idx_position_id (position_id),
    INDEX idx_status (status),
    INDEX idx_email (email),
    INDEX idx_hire_date (hire_date)
);

-- ======================================================================
-- TABLA 5: ASISTENCIA
-- ======================================================================
CREATE TABLE IF NOT EXISTS attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT NOT NULL,
    employee_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    clock_in DATETIME,
    clock_out DATETIME,
    hours_worked DECIMAL(5,2),
    overtime_hours DECIMAL(5,2) DEFAULT 0,
    attendance_status ENUM('PRESENT', 'ABSENT', 'LATE', 'HALF_DAY', 'HOLIDAY', 'WEEKEND', 'WEEKEND_WORK') DEFAULT 'PRESENT',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES companies(company_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    UNIQUE KEY unique_attendance (company_id, employee_id, attendance_date),
    INDEX idx_company_id (company_id),
    INDEX idx_employee_id (employee_id),
    INDEX idx_attendance_date (attendance_date)
);

-- ======================================================================
-- TABLA 6: TIPOS DE LICENCIA
-- ======================================================================
CREATE TABLE IF NOT EXISTS leave_types (
    leave_type_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT NOT NULL,
    leave_type_name VARCHAR(50) NOT NULL,
    description TEXT,
    days_per_year INT DEFAULT 15,
    is_paid BOOLEAN DEFAULT TRUE,
    carry_over_allowed BOOLEAN DEFAULT FALSE,
    max_carry_over_days INT,
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES companies(company_id),
    UNIQUE KEY unique_leave_type (company_id, leave_type_name),
    INDEX idx_company_id (company_id)
);

-- ======================================================================
-- TABLA 7: SALDO DE LICENCIAS
-- ======================================================================
CREATE TABLE IF NOT EXISTS leave_balances (
    balance_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT NOT NULL,
    employee_id INT NOT NULL,
    leave_type_id INT NOT NULL,
    fiscal_year INT NOT NULL,
    entitled_days DECIMAL(5,1) DEFAULT 0,
    taken_days DECIMAL(5,1) DEFAULT 0,
    carried_over_days DECIMAL(5,1) DEFAULT 0,
    remaining_days DECIMAL(5,1) GENERATED ALWAYS AS (entitled_days + carried_over_days - taken_days) STORED,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES companies(company_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (leave_type_id) REFERENCES leave_types(leave_type_id),
    UNIQUE KEY unique_leave_balance (company_id, employee_id, leave_type_id, fiscal_year),
    INDEX idx_employee_id (employee_id)
);

-- ======================================================================
-- TABLA 8: SOLICITUDES DE LICENCIA
-- ======================================================================
CREATE TABLE IF NOT EXISTS leave_requests (
    request_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT NOT NULL,
    employee_id INT NOT NULL,
    leave_type_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_days DECIMAL(5,1) NOT NULL,
    reason TEXT,
    status ENUM('PENDING', 'APPROVED', 'REJECTED', 'CANCELLED') DEFAULT 'PENDING',
    approved_by INT,
    approval_date DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES companies(company_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (leave_type_id) REFERENCES leave_types(leave_type_id),
    FOREIGN KEY (approved_by) REFERENCES employees(employee_id),
    INDEX idx_employee_id (employee_id),
    INDEX idx_status (status),
    INDEX idx_dates (start_date, end_date)
);

-- ======================================================================
-- TABLA 9: PLANTILLAS DE SALARIO
-- ======================================================================
CREATE TABLE IF NOT EXISTS salary_templates (
    template_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT NOT NULL,
    template_name VARCHAR(100) NOT NULL,
    description TEXT,
    base_salary DECIMAL(12,2) NOT NULL,
    housing_allowance DECIMAL(12,2),
    transport_allowance DECIMAL(12,2),
    meal_allowance DECIMAL(12,2),
    other_allowances DECIMAL(12,2),
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES companies(company_id),
    INDEX idx_company_id (company_id)
);

-- ======================================================================
-- TABLA 10: SALARIOS DE EMPLEADOS
-- ======================================================================
CREATE TABLE IF NOT EXISTS employee_salaries (
    salary_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT NOT NULL,
    employee_id INT NOT NULL,
    template_id INT,
    base_salary DECIMAL(12,2) NOT NULL,
    housing_allowance DECIMAL(12,2) DEFAULT 0,
    transport_allowance DECIMAL(12,2) DEFAULT 0,
    meal_allowance DECIMAL(12,2) DEFAULT 0,
    other_allowances DECIMAL(12,2) DEFAULT 0,
    effective_date DATE NOT NULL,
    end_date DATE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES companies(company_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (template_id) REFERENCES salary_templates(template_id),
    INDEX idx_employee_id (employee_id),
    INDEX idx_is_active (is_active)
);

-- ======================================================================
-- TABLA 11: CICLOS DE EVALUACIÓN DE DESEMPEÑO
-- ======================================================================
CREATE TABLE IF NOT EXISTS review_cycles (
    cycle_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT NOT NULL,
    cycle_name VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status ENUM('PLANNED', 'OPEN', 'IN_PROGRESS', 'CLOSED') DEFAULT 'OPEN',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES companies(company_id),
    INDEX idx_company_id (company_id)
);

-- ======================================================================
-- TABLA 12: EVALUACIONES DE DESEMPEÑO
-- ======================================================================
CREATE TABLE IF NOT EXISTS performance_reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT NOT NULL,
    employee_id INT NOT NULL,
    reviewer_id INT NOT NULL,
    cycle_id INT NOT NULL,
    review_date DATE NOT NULL,
    performance_rating DECIMAL(3,2),
    quality_score DECIMAL(3,2),
    productivity_score DECIMAL(3,2),
    attendance_score DECIMAL(3,2),
    customer_satisfaction_score DECIMAL(3,2),
    copc_compliance_score DECIMAL(3,2),
    comments TEXT,
    status ENUM('DRAFT', 'SUBMITTED', 'APPROVED', 'REJECTED') DEFAULT 'DRAFT',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES companies(company_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (reviewer_id) REFERENCES employees(employee_id),
    FOREIGN KEY (cycle_id) REFERENCES review_cycles(cycle_id),
    INDEX idx_employee_id (employee_id),
    INDEX idx_cycle_id (cycle_id)
);

-- ======================================================================
-- TABLA 13: PROGRAMAS DE CAPACITACIÓN
-- ======================================================================
CREATE TABLE IF NOT EXISTS training_programs (
    program_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT NOT NULL,
    program_name VARCHAR(150) NOT NULL,
    description TEXT,
    program_type ENUM('COPC_CERTIFICATION', 'TECHNICAL', 'SOFT_SKILLS', 'MANDATORY', 'OPTIONAL') DEFAULT 'OPTIONAL',
    duration_hours INT,
    instructor VARCHAR(100),
    is_mandatory BOOLEAN DEFAULT FALSE,
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES companies(company_id),
    INDEX idx_company_id (company_id)
);

-- ======================================================================
-- TABLA 14: REGISTROS DE CAPACITACIÓN
-- ======================================================================
CREATE TABLE IF NOT EXISTS training_records (
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT NOT NULL,
    employee_id INT NOT NULL,
    program_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    hours_completed INT,
    certification_obtained BOOLEAN DEFAULT FALSE,
    certification_date DATE,
    score DECIMAL(5,2),
    status ENUM('ENROLLED', 'IN_PROGRESS', 'COMPLETED', 'FAILED', 'DROPPED') DEFAULT 'ENROLLED',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES companies(company_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (program_id) REFERENCES training_programs(program_id),
    INDEX idx_employee_id (employee_id),
    INDEX idx_status (status)
);

-- ======================================================================
-- TABLA 15: MÉTRICAS OPERACIONALES (COPC)
-- ======================================================================
CREATE TABLE IF NOT EXISTS operational_metrics (
    metric_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT NOT NULL,
    department_id INT NOT NULL,
    metric_date DATE NOT NULL,
    total_interactions INT,
    quality_score DECIMAL(5,2),
    compliance_score DECIMAL(5,2),
    customer_satisfaction_score DECIMAL(5,2),
    employee_satisfaction_score DECIMAL(5,2),
    productivity_score DECIMAL(5,2),
    copc_score DECIMAL(5,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES companies(company_id),
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    UNIQUE KEY unique_metric (company_id, department_id, metric_date),
    INDEX idx_metric_date (metric_date)
);

-- ======================================================================
-- TABLA 16: REGISTRO DE CAMBIOS DE EMPLEADOS
-- ======================================================================
CREATE TABLE IF NOT EXISTS employee_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT NOT NULL,
    employee_id INT NOT NULL,
    change_type ENUM('HIRE', 'PROMOTION', 'TRANSFER', 'SALARY_CHANGE', 'STATUS_CHANGE', 'TERMINATION') NOT NULL,
    old_value VARCHAR(255),
    new_value VARCHAR(255),
    effective_date DATE NOT NULL,
    notes TEXT,
    changed_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES companies(company_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    INDEX idx_employee_id (employee_id),
    INDEX idx_change_type (change_type),
    INDEX idx_effective_date (effective_date)
);

-- ======================================================================
-- CREAR ÍNDICES ADICIONALES PARA OPTIMIZACIÓN
-- ======================================================================
CREATE INDEX idx_employees_active ON employees(company_id, status);
CREATE INDEX idx_employees_department_status ON employees(department_id, status);
CREATE INDEX idx_attendance_month ON attendance(YEAR(attendance_date), MONTH(attendance_date));
CREATE INDEX idx_leave_requests_year ON leave_requests(YEAR(start_date));

-- ======================================================================
-- FIN DEL SCHEMA
-- ======================================================================
