# Technical Decisions

## Indexing Strategy – order_items

### Context
The analytical query aggregates customer spend over recent orders and joins:
- customers → orders → order_items

After scaling the dataset (~200k orders, ~1.8M order_items), the baseline execution plan showed:
- Parallel sequential scan on order_items
- Hash join on oi.order_id = o.order_id
- Execution time ~490 ms

### Problem
The join between orders and order_items required scanning a large portion of order_items,
even though only a subset of orders (PAID/SHIPPED, last 90 days) was relevant.

### Decision
Create a single B-tree index on:

    order_items(order_id)

This index targets the join condition directly and allows the planner to reduce the amount
of data read from order_items during the aggregation.

### Trade-offs
- Additional storage and write overhead on order_items inserts
- Acceptable given the analytical read-heavy workload

### Expected Outcome
- Reduced I/O on order_items
- Lower execution time for aggregation queries involving recent orders

Indexes didn’t improve runtime because the query still scanned a large portion of order_items.

Introduced a pre-aggregated table (order_totals) to reduce join input cardinality and improve analytical performance.
