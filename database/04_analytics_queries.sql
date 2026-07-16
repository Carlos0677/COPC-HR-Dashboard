-- database/04_analytics_queries.sql
USE copc_hr_dashboard;

-- 1) Turnover rate (simple approximation using employee_history)
-- CALL sp_turnover_rate(<company_id>, <year>);

-- 2) Top 10 employees by average performance_rating
SELECT e.employee_id, e.first_name, e.last_name, ROUND(AVG(pr.performance_rating),2) AS avg_perf
FROM performance_reviews pr
JOIN employees e ON e.employee_id = pr.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY avg_perf DESC
LIMIT 10;

-- 3) Average attendance hours by department for last 30 days
SELECT d.department_id, d.department_name, ROUND(AVG(a.hours_worked),2) AS avg_hours
FROM attendance a
JOIN employees e ON e.employee_id = a.employee_id
JOIN departments d ON d.department_id = e.department_id
WHERE a.attendance_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
GROUP BY d.department_id, d.department_name;

-- 4) Percentage of employees certified in COPC by company
SELECT c.company_id, c.company_name, ROUND( (SUM(CASE WHEN e.is_copc_certified THEN 1 ELSE 0 END) / COUNT(e.employee_id)) * 100,2) AS pct_copc_certified
FROM companies c
JOIN employees e ON e.company_id = c.company_id
GROUP BY c.company_id, c.company_name;

-- 5) Training completion rate per program
SELECT tp.program_id, tp.program_name, ROUND( (SUM(CASE WHEN tr.status = 'COMPLETED' THEN 1 ELSE 0 END) / COUNT(tr.record_id)) * 100,2) AS completion_pct
FROM training_programs tp
LEFT JOIN training_records tr ON tr.program_id = tp.program_id
GROUP BY tp.program_id, tp.program_name;

-- 6) Monthly COPC score trend for a company
SELECT company_id, year, month, avg_copc_score
FROM vw_company_monthly_kpis
WHERE company_id = 1
ORDER BY year, month;

-- End analytics queries
