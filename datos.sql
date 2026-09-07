USE pizzeria_db;

-- 1. INSERTAR CATEGORÍAS
INSERT INTO Categorias (categoria_id, nombre, descripcion) VALUES
(1, 'Pizzas', 'Pizzas artesanales en masa delgada y tradicional'),
(2, 'Panzarottis', 'Empanadas al horno de masa de pizza rellenadas de queso e ingredientes'),
(3, 'Bebidas', 'Gaseosas, jugos naturales y cervezas'),
(4, 'Postres', 'Postres de la casa para acompañar');

-- 2. INSERTAR INGREDIENTES
INSERT INTO Ingredientes (ingrediente_id, nombre, unidad_medida) VALUES
(1, 'Queso Mozzarella', 'Gramos'),
(2, 'Salsa de Tomate', 'Mililitros'),
(3, 'Pepperoni', 'Gramos'),
(4, 'Jamón', 'Gramos'),
(5, 'Piña', 'Gramos'),
(6, 'Champiñones', 'Gramos'),
(7, 'Masa de Pizza', 'Unidades');

-- 3. INSERTAR PRODUCTOS (Elaborados y No Elaborados)
INSERT INTO Productos (producto_id, categoria_id, nombre, descripcion, precio_base, es_elaborado) VALUES
-- Pizzas (Elaborados)
(1, 1, 'Pizza Pepperoni', 'Salsa de tomate, queso mozzarella y pepperoni', 12.50, TRUE),
(2, 1, 'Pizza Hawaiana', 'Salsa de tomate, queso mozzarella, jamón y piña', 13.00, TRUE),
(3, 1, 'Pizza Champino', 'Salsa de tomate, queso mozzarella y champiñones', 11.50, TRUE),

-- Panzarottis (Elaborados)
(4, 2, 'Panzarotti Mixto', 'Relleno de jamón, queso mozzarella y salsa de tomate', 8.00, TRUE),
(5, 2, 'Panzarotti Pepperoni', 'Relleno de pepperoni y queso mozzarella', 8.50, TRUE),

-- Bebidas (No Elaborados)
(6, 3, 'Coca Cola 1.5L', 'Gaseosa tamaño familiar', 3.50, FALSE),
(7, 3, 'Jugo de Mora 500ml', 'Jugo natural embotellado', 2.50, FALSE),
(8, 3, 'Cerveza Club Colombia', 'Cerveza personal 330ml', 3.00, FALSE),

-- Postres (No Elaborados)
(9, 4, 'Volcán de Chocolate', 'Bizcocho relleno de chocolate caliente', 4.50, FALSE),
(10, 4, 'Tiramisú', 'Postre tradicional italiano de café y mascarpone', 5.00, FALSE);

-- 4. RECETA BASE (Producto_Ingrediente)
INSERT INTO Producto_Ingrediente (producto_id, ingrediente_id, cantidad) VALUES
(1, 7, 1.00), (1, 2, 150.00), (1, 1, 200.00), (1, 3, 100.00), -- Pizza Pepperoni
(2, 7, 1.00), (2, 2, 150.00), (2, 1, 200.00), (2, 4, 80.00), (2, 5, 80.00), -- Pizza Hawaiana
(4, 7, 0.50), (4, 1, 100.00), (4, 4, 50.00); -- Panzarotti Mixto

-- 5. INSERTAR ADICIONES
INSERT INTO Adiciones (adicion_id, nombre, precio) VALUES
(1, 'Extra Queso', 2.00),
(2, 'Salsa Ajo Especial', 1.00),
(3, 'Tocineta Crotante', 2.50),
(4, 'Borde de Queso', 3.00);

-- 6. INSERTAR COMBOS
INSERT INTO Combos (combo_id, nombre, descripcion, precio) VALUES
(1, 'Combo Pareja', '1 Pizza Pepperoni + 2 Coca Colas 1.5L', 17.50),
(2, 'Combo Personal Panzarotti', '1 Panzarotti Mixto + 1 Jugo de Mora', 9.50),
(3, 'Combo Familiar', '2 Pizzas Hawaianas + 1 Volcán de Chocolate', 28.00);

-- 7. DETALLE DE COMBOS (Combo_Producto)
INSERT INTO Combo_Producto (combo_id, producto_id, cantidad) VALUES
(1, 1, 1), (1, 6, 2), -- Combo Pareja
(2, 4, 1), (2, 7, 1), -- Combo Personal Panzarotti
(3, 2, 2), (3, 9, 1); -- Combo Familiar

-- 8. INSERTAR CLIENTES
INSERT INTO Clientes (cliente_id, nombre, telefono, email, fecha_registro) VALUES
(1, 'Carlos Mendoza', '3001234567', 'carlos.m@mail.com', '2026-01-10 10:00:00'),
(2, 'Ana Gómez', '3109876543', 'ana.gomez@mail.com', '2026-01-15 11:30:00'),
(3, 'Luis Rodríguez', '3204567890', 'luis.r@mail.com', '2026-02-01 14:20:00'),
(4, 'María Fernández', '3156543210', 'maria.f@mail.com', '2026-02-10 16:45:00'),
(5, 'Juan Pérez', '3017894561', 'juan.perez@mail.com', '2026-02-12 18:10:00');

