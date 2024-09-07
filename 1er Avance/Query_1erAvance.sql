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
--Categorias
CREATE TABLE Categorias(
	/*Creamos la clave primaria de tipo entero 
	usando identity para que vaya autocrementandose el valor de 1 por registro(tambien es por defecto)*/
	id_categoria INT PRIMARY KEY IDENTITY(1,1),
	/*Creamos un atributo de ncaracter de maximo 100 que no acepta valores nulos*/
	nombre_categoria NVARCHAR(100) NOT NULL
);

--Productos
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

