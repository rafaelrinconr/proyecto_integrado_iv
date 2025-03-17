-- TODO: Esta consulta devolverá una tabla con las diferencias entre los tiempos 
-- reales y estimados de entrega por mes y año. Tendrá varias columnas: 
-- month_no, con los números de mes del 01 al 12; month, con las primeras 3 letras 
-- de cada mes (ej. Ene, Feb); Year2016_real_time, con el tiempo promedio de 
-- entrega real por mes de 2016 (NaN si no existe); Year2017_real_time, con el 
-- tiempo promedio de entrega real por mes de 2017 (NaN si no existe); 
-- Year2018_real_time, con el tiempo promedio de entrega real por mes de 2018 
-- (NaN si no existe); Year2016_estimated_time, con el tiempo promedio estimado 
-- de entrega por mes de 2016 (NaN si no existe); Year2017_estimated_time, con 
-- el tiempo promedio estimado de entrega por mes de 2017 (NaN si no existe); y 
-- Year2018_estimated_time, con el tiempo promedio estimado de entrega por mes 
-- de 2018 (NaN si no existe).
-- PISTAS:
-- 1. Puedes usar la función julianday para convertir una fecha a un número.
-- 2. order_status == 'delivered' AND order_delivered_customer_date IS NOT NULL
-- 3. Considera tomar order_id distintos.

-- Define una expresión de tabla común llamada delivery_times
WITH delivery_times AS (
  -- Selecciona el número de mes de la fecha de compra del pedido
  SELECT
    STRFTIME('%m', o.order_purchase_timestamp) AS month_no,
    -- Convierte el número de mes a su abreviatura de tres letras (p. ej., 'Jan' para enero)
    CASE STRFTIME('%m', o.order_purchase_timestamp)
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
    -- Extrae el año de la fecha de compra del pedido
    STRFTIME('%Y', o.order_purchase_timestamp) AS year,
    -- Calcula la diferencia en días entre la fecha de entrega al cliente y la fecha de compra del pedido (tiempo real de entrega)
    JULIANDAY(o.order_delivered_customer_date) - JULIANDAY(o.order_purchase_timestamp) AS real_time,
    -- Calcula la diferencia en días entre la fecha estimada de entrega y la fecha de compra del pedido (tiempo estimado de entrega)
    JULIANDAY(o.order_estimated_delivery_date) - JULIANDAY(o.order_purchase_timestamp) AS estimated_time
  -- De la tabla 'olist_orders_dataset' con alias 'o'
  FROM olist_orders AS o
  -- Filtra los pedidos que han sido entregados ('delivered') y tienen una fecha de entrega real
  WHERE
    o.order_status = 'delivered' AND o.order_delivered_customer_date IS NOT NULL
  -- Agrupa los resultados por ID de pedido para obtener un registro por pedido
  GROUP BY
    o.order_id
)
-- Consulta principal que utiliza la 'delivery_times'
SELECT
  -- Selecciona el número de mes
  dt.month_no,
  -- Selecciona la abreviatura del mes
  dt.month,
  -- Calcula el tiempo real promedio de entrega para el año 2016
  AVG(CASE WHEN dt.year = '2016' THEN dt.real_time END) AS Year2016_real_time,
  -- Calcula el tiempo real promedio de entrega para el año 2017
  AVG(CASE WHEN dt.year = '2017' THEN dt.real_time END) AS Year2017_real_time,
  -- Calcula el tiempo real promedio de entrega para el año 2018
  AVG(CASE WHEN dt.year = '2018' THEN dt.real_time END) AS Year2018_real_time,
  -- Calcula el tiempo estimado promedio de entrega para el año 2016
  AVG(CASE WHEN dt.year = '2016' THEN dt.estimated_time END) AS Year2016_estimated_time,
  -- Calcula el tiempo estimado promedio de entrega para el año 2017
  AVG(CASE WHEN dt.year = '2017' THEN dt.estimated_time END) AS Year2017_estimated_time,
  -- Calcula el tiempo estimado promedio de entrega para el año 2018
  AVG(CASE WHEN dt.year = '2018' THEN dt.estimated_time END) AS Year2018_estimated_time
-- De la CTE 'delivery_times' con alias 'dt'
FROM delivery_times AS dt
-- Agrupa los resultados por número de mes y abreviatura del mes
GROUP BY
  dt.month_no,
  dt.month
-- Ordena los resultados por número de mes
ORDER BY
  dt.month_no;