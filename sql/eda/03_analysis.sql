-- Asegurarse de que estamos en la base de datos correcta.
USE delitos_mexico;

-- =====================================================
-- Análisis básico
-- =====================================================

-- Delitos totales por año:
SELECT anio AS 'Año', SUM(total_casos) AS 'Delitos totales' FROM delitos_mexico_raw GROUP BY anio ORDER BY anio;

-- Top estados con más delitos:
SELECT estado AS Estado, SUM(total_casos) AS 'Delitos totales' FROM delitos_mexico_raw GROUP BY estado ORDER BY SUM(total_casos) DESC LIMIT 10;

-- Delitos totales por tipo:
SELECT tipo_delito AS 'Tipo de delito', SUM(total_casos) AS 'Delitos totales'
FROM delitos_mexico_raw GROUP BY tipo_delito ORDER BY SUM(total_casos) DESC;

-- Estacionalidad de delitos totales por mes:
SELECT mes AS Mes, SUM(total_casos) AS 'Delitos totales' FROM delitos_mexico_raw GROUP BY mes ORDER BY SUM(total_casos) DESC;