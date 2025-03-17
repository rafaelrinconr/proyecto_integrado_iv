-- TODO: Esta consulta devolverá una tabla con dos columnas: Estado y 
-- Diferencia_Entrega. La primera contendrá las letras que identifican los 
-- estados, y la segunda mostrará la diferencia promedio entre la fecha estimada 
-- de entrega y la fecha en la que los productos fueron realmente entregados al 
-- cliente.
-- PISTAS:
-- 1. Puedes usar la función julianday para convertir una fecha a un número.
-- 2. Puedes usar la función CAST para convertir un número a un entero.
-- 3. Puedes usar la función STRFTIME para convertir order_delivered_customer_date a una cadena, eliminando horas, minutos y segundos.
-- 4. order_status == 'delivered' AND order_delivered_customer_date IS NOT NULL


-- Selecciona el estado del cliente y lo renombra como "State"
SELECT 
    c.customer_state AS State,
    -- Calcula la diferencia promedio en días entre la fecha estimada de entrega y la fecha real de entrega (sin la hora), lo convierte a entero y lo renombra como "Delivery_Difference"
    CAST(AVG(JULIANDAY(o.order_estimated_delivery_date) - JULIANDAY(STRFTIME('%Y-%m-%d', o.order_delivered_customer_date))) AS INT) AS Delivery_Difference
-- De la tabla "olist_customers_dataset" (alias "c")
FROM 
    olist_customers c
-- Une con la tabla "olist_orders_dataset" (alias "o") usando la columna "customer_id" como clave
JOIN 
    olist_orders o ON c.customer_id = o.customer_id
-- Filtra los pedidos que tienen estado 'delivered' y que tienen una fecha de entrega real
WHERE 
    o.order_status = 'delivered' AND o.order_delivered_customer_date IS NOT NULL
-- Agrupa los resultados por el estado del cliente
GROUP BY
   c.customer_state
-- Ordena los resultados por la diferencia promedio de entrega ("Delivery_Difference") en orden ascendente
ORDER BY
    Delivery_Difference ASC;