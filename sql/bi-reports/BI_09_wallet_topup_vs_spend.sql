-- Query: BI_09_wallet_topup_vs_spend.sql
-- Task 4.4 — Business Intelligence Reporting
-- Report: Wallet Top-Up vs Spend Analysis
-- Description: Compares how much merchants top up their wallets versus how much
--              they spend, revealing liquidity patterns and float management.

SELECT
    u.id                                          AS merchant_id,
    u.name                                        AS merchant_name,
    SUM(CASE WHEN w.type = 'top_up'
             THEN w.amount ELSE 0 END)            AS total_topped_up,
    SUM(CASE WHEN w.type = 'debit'
             THEN w.amount ELSE 0 END)            AS total_spent,
    SUM(CASE WHEN w.type = 'commission'
             THEN w.amount ELSE 0 END)            AS total_commission_received,
    w_current.balance                             AS current_wallet_balance,
    ROUND(
        SUM(CASE WHEN w.type = 'debit' THEN w.amount ELSE 0 END) /
        NULLIF(SUM(CASE WHEN w.type = 'top_up' THEN w.amount ELSE 0 END), 0)
        * 100, 2
    )                                             AS spend_to_topup_ratio_pct,
    COUNT(DISTINCT CASE WHEN w.type = 'top_up'
                        THEN w.id END)            AS topup_count
FROM Users u
JOIN WalletTransactions w          ON w.merchant_id = u.id
JOIN Wallets            w_current  ON w_current.merchant_id = u.id
GROUP BY u.id, u.name, w_current.balance
ORDER BY total_topped_up DESC
LIMIT 20;
