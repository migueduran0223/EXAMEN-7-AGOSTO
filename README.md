PIZZERIA ADVERSA

Este proyecto permite crear una base de datos para organizar de una manera comoda y eficiente datos sobre la pizzeria,productos, y demás

INSTRUCCIONES PARA ABRIR LOS ARCHIVOS 

Contamos con 3 archivos, el primero se llama estructura.sql, el segundo datos.sql y por ultimo el README.md

EJECUCIÓN: primero abrimos el mysql workbench,abrimos el archivo estructura.sql, lo ejecutamos, seguido de su ejecución, abrimos el archivo datos.sql y lo ejecutamos también

Solución 20 consultas: 

--1.Productos más vendidos
SELECT p.nombre, SUM(dp.cantidad) AS total_vendidos
FROM Detalle_Pedido dp
JOIN Productos p ON dp.producto_id = p.producto_id
GROUP BY p.producto_id, p.nombre
ORDER BY total_vendidos DESC;

-- 2. Total de ingresos generados por cada combo
SELECT c.nombre AS combo, SUM(dp.subtotal) AS ingresos_totales
FROM Detalle_Pedido dp
JOIN Combos c ON dp.combo_id = c.combo_id
GROUP BY c.combo_id, c.nombre;

-- 3. Pedidos realizados para recoger vs. comer en la pizzería
SELECT tipo_pedido, COUNT(*) AS total_pedidos
FROM Pedidos
GROUP BY tipo_pedido;

-- 4. Adiciones más solicitadas en pedidos personalizados
SELECT a.nombre AS adicion, SUM(da.cantidad) AS veces_solicitada
FROM Detalle_Adicion da
JOIN Adiciones a ON da.adicion_id = a.adicion_id
GROUP BY a.adicion_id, a.nombre
ORDER BY veces_solicitada DESC;

-- 5. Cantidad total de productos vendidos por categoría
SELECT c.nombre AS categoria, SUM(dp.cantidad) AS total_productos
FROM Detalle_Pedido dp
JOIN Productos p ON dp.producto_id = p.producto_id
JOIN Categorias c ON p.categoria_id = c.categoria_id
GROUP BY c.categoria_id, c.nombre;

-- 6. Promedio de pizzas pedidas por cliente
SELECT AVG(pizzas_por_cliente) AS promedio_pizzas
FROM (
    SELECT p.cliente_id, SUM(dp.cantidad) AS pizzas_por_cliente
    FROM Pedidos p
    JOIN Detalle_Pedido dp ON p.pedido_id = dp.pedido_id
    JOIN Productos pr ON dp.producto_id = pr.producto_id
    WHERE pr.categoria_id = 1 -- Categoría Pizzas
    GROUP BY p.cliente_id
) AS subconsulta;

-- 7. Total de ventas por día de la semana
SELECT DAYNAME(fecha_pedido) AS dia, SUM(total) AS total_ventas
FROM Pedidos
GROUP BY DAYNAME(fecha_pedido), DAYOFWEEK(fecha_pedido)
ORDER BY DAYOFWEEK(fecha_pedido);

-- 8. Cantidad de panzarottis vendidos con extra queso
SELECT SUM(dp.cantidad) AS total_panzarottis_extra_queso
FROM Detalle_Pedido dp
JOIN Productos p ON dp.producto_id = p.producto_id
JOIN Detalle_Adicion da ON dp.detalle_id = da.detalle_id
JOIN Adiciones a ON da.adicion_id = a.adicion_id
WHERE p.categoria_id = 2 AND a.nombre = 'Extra Queso';

-- 9. Pedidos que incluyen bebidas como parte de un combo
SELECT DISTINCT dp.pedido_id, c.nombre AS combo
FROM Detalle_Pedido dp
JOIN Combos c ON dp.combo_id = c.combo_id
JOIN Combo_Producto cp ON c.combo_id = cp.combo_id
JOIN Productos p ON cp.producto_id = p.producto_id
WHERE p.categoria_id = 3; -- Categoría Bebidas

