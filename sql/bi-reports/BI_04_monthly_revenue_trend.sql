-- Query: BI_04_monthly_revenue_trend.sql
-- Task 4.4 — Business Intelligence Reporting
-- Report: Monthly Revenue Trend (Last 12 Months)
-- Description: Month-over-month revenue trend for executive dashboard.
--              Includes growth % versus the previous month.

SELECT
    DATE_FORMAT(t.created_at, '%Y-%m')            AS sales_month,
    COUNT(t.id)                                   AS total_transactions,
    SUM(t.amount)                                 AS monthly_revenue,
    ROUND(AVG(t.amount), 2)                       AS avg_order_value,
    SUM(SUM(t.amount)) OVER (
        ORDER BY DATE_FORMAT(t.created_at, '%Y-%m')
    )                                             AS cumulative_revenue,
    ROUND(
        100.0 * (SUM(t.amount) - LAG(SUM(t.amount)) OVER (
            ORDER BY DATE_FORMAT(t.created_at, '%Y-%m')
        )) /
        NULLIF(LAG(SUM(t.amount)) OVER (
            ORDER BY DATE_FORMAT(t.created_at, '%Y-%m')
        ), 0),
    2)                                            AS mom_growth_pct
FROM Transactions t
WHERE t.type       = 'sale'
  AND t.status     = 'completed'
  AND t.created_at >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
GROUP BY DATE_FORMAT(t.created_at, '%Y-%m')
ORDER BY sales_month ASC;
