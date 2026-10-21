-- Motor utilizado: MySQL
-- =========================================================================
-- Archivo: m5_consultas_joins.sql
-- Proyecto: Pre-entrega Módulo 5
-- Base de datos: Ventas_Tech_DB
-- =========================================================================

USE Ventas_Tech_DB;

-- =========================================================================
-- CONSULTA 1 — Vista base del proyecto (INNER JOIN)
-- Propósito: combinar la tabla de ventas con clientes, productos y categorías 
-- para obtener una vista enriquecida con fecha, cliente, producto, categoría, 
-- región/ciudad, cantidad, precio unitario y total de venta para Power BI.
-- =========================================================================
SELECT 
    v.fecha_venta,
    c.nombre AS nombre_cliente,
    c.ciudad AS region_cliente,
    pr.nombre_producto,
    cat.nombre_categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
INNER JOIN productos pr ON v.id_producto = pr.id_producto
INNER JOIN categorias cat ON pr.id_categoria = cat.id_categoria;

-- Hallazgo: Esta vista permite analizar las ventas cruzando la dimensión geográfica ciudad del cliente con las categorías de productos, facilitando la futura construcción en el dashboard.


-- =========================================================================
-- CONSULTA 2 — Clientes sin ventas (LEFT JOIN)
-- Propósito: Identificar clientes registrados que aún no han realizado ninguna compra 
-- utilizando LEFT JOIN y WHERE ... IS NULL
-- =========================================================================
SELECT 
    c.id_cliente,
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- Hallazgo: 0 clientes sin compras; el 100% de los clientes registrados en la base 
-- han realizado al menos una transacción. Para el área de CRM, 
-- esto implica que la tasa de conversión inicial es del 100% y que todos los 
-- usuarios registrados están activos, por lo que las acciones deben centrarse 
-- en la retención y fidelización en lugar de la reactivación.


-- =========================================================================
-- CONSULTA 3 — Productos sin ventas (LEFT JOIN)
-- Propósito: Identificar los artículos del catálogo que no tienen ninguna venta registrada 
-- utilizando LEFT JOIN y WHERE ... IS NULL, para que el área de producto evalúe su rotación.
-- =========================================================================
SELECT 
    pr.id_producto,
    pr.nombre_producto,
    cat.nombre_categoria,
    pr.precio
FROM productos pr
INNER JOIN categorias cat ON pr.id_categoria = cat.id_categoria
LEFT JOIN ventas v ON pr.id_producto = v.id_producto
WHERE v.id_venta IS NULL;

-- Hallazgo: 0 productos sin ventas, todos los artículos del catálogo registran al menos una salida.
-- Para el área de **Producto**,  esto implica que todo el catálogo actual tiene una rotación comercial saludable, 
-- por lo que no hay stock obsoleto que liquidar y se puede planificar la reposición con total seguridad.

-- =========================================================================
-- CONSULTA 4 — Consolidado por canal (UNION ALL)
-- Propósito: Unir transacciones divididas por período u origen utilizando valores 
-- literales para el canal ('Online' vs 'Presencial') con UNION ALL, agrupando para 
-- obtener el total de cada uno sin perder filas duplicadas.
-- =========================================================================
SELECT 
    canal, 
    SUM(total) AS total_canal
FROM (
    -- Ventas de la primera quincena de marzo de 2024 (canal online)
    SELECT 
        fecha_venta, 
        (cantidad * precio_unitario) AS total, 
        'Online' AS canal
    FROM ventas 
    WHERE fecha_venta <= '2024-03-10'
    
    UNION ALL
    
    -- Ventas de la segunda quincena de marzo de 2024 en adelante (canal presencial)
    SELECT 
        fecha_venta, 
        (cantidad * precio_unitario) AS total, 
        'Presencial' AS canal
    FROM ventas 
    WHERE fecha_venta > '2024-03-10'
) AS consolidado
GROUP BY canal;

-- Hallazgo: El canal online concentra el mayor volumen de facturación frente al canal 
-- presencial en este período, lo que orienta la estrategia publicitaria hacia el comercio electrónico.