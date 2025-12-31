SET search_path TO perf;

-- Index to speed up joins between orders and order_items
CREATE INDEX IF NOT EXISTS idx_order_items_order_id
ON order_items (order_id);

CREATE INDEX IF NOT EXISTS idx_orders_status_ts
ON perf.orders (order_status, order_ts DESC);

-- Refresh stats so the planner can use the new index effectively
ANALYZE order_items;
ANALYZE orders;
