-- TODO: Esta consulta devolverá una tabla con los ingresos por mes y año.
-- Tendrá varias columnas: month_no, con los números de mes del 01 al 12;
-- month, con las primeras 3 letras de cada mes (ej. Ene, Feb);
-- Year2016, con los ingresos por mes de 2016 (0.00 si no existe);
-- Year2017, con los ingresos por mes de 2017 (0.00 si no existe); y
-- Year2018, con los ingresos por mes de 2018 (0.00 si no existe).

WITH delivered_orders AS (
    -- Selecciona las columnas necesarias de las tablas olist_orders_dataset y olist_order_payments_dataset
    SELECT 
        oo.order_id,                     -- ID del pedido
        oo.customer_id,                  -- ID del cliente
        oo.order_delivered_customer_date, -- Fecha de entrega del pedido al cliente
        oop.payment_value                -- Valor del pago del pedido
    -- Desde la tabla olist_orders_dataset (alias oo)
    FROM olist_orders oo 
    -- Une con la tabla olist_order_payments_dataset (alias oop) usando order_id como clave
    JOIN olist_order_payments oop ON oo.order_id = oop.order_id
    -- Filtra los pedidos que han sido entregados y tienen una fecha de entrega
    WHERE oo.order_delivered_customer_date IS NOT NULL AND oo.order_status = 'delivered'
    -- Agrupa los resultados por order_id para obtener un registro por pedido
    GROUP BY oo.order_id
    -- Ordena los resultados por fecha de entrega del pedido
    ORDER BY oo.order_delivered_customer_date
) 
-- Selecciona el número de mes, el nombre del mes y la suma de payment_value por año
SELECT 
    -- Extrae el número de mes de la fecha de entrega y lo etiqueta como month_no
    STRFTIME('%m', do.order_delivered_customer_date) AS month_no,
    -- Convierte el número de mes a su abreviatura de tres letras
    CASE STRFTIME('%m', do.order_delivered_customer_date)
        WHEN '01' THEN 'Jan' 
        WHEN '02' THEN 'Feb' 
        WHEN '03' THEN 'Mar'
        WHEN '04' THEN 'Apr' 
        WHEN '05' THEN 'May' 
        WHEN '06' THEN 'Jun'
        WHEN '07' THEN 'Jul' 
        WHEN '08' THEN 'Aug' 
        WHEN '09' THEN 'Sep'
        WHEN '10' THEN 'Oct' 
        WHEN '11' THEN 'Nov' 
        WHEN '12' THEN 'Dec'
    END AS month,
    -- Suma los payment_value para el año 2016
    SUM(CASE WHEN STRFTIME('%Y', do.order_delivered_customer_date) = '2016' THEN do.payment_value ELSE 0.00 END) AS Year2016,
    -- Suma los payment_value para el año 2017
    SUM(CASE WHEN STRFTIME('%Y', do.order_delivered_customer_date) = '2017' THEN do.payment_value ELSE 0.00 END) AS Year2017,
    -- Suma los payment_value para el año 2018
    SUM(CASE WHEN STRFTIME('%Y', do.order_delivered_customer_date) = '2018' THEN do.payment_value ELSE 0.00 END) AS Year2018
-- Desde la CTE delivered_orders (alias do)
FROM delivered_orders do
-- Filtra los registros donde month_no no es nulo
WHERE month_no IS NOT NULL
-- Agrupa los resultados por número de mes
GROUP BY month_no
-- Ordena los resultados por número de mes y nombre del mes
ORDER BY month_no, month;
