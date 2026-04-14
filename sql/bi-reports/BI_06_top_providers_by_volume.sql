-- Query: BI_06_top_providers_by_volume.sql
-- Task 4.4 — Business Intelligence Reporting
-- Report: Top Providers by Transaction Volume
-- Description: Identifies which network/digital providers (Vodacom, MTN, Telkom,
--              PlayStation, Steam, Showmax etc.) drive the most volume and revenue.

SELECT
    p.provider                                    AS provider_name,
    p.category                                    AS category,
    COUNT(t.id)                                   AS total_transactions,
    SUM(t.amount)                                 AS total_revenue,
    ROUND(AVG(t.amount), 2)                       AS avg_transaction_value,
    COUNT(DISTINCT t.merchant_id)                 AS merchants_selling,
    COUNT(DISTINCT t.customer_phone)              AS unique_customers,
    ROUND(
        100.0 * COUNT(t.id) /
        SUM(COUNT(t.id)) OVER (),
    2)                                            AS volume_share_pct
FROM Products p
JOIN Transactions t ON t.product_id = p.id
WHERE t.type   = 'sale'
  AND t.status = 'completed'
GROUP BY p.provider, p.category
ORDER BY total_revenue DESC
LIMIT 10;
