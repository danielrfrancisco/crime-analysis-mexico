-- Asegurarse de que estamos en la base de datos correcta.
USE delitos_mexico;

-- =====================================================
-- Creación de dimensiones
-- =====================================================

-- Crear la dimensión para las fechas:
CREATE TABLE dim_fecha AS
SELECT DISTINCT
    fecha AS fecha_id,
    fecha,
    anio,
    mes_num,
    mes AS mes_nombre
FROM delitos_mexico_clean;

-- Crear la dimensión para los estados:
CREATE TABLE dim_estado AS
SELECT DISTINCT
    codigo_estado,
    estado
FROM delitos_mexico_clean;

-- Crear la dimensión para los delitos:
CREATE TABLE dim_delito AS
SELECT DISTINCT
    bien_juridico_afectado,
    tipo_delito,
    subtipo_delito,
    modalidad
FROM delitos_mexico_clean;

-- =====================================================
-- Agregación de claves
-- =====================================================

-- Agregar claves para la dimensión de las fechas. Convertir la columa "fecha_id" a claves:
ALTER TABLE dim_fecha ADD PRIMARY KEY (fecha_id);

-- Agregar claves para la dimensión de los estados.
ALTER TABLE dim_estado ADD COLUMN estado_id INT AUTO_INCREMENT PRIMARY KEY;

-- Agregar claves para la dimensión de los delitos.
ALTER TABLE dim_delito ADD COLUMN delito_id INT AUTO_INCREMENT PRIMARY KEY;

-- =====================================================
-- Creación de la tabla de hechos
-- =====================================================

-- Crear la tabla fact:
CREATE TABLE fact_delitos AS
SELECT
    f.fecha AS fecha_id,
    e.estado_id,
    d.delito_id,
    f.total_casos
FROM delitos_mexico_clean f

JOIN dim_estado e ON f.codigo_estado = e.codigo_estado
    
JOIN dim_delito d
    ON f.bien_juridico_afectado = d.bien_juridico_afectado
    AND f.tipo_delito = d.tipo_delito
    AND f.subtipo_delito = d.subtipo_delito
    AND f.modalidad = d.modalidad;
    
-- =====================================================
-- Creación de índices
-- =====================================================

-- Crear un índice para cada dimensión:
CREATE INDEX idx_fact_fecha ON fact_delitos(fecha_id);
CREATE INDEX idx_fact_estado ON fact_delitos(estado_id);
CREATE INDEX idx_fact_delito ON fact_delitos(delito_id);

-- =====================================================
-- Creación de llaves foráneas
-- =====================================================

-- Crear llaves foráneas para cada dimensión:
ALTER TABLE fact_delitos ADD CONSTRAINT fk_fecha
FOREIGN KEY (fecha_id) REFERENCES dim_fecha(fecha_id);

ALTER TABLE fact_delitos ADD CONSTRAINT fk_estado
FOREIGN KEY (estado_id) REFERENCES dim_estado(estado_id);

ALTER TABLE fact_delitos ADD CONSTRAINT fk_delito
FOREIGN KEY (delito_id) REFERENCES dim_delito(delito_id);

-- =====================================================
-- Validaciones finales del modelo
-- =====================================================

-- Verificar que no se perdieron filas:
SELECT COUNT(*) AS 'Filas "fact"' FROM fact_delitos;
SELECT COUNT(*) AS 'Filas "clean"' FROM delitos_mexico_clean;

-- Verificar la integridad de los joins:
SELECT COUNT(*) FROM fact_delitos WHERE estado_id IS NULL OR delito_id IS NULL;

-- Verificar que no hayan entradas duplicadas en las dimensiones:
SELECT codigo_estado, COUNT(*) FROM dim_estado
GROUP BY codigo_estado HAVING COUNT(*) > 1;

SELECT bien_juridico_afectado, tipo_delito, subtipo_delito, modalidad, COUNT(*) FROM dim_delito
GROUP BY bien_juridico_afectado, tipo_delito, subtipo_delito, modalidad HAVING COUNT(*) > 1;

-- Verificar las relaciones:
SELECT * FROM fact_delitos f
LEFT JOIN dim_estado e ON f.estado_id = e.estado_id WHERE e.estado_id IS NULL;

-- Actualizar las estadísticas internas:
ANALYZE TABLE fact_delitos;
ANALYZE TABLE dim_estado;
ANALYZE TABLE dim_delito;
ANALYZE TABLE dim_fecha;