-- Query: BI_08_peak_sales_hours_heatmap.sql
-- Task 4.4 — Business Intelligence Reporting
-- Report: Peak Sales Hours Heatmap
-- Description: Breaks down transaction volume and revenue by day-of-week and hour
--              to support staffing, promotion scheduling, and system load planning.

SELECT
    DAYNAME(t.created_at)                         AS day_of_week,
    DAYOFWEEK(t.created_at)                       AS day_number,
    HOUR(t.created_at)                            AS hour_of_day,
    COUNT(t.id)                                   AS transaction_count,
    SUM(t.amount)                                 AS hourly_revenue,
    ROUND(AVG(t.amount), 2)                       AS avg_transaction_value,
    RANK() OVER (
        ORDER BY COUNT(t.id) DESC
    )                                             AS volume_rank
FROM Transactions t
WHERE t.type   = 'sale'
  AND t.status = 'completed'
GROUP BY
    DAYNAME(t.created_at),
    DAYOFWEEK(t.created_at),
    HOUR(t.created_at)
ORDER BY day_number ASC, hour_of_day ASC;
