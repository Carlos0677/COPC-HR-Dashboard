# Receta completa para crear el .pbix (PDF-ready)

Este documento contiene la receta paso a paso para montar el .pbix en Power BI Desktop y las instrucciones para generar el PDF final. Está en español y listo para exportar.

## Resumen
- Contenido: instrucciones paso a paso, medidas DAX, diseño de 5 páginas (Overview, Attendance, Performance, Payroll, Training), interacciones, bookmarks y checklist.
- Requisito previo: base de datos `copc_hr_dashboard` creada y poblada con los scripts en `database/`.

---

(El contenido completo de la receta larga se incluye íntegramente a continuación)


Preparación del modelo

1. Importa estas tablas desde MySQL (copiar/pegar nombres exactos):
   - companies
   - departments
   - job_positions
   - employees
   - attendance
   - leave_requests
   - leave_balances
   - employee_salaries
   - performance_reviews
   - training_programs
   - training_records
   - operational_metrics
   - vw_monthly_attendance
   - vw_company_monthly_kpis

2. Crea la tabla Calendar (Modeling > New Table) con esta DAX:

```dax
Calendar =
ADDCOLUMNS(
  CALENDAR(DATE(2024,1,1), DATE(2026,12,31)),
  "Year", YEAR([Date]),
  "Month", MONTH([Date]),
  "MonthName", FORMAT([Date],"MMMM"),
  "YearMonth", FORMAT([Date],"yyyy-MM"),
  "Quarter", "Q" & FORMAT([Date], "Q")
)
```

3. Relaciona (Model view) — relaciones clave (single direction por defecto):
   - companies.company_id -> employees.company_id
   - departments.department_id -> employees.department_id
   - job_positions.position_id -> employees.position_id
   - employees.employee_id -> attendance.employee_id
   - employees.employee_id -> performance_reviews.employee_id
   - departments.department_id -> operational_metrics.department_id
   - Calendar[Date] -> attendance[attendance_date]
   - Calendar[Date] -> operational_metrics[metric_date]

4. Asegúrate de:
   - Marcar tipos: attendance.attendance_date, performance_reviews.review_date, operational_metrics.metric_date, employees.hire_date.
   - employees[is_copc_certified] tipo Booleano/TrueFalse.


Medidas DAX (crear en Home/Modeling > New Measure)

Copia exactamente estas medidas:

```dax
-- Headcount activo
Headcount Activo = CALCULATE(COUNTROWS(Employees), Employees[status] = "ACTIVE")

-- Total Interactions
Total Interactions = SUM(Operational_Metrics[total_interactions])

-- Promedio COPC
Promedio COPC = AVERAGE(Operational_Metrics[copc_score])

-- % Certificados COPC
% Certificados COPC =
DIVIDE(
  CALCULATE(COUNTROWS(Employees), Employees[is_copc_certified] = TRUE),
  COUNTROWS(Employees),
  0
)

-- Promedio Quality
Promedio Quality = AVERAGE(Operational_Metrics[quality_score])

-- Horas promedio últimos 30 días
Horas Promedio 30d =
CALCULATE(
  AVERAGE(Attendance[hours_worked]),
  DATESINPERIOD(Calendar[Date], MAX(Calendar[Date]), -30, DAY)
)

-- Presupuesto salarial total (suma simple)
Presupuesto Salarial Total =
SUM(Employee_Salaries[base_salary])
+ COALESCE(SUM(Employee_Salaries[housing_allowance]),0)
+ COALESCE(SUM(Employee_Salaries[transport_allowance]),0)
+ COALESCE(SUM(Employee_Salaries[meal_allowance]),0)
+ COALESCE(SUM(Employee_Salaries[other_allowances]),0)

-- Avg Performance (por empleado / departamento)
Avg Performance = AVERAGE(Performance_Reviews[performance_rating])

-- Absences Count (para matrices/heatmaps)
Absences Count =
CALCULATE(
  COUNTROWS(Attendance),
  Attendance[attendance_status] = "ABSENT"
)

-- Training Completion % (global)
Training Completion % =
DIVIDE(
  CALCULATE(COUNTROWS(Training_Records), Training_Records[status] = "COMPLETED"),
  COUNTROWS(Training_Records),
  0
)
```

Consejo: crea también columna Employees[FullName] concatenando first_name y last_name.


Slicers comunes (poner en cada página)
- companies[company_name] (single-select)
- Calendar[YearMonth]
- departments[department_name] (opcional)


PÁGINA 1 — Overview (pasos detallados)

1) Insert > Card. Selecciona medida Headcount Activo.
   - Format > Data label > Decimals = 0
   - Title = "Headcount Activo"
   - Background: #FFFFFF, Border: 1px #E6EEF6

