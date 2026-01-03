# Proyecto RA1 – Big Data  
## Intentos de Inicio de Sesión Fallidos – ETL y Data Warehouse para Analítica de Seguridad

**Autor:** Unai Canet  
**Fecha:** Diciembre 2025  


**Stack Tecnológico:**  
Python · Pandas · PySpark · SQLite · SQL · Docker · ETL · Data Warehouse

---

## Descripción del Proyecto

Este proyecto implementa un **pipeline ETL completo de extremo a extremo** aplicado a un escenario realista de **analítica de ciberseguridad**.  
El dataset contiene **10.000 eventos de intentos de inicio de sesión fallidos** (`failed_logins.csv`) con múltiples problemas reales de calidad de datos.

El objetivo es transformar logs de seguridad ruidosos e inconsistentes en un **Data Warehouse analítico estructurado**, que permita realizar análisis avanzados mediante SQL, tales como:

- Detección de patrones sospechosos de inicio de sesión  
- Monitoreo de alertas de seguridad  
- Análisis de comportamiento de acceso y reportes  

Se implementan **dos pipelines ETL en paralelo**:

- **ETL con Pandas:** Procesamiento en memoria con control explícito de la calidad de los datos  
- **ETL con PySpark:** Procesamiento escalable con enfoque de Big Data  

Ambos pipelines generan **Data Warehouses en SQLite** equivalentes, siguiendo un **modelo dimensional en esquema estrella**, comúnmente utilizado en entornos analíticos de producción.

---

## Objetivos del Proyecto

- Realizar limpieza de datos realista sobre logs de seguridad  
- Diseñar e implementar pipelines ETL completos  
- Comparar Pandas y PySpark desde una perspectiva de ingeniería de datos  
- Construir un Data Warehouse dimensional optimizado para análisis  
- Ejecutar consultas analíticas SQL sobre datos estructurados  
- Garantizar reproducibilidad completa mediante Docker  
- Entregar documentación clara y profesional  

---

## Problemas de Calidad de Datos Identificados

El dataset original presenta varios problemas que impiden su análisis directo:

- Valores faltantes en campos críticos (`device`, `login_attempts`, `source_port`)  
- Múltiples formatos de fecha (`dd/mm/yyyy`, `yyyy-mm-dd`, `mm-dd-yyyy`)  
- Valores categóricos inconsistentes (`ROOT` vs `root`, `FAIL` vs `failed`)  
- Valores de texto en campos numéricos (`"three"`, `"5+"`)  
- Números de puerto inválidos (por ejemplo, `65536`)  

Estos problemas justifican la necesidad de un proceso ETL robusto, similar al requerido en sistemas de seguridad en producción.

---


## Estructura del Proyecto

```text
failed_logins/
├── Dockerfile
├── docker-compose.yml
├── Data/
│   ├── dataset_clean_pandas.csv
│   ├── dataset_clean1.csv
│   └── failed_logins
│
├── notebooks/
│   ├── 01_pandas_sqlite.ipynb
│   ├── 01_pandasfinal.ipynb
│   └── 02_spark.ipynb
│
├── warehouse/
│   ├── warehouse_pandas.db
│   ├── warehouse_pyspark1.db
│   ├── modelo_datawarehouse_pandas.sql
│   └── modelo_datawarehouse_pyspark.sql
│
└── docs/
    └──README.md
```

## 📊 Fase 1 – Exploración de Datos y ETL con Pandas

### 📓 Notebook
- `01_pandasFinal.ipynb`

### 🎯 Objetivo
Transformar un dataset bruto, inconsistente y con problemas de calidad en una **fuente de datos limpia, tipada y lista para análisis**, apta para ser cargada en un **Data Warehouse**.

### 🔧 Transformaciones Clave
- Normalización de texto (`lower()`, `strip()`)
- Conversión robusta de fechas con `to_datetime`, gestionando múltiples formatos
- Conversión de valores textuales a numéricos (`"three" → 3`, `"5+" → 5`)
- Estandarización de banderas binarias (`alert_flag → 0 / 1`)
- Tipado explícito de columnas para garantizar consistencia analítica

### 📁 Resultado
**`dataset_clean_pandas.csv`**
- 10.000 registros válidos
- Sin valores inválidos ni inconsistentes
- Tipos de datos homogéneos y listos para explotación analítica

---

## ⚙️ Fase 2 – Procesamiento ETL con PySpark

### 📓 Notebook
- `02_pyspark.ipynb`

### 🎯 Objetivo
Replicar el mismo proceso ETL utilizando **PySpark**, simulando un entorno de **procesamiento distribuido y escalable**, típico de arquitecturas Big Data.

### 🔄 Operaciones Realizadas
- Inicialización de `SparkSession`
- Transformaciones de columnas con `withColumn`
- Filtrado de registros con `filter`
- Agregaciones con `groupBy`
- Validación de resultados comparándolos con el pipeline de Pandas

📌 *Esta fase demuestra que el diseño del ETL es independiente de la tecnología, una competencia clave en perfiles de Data Engineer.*

---

## 🔄 Fase 3 – ETL Completo con Pandas → Data Warehouse en SQLite

