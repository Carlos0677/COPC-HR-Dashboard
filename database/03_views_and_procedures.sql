-- database/03_views_and_procedures.sql
USE copc_hr_dashboard;

-- View: Monthly attendance summary per employee
DROP VIEW IF EXISTS vw_monthly_attendance;
CREATE VIEW vw_monthly_attendance AS
SELECT
  company_id,
  employee_id,
  YEAR(attendance_date) AS year,
  MONTH(attendance_date) AS month,
  COUNT(*) AS days_recorded,
  SUM(CASE WHEN attendance_status = 'PRESENT' THEN 1 ELSE 0 END) AS days_present,
  SUM(CASE WHEN attendance_status = 'ABSENT' THEN 1 ELSE 0 END) AS days_absent,
  AVG(hours_worked) AS avg_hours_worked
FROM attendance
GROUP BY company_id, employee_id, YEAR(attendance_date), MONTH(attendance_date);

-- View: Active employees per department
DROP VIEW IF EXISTS vw_department_staff;
CREATE VIEW vw_department_staff AS
SELECT d.company_id, d.department_id, d.department_name, COUNT(e.employee_id) AS staff_count
FROM departments d
LEFT JOIN employees e ON e.department_id = d.department_id AND e.status = 'ACTIVE'
GROUP BY d.company_id, d.department_id, d.department_name;

-- View: KPIs per company (monthly)
DROP VIEW IF EXISTS vw_company_monthly_kpis;
CREATE VIEW vw_company_monthly_kpis AS
SELECT
  om.company_id,
  YEAR(om.metric_date) AS year,
  MONTH(om.metric_date) AS month,
  SUM(om.total_interactions) AS total_interactions,
  ROUND(AVG(om.quality_score),2) AS avg_quality_score,
  ROUND(AVG(om.copc_score),2) AS avg_copc_score
FROM operational_metrics om
GROUP BY om.company_id, YEAR(om.metric_date), MONTH(om.metric_date);

-- Stored procedure: Calculate simple turnover rate for a given company and year
DROP PROCEDURE IF EXISTS sp_turnover_rate;
DELIMITER $$
CREATE PROCEDURE sp_turnover_rate(IN in_company_id INT, IN in_year INT)
BEGIN
  DECLARE hires INT DEFAULT 0;
  DECLARE terminations INT DEFAULT 0;
  DECLARE avg_headcount DECIMAL(10,2) DEFAULT 0;

  SELECT COUNT(*) INTO hires FROM employee_history h WHERE h.company_id = in_company_id AND h.change_type = 'HIRE' AND YEAR(h.effective_date) = in_year;
  SELECT COUNT(*) INTO terminations FROM employee_history h WHERE h.company_id = in_company_id AND h.change_type = 'TERMINATION' AND YEAR(h.effective_date) = in_year;
  SELECT AVG(cnt) INTO avg_headcount FROM (
    SELECT COUNT(*) AS cnt FROM employees e WHERE e.company_id = in_company_id GROUP BY MONTH(e.hire_date) -- simplistic proxy
  ) tmp;

  SELECT in_company_id AS company_id, in_year AS year, hires, terminations, avg_headcount, 
    CASE WHEN avg_headcount > 0 THEN ROUND((terminations / avg_headcount) * 100,2) ELSE NULL END AS turnover_rate_pct;
END$$
DELIMITER ;

-- End views and procedures
