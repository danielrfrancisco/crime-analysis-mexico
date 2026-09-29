-- Asegurarse de que estamos en la base de datos correcta.
USE delitos_mexico;

-- =====================================================
-- Exploración de variables
-- =====================================================

-- Ver los años y meses disponibles:
SELECT DISTINCT anio AS 'Año' FROM delitos_mexico_raw ORDER BY anio;
SELECT DISTINCT mes AS Mes FROM delitos_mexico_raw ORDER BY mes;

-- Conocer los estados disponibles:
SELECT COUNT(DISTINCT estado) AS 'Estados disponibles' FROM delitos_mexico_raw;
SELECT DISTINCT estado AS Estado FROM delitos_mexico_raw ORDER BY estado;

-- Conocer las variables categóricas clave:
SELECT COUNT(DISTINCT tipo_delito) AS 'Tipos de delitos disponibles' FROM delitos_mexico_raw;
SELECT COUNT(DISTINCT subtipo_delito) AS 'Subtipos de delitos disponibles' FROM delitos_mexico_raw;
SELECT COUNT(DISTINCT modalidad) AS 'Modalidades disponibles' FROM delitos_mexico_raw;
SELECT COUNT(DISTINCT bien_juridico_afectado) AS 'Bienes jurídicos afectados disponibles' FROM delitos_mexico_raw;

-- =====================================================
-- Calidad de los datos
-- =====================================================

-- Verificar si existen valores nulos:
SELECT
    SUM(anio IS NULL) AS '"anio" nulos',
    SUM(codigo_estado IS NULL) AS '"codigo_estado" nulos',
    SUM(estado IS NULL) AS '"estado" nulos',
    SUM(bien_juridico_afectado IS NULL) AS '"bien_juridico_afectado" nulos',
    SUM(tipo_delito IS NULL) AS '"tipo_delito" nulos',
    SUM(subtipo_delito IS NULL) AS '"subtipo_delito" nulos',
    SUM(modalidad IS NULL) AS '"modalidad" nulos',
    SUM(mes IS NULL) AS '"mes" nulos',
    SUM(total_casos IS NULL) AS '"total_casos" nulos'
FROM delitos_mexico_raw;

-- Verificar si existen valores negativos para el conteo de casos:
SELECT * FROM delitos_mexico_raw WHERE total_casos < 0;

-- Verificar si existen entradas lógicas duplicadas:
SELECT
    anio,
    estado,
    tipo_delito,
    subtipo_delito,
    modalidad,
    mes,
    COUNT(*) AS 'Entradas lógicas duplicadas'
FROM delitos_mexico_raw
GROUP BY
    anio, estado, tipo_delito, subtipo_delito, modalidad, mes
HAVING COUNT(*) > 1;

-- Verificar si existen valores vacíos:
SELECT
	SUM(anio = '') AS '"anio" vacíos',
    SUM(codigo_estado = '') AS '"codigo_estado" vacíos',
    SUM(estado = '') AS '"estado" vacíos',
    SUM(bien_juridico_afectado = '') AS '"bien_juridico_afectado" vacíos',
    SUM(tipo_delito = '') AS '"tipo_delito" vacíos',
    SUM(subtipo_delito = '') AS '"subtipo_delito" vacíos',
    SUM(modalidad = '') AS '"modalidad" vacíos',
    SUM(mes = '') AS '"mes" vacíos',
    SUM(total_casos IS NULL) AS '"total_casos" nulos'
FROM delitos_mexico_raw;

-- Verificación de consistencia jerárquica:
SELECT DISTINCT tipo_delito AS 'Tipo de delito', subtipo_delito AS 'Subtipo de delito' FROM delitos_mexico_raw ORDER BY tipo_delito;

-- Verificar que no hayan entradas duplicadas exactas:
SELECT COUNT(*) AS 'Entradas totales',
       COUNT(DISTINCT CONCAT(
           anio, '-', codigo_estado, '-', estado, '-', bien_juridico_afectado, '-', tipo_delito, '-', subtipo_delito, '-', modalidad, '-', mes, '-',
           total_casos
       )) AS 'Entradas únicas'
FROM delitos_mexico_raw;