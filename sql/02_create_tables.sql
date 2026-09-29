-- Crear la tabla con la información de la base de datos.
CREATE TABLE delitos_mexico_raw (
    anio INT,
    codigo_estado INT,
    estado VARCHAR(100),
    bien_juridico_afectado VARCHAR(150),
    tipo_delito VARCHAR(150),
    subtipo_delito VARCHAR(150),
    modalidad VARCHAR(150),
    mes VARCHAR(20),
    total_casos INT
);