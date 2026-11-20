CREATE OR REPLACE TABLE datos_validos 
AS SELECT * FROM raw_pedidos WHERE id_pedido IS NOT NULL 
AND TRY_CAST(fecha_pedido AS DATE) IS NOT NULL 
AND email_cliente IS NOT NULL AND email_cliente LIKE '%@%'
AND TRY_CAST(cantidad AS INTEGER)> 0 AND TRY_CAST(precio_unitario AS DOUBLE)>0
AND TRY_CAST(descuento_pct AS DOUBLE) BETWEEN 0 
AND 100 AND estado IN ('entregado', 'enviado', 'pendiente', 'cancelado') 
AND medio_pago IN ('tarjeta', 'transferencia', 'efectivo', 'billetera_virtual');


CREATE OR REPLACE TABLE rechazados AS 
SELECT *, CASE WHEN id_pedido IS NULL THEN 'id_pedido es nulo' 
WHEN TRY_CAST(fecha_pedido AS DATE) IS NULL THEN 'fecha_pedido invalida'
WHEN email_cliente IS NULL OR email_cliente NOT LIKE '%@%' THEN 'email_cliente invalido'
WHEN TRY_CAST(cantidad AS INTEGER) <= 0 OR TRY_CAST(cantidad AS INTEGER) IS NULL THEN 'cantidad<= 0 o nula'
WHEN TRY_CAST(precio_unitario AS DOUBLE) <= 0 OR TRY_CAST(precio_unitario AS DOUBLE) IS NULL THEN 'precio_unitario <= 0 o nulo' 
WHEN TRY_CAST(descuento_pct AS DOUBLE) < 0 OR TRY_CAST(descuento_pct AS DOUBLE)>  100 OR TRY_CAST(descuento_pct AS DOUBLE) IS NULL THEN 'descuento fuera de rango' 
WHEN estado NOT IN ('entregado', 'enviado', 'pendiente', 'cancelado') THEN 'estado no permitido' 
WHEN medio_pago NOT IN ('tarjeta', 'transferencia', 'efectivo', 'billetera_virtual') THEN 'medio_pago no permitido' ELSE 'otro motivo' END AS motivo_rechazo FROM raw_pedidos
WHERE id_pedido IS NULL OR TRY_CAST(fecha_pedido AS DATE) IS NULL OR email_cliente IS NULL 
OR email_cliente NOT LIKE '%@%'
OR TRY_CAST(cantidad AS INTEGER) <= 0 OR TRY_CAST(cantidad AS INTEGER) IS NULL 
OR TRY_CAST(precio_unitario AS DOUBLE) <= 0
OR TRY_CAST(precio_unitario AS DOUBLE) IS NULL 
OR TRY_CAST(descuento_pct AS DOUBLE) < 0 
OR TRY_CAST(descuento_pct AS DOUBLE) > 100 OR TRY_CAST(descuento_pct AS DOUBLE) IS NULL 
OR estado NOT IN ('entregado', 'enviado', 'pendiente', 'cancelado')
OR medio_pago NOT IN ('tarjeta', 'transferencia', 'efectivo', 'billetera_virtual');
