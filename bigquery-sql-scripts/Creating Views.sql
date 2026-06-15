-- View 1: Summary KPIs
CREATE OR REPLACE VIEW `ecommerce-churn-analysis.ecom.v_kpi_summary` AS
SELECT 
  COUNT(*)                      AS TotalCustomers,
  COUNTIF(is_churned=1)          AS TotalChurned,
  COUNTIF(is_churned=0)          AS TotalActive,
  ROUND(COUNTIF(is_churned=1)*100.0/COUNT(*),2) AS ChurnRatePct,
  ROUND(SUM(total_spent_inr),2) AS TotalSpent,
  ROUND(AVG(total_spent_inr),2) AS AvgSpent,
  ROUND(AVG(total_orders),2) AS AvgOrders
FROM ecommerce-churn-analysis.ecom.clean_customers;

-- View 2: Segment breakdown
CREATE OR REPLACE VIEW `ecommerce-churn-analysis.ecom.v_segment_churn` AS
SELECT
  membership_tier, acquisition_channel, favorite_category,
  preferred_device, Gender, age_group, city,
  churn, is_churned, recency_bucket,
  total_spent_inr, total_orders, Avg_order_value_inr,
  sessions_per_month, discount_usage_pct, total_complaints
FROM `ecommerce-churn-analysis.ecom.clean_customers`;

-- View 3: Monthly Churn Trend
CREATE OR REPLACE VIEW `ecommerce-churn-analysis.ecom.v_churn_trend` AS
SELECT
  FORMAT_DATE('%Y-%m',churn_date) as churn_month,
  COUNT(*) AS churned_count,
  ROUND(SUM(total_spent_inr),2) AS RevenueLost,
  churn_reason
FROM `ecommerce-churn-analysis.ecom.clean_customers`
WHERE churn_date IS NOT NULL AND is_churned = 1
GROUP BY churn_month,churn_reason;

-- View 4: Risk scoring table
CREATE OR REPLACE VIEW `ecommerce-churn-analysis.ecom.v_risk_scores` AS
SELECT
  customer_id, FullName, membership_tier,
  favorite_category, city, recency_days,
  total_orders, total_spent_inr,
  r_score, f_score, m_score, Total_RFM_Score,
  customer_segment, risk_score,
  CASE
    WHEN risk_score >= 70 THEN 'High Risk'
    WHEN risk_score >= 40 THEN 'Medium Risk'
    ELSE 'Low Risk'
  END AS risk_tier,
  is_churned, churn_reason
FROM `ecommerce-churn-analysis.ecom.rfm_scores`;