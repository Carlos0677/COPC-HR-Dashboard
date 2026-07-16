# powerbi/data_model.md

Modelo de datos recomendado para Power BI (copiar/crear en Power BI Desktop):

Tablas principales (usar estas tablas desde MySQL):
- companies (company_id PK)
- departments (department_id PK, company_id FK)
- job_positions (position_id PK, department_id FK)
- employees (employee_id PK, department_id FK, position_id FK, company_id FK)
- attendance (attendance_id PK, employee_id FK, company_id FK)
- leave_requests (request_id PK, employee_id FK, company_id FK)
- leave_balances (balance_id PK)
- employee_salaries (salary_id PK)
- performance_reviews (review_id PK, employee_id FK)
- training_programs (program_id PK)
- training_records (record_id PK)
- operational_metrics (metric_id PK, department_id FK)

Relaciones recomendadas (model view):
- companies.company_id -> employees.company_id
- departments.department_id -> employees.department_id
- job_positions.position_id -> employees.position_id
- employees.employee_id -> attendance.employee_id
- employees.employee_id -> performance_reviews.employee_id
- departments.department_id -> operational_metrics.department_id

Consejos:
- Marcar columns de fecha (hire_date, attendance_date, metric_date, review_date) como tipo Date/Datetime.
- Crear una tabla Calendar/Date (tabla de fechas) y relacionarla con attendance.attendance_date y operational_metrics.metric_date para un análisis temporal consistente.
- Evitar relaciones ambigüas: usa company_id en cada relación cuando haya multi-tenant.
