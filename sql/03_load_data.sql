-- Asegurarse de que estamos en la base de datos correcta.
USE delitos_mexico;

-- Realizar la ingesta de datos.
LOAD DATA LOCAL INFILE 'ruta/mexico_crime.csv'
INTO TABLE delitos_mexico_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(anio, codigo_estado, estado, bien_juridico_afectado,
tipo_delito, subtipo_delito, modalidad, mes, total_casos);