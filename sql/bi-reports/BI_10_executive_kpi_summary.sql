-- Query: BI_10_executive_kpi_summary.sql
-- Task 4.4 — Business Intelligence Reporting
-- Report: Executive KPI Summary Dashboard
-- Description: Single-query snapshot of all key business metrics for C-suite reporting.
--              Covers revenue, commissions, wallet activity, and customer engagement.

SELECT
    -- Revenue Metrics
    (SELECT COUNT(*)
       FROM Transactions
      WHERE type = 'sale' AND status = 'completed')          AS total_completed_sales,

    (SELECT COALESCE(SUM(amount), 0)
       FROM Transactions
      WHERE type = 'sale' AND status = 'completed')          AS total_gross_revenue,

    (SELECT COALESCE(ROUND(AVG(amount), 2), 0)
       FROM Transactions
      WHERE type = 'sale' AND status = 'completed')          AS avg_transaction_value,

    -- This Month vs Last Month
    (SELECT COALESCE(SUM(amount), 0)
       FROM Transactions
      WHERE type = 'sale'
        AND status = 'completed'
        AND MONTH(created_at)  = MONTH(CURDATE())
        AND YEAR(created_at)   = YEAR(CURDATE()))            AS revenue_this_month,

    (SELECT COALESCE(SUM(amount), 0)
       FROM Transactions
      WHERE type = 'sale'
        AND status = 'completed'
        AND MONTH(created_at)  = MONTH(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
        AND YEAR(created_at)   = YEAR(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))) AS revenue_last_month,

    -- Commission Metrics
    (SELECT COALESCE(SUM(t.amount * c.commission_rate / 100.0), 0)
       FROM Transactions t
       JOIN Commissions c ON c.merchant_id = t.merchant_id
      WHERE t.type = 'sale' AND t.status = 'completed')      AS total_commissions_paid,

    -- Merchant & Customer Counts
    (SELECT COUNT(DISTINCT merchant_id)
       FROM Transactions
      WHERE type = 'sale' AND status = 'completed')          AS active_merchants,

    (SELECT COUNT(DISTINCT customer_phone)
       FROM Transactions
      WHERE type = 'sale' AND status = 'completed')          AS unique_customers,

    -- Wallet Metrics
    (SELECT COALESCE(SUM(balance), 0)
       FROM Wallets)                                          AS total_wallet_float,

    (SELECT COALESCE(SUM(amount), 0)
       FROM WalletTransactions
      WHERE type = 'top_up')                                  AS total_topups_alltime,

    -- Product Metrics
    (SELECT COUNT(DISTINCT product_id)
       FROM Transactions
      WHERE type = 'sale' AND status = 'completed')          AS products_sold,

    (SELECT COUNT(*)
       FROM Products
      WHERE stock_quantity = 0)                              AS out_of_stock_products,

    -- Failure Rate
    (SELECT ROUND(
        100.0 * COUNT(CASE WHEN status = 'failed' THEN 1 END) /
        NULLIF(COUNT(*), 0), 2)
       FROM Transactions
      WHERE type = 'sale')                                   AS sale_failure_rate_pct;
