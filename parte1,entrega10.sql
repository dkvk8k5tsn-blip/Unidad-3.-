-- 1. Creo la base de datos:
CREATE DATABASE IF NOT EXISTS pre_entrega_10;

-- 2. Para usar la base de datos ahora que si que se encuentra:
USE pre_entrega_10;

-- 3. Borro la tabla si ya existía para evitar errores 
-- (para confirmar que den los cálculos por los intentos anteriores):
DROP TABLE IF EXISTS ventas_semana;

-- 4. Hago la tabla para que sea limpia:
CREATE TABLE ventas_semana (
    sucursal VARCHAR(20),
    venta DECIMAL(10, 2)
);

-- 5. Agrego los datos de las dos sucursales dados en la letra:
INSERT INTO ventas_semana (sucursal, venta) VALUES
('Norte', 500), ('Norte', 510), ('Norte', 490), ('Norte', 505), ('Norte', 495),
('Sur', 100),   ('Sur', 900),   ('Sur', 50),    ('Sur', 1200),  ('Sur', 250);


-- Calculo de la media y rango por sucursal, agregando que se limite la cantidad de números
SELECT 
    sucursal,
    ROUND(AVG(venta), 2) AS media_ventas,
    ROUND(MAX(venta) - MIN(venta), 2) AS rango_ventas
FROM ventas_semana
GROUP BY sucursal;

-- Calculo la desviación estándar muestral, agregando que se limite por decimal:
SELECT 
    sucursal,
    ROUND(STDDEV_SAMP(venta), 2) AS desviacion_estandar
FROM ventas_semana
GROUP BY sucursal;
