# 📊 COPC HR Dashboard - Sistema Integral de Recursos Humanos

## 🎯 Descripción

Dashboard integral de Recursos Humanos para organizaciones certificadas en **COPC** (Customer Operations Performance Center). Incluye gestión de empleados, asistencia, desempeño, licencias y análisis predictivo de rotación.

## 📁 Estructura del Proyecto

```
COPC-HR-Dashboard/
├── 📂 database/
│   ├── 01_create_schema.sql          # Creación de tablas
│   ├── 02_insert_sample_data.sql     # Datos de ejemplo
│   ├── 03_views_and_procedures.sql   # Vistas y procedimientos
│   └── 04_analytics_queries.sql      # Queries para análisis
├── 📂 powerbi/
│   ├── COPC_HR_Dashboard.pbix        # Archivo Power BI completo
│   ├── data_model.md                 # Documentación del modelo
│   └── dax_formulas.txt              # Fórmulas DAX
├── 📂 documentation/
│   ├── SETUP.md                      # Guía de instalación
│   ├── METRICS.md                    # Definición de KPIs
│   └── ARCHITECTURE.md               # Arquitectura del sistema
├── 📂 examples/
│   ├── sample_reports.md             # Reportes de ejemplo
│   └── use_cases.md                  # Casos de uso
└── README.md                         # Este archivo
```

## 🚀 Quick Start

### 1. **Base de Datos (SQL)**
```bash
# Crear esquema
mysql -u root -p < database/01_create_schema.sql

# Insertar datos de ejemplo
mysql -u root -p < database/02_insert_sample_data.sql

# Crear vistas y procedimientos
mysql -u root -p < database/03_views_and_procedures.sql
```

### 2. **Power BI**
- Abre `powerbi/COPC_HR_Dashboard.pbix`
- Conecta la fuente de datos (MySQL/SQL Server)
- Actualiza los datos
- Publica en Power BI Service

## 📊 Métricas Principales (KPIs)

### **Rotación de Personal**
- Tasa de rotación anual
- Tendencias por departamento
- Análisis de riesgo de attrición

### **Desempeño**
- Rating de desempeño por empleado
- Evaluación por departamento
- Comparativa vs. objetivos COPC

### **Asistencia**
- Tasa de asistencia promedio
- Absentismo por departamento
- Horas extras trabajadas

### **Nómina**
- Presupuesto salarial total
- Salario promedio por departamento
- Análisis de costos

### **Capacitación**
- % empleados certificados COPC
- Horas de formación/empleado
- Cumplimiento de objetivos

## 🗄️ Esquema de Base de Datos

### Tablas Principales
- **employees**: Datos demográficos y laborales
- **departments**: Estructura organizacional
- **attendance**: Registro de asistencia
- **performance_reviews**: Evaluaciones de desempeño
- **leave_requests**: Solicitudes de licencias
- **salary_templates**: Configuración salarial
- **training_records**: Registro de capacitaciones
- **operational_metrics**: Métricas COPC

## 💾 Tecnologías Utilizadas

- **Database**: MySQL 5.7+
- **BI**: Microsoft Power BI
- **Lenguaje**: SQL, DAX
- **Análisis**: Predictivo de attrición

## 📖 Documentación

- [Guía de Configuración](documentation/SETUP.md)
- [Definición de Métricas](documentation/METRICS.md)
- [Arquitectura del Sistema](documentation/ARCHITECTURE.md)

## ✅ Cumplimiento COPC

Este dashboard está diseñado para:
- ✓ Monitorear adherencia a estándares COPC
- ✓ Evaluar calidad operacional
- ✓ Mejorar satisfacción de empleados
- ✓ Optimizar productividad
- ✓ Detectar riesgos de rotación

## 👤 Autor

**Carlos0677** - Dashboard de RH para Certificación COPC

## 📝 Licencia

MIT License - Libre para usar y modificar

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:
1. Fork el proyecto
2. Crea una rama (`git checkout -b feature/mejora`)
3. Commit cambios (`git commit -m 'Agrega mejora'`)
4. Push a la rama (`git push origin feature/mejora`)
5. Abre un Pull Request

---

**Última actualización**: 2026-07-16