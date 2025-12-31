SET search_path TO perf;

DROP TABLE IF EXISTS order_totals;

CREATE TABLE order_totals AS
SELECT
  order_id,
  SUM(line_amount) AS order_total
FROM order_items
GROUP BY order_id;

-- Helpful index for joins
CREATE INDEX idx_order_totals_order_id ON order_totals(order_id);

ANALYZE order_totals;