-- 10. Clientes que han realizado más de 5 pedidos en el último mes
SELECT c.nombre, COUNT(p.pedido_id) AS total_pedidos
FROM Clientes c
JOIN Pedidos p ON c.cliente_id = p.cliente_id
WHERE p.fecha_pedido >= DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH)
GROUP BY c.cliente_id, c.nombre
HAVING COUNT(p.pedido_id) > 5;

-- 11. Ingresos totales generados por productos no elaborados
SELECT SUM(dp.subtotal) AS ingresos_no_elaborados
FROM Detalle_Pedido dp
JOIN Productos p ON dp.producto_id = p.producto_id
WHERE p.es_elaborado = FALSE;

-- 12. Promedio de adiciones por pedido
SELECT AVG(total_adiciones) AS promedio_adiciones_por_pedido
FROM (
    SELECT p.pedido_id, COALESCE(SUM(da.cantidad), 0) AS total_adiciones
    FROM Pedidos p
    LEFT JOIN Detalle_Pedido dp ON p.pedido_id = dp.pedido_id
    LEFT JOIN Detalle_Adicion da ON dp.detalle_id = da.detalle_id
    GROUP BY p.pedido_id
) AS sub;

-- 13. Total de combos vendidos en el último mes
SELECT SUM(dp.cantidad) AS total_combos_ultimo_mes
FROM Detalle_Pedido dp
JOIN Pedidos p ON dp.pedido_id = p.pedido_id
WHERE dp.combo_id IS NOT NULL 
  AND p.fecha_pedido >= DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH);

-- 14. Clientes con pedidos tanto para recoger como para consumir en el lugar
SELECT c.nombre
FROM Clientes c
JOIN Pedidos p ON c.cliente_id = p.cliente_id
GROUP BY c.cliente_id, c.nombre
HAVING COUNT(DISTINCT p.tipo_pedido) = 2;

-- 15. Total de productos personalizados con adiciones
SELECT COUNT(DISTINCT dp.detalle_id) AS productos_personalizados
FROM Detalle_Pedido dp
JOIN Detalle_Adicion da ON dp.detalle_id = da.detalle_id;

-- 16. Pedidos con más de 3 productos diferentes
SELECT pedido_id, COUNT(DISTINCT producto_id) AS variedad_productos
FROM Detalle_Pedido
WHERE producto_id IS NOT NULL
GROUP BY pedido_id
HAVING COUNT(DISTINCT producto_id) > 3;

-- 17. Promedio de ingresos generados por día
SELECT AVG(venta_diaria) AS promedio_ingresos_diarios
FROM (
    SELECT DATE(fecha_pedido) AS fecha, SUM(total) AS venta_diaria
    FROM Pedidos
    GROUP BY DATE(fecha_pedido)
) AS sub;

-- 18. Clientes que han pedido pizzas con adiciones en más del 50% de sus pedidos
SELECT c.nombre
FROM Clientes c
JOIN Pedidos p ON c.cliente_id = p.cliente_id
JOIN Detalle_Pedido dp ON p.pedido_id = dp.pedido_id
JOIN Productos pr ON dp.producto_id = pr.producto_id
LEFT JOIN Detalle_Adicion da ON dp.detalle_id = da.detalle_id
WHERE pr.categoria_id = 1
GROUP BY c.cliente_id, c.nombre
HAVING COUNT(DISTINCT CASE WHEN da.adicion_id IS NOT NULL THEN p.pedido_id END) / COUNT(DISTINCT p.pedido_id) > 0.5;

-- 19. Porcentaje de ventas provenientes de productos no elaborados
SELECT 
    (SUM(CASE WHEN p.es_elaborado = FALSE THEN dp.subtotal ELSE 0 END) / SUM(dp.subtotal)) * 100 AS porcentaje_no_elaborados
FROM Detalle_Pedido dp
JOIN Productos p ON dp.producto_id = p.producto_id;

-- 20. Día de la semana con mayor número de pedidos para recoger
SELECT DAYNAME(fecha_pedido) AS dia, COUNT(*) AS total_pedidos_recoger
FROM Pedidos
WHERE tipo_pedido = 'RECOGER'
GROUP BY DAYNAME(fecha_pedido)
ORDER BY total_pedidos_recoger DESC
LIMIT 1;



