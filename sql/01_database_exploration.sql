-- OLIST | Sales Performance
-- 01. Exploración inicial de la base de datos
-- Objetivo: Identificar las tablas disponibles y sus columnas
-- antes de seleccionar las necesarias para el análisis.

SELECT
    table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'public'
ORDER BY
    table_name,
    ordinal_position;