### 🎯 Objetivo
Implementar el ciclo completo **Extract – Transform – Load (ETL)** utilizando Pandas y cargar los datos en un **Data Warehouse dimensional**.

### 🔧 Proceso
**Extract**
- Lectura del dataset limpio

**Transform**
- Creación de tablas dimensionales con claves sustitutas
- Preparación de la tabla de hechos

**Load**
- Carga de dimensiones y hechos en SQLite mediante `to_sql()` y SQLAlchemy

### 📁 Resultado
- `warehouse/warehouse_pandas.db`

---

## ⚡ Fase 4 – ETL Completo con PySpark → Data Warehouse en SQLite

### 🎯 Objetivo
Construir el **mismo Data Warehouse** utilizando PySpark, manteniendo el modelo dimensional.

### 🔧 Proceso
- Creación de dimensiones usando `dropDuplicates()`
- Construcción de la tabla de hechos mediante joins entre DataFrames
- Conversión final a Pandas para compatibilidad con SQLite
- Carga en base de datos

### 📁 Resultado
- `warehouse/warehouse_pyspark.db`

📌 *Mismo modelo de datos, distinta tecnología de procesamiento.*

---

## 🧠 Fase 5 – Diseño del Data Warehouse (Modelo Estrella)

El Data Warehouse se diseña siguiendo un **modelo dimensional tipo Star Schema**, optimizado para consultas analíticas y reporting de seguridad.

### ⭐ Esquema Estrella
```text
                         dim_dates
                             ▲
                             │
dim_users ───────────▶ fact_logins ◀────────── dim_ports

```
## 📐 Justificación del Modelo

El **modelo estrella (Star Schema)** ha sido elegido por su idoneidad en entornos analíticos y de reporting:

- Simplifica las consultas SQL mediante relaciones claras entre hechos y dimensiones
- Mejora el rendimiento en análisis agregados y consultas complejas
- Facilita el análisis multidimensional por:
  - Usuario
  - Tiempo
  - Ubicación
  - Puertos de origen

---

## 🗂️ Tablas del Modelo

### ⭐ Tabla de Hechos

**`fact_logins`**
- Representa cada evento de login fallido
- Contiene métricas y banderas de seguridad
- Incluye claves foráneas hacia las tablas dimensionales

---

### 📊 Tablas Dimensionales

**`dim_users`**
- Información del usuario: nombre, rol, ubicación y dispositivo

**`dim_ports`**
- Catálogo normalizado de puertos de origen

**`dim_dates`**
- Dimensión temporal para análisis por año, mes y día

---

Este diseño permite responder preguntas clave de seguridad como:

- ¿Qué usuarios generan más intentos fallidos?
- ¿Desde qué ubicaciones se producen más alertas?
- ¿En qué periodos temporales aumentan los ataques?

---

## 🔍 Fase 6 – Consultas SQL de Análisis

A continuación se muestran ejemplos de consultas analíticas realizadas sobre el Data Warehouse dimensional, que permiten explotar los datos de seguridad tras el proceso ETL.

## 1️⃣ Visualización inicial de eventos de seguridad

````Validación básica de la carga de datos en la tabla de hechos.

SELECT *
FROM fact_logins
LIMIT 10;
````
## 2️⃣ Usuarios con mayor número de intentos de login fallidos

````Identifica posibles cuentas comprometidas o bajo ataque.

SELECT 
    u.username,
    COUNT(*) AS total_intentos_fallidos
FROM fact_logins f
JOIN dim_users u 
    ON f.user_id = u.user_id
WHERE f.status = 'failed'
GROUP BY u.username
ORDER BY total_intentos_fallidos DESC
LIMIT 10;
````
## 3️⃣ Distribución de alertas de seguridad por ubicación

````Permite detectar regiones con mayor actividad sospechosa.

SELECT 
    u.location,
    COUNT(*) AS total_alertas,
    COUNT(DISTINCT u.username) AS usuarios_afectados
FROM fact_logins f
JOIN dim_users u 
    ON f.user_id = u.user_id
WHERE f.alert_flag = 1
GROUP BY u.location
ORDER BY total_alertas DESC;
````
## 4️⃣ Análisis temporal de intentos de login

````Detecta picos de actividad sospechosa a lo largo del tiempo.

SELECT 
    d.year,
    d.month,
    COUNT(*) AS total_intentos
FROM fact_logins f
JOIN dim_dates d 
    ON f.date_id = d.date_id
GROUP BY d.year, d.month
ORDER BY d.year, d.month;
````
## 5️⃣ Puertos de origen más utilizados en intentos fallidos

```Útil para análisis de patrones de ataque y tráfico sospechoso.

SELECT 
    p.source_port,
    COUNT(*) AS total_intentos
FROM fact_logins f
JOIN dim_ports p 
    ON f.port_id = p.port_id
GROUP BY p.source_port
ORDER BY total_intentos DESC
LIMIT 10;
---
````
## 🐳 Fase 7 – Entorno Dockerizado

### 🎯 Objetivo
Garantizar **reproducibilidad total** del proyecto y facilitar su ejecución en cualquier entorno.

```bash
docker-compose up --build
Acceso a Jupyter Notebook:
👉 http://localhost:8888
```
