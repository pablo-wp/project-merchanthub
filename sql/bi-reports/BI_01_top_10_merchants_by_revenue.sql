-- Query: BI_01_top_10_merchants_by_revenue.sql
-- Task 4.4 — Business Intelligence Reporting
-- Report: Top 10 Merchants by Total Revenue
-- Description: Ranks merchants by total transaction revenue for executive reporting.
--              Includes merchant name, total sales count, and gross revenue.

SELECT
    u.id                                          AS merchant_id,
    u.name                                        AS merchant_name,
    u.phone                                       AS merchant_phone,
    COUNT(t.id)                                   AS total_transactions,
    SUM(t.amount)                                 AS gross_revenue,
    ROUND(AVG(t.amount), 2)                       AS avg_transaction_value,
    MIN(t.created_at)                             AS first_sale_date,
    MAX(t.created_at)                             AS last_sale_date
FROM Users u
JOIN Transactions t ON t.merchant_id = u.id
WHERE t.type       = 'sale'
  AND t.status     = 'completed'
GROUP BY u.id, u.name, u.phone
ORDER BY gross_revenue DESC
LIMIT 10;
