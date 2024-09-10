--Paso 1: CREACIÓN DE LA BASE DE DATOS
--Crea la base de datos, almacenando sus archivos en una carpeta específica en el disco C.
/*En este caso se llamará FastFood, estará dentro de la carpeta "Proyecto_Integrador2"*/
CREATE DATABASE FastFood
ON
( NAME = 'FastFood_Data',
  FILENAME = 'C:\SQLData\Proyecto_integrador2\FastFood_Data.mdf',
  SIZE = 50MB,
  MAXSIZE = 1GB,
  FILEGROWTH = 5MB )
LOG ON
( NAME = 'FastFood_Log',
  FILENAME = 'C:\SQLData\Proyecto_integrador2\FastFood_Log.ldf',
  SIZE = 25MB,
  MAXSIZE = 256MB,
  FILEGROWTH = 5MB );

--Refrescar y ubicarme en la base creada
USE FastFood;

--Paso 2: CREACIÓN DE TABLA Y COLUMNAS
--	TABLA Categorias
CREATE TABLE Categorias(
	/*Creamos la clave primaria de tipo entero 
	usando identity para que vaya autocrementandose el valor de 1 por registro(tambien es por defecto)*/
	id_categoria INT PRIMARY KEY IDENTITY(1,1),
	/*Creamos un atributo de ncaracter de maximo 100 que no acepta valores nulos*/
	nombre_categoria NVARCHAR(100) NOT NULL
);

--	TABLA Productos
CREATE TABLE Productos(
	cod_producto INT PRIMARY KEY IDENTITY,
	nombre_producto NVARCHAR(150) NOT NULL,
	--Precio tendrá 10 digitos maximo y 2 deccimales
	precio DECIMAL(10,2),
	stock INT NOT NULL,
	id_categoria INT,
	--Hacemos la llave foranea referenciado la tabla Categorias
	FOREIGN KEY(id_categoria) REFERENCES Categorias(id_categoria)
);

--	TABLA Sucursales
CREATE TABLE Sucursales (
	id_sucursal INT PRIMARY KEY IDENTITY,
	nombre_sucursal NVARCHAR(100),
	ubicacion NVARCHAR(255)
);


--	TABLA Empleados
CREATE TABLE Empleados(
	id_empleado INT PRIMARY KEY IDENTITY,
	nombre_empleado NVARCHAR(150) NOT NULL,
	puesto NVARCHAR(150) NOT NULL,
	rol NVARCHAR(100) NOT NULL,
	departamento NVARCHAR(100) NOT NULL,
	--Clave foranea
	id_sucursal INT,
	FOREIGN KEY (id_sucursal) REFERENCES Sucursales(id_sucursal)
);

-- TABLA Clientes
CREATE TABLE Clientes(
	id_cliente INT PRIMARY KEY IDENTITY,
	nombre_cliente NVARCHAR(150) NOT NULL,
	direccion NVARCHAR(255) NOT NULL
);

-- TABLA Origenes
CREATE TABLE Origenes(
	id_origen INT PRIMARY KEY IDENTITY,
	descripcion NVARCHAR(255) NOT NULL
);


-- TABLA Tipos De Pago
CREATE TABLE TiposDePago(
	id_tipo_pago INT PRIMARY KEY IDENTITY,
	descripcion NVARCHAR(100) NOT NULL
);

-- TABLA Mensajeros
CREATE TABLE Mensajeros(
	id_mensajero INT PRIMARY KEY IDENTITY,
	nombre_mensajero NVARCHAR(150) NOT NULL,
	es_externo BIT NOT NULL --Cuando el valor es 1 es externo, si es 0 es empleado 
);

--Tabla Ordenes
CREATE TABLE Ordenes(
	id_orden INT PRIMARY KEY IDENTITY,
	horario_venta NVARCHAR(20) NOT NULL, --Mañana, Tarde o Noche
	total_compra DECIMAL(10,2) NOT NULL,
	kilometros_recorrer FLOAT NOT NULL,
	fecha_despacho DATETIME,
	fecha_entrega DATETIME,
	fecha_orden_tomada DATETIME,
	fecha_orden_lista DATETIME,
	--Claves Foraneas
	id_sucursal INT, FOREIGN KEY (id_sucursal) REFERENCES Sucursales(id_sucursal),
	id_origen INT, FOREIGN KEY (id_origen) REFERENCES Origenes(id_origen),
	id_tipo_pago INT, FOREIGN KEY (id_tipo_pago) REFERENCES TiposDePago(id_tipo_pago),
	id_cliente INT, FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
	id_mensajero INT, FOREIGN KEY (id_mensajero) REFERENCES Mensajeros(id_mensajero),
	id_empleado INT, FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado),
);

-- TABLA TEA(ORDENES-PRODUCTOS) DETALLES
CREATE TABLE Detalles(
	id_orden INT,
	cod_producto INT,
	FOREIGN KEY(id_orden) REFERENCES Ordenes(id_orden),
	FOREIGN KEY(cod_producto) REFERENCES Productos(cod_producto),
	cantidad INT NOT NULL,
	precio DECIMAL(10,2) NOT NULL,
);
