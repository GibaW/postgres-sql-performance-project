-- schema/02_constraints.sql
SET search_path TO perf;

-- Customers
ALTER TABLE customers
  ADD CONSTRAINT uq_customers_email UNIQUE (email);

-- Products
ALTER TABLE products
  ADD CONSTRAINT uq_products_sku UNIQUE (sku);

ALTER TABLE products
  ADD CONSTRAINT ck_products_unit_price CHECK (unit_price >= 0);

-- Orders
ALTER TABLE orders
  ADD CONSTRAINT fk_orders_customer
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

ALTER TABLE orders
  ADD CONSTRAINT ck_orders_total_amount CHECK (total_amount >= 0);

ALTER TABLE orders
  ADD CONSTRAINT ck_orders_status CHECK (order_status IN ('NEW','PAID','SHIPPED','CANCELED'));

ALTER TABLE orders
  ADD CONSTRAINT ck_orders_channel CHECK (channel IN ('WEB','MOBILE','STORE'));

-- Order Items
ALTER TABLE order_items
  ADD CONSTRAINT fk_order_items_order
  FOREIGN KEY (order_id) REFERENCES orders(order_id);

ALTER TABLE order_items
  ADD CONSTRAINT fk_order_items_product
  FOREIGN KEY (product_id) REFERENCES products(product_id);

ALTER TABLE order_items
  ADD CONSTRAINT ck_order_items_qty CHECK (quantity > 0);

ALTER TABLE order_items
  ADD CONSTRAINT ck_order_items_unit_price CHECK (unit_price >= 0);

ALTER TABLE order_items
  ADD CONSTRAINT ck_order_items_line_amount CHECK (line_amount >= 0);

-- Payments
ALTER TABLE payments
  ADD CONSTRAINT fk_payments_order
  FOREIGN KEY (order_id) REFERENCES orders(order_id);

ALTER TABLE payments
  ADD CONSTRAINT ck_payments_paid_amount CHECK (paid_amount >= 0);

ALTER TABLE payments
  ADD CONSTRAINT ck_payments_status CHECK (payment_status IN ('APPROVED','DECLINED','REFUNDED'));
