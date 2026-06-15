# 🔇 Silent Exit — E-Commerce Customer Churn Analysis

> *"Customers don't always say goodbye. They just stop showing up."*

**Tools:** BigQuery · SQL · Looker Studio · Google Cloud Platform  
**Dataset:** 1,05,000 rows · 34 columns · Jan 2021 – Jun 2024

---

## 📊 Live Dashboard
🔗 **[View Interactive Dashboard]((https://datastudio.google.com/u/0/reporting/3c3c16d4-173f-4aac-a598-5b63cc70f721/page/N430F))**

---

## 📌 What is Silent Exit?

In e-commerce, most customers don't cancel — they simply **stop buying**.  
No warning. No complaint. No goodbye.  
This is called **Silent Churn** — and it costs businesses millions.

This project answers:
- How many customers silently exited — and how much revenue did we lose?
- Which customers are about to exit next?
- What behaviour patterns predict a silent exit?
- How do we stop it before it happens?

---

## 🖼️ Dashboard Preview

### Page 1 — Executive Overview
![Executive Overview](dashboard/page1_executive_overview.png)

### Page 2 — Customer & Behavior Analysis
![Customer Behavior](dashboard/page2_customer_behavior.png)

### Page 3 — Revenue & Risk Analysis
![Revenue Risk](dashboard/page3_revenue_risk.png)

---

## 🔑 Key Findings

| # | Finding | Number |
|---|---------|--------|
| 1 | Overall churn rate | **37.43%** |
| 2 | Total customers churned | **33,340** |
| 3 | Revenue lost to churn | **₹543.6M** |
| 4 | Churn rate — 365+ day inactive customers | **54.48%** |
| 5 | Churn rate — recently active customers | **16.47%** |
| 6 | None-tier member churn rate | **53.08%** |
| 7 | Platinum member churn rate | **23.68%** |
| 8 | High risk active customers | **9,069** |
| 9 | Revenue at immediate risk | **₹9.84M** |
| 10 | Churn growth 2021 → 2023 | **1.5K → 14K (9x)** |

---

## 🗂️ Dataset Overview

- **Source:** Synthetically generated realistic Indian e-commerce data
- **Size:** 1,05,000 rows · 34 columns
- **Period:** January 2021 – June 2024
- **Churn Rate:** 37.43%
- **Total Revenue:** ₹1.92 Billion

### Intentional Data Quality Issues (Real-world simulation)

| Issue | Description | Count |
|-------|-------------|-------|
| Null/invalid emails | Missing @, junk values (N/A, null@, test@) | ~2,400 |
| Invalid ages | Values like 0, -1, 150, 999 | ~500 |
| Negative spend | Negative total_spent_inr values | ~182 |
| Membership typos | Sivler, G0ld, Platinium, Platnium | ~3% rows |
| Impossible returns | total_returns > total_orders | ~1,050 |
| Future signup dates | Dates beyond June 2024 | 50 rows |
| Duplicate records | Same customer multiple times | ~1,575 |
| Mixed gender formats | M, F, 0, 1, male, MALE, female | ~2,000 |
| Mixed payment formats | upi, CREDIT CARD, cod, Net banking | ~1,800 |
| Invalid ratings | Values outside 1–5 range | ~900 |

---

## 🔧 Tech Stack

| Tool | Purpose |
|------|---------|
| **Google BigQuery** | Data storage, cleaning, analysis |
| **SQL (BigQuery dialect)** | All transformations, window functions, RFM scoring |
| **Looker Studio** | 3-page interactive dashboard |
| **Google Cloud Platform** | Cloud infrastructure |
| **Python (pandas, numpy)** | Dataset generation |

---

## 📁 Project Structure

```
silent-exit/
│
├── README.md
│
├── sql/
│   ├── 01_data_exploration.sql
│   ├── 02_data_cleaning.sql
│   ├── 03_analysis.sql
│   └── 04_views.sql
│
├── docs/
│   ├── data_dictionary.md
│   └── key_findings.md
│
└── dashboard/
    ├── page1_executive_overview.png
    ├── page2_customer_behavior.png
    └── page3_revenue_risk.png
```

---

## 🧹 Data Cleaning Highlights

All cleaning done using `CREATE OR REPLACE TABLE` in BigQuery.  
Raw data is **never modified** — cleaning creates a separate `clean_customers` table.

| Column | Issue Found | Fix Applied |
|--------|-------------|-------------|
| `email` | Nulls, missing @, junk values | CASE + LIKE + IN checks |
| `phone` | Mixed formats (+91-XXXXX), short numbers | REGEXP_REPLACE + RIGHT(10) |
| `gender` | M/F/0/1/male/MALE formats | UPPER + CASE standardization |
| `age` | Impossible values (0, -1, 150, 999) | NULL out invalid range |
| `membership_tier` | Typos: Sivler, G0ld, Platinium | LOWER + IN list matching |
| `total_spent_inr` | Negatives, zero with orders | ABS() for negatives, NULL for zeros |
| `avg_order_value_inr` | Missing but calculable | Recalculate from spent ÷ orders |
| `total_returns` | Returns > Orders (impossible) | Cap at total_orders |
| `avg_product_rating` | Values outside 1–5 range | NULL out invalid |
| `duplicates` | ~1,575 duplicate records | ROW_NUMBER() + QUALIFY |

---

## 📈 Analysis Layers

### Layer 1 — Overall KPIs
Total customers, churn rate, active vs churned revenue, avg orders, sessions

### Layer 2 — Recency Analysis
Churn rate by recency bucket (0–30, 31–90, 91–180, 181–365, 365+ days)  
Monthly churn trend from Jan 2021 to Jun 2024

### Layer 3 — Segment Analysis
Churn breakdown by: Membership Tier · Gender · Age Group · Acquisition Channel · Device · Payment Method · Category

### Layer 4 — Revenue Impact
Historical revenue from churned customers · Potential next-order revenue lost · Annual revenue at risk by segment

### Layer 5 — RFM + Churn Risk Scoring (No ML)
- **R** (Recency): Days since last purchase → NTILE(5) score 1–5
- **F** (Frequency): Total orders → NTILE(5) score 1–5
- **M** (Monetary): Total spend → NTILE(5) score 1–5
- **Risk Score:** Rule-based 0–100 using recency + orders + spend + membership + complaints
- **Segments:** Champions · Loyal Customers · At Risk · About to Churn · Lost

---

## 🚨 Churn Risk Score Logic

| Factor | Condition | Points |
|--------|-----------|--------|
| Recency | days_since > 365 | +40 |
| Recency | days_since > 180 | +25 |
| Recency | days_since > 90 | +12 |
| Orders | total_orders ≤ 2 | +20 |
| Orders | total_orders ≤ 5 | +10 |
| Membership | None | +15 |
| Membership | Silver | +8 |
| Membership | Gold | +3 |
| Membership | Platinum | +0 |
| Spend | total_spent < ₹500 | +15 |
| Spend | total_spent < ₹2,000 | +8 |
| Complaints | Any complaint | +10 |
| **Max Score** | | **100** |

**Risk Tiers:**
- 🔴 High Risk: Score ≥ 70
- 🟡 Medium Risk: Score 40–69
- 🟢 Low Risk: Score < 40

---

## 💡 Business Recommendations

| Priority | Action | Impact |
|----------|--------|--------|
| 🔴 P1 | Contact 9,069 High Risk customers immediately | ₹9.84M saved |
| 🔴 P1 | Re-engagement campaign after 90 days inactivity | Reduce 54% churn |
| 🟡 P2 | Push Silver upgrades to None-tier customers | Reduce 53% → 23% churn |
| 🟡 P2 | Exit surveys for churned customers | Identify root causes |
| 🟢 P3 | Monthly churn monitoring dashboard | Early warning system |

---

## 💼 Resume Description

> **Silent Exit — E-Commerce Customer Churn Analysis** | BigQuery · SQL · Looker Studio · GCP
> - Cleaned and analyzed **1,05,000 customer records**, resolving 15+ real-world data quality issues including invalid emails, impossible ages, negative spend, duplicates, and mixed-format fields
> - Built a **SQL-based RFM churn risk scoring model** (no ML) — identified 9,069 high-risk active customers representing **₹9.84M revenue at immediate risk**
> - Discovered customers inactive 365+ days churn at **54.48% vs 16.47%** for recent buyers
> - Quantified **₹543.6M revenue lost** to churn (28.1% of ₹1.92B total)
> - Delivered **3-page interactive Looker Studio dashboard** with geo map, risk scoring table, and segment-level filters

---

## 👤 Author
**[Your Name]**  
[LinkedIn](your-linkedin-url) · [Live Dashboard](https://datastudio.google.com/reporting/aaa25d00-0e9b-4db2-867e-b3bb14ed35dd)
