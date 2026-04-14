-- Query: BI_03_revenue_by_category.sql
-- Task 4.4 — Business Intelligence Reporting
-- Report: Revenue Breakdown by Product Category
-- Description: Executive summary of revenue split across Airtime, Data Bundle,
--              1Voucher, Electricity, Gaming, Entertainment, Cash-Out, etc.

SELECT
    p.category                                    AS product_category,
    COUNT(DISTINCT t.merchant_id)                 AS active_merchants,
    COUNT(t.id)                                   AS total_transactions,
    SUM(t.amount)                                 AS total_revenue,
    ROUND(AVG(t.amount), 2)                       AS avg_transaction_value,
    ROUND(
        100.0 * SUM(t.amount) /
        SUM(SUM(t.amount)) OVER (),
    2)                                            AS revenue_share_pct
FROM Transactions t
JOIN Products p ON p.id = t.product_id
WHERE t.type   = 'sale'
  AND t.status = 'completed'
GROUP BY p.category
ORDER BY total_revenue DESC;
