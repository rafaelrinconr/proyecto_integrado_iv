-- TODO: Esta consulta devolverá una tabla con dos columnas; customer_state y Revenue.
-- La primera contendrá las abreviaturas que identifican a los 10 estados con mayores ingresos,
-- y la segunda mostrará el ingreso total de cada uno.
-- PISTA: Todos los pedidos deben tener un estado "delivered" y la fecha real de entrega no debe ser nula.

SELECT 
    c.customer_state AS customer_state,  -- Selecciona el estado del cliente
    SUM(p.payment_value) AS Revenue  -- Suma el valor de los pagos para calcular el ingreso total
FROM 
    olist_orders o  -- Desde la tabla "olist_orders_dataset"
JOIN 
    olist_customers c ON o.customer_id = c.customer_id  -- Une con la tabla "olist_customers_dataset" usando "customer_id" como clave
JOIN 
    olist_order_payments p ON o.order_id = p.order_id  -- Une con la tabla "olist_order_payments_dataset" usando "order_id" como clave
WHERE 
    o.order_status = 'delivered'  -- Filtra los pedidos que tienen estado "delivered"
    AND o.order_delivered_customer_date IS NOT NULL  -- Asegura que la fecha real de entrega no sea nula
GROUP BY 
    c.customer_state  -- Agrupa los resultados por estado del cliente
ORDER BY 
    Revenue DESC  -- Ordena los resultados por ingreso total en orden descendente
LIMIT 10;  -- Limita los resultados a los 10 estados con mayores ingresos
