-- Query: BI_05_commission_earnings_leaderboard.sql
-- Task 4.4 — Business Intelligence Reporting
-- Report: Commission Earnings Leaderboard
-- Description: Ranks merchants by total commission earned.
--              Helps identify the highest-value commission-generating accounts.

SELECT
    u.id                                          AS merchant_id,
    u.name                                        AS merchant_name,
    u.phone                                       AS merchant_phone,
    COUNT(t.id)                                   AS completed_sales,
    SUM(t.amount)                                 AS gross_sales_value,
    ROUND(AVG(c.commission_rate), 2)              AS avg_commission_rate_pct,
    SUM(t.amount * c.commission_rate / 100.0)     AS total_commission_earned,
    RANK() OVER (
        ORDER BY SUM(t.amount * c.commission_rate / 100.0) DESC
    )                                             AS commission_rank
FROM Users u
JOIN Transactions  t ON t.merchant_id      = u.id
JOIN Commissions   c ON c.merchant_id      = u.id
WHERE t.type   = 'sale'
  AND t.status = 'completed'
GROUP BY u.id, u.name, u.phone
ORDER BY total_commission_earned DESC
LIMIT 15;
