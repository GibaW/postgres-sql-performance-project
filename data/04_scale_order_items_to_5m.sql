SET search_path TO perf;

-- Add 4 more items per order (total: 9 items/order) run 4 times
INSERT INTO order_items (order_id, product_id, quantity, unit_price, line_amount)
SELECT
  o.order_id,
  p.product_id,
  qty.quantity,
  p.unit_price,
  (qty.quantity * p.unit_price)::numeric(14,2) 
FROM orders o
CROSS JOIN LATERAL (
  SELECT product_id, unit_price
  FROM products
  ORDER BY random()
  LIMIT 4
) p
CROSS JOIN LATERAL (
  SELECT (1 + floor(random() * 5))::int AS quantity
) qty;