2) Repetir para Promedio COPC, % Certificados COPC y Presupuesto Salarial Total
   - Para %: Format > Data label > Display units = None, Decimal places = 1, Show %
   - Presupuesto: Format > Data label > Display units = Auto, Show as currency

3) Insert > Line chart
   - Axis: Calendar[YearMonth]
   - Values: Promedio COPC
   - Sort axis by Calendar[Date]
   - Format > Data labels = On, Decimal = 2
   - Y axis: Minimum = 0, Maximum = 5

4) Insert > Line and clustered column chart
   - Axis: Calendar[YearMonth]
   - Column values: Total Interactions
   - Line values: Promedio Quality

5) Insert > Table
   - Columns: companies[company_name], Headcount Activo, Promedio COPC, % Certificados COPC, Presupuesto Salarial Total
   - Sort by Headcount Activo desc


PÁGINA 2 — Attendance (pasos)

1) Insert > Slicer: departments[department_name]
2) Insert > Line chart
   - Axis: Calendar[YearMonth]
   - Legend: departments[department_name]
   - Values: Horas Promedio 30d
3) Insert > Matrix
   - Rows: departments[department_name]
   - Columns: Calendar[YearMonth]
   - Values: Absences Count
   - Format > Conditional formatting > Background color scale (green->red)
4) Insert > Table with attendance details
   - Columns: Employees[FullName], employees[employee_code], attendance[attendance_date], attendance[clock_in], attendance[clock_out], attendance[hours_worked], attendance[attendance_status]
   - Sort: attendance_date desc


PÁGINA 3 — Performance (pasos)

1) Insert > Clustered bar chart
   - Axis: departments[department_name]
   - Values: Avg Performance
   - Data labels: On
2) Insert > Table (reviews)
   - Columns: Employees[FullName], performance_reviews[review_date], performance_reviews[performance_rating], performance_reviews[quality_score], performance_reviews[comments], performance_reviews[status]
3) Top N: En pane Filters use Top N on Employees by Avg Performance (Top 10)


PÁGINA 4 — Payroll & Costs (pasos)

1) Insert > Card: Presupuesto Salarial Total (formato moneda)
2) Insert > Clustered bar chart
   - Axis: departments[department_name]
   - Values: Avg Salary (crear medida Avg Salary = AVERAGE(Employee_Salaries[base_salary]))
3) Insert > Table: employee salary details
   - Columns: Employees[FullName], Employee_Salaries[base_salary], employee_salaries[effective_date], employee_salaries[is_active]


PÁGINA 5 — Training & Certifications (pasos)

1) Insert > Donut chart
   - Legend: training_programs[program_name]
   - Values: Training Completion % (por programa) — ver nota abajo
2) Insert > Table (certificados COPC)
   - Columns: Employees[FullName], Employees[is_copc_certified], Training_Records[program_id] (mapear al nombre), training_records[certification_date], training_records[status]
3) Insert > Bar chart
   - Axis: Employees[FullName]
   - Values: SUM(training_records[hours_completed])

Nota: para medidas por programa (Training Completion % por programa) usa la medida con contexto de programa en el donut.


Interacciones, Bookmarks y Drillthrough
- Edit interactions: Report > Edit interactions, permite que slicers afecten visuales
- Bookmarks: crear "Overview default" y "Presentation"
- Drillthrough: crea página detalle con Employee[FullName] en Drillthrough filters


Exportar PDF y PNGs (instrucciones)

1) Desde Power BI: File > Export > Export to PDF — esto exporta todas las páginas como PDF.
2) Para generar PNGs desde los SVG que añadí al repo (o desde Power BI):
   - Si tienes Inkscape instalado (Linux/Mac/Windows):
     inkscape images/overview.svg --export-type=png --export-filename=images/overview.png
   - O con rsvg-convert:
     rsvg-convert -o images/overview.png images/overview.svg

3) Para generar PDF desde este markdown (local):
   pandoc documentation/POWERBI_RECIPE.md -o documentation/POWERBI_RECIPE.pdf --pdf-engine=xelatex


Checklist de verificación
- [ ] Headcount Activo correcto
- [ ] Promedio COPC coincide con la media en operational_metrics
- [ ] Horas Promedio 30d reflejan attendance
- [ ] Presupuesto Salarial Total suma correctamente
- [ ] Training Completion % concuerda con training_records


Fin del documento. Si quieres, puedo:
- Añadir un GitHub Action que convierta automáticamente el Markdown a PDF y los SVG a PNG cada vez que empujes a main.
- Generar versiones PNG de las simulaciones y añadirlas al repo si me das permiso para ejecutar una acción (o puedo añadir el Action y tú lo activas).