-- 9. INSERTAR PEDIDOS (Últimos dos meses, diferentes días de la semana y modos)
INSERT INTO Pedidos (pedido_id, cliente_id, fecha_pedido, tipo_pedido, total) VALUES
-- Pedidos de Carlos Mendoza (Frecuente > 5 pedidos en el último mes)
(1, 1, '2026-08-03 19:00:00', 'LOCAL', 14.50),   -- Lunes
(2, 1, '2026-08-08 20:15:00', 'RECOGER', 17.50), -- Sábado
(3, 1, '2026-08-14 18:30:00', 'LOCAL', 10.50),   -- Viernes
(4, 1, '2026-08-20 19:45:00', 'RECOGER', 13.00), -- Jueves
(5, 1, '2026-08-25 12:30:00', 'LOCAL', 9.50),    -- Martes
(6, 1, '2026-08-30 20:00:00', 'RECOGER', 16.50), -- Domingo

-- Pedidos de Ana Gómez (Mezcla de llevar y comer local)
(7, 2, '2026-08-05 13:00:00', 'LOCAL', 28.00),   -- Miércoles
(8, 2, '2026-08-12 19:10:00', 'RECOGER', 12.50), -- Miércoles
(9, 2, '2026-08-28 21:00:00', 'LOCAL', 17.50),   -- Viernes

-- Pedidos de Luis Rodríguez
(10, 3, '2026-08-15 19:30:00', 'RECOGER', 10.50),-- Sábado
(11, 3, '2026-08-22 20:00:00', 'RECOGER', 28.00),-- Sábado

-- Pedidos de María Fernández
(12, 4, '2026-08-18 18:00:00', 'LOCAL', 14.50),  -- Martes
(13, 4, '2026-09-01 19:20:00', 'LOCAL', 8.50),   -- Martes

-- Pedidos de Juan Pérez
(14, 5, '2026-09-02 20:45:00', 'RECOGER', 17.50);-- Miércoles

-- 10. INSERTAR DETALLE DE PEDIDOS (Productos y Combos vendidos)
INSERT INTO Detalle_Pedido (detalle_id, pedido_id, producto_id, combo_id, cantidad, precio_unitario, subtotal) VALUES
-- Pedido 1
(1, 1, 1, NULL, 1, 12.50, 12.50), -- Pizza Pepperoni
-- Pedido 2
(2, 2, NULL, 1, 1, 17.50, 17.50), -- Combo Pareja
-- Pedido 3
(3, 3, 4, NULL, 1, 8.50, 8.50),   -- Panzarotti Mixto
(4, 3, 7, NULL, 1, 2.50, 2.50),   -- Jugo de Mora
-- Pedido 4
(5, 4, 2, NULL, 1, 13.00, 13.00), -- Pizza Hawaiana
-- Pedido 5
(6, 5, NULL, 2, 1, 9.50, 9.50),   -- Combo Personal Panzarotti
-- Pedido 6
(7, 6, 1, NULL, 1, 12.50, 12.50), -- Pizza Pepperoni
(8, 6, 9, NULL, 1, 4.00, 4.00),   -- Volcán de Chocolate
-- Pedido 7
(9, 7, NULL, 3, 1, 28.00, 28.00), -- Combo Familiar
-- Pedido 8
(10, 8, 1, NULL, 1, 12.50, 12.50),-- Pizza Pepperoni
-- Pedido 9
(11, 9, NULL, 1, 1, 17.50, 17.50),-- Combo Pareja
-- Pedido 10
(12, 10, 5, NULL, 1, 8.50, 8.50), -- Panzarotti Pepperoni
(13, 10, 7, NULL, 1, 2.50, 2.50), -- Jugo de Mora
-- Pedido 11
(14, 11, NULL, 3, 1, 28.00, 28.00),-- Combo Familiar
-- Pedido 12
(15, 12, 1, NULL, 1, 12.50, 12.50),-- Pizza Pepperoni
-- Pedido 13
(16, 13, 4, NULL, 1, 8.50, 8.50), -- Panzarotti Mixto
-- Pedido 14
(17, 14, NULL, 1, 1, 17.50, 17.50);-- Combo Pareja

-- 11. INSERTAR DETALLE ADICIONES (Personalizaciones con Extra Queso, Salsa, etc.)
INSERT INTO Detalle_Adicion (detalle_id, adicion_id, cantidad, precio_unitario) VALUES
(1, 1, 1, 2.00), -- Extra Queso a Pizza Pepperoni (Detalle 1)
(3, 1, 1, 2.00), -- Extra Queso a Panzarotti Mixto (Detalle 3)
(7, 1, 1, 2.00), (7, 2, 1, 1.00), -- Extra Queso y Salsa Ajo a Pizza Pepperoni (Detalle 7)
(12, 1, 1, 2.00), -- Extra Queso a Panzarotti Pepperoni (Detalle 12)
(15, 1, 1, 2.00); -- Extra Queso a Pizza Pepperoni (Detalle 15)