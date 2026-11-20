
 CREATE OR REPLACE TABLE rechazados_limpios AS SELECT id_pedido, TRY_CAST(fecha_pedido AS DATE) AS fecha_pedido, TRIM(LOWER(email_cliente)) AS email_cliente, 
 TRY_CAST(cantidad AS INTEGER) AS cantidad, 
 TRY_CAST(precio_unitario AS DOUBLE) AS precio_unitario, 
 TRY_CAST(descuento_pct AS DOUBLE) AS descuento_pct, TRIM(LOWER(REPLACE(estado, ' ', '')))
  AS estado, TRIM(LOWER(REPLACE(medio_pago, ' ', '_'))) 
 AS medio_pago, motivo_rechazo FROM rechazados;
