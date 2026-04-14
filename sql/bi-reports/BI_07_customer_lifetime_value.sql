-- Query: BI_07_customer_lifetime_value.sql
-- Task 4.4 — Business Intelligence Reporting
-- Report: Customer Lifetime Value (CLV)
-- Description: Identifies high-value customers based on cumulative spend,
--              purchase frequency, and recency (RFM model).

SELECT
    c.id                                          AS customer_id,
    c.name                                        AS customer_name,
    c.phone                                       AS customer_phone,
    COUNT(t.id)                                   AS total_purchases,
    SUM(t.amount)                                 AS lifetime_spend,
    ROUND(AVG(t.amount), 2)                       AS avg_purchase_value,
    MIN(t.created_at)                             AS first_purchase_date,
    MAX(t.created_at)                             AS last_purchase_date,
    DATEDIFF(CURDATE(), MAX(t.created_at))        AS days_since_last_purchase,
    CASE
        WHEN DATEDIFF(CURDATE(), MAX(t.created_at)) <= 30  THEN 'Active'
        WHEN DATEDIFF(CURDATE(), MAX(t.created_at)) <= 90  THEN 'At Risk'
        ELSE 'Churned'
    END                                           AS customer_status,
    RANK() OVER (ORDER BY SUM(t.amount) DESC)     AS clv_rank
FROM Customers c
JOIN Transactions t
       ON t.customer_phone = c.phone
      AND t.type           = 'sale'
      AND t.status         = 'completed'
GROUP BY c.id, c.name, c.phone
ORDER BY lifetime_spend DESC
LIMIT 20;
