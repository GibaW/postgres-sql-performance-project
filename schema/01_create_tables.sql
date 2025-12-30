-- schema/01_create_tables.sql
-- PostgreSQL 18+

CREATE SCHEMA IF NOT EXISTS perf;
SET search_path TO perf;

-- Customers
CREATE TABLE customers (
  customer_id      BIGSERIAL PRIMARY KEY,
  full_name        TEXT NOT NULL,
  email            TEXT NOT NULL,
  phone            TEXT,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Products
CREATE TABLE products (
  product_id       BIGSERIAL PRIMARY KEY,
  sku              TEXT NOT NULL,
  product_name     TEXT NOT NULL,
  category         TEXT NOT NULL,
  unit_price       NUMERIC(12,2) NOT NULL,
  is_active        BOOLEAN NOT NULL DEFAULT TRUE,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Orders (header)
CREATE TABLE orders (
  order_id         BIGSERIAL PRIMARY KEY,
  customer_id      BIGINT NOT NULL,
  order_ts         TIMESTAMPTZ NOT NULL,
  order_status     TEXT NOT NULL,      -- e.g., NEW, PAID, SHIPPED, CANCELED
  channel          TEXT NOT NULL,      -- e.g., WEB, MOBILE, STORE
  shipping_state   TEXT,               -- e.g., FL, TX
  shipping_zip     TEXT,
  total_amount     NUMERIC(14,2) NOT NULL DEFAULT 0
);

-- Order items (details)
CREATE TABLE order_items (
  order_item_id    BIGSERIAL PRIMARY KEY,
  order_id         BIGINT NOT NULL,
  product_id       BIGINT NOT NULL,
  quantity         INTEGER NOT NULL,
  unit_price       NUMERIC(12,2) NOT NULL,
  line_amount      NUMERIC(14,2) NOT NULL
);

-- Payments
CREATE TABLE payments (
  payment_id       BIGSERIAL PRIMARY KEY,
  order_id         BIGINT NOT NULL,
  payment_ts       TIMESTAMPTZ NOT NULL,
  payment_method   TEXT NOT NULL,      -- CARD, ACH, PAYPAL, etc.
  payment_status   TEXT NOT NULL,      -- APPROVED, DECLINED, REFUNDED
  paid_amount      NUMERIC(14,2) NOT NULL
);
