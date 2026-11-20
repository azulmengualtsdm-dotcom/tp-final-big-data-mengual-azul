CREATE OR REPLACE TABLE tabla_final AS SELECT
 id_pedido, 
 fecha_pedido,
 email_cliente,
cantidad, 
precio_unitario,
descuento_pct, 
estado, 
medio_pago 
FROM ( SELECT id_pedido,
TRY_CAST(fecha_pedido AS DATE) AS fecha_pedido, email_cliente,
TRY_CAST(cantidad AS INTEGER) AS cantidad, 
TRY_CAST(precio_unitario AS DOUBLE) AS precio_unitario,
TRY_CAST(descuento_pct AS DOUBLE) 
AS descuento_pct, estado, medio_pago FROM datos_validos
UNION ALL SELECT TRY_CAST(id_pedido AS INTEGER) AS id_pedido,
fecha_pedido,
 email_cliente, 
 cantidad, 
 precio_unitario, 
 descuento_pct,
  estado,
medio_pago FROM rechazados_limpios WHERE id_pedido
 IS NOT NULL AND fecha_pedido
  IS NOT NULL AND email_cliente LIKE '%@%' AND cantidad > 0
   AND precio_unitario > 0 
AND descuento_pct BETWEEN 0 AND 100
AND estado IN ('entregado', 'enviado', 'pendiente', 'cancelado') 
AND medio_pago IN ('tarjeta', 'transferencia', 'efectivo', 'billetera_virtual') )
QUALIFY ROW_NUMBER() OVER (PARTITION BY id_pedido ORDER BY fecha_pedido DESC) = 1;
