# 🔇 Silent Exit — E-Commerce Customer Churn Analysis

> *"Customers don't always say goodbye. They just stop showing up."*

**Tools:** BigQuery · SQL · Looker Studio · Google Cloud Platform  
**Dataset:** 1,05,000 rows · 34 columns · Jan 2021 – Jun 2024

---

## 📊 Live Dashboard
🔗 **[View Interactive Dashboard](https://datastudio.google.com/reporting/aaa25d00-0e9b-4db2-867e-b3bb14ed35dd)**

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
![Executive Overview](dashboard/Page_1.jpeg)

### Page 2 — Customer Behavioral Analysis
![Customer Behavior](dashboard/Page_2.jpeg)

### Page 3 — Revenue & Risk Analysis
![Revenue Risk](dashboard/Page_3.jpeg)

### Page 4 — Customer Profile Deepdive
![Customer Profile](dashboard/Page_4.png)

---

## 🔑 Key Findings

| # | Finding | Value |
|---|---------|-------|
| 1 | Overall churn rate | **33.3%** |
| 2 | Total customers | **89,075** |
| 3 | Churned customers | **29,664** |
| 4 | Active customers | **59,411** |
| 5 | Total revenue | **₹2.0 Billion** |
| 6 | Revenue lost to churn | **₹475.2M (24.4%)** |
| 7 | Active revenue retained | **75.6%** |
| 8 | None-tier churn rate | **48.41%** |
| 9 | Platinum churn rate | **20.37%** |
| 10 | 365+ day inactive churn | **52.31%** |
| 11 | 0-30 day active churn | **13.88%** |
| 12 | Monthly churn growth | **1 (Jan 2021) → 3,500+ (May 2024)** |
| 13 | High risk customers | **4,400** |
| 14 | Medium risk customers | **24,183** |
| 15 | Revenue at risk | **₹3.7M** |
| 16 | Avg risk score | **31.8** |
| 17 | Lost customers (RFM) | **2,611** |
| 18 | UPI payment share | **29.6%** (most used) |

---

## 🗂️ Dataset Overview

- **Source:** Synthetically generated realistic Indian e-commerce data
- **Size:** 1,05,000 rows · 34 columns
- **Period:** January 2021 – June 2024
- **Churn Rate:** 33.3%
- **Total Revenue:** ₹2.0 Billion

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
| **Looker Studio** | 4-page interactive dashboard |
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
│   ├── key_findings.md
│   └── project_flow.html
│
└── dashboard/
    ├── Page_1.jpeg
    ├── Page_2.jpeg
    ├── Page_3.jpeg
    └── Page_4.png
```

---

## 📊 Dashboard Pages

| Page | Title | Story |
|------|-------|-------|
| Page 1 | Executive Overview | What is our overall churn situation? |
| Page 2 | Customer Behavioral Analysis | Who churns and when? |
| Page 3 | Revenue & Risk Analysis | Where is money at risk? |
| Page 4 | Customer Profile Deepdive | Geographic and category patterns |

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
Total customers: 89,075 · Churn rate: 33.3% · Revenue lost: ₹475.2M

### Layer 2 — Recency Analysis
365+ days inactive → 52.31% churn vs 13.88% for 0-30 day customers

### Layer 3 — Segment Analysis
Membership · Gender · Age Group · Acquisition Channel · Device · Payment · Category

### Layer 4 — Revenue Impact
₹475.2M lost (24.4%) · ₹3.7M at immediate risk from high-risk active customers

### Layer 5 — RFM + Churn Risk Scoring (No ML)
- **R** (Recency): Days since last purchase → NTILE(5) score 1–5
- **F** (Frequency): Total orders → NTILE(5) score 1–5
- **M** (Monetary): Total spend → NTILE(5) score 1–5
- **Risk Score:** Rule-based 0–100
- **Segments:** Champions · Loyal Customers · At Risk · About to Churn · Lost

---

## 🚨 Risk Score Distribution

| Risk Tier | Customers | % of Base |
|-----------|-----------|-----------|
| 🟢 Low Risk | ~59,492 | 66.9% |
| 🟡 Medium Risk | 24,183 | 28% |
| 🔴 High Risk | 4,400 | 4.1% |

---

## 💡 Business Recommendations

| Priority | Action | Impact |
|----------|--------|--------|
| 🔴 P1 | Contact 4,400 High Risk customers immediately | ₹3.7M protected |
| 🔴 P1 | Re-engagement after 90 days inactivity | Reduce 52.31% churn |
| 🟡 P2 | Push Silver upgrades to None-tier (48.41% churn) | Bring closer to 20.37% |
| 🟡 P2 | Exit surveys for churned customers | Identify root causes |
| 🟢 P3 | Monthly churn monitoring | Early warning system |

---

## 💼 Resume Description

> **Silent Exit — E-Commerce Customer Churn Analysis** | BigQuery · SQL · Looker Studio · GCP
> - Cleaned and analyzed **1,05,000 customer records**, resolving 15+ real-world data quality issues
> - Built a **SQL-based RFM churn risk scoring model** (no ML) — identified 4,400 high-risk active customers representing **₹3.7M revenue at immediate risk**
> - Discovered customers inactive 365+ days churn at **52.31% vs 13.88%** for recent buyers
> - Quantified **₹475.2M revenue lost** to churn (24.4% of ₹2.0B total)
> - Delivered **4-page interactive Looker Studio dashboard** with geo map, risk table, RFM segments, and insight notes

---

## 👤 Author
**[Your Name]**  
[LinkedIn](your-linkedin-url) · [Live Dashboard](https://datastudio.google.com/reporting/aaa25d00-0e9b-4db2-867e-b3bb14ed35dd)
