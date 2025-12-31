SET search_path TO perf;

EXPLAIN (ANALYZE, BUFFERS)
SELECT
  c.customer_id,
  c.full_name,
  SUM(oi.line_amount) AS total_spent
FROM customers c
JOIN orders o
  ON o.customer_id = c.customer_id
JOIN order_items oi
  ON oi.order_id = o.order_id
WHERE o.order_ts >= now() - interval '90 days'
  AND o.order_status IN ('PAID','SHIPPED')
GROUP BY c.customer_id, c.full_name
ORDER BY total_spent DESC
LIMIT 10;
