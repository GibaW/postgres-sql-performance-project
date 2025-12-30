SET search_path TO perf;

-- Customers
INSERT INTO customers (full_name, email, phone, created_at)
SELECT
  'Customer ' || g,
  'customer' || g || '@email.com',
  '555-000' || g,
  now() - (g || ' days')::interval
FROM generate_series(1, 1000) g;

-- Products
INSERT INTO products (sku, product_name, category, unit_price, is_active)
SELECT
  'SKU-' || g,
  'Product ' || g,
  CASE WHEN g % 5 = 0 THEN 'Electronics'
       WHEN g % 5 = 1 THEN 'Books'
       WHEN g % 5 = 2 THEN 'Home'
       WHEN g % 5 = 3 THEN 'Sports'
       ELSE 'Clothing' END,
  (random() * 500 + 10)::numeric(12,2),
  TRUE
FROM generate_series(1, 500) g;
