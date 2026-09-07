-- 1. Creación y selección de la Base de Datos
DROP DATABASE IF EXISTS pizzeria_db;
CREATE DATABASE pizzeria_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE pizzeria_db;

-- 2. TABLA: Clientes
CREATE TABLE Clientes (
    cliente_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    email VARCHAR(100) UNIQUE,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 3. TABLA: Categorias
CREATE TABLE Categorias (
    categoria_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(255)
) ENGINE=InnoDB;

-- 4. TABLA: Productos
CREATE TABLE Productos (
    producto_id INT AUTO_INCREMENT PRIMARY KEY,
    categoria_id INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio_base DECIMAL(10,2) NOT NULL,
    es_elaborado BOOLEAN NOT NULL DEFAULT TRUE, -- TRUE: Pizza/Panzarotti, FALSE: Bebidas/Postres
    FOREIGN KEY (categoria_id) REFERENCES Categorias(categoria_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 5. TABLA: Ingredientes
CREATE TABLE Ingredientes (
    ingrediente_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    unidad_medida VARCHAR(20) NOT NULL
) ENGINE=InnoDB;

-- 6. TABLA INTERMEDIA: Producto_Ingrediente (Receta base)
CREATE TABLE Producto_Ingrediente (
    producto_id INT NOT NULL,
    ingrediente_id INT NOT NULL,
    cantidad DECIMAL(8,2) NOT NULL,
    PRIMARY KEY (producto_id, ingrediente_id),
    FOREIGN KEY (producto_id) REFERENCES Productos(producto_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ingrediente_id) REFERENCES Ingredientes(ingrediente_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 7. TABLA: Adiciones
CREATE TABLE Adiciones (
    adicion_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    precio DECIMAL(10,2) NOT NULL
) ENGINE=InnoDB;

-- 8. TABLA: Combos
CREATE TABLE Combos (
    combo_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL
) ENGINE=InnoDB;

-- 9. TABLA INTERMEDIA: Combo_Producto
CREATE TABLE Combo_Producto (
    combo_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    PRIMARY KEY (combo_id, producto_id),
    FOREIGN KEY (combo_id) REFERENCES Combos(combo_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES Productos(producto_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 10. TABLA: Pedidos
CREATE TABLE Pedidos (
    pedido_id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    fecha_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    tipo_pedido ENUM('RECOGER', 'LOCAL') NOT NULL,
    total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 11. TABLA: Detalle_Pedido
CREATE TABLE Detalle_Pedido (
    detalle_id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    producto_id INT NULL,
    combo_id INT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(pedido_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES Productos(producto_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (combo_id) REFERENCES Combos(combo_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 12. TABLA INTERMEDIA: Detalle_Adicion
CREATE TABLE Detalle_Adicion (
    detalle_id INT NOT NULL,
    adicion_id INT NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (detalle_id, adicion_id),
    FOREIGN KEY (detalle_id) REFERENCES Detalle_Pedido(detalle_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (adicion_id) REFERENCES Adiciones(adicion_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;