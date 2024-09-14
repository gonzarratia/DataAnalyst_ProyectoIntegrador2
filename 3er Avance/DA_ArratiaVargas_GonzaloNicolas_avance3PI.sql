SELECT * FROM Categorias;
SELECT * FROM Clientes;
SELECT * FROM Detalles;
SELECT * FROM Empleados;
SELECT * FROM Mensajeros;
SELECT * FROM Ordenes;
SELECT * FROM Origenes;
SELECT * FROM Productos;
SELECT * FROM Sucursales;
SELECT * FROM TiposDePago;

--1) Total de ventas globales
--�Cu�l es el total de ventas (TotalCompra) a nivel global?
SELECT SUM(total_compra) AS totalVentas FROM Ordenes;


--2) Promedio de precios de productos por categor�a
--�Cu�l es el precio promedio de los productos dentro de cada categor�a?
--CAST y AS nos permite convertir un tipo de dato a otro
SELECT 
	C.nombre_categoria, 
	CAST(AVG(precio) AS DECIMAL(10,2)) AS promedioPrecio  
FROM Productos P , Categorias C
WHERE P.id_categoria = C.id_categoria
GROUP BY C.nombre_categoria
ORDER BY promedioPrecio DESC;

--3) Orden m�nima y m�xima por sucursal
--�Cu�l es el valor de la orden m�nima y m�xima por cada sucursal?
SELECT 
	id_sucursal AS Sucursal, 
	MIN(total_compra) AS OrdenMinima,
	MAX(total_compra) AS OrdenMaxima
FROM Ordenes
GROUP BY id_sucursal

--4) Mayor n�mero de kil�metros recorridos para entrega
--�Cu�l es el mayor n�mero de kil�metros recorridos para una entrega?
SELECT 
	MAX(kilometros_recorrer) AS MayorRecorrido
FROM Ordenes

--5)Promedio de cantidad de productos por orden
--�Cu�l es la cantidad promedio de productos por orden?
SELECT 
	id_orden AS Orden,
	AVG(cantidad) AS CantidadPromedio
FROM Detalles
GROUP BY id_orden

--6) Total de ventas por tipo de pago
--�C�mo se distribuye la Facturaci�n Total del Negocio de acuerdo a los m�todos de pago?
SELECT 
	TP.descripcion AS TipoPago,
	SUM(total_compra) AS FacturacionTotal
FROM Ordenes AS O , TiposDePago AS TP
WHERE O.id_tipo_pago = TP.id_tipo_pago
GROUP BY TP.descripcion
ORDER BY FacturacionTotal DESC;

-- 7) Sucursal con la venta promedio m�s alta
--�Cu�l Sucursal tiene el ingreso promedio m�s alto?
SELECT TOP 1
	S.nombre_sucursal,
	CAST(AVG(total_compra)AS DECIMAL(10,2)) AS IngresoPromedio
FROM Ordenes AS O, Sucursales AS S
WHERE O.id_sucursal = S.id_sucursal
GROUP BY nombre_sucursal
ORDER BY IngresoPromedio DESC

--8)  Sucursal con la mayor cantidad de ventas por encima de un umbral
--�Cu�les son las sucursales que han generado ventas totales por encima de $ 1000?
SELECT
	S.nombre_sucursal,
	SUM(total_compra) AS VentasTotales
FROM Ordenes O, Sucursales S
WHERE O.id_sucursal = S.id_sucursal
GROUP BY nombre_sucursal
HAVING SUM(total_compra)>1000 --solamente el ORDER BY acepta el alias
ORDER BY VentasTotales DESC

--9) Comparaci�n de ventas promedio antes y despu�s de una fecha espec�fica
--�C�mo se comparan las ventas promedio antes y despu�s del 1 de julio de 2023?
--1ra FORMA
SELECT 
	CAST(AVG(total_compra) AS decimal(10,2)) AS VentasPromedio_Pos1Julio
FROM Ordenes
WHERE fecha_orden_tomada >= '2023-07-01';


SELECT 
	CAST(AVG(total_compra) AS decimal(10,2)) AS VentasPromedio_Pre1Julio
FROM Ordenes
WHERE fecha_orden_tomada < '2023-07-01';



 --2da FORMA
 SELECT 
	'Despues_de_Julio' AS periodo,
	CAST(AVG(total_compra) AS decimal(10,2)) AS VentaPromedio
FROM Ordenes
WHERE fecha_orden_tomada >= '2023-07-01'

UNION ALL  --Hacemos uso de UNION ALL

SELECT 
	'Antes_de_Julio' AS periodo,
	CAST(AVG(total_compra) AS decimal(10,2)) AS VentaPromedio
FROM Ordenes
WHERE fecha_orden_tomada < '2023-07-01';

--3ra FORMA (Con condicional)
SELECT 
	CASE WHEN fecha_orden_tomada>= '2023-07-01' THEN  'Despues_de_Julio'
	ELSE 'Antes_de_Julio' END AS Periodo,
	CAST(AVG(total_compra) AS decimal(10,2)) AS VentaPromedio
FROM
	Ordenes
GROUP BY 
	CASE WHEN fecha_orden_tomada>= '2023-07-01' THEN  'Despues_de_Julio'
	ELSE 'Antes_de_Julio' END
ORDER BY 
	Periodo DESC;

--10) An�lisis de actividad de ventas por horario
--�Durante qu� horario del d�a (ma�ana, tarde, noche) se registra la mayor CANTIDAD 
--de ventas, cu�l es el ingreso promedio de estas ventas, y cu�l ha sido el importe 
--m�ximo alcanzado por una orden en dicha jornada?

SELECT
	horario_venta,
	COUNT(id_orden) AS CantidadVentas,
	CAST(AVG(total_compra)AS DECIMAL(10,2)) AS IngresoPromedio,
	MAX(total_compra) AS ImporteMaximo
FROM Ordenes
GROUP BY horario_venta