SET search_path TO perf;

-- Orders
INSERT INTO orders (
  customer_id,
  order_ts,
  order_status,
  channel,
  shipping_state,
  shipping_zip,
  total_amount
)
SELECT
  (random() * 999 + 1)::bigint,
  now() - (random() * interval '180 days'),
  CASE
    WHEN g % 4 = 0 THEN 'NEW'
    WHEN g % 4 = 1 THEN 'PAID'
    WHEN g % 4 = 2 THEN 'SHIPPED'
    ELSE 'CANCELED'
  END,
  CASE
    WHEN g % 3 = 0 THEN 'WEB'
    WHEN g % 3 = 1 THEN 'MOBILE'
    ELSE 'STORE'
  END,
  CASE
    WHEN g % 5 = 0 THEN 'FL'
    WHEN g % 5 = 1 THEN 'TX'
    WHEN g % 5 = 2 THEN 'CA'
    WHEN g % 5 = 3 THEN 'NY'
    ELSE 'IL'
  END,
  lpad((10000 + g % 90000)::text, 5, '0'),
  0
FROM generate_series(1, 200000) g;
