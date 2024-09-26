				--Preguntas para consultas
SELECT * FROM [dbo].[Categorias]
SELECT * FROM [dbo].[Clientes]
SELECT * FROM [dbo].[Detalles]
SELECT * FROM [dbo].[Empleados]
SELECT * FROM [dbo].[Mensajeros]
SELECT * FROM [dbo].[Ordenes]
SELECT * FROM [dbo].[Origenes]
SELECT * FROM [dbo].[Productos]
SELECT * FROM [dbo].[Sucursales]
SELECT * FROM [dbo].[TiposDePago]

--1 Listar todos los productos y sus categorías
--¿Cómo puedo obtener una lista de todos los productos junto con sus categorías?
SELECT 
		P.cod_producto AS [Codigo Producto],
		P.nombre_producto AS [Nombre Producto],
		C.nombre_categoria AS Categoria
FROM Productos AS P
LEFT JOIN Categorias AS C ON P.id_categoria = C.id_categoria

--2 Obtener empleados y su sucursal asignada
--¿Cómo puedo saber a qué sucursal está asignado cada empleado?
SELECT 
		E.id_empleado,
		E.nombre_empleado,
		E.puesto,
		E.rol,
		E.departamento,
		S.nombre_sucursal AS sucursal,
		S.ubicacion
FROM Empleados AS E
LEFT JOIN Sucursales AS S ON E.id_sucursal = S.id_sucursal


--3 Identificar productos sin categoría asignada
--¿Existen productos que no tienen una categoría asignada?
SELECT 
		P.cod_producto,
		P.nombre_producto,
		C.nombre_categoria AS categoria
FROM Productos AS P
LEFT JOIN Categorias AS C ON P.id_categoria = C.id_categoria
WHERE C.id_categoria IS NULL;
--Respuesta: No hay productos que no tengan una categoría asignada, pero si hay categorias donde no tienen productos

--4 Detalle completo de órdenes
--¿Cómo puedo obtener un detalle completo de las órdenes, incluyendo el Nombre del cliente, Nombre del empleado que tomó la orden, y Nombre del mensajero que la entregó?
SELECT 
	O.*,
	C.nombre_cliente,
	E.nombre_empleado,
	M.nombre_mensajero

FROM Ordenes AS O
INNER JOIN Clientes AS C ON O.id_cliente = C.id_cliente
INNER JOIN Empleados AS E ON O.id_empleado = E.id_empleado
INNER JOIN Mensajeros AS M ON O.id_mensajero = M.id_mensajero


--5 Productos vendidos por sucursal
--¿Cuántos artículos correspondientes a cada Categoría de Productos se han vendido en cada sucursal?
SELECT 
	C.nombre_categoria AS Categoria,
	S.nombre_sucursal AS [Nombre Sucursal],
	SUM(D.cantidad) AS [Articulos Vendidos]

FROM Detalles AS D
INNER JOIN [dbo].[Productos] AS P ON D.cod_producto = P.cod_producto
INNER JOIN [dbo].[Categorias] AS C ON P.id_categoria = C.id_categoria
INNER JOIN [dbo].[Ordenes] AS O ON D.id_orden = O.id_orden
INNER JOIN [dbo].[Sucursales] AS S ON O.id_sucursal = S.id_sucursal
GROUP BY C.nombre_categoria, S.nombre_sucursal


--BONUS
--Mostrar aquellas categorias con 7 o mas articulos vendidos
SELECT 
	C.nombre_categoria AS Categoria,
	S.nombre_sucursal AS [Nombre Sucursal],
	SUM(D.cantidad) AS [Articulos Vendidos]

FROM Detalles AS D
INNER JOIN [dbo].[Productos] AS P ON D.cod_producto = P.cod_producto
INNER JOIN [dbo].[Categorias] AS C ON P.id_categoria = C.id_categoria
INNER JOIN [dbo].[Ordenes] AS O ON D.id_orden = O.id_orden
INNER JOIN [dbo].[Sucursales] AS S ON O.id_sucursal = S.id_sucursal
GROUP BY C.nombre_categoria, S.nombre_sucursal
HAVING SUM(D.cantidad) >=7;