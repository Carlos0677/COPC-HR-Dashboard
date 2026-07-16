# documentation/SETUP.md

Pasos para levantar el entorno mínimo y validar el prototipo:

1) Crear base de datos y cargar esquema

```bash
# Ejecutar el script de esquema
mysql -u root -p < database/01_create_schema.sql

# Cargar datos de ejemplo
mysql -u root -p < database/02_insert_sample_data.sql

# Crear vistas y procedimientos
mysql -u root -p < database/03_views_and_procedures.sql
```

2) Verificar las vistas y datos

- Conéctate a MySQL y ejecuta: SELECT * FROM vw_company_monthly_kpis LIMIT 10;
- Ejecuta algunas consultas de analytics: mysql -u root -p < database/04_analytics_queries.sql

3) Abrir el informe en Power BI Desktop

- Abrir Power BI Desktop
- Obtener datos -> MySQL database -> host, puerto, base de datos copc_hr_dashboard
- Seleccionar tablas indicadas en powerbi/data_model.md
- Crear la tabla Calendar: "Modeling > New Table" y pegar una fórmula de calendario común
- Añadir relaciones (si Power BI no las detecta automáticamente)
- Añadir medidas (copiar desde powerbi/dax_formulas.txt)

4) Visualizaciones recomendadas

- Página 1 - Overview: KPI cards (Headcount Activo, Turnover %, Promedio COPC, % Certificados)
- Página 2 - Attendance: Line chart de Horas Promedio 30d por departamento, tabla con días ausentes
- Página 3 - Performance: Bar chart de avg performance por departamento, detalle por empleado
- Página 4 - Training: Completion rate per program, certificados por empleado

5) Publicación

- Publicar el .pbix en Power BI Service (si corresponde) y configurar credenciales de refresco (Gateway si la base está on-premises)

