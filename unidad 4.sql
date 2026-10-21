-- Motor utilizado: MySQL
-- =========================================================================
-- Archivo: m4_consultas_negocio.sql
-- Proyecto: Pre-entrega Módulo 4
-- Base de datos: Ventas_Tech_DB
-- =========================================================================

USE Ventas_Tech_DB;

-- =========================================================================
-- CONSULTA 1 — Resumen ejecutivo mensual
-- Total facturado, cantidad de pedidos y ticket promedio, agrupados por mes.
-- =========================================================================
SELECT 
    MONTH(fecha_venta) AS mes,
    COUNT(id_venta) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_facturado,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;


-- =========================================================================
-- CONSULTA 2 — Ranking de productos.
-- Top 5 de id_producto por total facturado, unidades vendidas y total generado.
-- =========================================================================
SELECT 
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC
LIMIT 5;


-- =========================================================================
-- CONSULTA 3 — Clientes recurrentes
-- Clientes que hayan realizado más de un pedido, mostrando su cantidad y total gastado.
-- =========================================================================
SELECT 
    id_cliente,
    COUNT(id_venta) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(id_venta) > 1
ORDER BY total_gastado DESC;


-- =========================================================================
-- CONSULTA 4 — Meses por encima/por debajo del promedio general
-- Total facturado por mes con una columna adicional que etiquete con CASE WHEN  si ese mes quedó 'Por encima' o 'Por debajo' del promedio mensual general.
-- =========================================================================
WITH VentasMensuales AS (
    SELECT 
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS facturacion_mes
    FROM ventas
    GROUP BY MONTH(fecha_venta)
),
PromedioGeneral AS (
    SELECT AVG(facturacion_mes) AS promedio_mensual FROM VentasMensuales
)
SELECT 
    v.mes,
    v.facturacion_mes,
    ROUND(p.promedio_mensual, 2) AS promedio_general_referencia,
    CASE 
        WHEN v.facturacion_mes >= p.promedio_mensual THEN 'Por encima'
        ELSE 'Por debajo'
    END AS rendimiento_mes
FROM VentasMensuales v
CROSS JOIN PromedioGeneral p
ORDER BY v.mes;


-- =========================================================================
-- BLOQUE DE CIERRE: Hallazgos concretos.
-- =========================================================================
-- 1. Concentración de ingresos por producto: El producto con ID 1 (Es decir, la Laptop) 
--    lidera ampliamente la facturación total debido a su alto valor unitario, 
--    convirtiéndose en el motor financiero principal.
-- 2. Comportamiento de clientes recurrentes: Se detectó que clientes específicos (como el 
--    id_cliente 1 y 3) realizan compras múltiples, lo que demuestra fidelización y justifica 
--    implementar campañas de beneficios o promociones por fidelidad. 
-- 3. Variabilidad estacional de la demanda: Al comparar los meses contra el promedio general, 
--    se identifican períodos pico de facturación que permiten al equipo comercial planificar 
--    con antelación la reposición de accesorios.