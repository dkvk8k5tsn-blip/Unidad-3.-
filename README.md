**Descripción del Proyecto**
Este repositorio forma parte del proyecto RetailPro y tiene como objetivo diseñar e implementar una solución analítica integral de Business Intelligence. A través de MySQL, Power Query y Power BI Desktop, se construye un flujo de trabajo que abarca desde la estructuración de la base de datos relacional y consultas avanzadas, hasta la creación de un modelo multidimensional en estrella (Star Schema) para el análisis de ventas, rentabilidad por canal y comportamiento de clientes.
**Desarrollo y Arquitectura de Datos**
El proyecto evoluciona la base de datos relacional hacia un esquema analítico optimizado para Business Intelligence. Se estructura en un Modelo en Estrella (Star Schema) compuesto por:
Tabla de Hechos (Fact_Ventas): Registra las transacciones comerciales detalladas (cliente, producto, canal, precio unitario, montos totales y fecha).
Tablas Dimensionales (Dim_Clientes, Dim_Productos, Dim_Categorias, Dim_Fechas): Contienen los atributos descriptivos que permiten filtrar y segmentar la información.
Tabla Organizadora (_Medidas): Tabla contenedora desconectada diseñada exclusivamente para almacenar los indicadores clave de negocio (KPIs) en lenguaje DAX.
Métricas Clave y Medidas DAX
Se implementó la tabla organizadora _Medidas con las principales fórmulas de negocio:
Total Ventas: Suma total de facturación.
Ventas Online: Cálculo condicional de facturación por canal digital (CALCULATE).
Ventas YTD: Acumulado de ventas año a año (TOTALYTD).
Ventas LY: Ventas del mismo período del año anterior (SAMEPERIODLASTYEAR).
% Crecimiento Anual: Tasa de crecimiento interanual calculada mediante variables y control de división por cero (DIVIDE).
**Datos Utilizados y Pipeline ETL**
Se trabajó con datos de transacciones comerciales, clientes y catálogo de productos tecnológicos. El proceso ETL (Extracción, Transformación y Carga) se ejecutó mediante Power Query, garantizando la limpieza de tipos de datos, eliminación de redundancias, modelado de claves primarias/foráneas y la vinculación con la tabla calendario Dim_Fechas.
**Tecnologías Utilizadas**
Base de Datos: MySQL y MySQL Workbench (Consultas con INNER JOIN, LEFT JOIN y UNION ALL).
ETL & Transformación: Power Query.
Business Intelligence & Visualización: Power BI Desktop (Modelado 1:N y paneles relacionales).
Lenguajes: SQL y DAX.
Control de Versiones: GitHub.
**Aplicaciones y Análisis de Negocio**
El desarrollo permite realizar análisis comerciales avanzados orientados a la toma de decisiones estratégicas:
Evaluación del margen de contribución y concentración de ingresos por productos estrella.
Medición de la efectividad del canal Online vs. Presencial.
Identificación de patrones de estacionalidad y análisis comparativo interanual (YTD / LY).
Segmentación del comportamiento de compra de clientes recurrentes.
**Cómo Ejecutar el Proyecto**
1. Entorno de Base de Datos (MySQL)
Descargar o clonar el repositorio.
Abrir los scripts SQL en MySQL Workbench o cliente compatible.
Ejecutar los scripts de creación de vistas y consultas de validación para verificar la coherencia relacional.
2. Entorno Analítico (Power BI)
Abrir el archivo .pbix del proyecto en Power BI Desktop.
Ir a la Vista de Modelo para comprobar las relaciones 1:N y la presencia de la tabla Dim_Fechas.
Revisar el panel de datos a la derecha para inspeccionar la tabla _Medidas con sus correspondientes fórmulas DAX.
****Contexto del Proyecto****
Este proyecto se desarrolla como parte del proyecto integrador RetailPro en Data Analytics, con foco en el ciclo completo de datos: ingeniería de datos relacional, modelado analítico multidimensional y generación de métricas de negocio para la toma de decisiones basada en datos.
