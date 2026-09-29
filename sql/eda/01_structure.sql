-- Asegurarse de que estamos en la base de datos correcta.
USE delitos_mexico;

-- =====================================================
-- Estructura del dataset
-- =====================================================

-- Ver la estructura de la tabla:
DESCRIBE delitos_mexico_raw;

-- Conocer el tamaño del dataset:
SELECT COUNT(*) AS 'Entradas totales' FROM delitos_mexico_raw;

-- Hacer un vistazo rápido de los datos:
SELECT * FROM delitos_mexico_raw LIMIT 10;