-- Crear base de datos
CREATE DATABASE IF NOT EXISTS CafeDB;
USE CafeDB;

-- Crear tablas 

CREATE TABLE Proveedores (
    Id_proveedor INT,
    Nombre_proveedor VARCHAR(50),
    Email_proveedor VARCHAR(50),
    Telefono_proveedor VARCHAR(20),
    PRIMARY KEY (Id_proveedor)
);

CREATE TABLE Productos (
    Id_producto INT,
    Nombre_producto VARCHAR(50),
    Tipo_producto VARCHAR(50),
    Precio_producto DECIMAL(10, 2),
    Stock_producto INT,
    Id_proveedor INT,
    PRIMARY KEY (Id_producto),
    FOREIGN KEY (Id_proveedor) REFERENCES Proveedores(Id_proveedor)
);


CREATE TABLE Clientes (
    Id_cliente INT,
    Nombre_cliente VARCHAR(50),
    Apellido_cliente VARCHAR(50),
    Email_cliente VARCHAR(50),
    PRIMARY KEY(Id_cliente)
);


CREATE TABLE Pedidos (
    Id_pedido INT,
    Tipo_producto VARCHAR(50),
    Precio_producto DECIMAL(10, 2),
    Fecha_pedido DATE,
    Cantidad_productos INT,
    Id_cliente INT,
    Id_producto INT,
    PRIMARY KEY (Id_pedido),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);


CREATE TABLE Empleados (
    Id_empleado INT ,
    Apellido_empleado VARCHAR(50),
    Nombre_empleado VARCHAR(50),
    Fecha_ingreso_empleado DATE,
    PRIMARY KEY(Id_empleado)
);




-- Cargar datos en las tablas
INSERT INTO Productos (Id_producto, Nombre_producto, Tipo_producto, Precio_producto, Stock_producto, Id_proveedor) VALUES
(1, 'Café Espresso', 'Café', 2.5, 100, 1),
(2, 'Té Verde', 'Té', 1.5, 50, 2);

INSERT INTO Clientes (Id_cliente, Nombre_cliente, Apellido_cliente, Email_cliente) VALUES
(1, 'Juan', 'Pérez', 'juan@example.com'),
(2, 'Ana', 'García', 'ana@example.com');

INSERT INTO Pedidos (Id_pedido, Tipo_producto, Precio_producto, Fecha_pedido, Cantidad_productos, Id_cliente, Id_producto) VALUES
(1, 'Café', 2.5, '2024-01-25', 2, 1, 1),
(2, 'Té', 1.5, '2024-01-26', 3, 2, 2);

INSERT INTO Empleados (Id_empleado, Apellido_empleado, Nombre_empleado, Fecha_ingreso_empleado) VALUES
(1, 'Gómez', 'Carlos', '2020-01-01'),
(2, 'Rodríguez', 'María', '2021-02-15');

INSERT INTO Proveedores (Id_proveedor, Nombre_proveedor, Email_proveedor, Telefono_proveedor) VALUES
(1, 'Proveedor1', 'proveedor1@example.com', '123-456-7890'),
(2, 'Proveedor2', 'proveedor2@example.com', '987-654-3210');

-- Consulta simple con WHERE
SELECT * FROM Productos WHERE Tipo_producto = 'Café';

-- Consulta simple con ORDER BY
SELECT * FROM Productos ORDER BY Precio_producto DESC;

-- Consulta con GROUP BY y JOIN
SELECT P.Nombre_producto, COUNT(D.id_pedido) as Cantidad_pedidos
FROM Productos P
JOIN Pedidos D ON P.id_producto = D.id_producto
GROUP BY P.Nombre_producto;

-- Consulta con UNION
SELECT Nombre_cliente, Email_cliente FROM Clientes
UNION
SELECT nombre_proveedor as Nombre_cliente, email_proveedor as Email_cliente FROM Proveedores;

-- Subconsulta
SELECT * FROM Productos
WHERE id_proveedor IN (SELECT id_proveedor FROM Proveedores WHERE nombre_proveedor = 'Proveedor1');

-- Función para calcular el total de un pedido
DELIMITER $$
CREATE FUNCTION CalcularTotalPedido(pedido_id INT)
RETURNS DECIMAL
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL;
    SELECT SUM(Precio_producto * Cantidad_productos) INTO total FROM Pedidos WHERE id_pedido = pedido_id;
    RETURN total;
END$$
DELIMITER $$

-- Vista para mostrar detalles del pedido con información del producto
CREATE VIEW VistaDetallesPedido AS
SELECT D.id_pedido, P.Nombre_producto, D.Cantidad_productos, D.Precio_producto
FROM Pedidos D
JOIN Productos P ON D.id_producto = P.id_producto;

-- Vista para mostrar clientes con la cantidad de pedidos realizados
CREATE VIEW VistaClientesConPedidos AS
SELECT C.id_cliente, CONCAT(C.Nombre_cliente, ' ', C.Apellido_cliente) as Nombre_completo, COUNT(P.id_pedido) as Cantidad_pedidos
FROM Clientes C
LEFT JOIN Pedidos P ON C.id_cliente = P.id_cliente
GROUP BY C.id_cliente;

-- Borrar un dato de una lista

/*DELETE FROM Productos 
WHERE Id_productos=1; 
