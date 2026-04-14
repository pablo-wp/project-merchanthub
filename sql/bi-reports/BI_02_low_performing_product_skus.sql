-- Query: BI_02_low_performing_product_skus.sql
-- Task 4.4 — Business Intelligence Reporting
-- Report: Low-Performing Product SKUs
-- Description: Identifies digital products generating the least revenue and volume.
--              Flags SKUs at risk of being discontinued or needing promotion.

SELECT
    p.id                                          AS product_id,
    p.sku                                         AS product_sku,
    p.name                                        AS product_name,
    p.category                                    AS category,
    p.provider                                    AS provider,
    COUNT(t.id)                                   AS total_units_sold,
    COALESCE(SUM(t.amount), 0)                    AS total_revenue,
    COALESCE(ROUND(AVG(t.amount), 2), 0)          AS avg_sale_price,
    p.stock_quantity                              AS current_stock,
    MAX(t.created_at)                             AS last_sold_date,
    CASE
        WHEN COUNT(t.id) = 0       THEN 'No Sales — Review for Removal'
        WHEN COUNT(t.id) < 5       THEN 'Critical — Very Low Volume'
        WHEN SUM(t.amount) < 500   THEN 'Warning  — Low Revenue'
        ELSE 'Acceptable'
    END                                           AS performance_flag
FROM Products p
LEFT JOIN Transactions t
       ON t.product_id = p.id
      AND t.type       = 'sale'
      AND t.status     = 'completed'
GROUP BY p.id, p.sku, p.name, p.category, p.provider, p.stock_quantity
ORDER BY total_revenue ASC, total_units_sold ASC
LIMIT 20;
