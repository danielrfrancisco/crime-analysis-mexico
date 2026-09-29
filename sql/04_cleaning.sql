-- Asegurarse de que estamos en la base de datos correcta.
USE delitos_mexico;

-- =====================================================
-- Creación de la tabla limpia
-- =====================================================

-- Crear la tabla base
CREATE TABLE delitos_mexico_clean AS
SELECT
    anio,
    codigo_estado,
    TRIM(estado) AS estado,
    TRIM(bien_juridico_afectado) AS bien_juridico_afectado,
    TRIM(tipo_delito) AS tipo_delito,
    TRIM(subtipo_delito) AS subtipo_delito,
    TRIM(modalidad) AS modalidad,
    TRIM(mes) AS mes,
    total_casos
FROM delitos_mexico_raw;

-- Desactivar el modo seguro si es necesario:
SET SQL_SAFE_UPDATES = 0;

-- Agrgar un identificador ID a cada entrada de la tabla limpia:
ALTER TABLE delitos_mexico_clean ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY;

-- Crear la columna que contendrá el mes en formato numérico:
ALTER TABLE delitos_mexico_clean ADD COLUMN mes_num INT;

-- Agregar el valor numérico correspondiente a cada mes:
UPDATE delitos_mexico_clean
SET mes_num = CASE
    WHEN mes = 'January' THEN 1
    WHEN mes = 'February' THEN 2
    WHEN mes = 'March' THEN 3
    WHEN mes = 'April' THEN 4
    WHEN mes = 'May' THEN 5
    WHEN mes = 'June' THEN 6
    WHEN mes = 'July' THEN 7
    WHEN mes = 'August' THEN 8
    WHEN mes = 'September' THEN 9
    WHEN mes = 'October' THEN 10
    WHEN mes = 'November' THEN 11
    WHEN mes = 'December' THEN 12
END;

-- Crear la columna que contendrá la fecha:
ALTER TABLE delitos_mexico_clean ADD COLUMN fecha DATE;

-- Agregar la fecha en el formato correspondiente:
UPDATE delitos_mexico_clean
SET fecha = STR_TO_DATE(
    CONCAT(anio, '-', mes_num, '-01'), '%Y-%m-%d'
);

-- Reescribir los nombres de los estados en mayúsculas:
UPDATE delitos_mexico_clean SET estado = UPPER(estado);

-- Reactivar el modo seguro en caso de que haya sido desactivado:
SET SQL_SAFE_UPDATES = 1;

-- Realizar una validación rápida:
SELECT
	COUNT(*) AS 'Filas totales',
	SUM(CASE WHEN mes_num IS NULL THEN 1 ELSE 0 END) AS 'Meses nulos',
	SUM(CASE WHEN fecha IS NULL THEN 1 ELSE 0 END) AS 'Fechas nulas'
FROM delitos_mexico_clean;