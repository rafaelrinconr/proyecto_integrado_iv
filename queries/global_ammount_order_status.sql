-- TODO: Esta consulta devolverá una tabla con dos columnas: estado_pedido y
-- Cantidad. La primera contendrá las diferentes clases de estado de los pedidos,
-- y la segunda mostrará el total de cada uno.

SELECT
  -- Selecciona la columna 'order_status' y la renombra como 'order_status' en el resultado.
  order_status AS order_status,
  -- Cuenta el número de filas para cada grupo y lo renombra como 'Ammount'.  
  COUNT(*) AS Ammount  
FROM
  -- Especifica la tabla 'olist_orders_dataset' dentro del esquema 'dataset'.
  olist_orders  
GROUP BY
  -- Agrupa las filas por los valores únicos en la columna 'order_status'.
  order_status
ORDER BY
  -- Ordena los resultados en orden ascendente según la columna 'order_status'.
  order_status ASC;  -- Ordena los resultados por "estado_pedido" en orden ascendente