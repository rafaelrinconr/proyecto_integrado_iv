-- TODO: Esta consulta devolverá una tabla con las 10 categorías con mayores ingresos
-- (en inglés), el número de pedidos y sus ingresos totales. La primera columna será
-- Category, que contendrá las 10 categorías con mayores ingresos; la segunda será
-- Num_order, con el total de pedidos de cada categoría; y la última será Revenue,
-- con el ingreso total de cada categoría.
-- PISTA: Todos los pedidos deben tener un estado 'delivered' y tanto la categoría
-- como la fecha real de entrega no deben ser nulas.

SELECT
    Category, -- Selecciona la columna 'Category', que representa el nombre de la categoría del producto.
    COUNT(DISTINCT OrderID) AS Num_order, -- Cuenta el número de pedidos únicos por categoría y lo renombra como 'Num_order'.
    SUM(PaymentValue) AS Revenue -- Suma los valores de pago por categoría y lo renombra como 'Revenue'.
FROM (              -- Inicia una subconsulta, que actúa como una tabla temporal.
    SELECT
        pcnt.product_category_name_english AS Category, -- Selecciona el nombre de la categoría del producto en inglés y lo renombra como 'Category'.
        ooi.order_id AS OrderID, -- Selecciona el ID del pedido y lo renombra como 'OrderID'.
        oop.payment_value AS PaymentValue  -- Selecciona el valor del pago y lo renombra como 'PaymentValue'.
    FROM
        olist_order_items ooi -- Selecciona datos de la tabla 'olist_order_items_dataset' y le asigna el alias 'ooi'.
        JOIN olist_products op ON op.product_id = ooi.product_id -- Une 'ooi' con 'olist_products_dataset' (alias 'op') usando 'product_id'.
        JOIN product_category_name_translation pcnt ON op.product_category_name = pcnt.product_category_name -- Une 'op' con 'product_category_name_translation' (alias 'pcnt') usando 'product_category_name'.
        JOIN olist_orders oo ON ooi.order_id = oo.order_id -- Une 'ooi' con 'olist_orders_dataset' (alias 'oo') usando 'order_id'.
        JOIN olist_order_payments oop ON oo.order_id = oop.order_id -- Une 'oo' con 'olist_order_payments_dataset' (alias 'oop') usando 'order_id'.
    WHERE
        oo.order_status = 'delivered'  -- Filtra los pedidos que han sido entregados.
        AND oo.order_delivered_customer_date IS NOT NULL -- Filtra los pedidos con fecha de entrega no nula.
        AND op.product_category_name IS NOT NULL  -- Filtra los productos con nombre de categoría no nulo.
) AS Subquery  -- Asigna el alias 'Subquery' a la subconsulta.
GROUP BY
    Category  -- Agrupa los resultados por categoría.
ORDER BY
    Revenue DESC  -- Ordena los resultados por ingresos en orden descendente.
LIMIT
    10;  -- Limita los resultados a los 10 primeros.