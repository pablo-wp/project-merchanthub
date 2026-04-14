# MerchantHub — QA & BI Reporting Project

**Platform:** https://quality-engineering-labs.vercel.app

---

## Project Structure

```
merchanthub-project/
├── playwright.config.js                  # Playwright configuration (Chromium + Firefox)
├── package.json
│
├── tests/                                # Task 3.3 — Cross-Role Sync (Playwright)
│   ├── cross-role-sync.spec.js           # 10 automated E2E tests
│   └── pages/
│       ├── SettingsPage.js               # POM — Admin Settings page
│       └── MerchantDashboardPage.js      # POM — Merchant Sell page
│
├── sql/
│   └── bi-reports/                       # Task 4.4 — BI Reporting (MySQL)
│       ├── BI_01_top_10_merchants_by_revenue.sql
│       ├── BI_02_low_performing_product_skus.sql
│       ├── BI_03_revenue_by_category.sql
│       ├── BI_04_monthly_revenue_trend.sql
│       ├── BI_05_commission_earnings_leaderboard.sql
│       ├── BI_06_top_providers_by_volume.sql
│       ├── BI_07_customer_lifetime_value.sql
│       ├── BI_08_peak_sales_hours_heatmap.sql
│       ├── BI_09_wallet_topup_vs_spend.sql
│       └── BI_10_executive_kpi_summary.sql
│
└── postman/
    └── Task_4.4_BI_Reporting.postman_collection.json
```

---

## Task 3.3 — Cross-Role Sync (Playwright Tests)

### Setup

```bash
npm install
npx playwright install
```

### Run Tests

```bash
# All browsers
npm test

# Chromium only
npm run test:chromium

# Firefox only
npm run test:firefox

# View HTML report
npm run report
```

### Test Coverage (10 Tests)

| ID | Description |
|----|-------------|
| T01 | Admin can navigate to Settings and see the Commission Rate field |
| T02 | Admin updates commission rate to 8% and save succeeds |
| T03 | Commission rate set in Settings is reflected on the Sell page |
| T04 | Commission rate change from 5% to 15% syncs to merchant Sell page |
| T05 | Commission calculation in sale summary matches the admin-set rate |
| T06 | Sell page info bar updates without requiring a full page reload |
| T07 | Commission rate persists after browser page reload |
| T08 | Commission rate of 0% is accepted and reflected on merchant page |
| T09 | Wallet balance on Sell page stays accurate after commission rate change |
| T10 | Full cross-role sync workflow — set rate, sell product, verify commission earned |

---

## Task 4.4 — BI Reporting (SQL Queries)

All queries target MySQL and use window functions (`RANK`, `LAG`, `SUM OVER`).

### Reports

| # | File | Description |
|---|------|-------------|
| 01 | `BI_01_top_10_merchants_by_revenue.sql` | Top 10 merchants by gross revenue |
| 02 | `BI_02_low_performing_product_skus.sql` | Low-performing SKUs with performance flags |
| 03 | `BI_03_revenue_by_category.sql` | Revenue share by product category |
| 04 | `BI_04_monthly_revenue_trend.sql` | MoM revenue trend with growth % (last 12 months) |
| 05 | `BI_05_commission_earnings_leaderboard.sql` | Commission leaderboard by merchant |
| 06 | `BI_06_top_providers_by_volume.sql` | Top providers by transaction volume |
| 07 | `BI_07_customer_lifetime_value.sql` | Customer LTV with RFM status (Active/At Risk/Churned) |
| 08 | `BI_08_peak_sales_hours_heatmap.sql` | Peak sales hours heatmap (day × hour) |
| 09 | `BI_09_wallet_topup_vs_spend.sql` | Wallet top-up vs spend ratio per merchant |
| 10 | `BI_10_executive_kpi_summary.sql` | Single-row executive KPI snapshot |

---

## Task 4.4 — Postman API Collection

Import `postman/Task_4.4_BI_Reporting.postman_collection.json` into Postman.

**Base URL variable:** `https://quality-engineering-labs.vercel.app`

Each request includes pre-built test scripts validating status codes, response schemas, and business logic (sort order, percentage totals, enum values, etc.).
