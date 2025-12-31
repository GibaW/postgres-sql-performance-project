SET search_path TO perf;

-- 1) Clear
TRUNCATE TABLE order_items RESTART IDENTITY;

-- 2) Insert: exactly 5 items per order => 200k * 5 = 1,000,000 rows
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
  LIMIT 5
) p
CROSS JOIN LATERAL (
  SELECT (1 + floor(random() * 5))::int AS quantity
) qty;
