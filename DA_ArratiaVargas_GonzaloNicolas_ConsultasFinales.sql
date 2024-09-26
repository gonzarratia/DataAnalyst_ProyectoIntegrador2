--Eficiencia de los mensajeros: 
--¿Cuál es el tiempo promedio desde el despacho hasta la entrega de los pedidos gestionados por todo el equipo de mensajería?
SELECT 
	AVG(DATEDIFF(Minute,O.fecha_despacho, O.fecha_entrega)) AS [Tiempo Promedio Por Minuto]
FROM Ordenes AS O
INNER JOIN Mensajeros AS M ON O.id_mensajero = M.id_mensajero

--Análisis de Ventas por Origen de Orden: 
--¿Qué canal de ventas genera más ingresos?
SELECT TOP 1
	A.descripcion AS [Canal de Ventas],
	SUM(O.total_compra) AS Ingresos
FROM Ordenes AS O
INNER JOIN Origenes A ON O.id_origen = A.id_origen
GROUP BY A.descripcion
ORDER BY SUM(O.total_compra) DESC


--Productividad de los Empleados: 
--¿Cuál es el nivel de ingreso generado por Empleado?
SELECT
	E.nombre_empleado AS Empleado,
	SUM(O.total_compra) AS Ingresos
FROM Ordenes AS O
INNER JOIN Empleados E ON O.id_empleado = E.id_empleado
GROUP BY E.nombre_empleado
ORDER BY SUM(O.total_compra) DESC

--Análisis de Demanda por Horario y Día: 
--¿Cómo varía la demanda de productos a lo largo del día? NOTA: Esta consulta no puede ser implementada sin una definición clara del horario (mañana, tarde, noche) en la base de datos existente. Asumiremos que HorarioVenta refleja esta información correctamente.

SELECT 
    O.horario_venta,
    P.nombre_producto,
    SUM(D.cantidad) AS Demanda
FROM 
    Detalles AS D
LEFT JOIN 
    Ordenes AS O ON D.id_orden = O.id_orden 
LEFT JOIN 
    Productos AS P ON D.cod_producto = P.cod_producto
GROUP BY 
    O.horario_venta, 
    P.nombre_producto
ORDER BY 
    Demanda DESC; 


--Comparación de Ventas Mensuales: 
--¿Cuál es la tendencia de los ingresos generados en cada periodo mensual?
SELECT 
    FORMAT(O.fecha_orden_tomada, 'MM-yyyy') AS mes,  -- Formato de fecha para agrupar por mes y año
    SUM(O.total_compra) AS total_ingresos    
FROM Ordenes AS O
GROUP BY FORMAT(O.fecha_orden_tomada, 'MM-yyyy') 
ORDER BY mes; 



--Análisis de Fidelidad del Cliente: 
--¿Qué porcentaje de clientes son recurrentes versus nuevos clientes cada mes? NOTA: La consulta se enfocaría en la frecuencia de órdenes por cliente para inferir la fidelidad.

-- Se define una CTE llamada ClienteFrecuente para calcular la frecuencia de compras de los clientes
WITH FrecuenciaClientes AS (
    SELECT 
        c.nombre_cliente AS Cliente,
        MONTH(O.fecha_orden_tomada) AS Mes,
        COUNT(O.id_cliente) AS Frecuencia
    FROM 
        Ordenes AS O
    LEFT JOIN 
        Clientes AS c ON O.id_cliente = c.id_cliente
    GROUP BY 
        c.nombre_cliente, MONTH(O.fecha_orden_tomada)
),
-- Consulta principal para obtener el porcentaje de clientes recurrentes y nuevos
ClasificacionClientes AS (
    SELECT 
        Mes,
        Cliente,
        Frecuencia,
        CASE 
            WHEN Frecuencia = 1 THEN 'Nuevo' 
            ELSE 'Recurrente' 
        END AS TipoCliente
    FROM 
        FrecuenciaClientes
)

SELECT 
    Mes,
    COUNT(CASE WHEN TipoCliente = 'Nuevo' THEN 1 END) * 100 / COUNT(*) AS PorcentajeNuevos,
    COUNT(CASE WHEN TipoCliente = 'Recurrente' THEN 1 END) * 100 / COUNT(*) AS PorcentajeRecurrentes
FROM 
    ClasificacionClientes
GROUP BY 
    Mes
ORDER BY 
    Mes;
