-- Motor utilizado: MySQL
-- =========================================================================
-- Archivo: m10_.sql
-- Proyecto: Pre-entrega Módulo 10
-- Base de datos: Ventas_Tech_DB
-- =========================================================================

USE Ventas_Tech_DB;

-- 1. Media y Mediana del Ticket
SELECT 
    ROUND(AVG(cantidad * precio_unitario), 2) AS media_ticket,
    (
        SELECT ROUND(total_venta, 2) 
        FROM (
            SELECT (cantidad * precio_unitario) AS total_venta,
                   ROW_NUMBER() OVER (ORDER BY (cantidad * precio_unitario)) AS rn,
                   COUNT(*) OVER() AS cnt
            FROM ventas
        ) t 
        WHERE rn IN (FLOOR((cnt + 1) / 2), CEIL((cnt + 1) / 2))
        LIMIT 1
    ) AS mediana_ticket
FROM ventas;


USE Ventas_Tech_DB;

-- 2. Cálculo de Q1, Q3, IQR y Límites de Outliers
WITH ventas_calculadas AS (
    SELECT (cantidad * precio_unitario) AS total_venta
    FROM ventas
),
ordenadas AS (
    SELECT total_venta,
           ROW_NUMBER() OVER (ORDER BY total_venta) AS rn,
           COUNT(*) OVER() AS total
    FROM ventas_calculadas
),
cuartiles AS (
    SELECT 
        (SELECT MAX(total_venta) FROM ordenadas WHERE rn <= total * 0.25) AS q1,
        (SELECT MAX(total_venta) FROM ordenadas WHERE rn <= total * 0.75) AS q3
)
SELECT 
    ROUND(q1, 2) AS Q1,
    ROUND(q3, 2) AS Q3,
    ROUND(q3 - q1, 2) AS IQR,
    GREATEST(0, ROUND(q1 - 1.5 * (q3 - q1), 2)) AS limite_inferior,
    ROUND(q3 + 1.5 * (q3 - q1), 2) AS limite_superior
FROM cuartiles;


USE Ventas_Tech_DB;

-- 3. Filtrar únicamente los Outliers que superan el límite superior
WITH ventas_calculadas AS (
    SELECT id_venta, id_producto, cantidad, precio_unitario, (cantidad * precio_unitario) AS total_venta
    FROM ventas
),
ordenadas AS (
    SELECT total_venta,
           ROW_NUMBER() OVER (ORDER BY total_venta) AS rn,
           COUNT(*) OVER() AS total
    FROM ventas_calculadas
),
limite AS (
    SELECT 
        ((SELECT MAX(total_venta) FROM ordenadas WHERE rn <= total * 0.75) 
        + 1.5 * ((SELECT MAX(total_venta) FROM ordenadas WHERE rn <= total * 0.75) 
               - (SELECT MAX(total_venta) FROM ordenadas WHERE rn <= total * 0.25))) AS limite_sup
)
SELECT 
    v.id_venta,
    v.id_producto,
    v.cantidad,
    v.precio_unitario,
    v.total_venta,
    ROUND(l.limite_sup, 2) AS limite_superior_aplicado
FROM ventas_calculadas v
CROSS JOIN limite l
WHERE v.total_venta > l.limite_sup;



-- 4. Sucursal por cuidad.
USE Ventas_Tech_DB;

SELECT 
    c.ciudad AS sucursal,
    AVG(v.cantidad * v.precio_unitario) AS media,
    MAX(v.cantidad * v.precio_unitario) - MIN(v.cantidad * v.precio_unitario) AS rango,
    STDDEV_SAMP(v.cantidad * v.precio_unitario) AS desvio_muestral
FROM ventas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
GROUP BY c.ciudad;



-- Para el boceto, cálculo extra:

USE Ventas_Tech_DB;

SELECT 
    p.nombre_producto,
    SUM(v.cantidad * v.precio_unitario) AS venta_total,
    -- Suponiendo un costo estimado del 60% del precio unitario del producto
    SUM(v.cantidad * (p.precio * 0.60)) AS costo_total,
    SUM(v.cantidad * v.precio_unitario) - SUM(v.cantidad * (p.precio * 0.60)) AS ganancia_neta,
    -- Margen de ganancia porcentual ((Venta - Costo) / Venta) * 100
    ROUND(
        ((SUM(v.cantidad * v.precio_unitario) - SUM(v.cantidad * (p.precio * 0.60))) / SUM(v.cantidad * v.precio_unitario)) * 100, 
        2
    ) AS margen_ganancia_porcentaje
FROM ventas v
INNER JOIN productos p ON v.id_producto = p.id_producto
GROUP BY p.id_producto, p.nombre_producto;
