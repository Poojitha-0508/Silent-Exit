-- LAYER1 - OVERALL CHURN KPIs
SELECT 
  COUNT(*)                      AS TotalCustomers,
  COUNTIF(is_churned=1)          AS TotalChurned,
  COUNTIF(is_churned=0)          AS TotalActive,
  ROUND(COUNTIF(is_churned=1)*100.0/COUNT(*),2) AS ChurnRatePct,
  ROUND(AVG(total_spent_inr),2) AS AvgSpent,
  ROUND(SUM(CASE WHEN is_churned=1 THEN total_spent_inr ELSE 0 END),2) AS ChurnedRevenue,
  ROUND(SUM(CASE WHEN is_churned=0 THEN total_spent_inr ELSE 0 END),2) AS ActiveRevenue,
  ROUND(AVG(total_orders),2) AS AvgOrders,
  ROUND(AVG(sessions_per_month),2) AS AvgSessionsPerMonth
FROM ecommerce-churn-analysis.ecom.clean_customers;

-- LAYER2 - RECENCY ANALYSIS

--Churn by recently shopped
SELECT
  recency_bucket,
  COUNT(*) AS customers,
  COUNTIF(is_churned=1) as churned,
  COUNTIF(is_churned=0) as active,
  ROUND(COUNTIF(is_churned=1)*100.0/COUNT(*),2) AS ChurnRatePct,
  ROUND(AVG(total_spent_inr),2) AS AvgSpent,
  ROUND(AVG(total_orders),2) AS AvgOrders,
  ROUND(AVG(sessions_per_month),2) AS AvgSessionsPerMonth
FROM ecommerce-churn-analysis.ecom.clean_customers
GROUP BY recency_bucket
ORDER BY
  CASE recency_bucket
    WHEN '0-30 days'    THEN 1
    WHEN '31-90 days'   THEN 2
    WHEN '91-180 days'  THEN 3
    WHEN '181-365 days' THEN 4
    WHEN '365+ days'    THEN 5
    ELSE 6
  END;

-- monthly churn trend
SELECT
  FORMAT_DATE('%Y-%m',churn_date) as churn_month,
  COUNT(*) AS customers,
  ROUND(AVG(total_spent_inr),2) AS AvgSpent,
  ROUND(AVG(total_orders),2) AS AvgOrders,
  ROUND(AVG(sessions_per_month),2) AS AvgSessionsPerMonth
FROM ecommerce-churn-analysis.ecom.clean_customers
WHERE churn_date IS NOT NULL AND is_churned=1
GROUP BY churn_month
ORDER BY churn_month;


-- LAYER 3 - SEGMENT ANALYSIS

-- churn by MemberShip tier
SELECT
  membership_tier,
  COUNT(*)                      AS TotalCustomers,
  COUNTIF(is_churned=1)          AS TotalChurned,
  ROUND(COUNTIF(is_churned=1)*100.0/COUNT(*),2) AS ChurnRatePct,
  ROUND(SUM(CASE WHEN is_churned=1 THEN total_spent_inr ELSE 0 END),2) AS ChurnedRevenue,
  ROUND(AVG(total_spent_inr),2) AS avgSpent,
  ROUND(AVG(total_orders),2) AS AvgOrders,
  ROUND(AVG(sessions_per_month),2) AS AvgSessionsPerMonth
FROM ecommerce-churn-analysis.ecom.clean_customers
GROUP BY membership_tier
ORDER BY ChurnRatePct DESC;

-- churn by Gender
SELECT
  Gender,
  COUNT(*)                      AS TotalCustomers,
  COUNTIF(is_churned=1)          AS TotalChurned,
  ROUND(COUNTIF(is_churned=1)*100.0/COUNT(*),2) AS ChurnRatePct,
  ROUND(SUM(CASE WHEN is_churned=1 THEN total_spent_inr ELSE 0 END),2) AS ChurnedRevenue,
  ROUND(AVG(total_spent_inr),2) AS avgSpent,
  ROUND(AVG(total_orders),2) AS AvgOrders,
  ROUND(AVG(sessions_per_month),2) AS AvgSessionsPerMonth
FROM ecommerce-churn-analysis.ecom.clean_customers
GROUP BY Gender
ORDER BY ChurnRatePct DESC;

-- churn by age_group
SELECT
  age_group,
  COUNT(*)                      AS TotalCustomers,
  COUNTIF(is_churned=1)          AS TotalChurned,
  ROUND(COUNTIF(is_churned=1)*100.0/COUNT(*),2) AS ChurnRatePct,
  ROUND(SUM(CASE WHEN is_churned=1 THEN total_spent_inr ELSE 0 END),2) AS ChurnedRevenue,
  ROUND(AVG(total_spent_inr),2) AS avgSpent,
  ROUND(AVG(total_orders),2) AS AvgOrders,
  ROUND(AVG(sessions_per_month),2) AS AvgSessionsPerMonth
FROM ecommerce-churn-analysis.ecom.clean_customers
GROUP BY age_group
ORDER BY ChurnRatePct DESC;

-- churn by acquisition_channel
SELECT
  acquisition_channel,
  COUNT(*)                      AS TotalCustomers,
  COUNTIF(is_churned=1)          AS TotalChurned,
  ROUND(COUNTIF(is_churned=1)*100.0/COUNT(*),2) AS ChurnRatePct,
  ROUND(SUM(CASE WHEN is_churned=1 THEN total_spent_inr ELSE 0 END),2) AS ChurnedRevenue,
  ROUND(AVG(total_spent_inr),2) AS avgSpent,
  ROUND(AVG(total_orders),2) AS AvgOrders,
  ROUND(AVG(sessions_per_month),2) AS AvgSessionsPerMonth
FROM ecommerce-churn-analysis.ecom.clean_customers
GROUP BY acquisition_channel
ORDER BY ChurnRatePct DESC;

-- churn by preferred_device
SELECT
  preferred_device,
  COUNT(*)                      AS TotalCustomers,
  COUNTIF(is_churned=1)          AS TotalChurned,
  ROUND(COUNTIF(is_churned=1)*100.0/COUNT(*),2) AS ChurnRatePct,
  ROUND(SUM(CASE WHEN is_churned=1 THEN total_spent_inr ELSE 0 END),2) AS ChurnedRevenue,
  ROUND(AVG(total_spent_inr),2) AS avgSpent,
  ROUND(AVG(total_orders),2) AS AvgOrders,
  ROUND(AVG(sessions_per_month),2) AS AvgSessionsPerMonth
FROM ecommerce-churn-analysis.ecom.clean_customers
GROUP BY preferred_device
ORDER BY ChurnRatePct DESC;

-- churn by preferred_os
SELECT
  preferred_os,
  COUNT(*)                      AS TotalCustomers,
  COUNTIF(is_churned=1)          AS TotalChurned,
  ROUND(COUNTIF(is_churned=1)*100.0/COUNT(*),2) AS ChurnRatePct,
  ROUND(SUM(CASE WHEN is_churned=1 THEN total_spent_inr ELSE 0 END),2) AS ChurnedRevenue,
  ROUND(AVG(total_spent_inr),2) AS avgSpent,
  ROUND(AVG(total_orders),2) AS AvgOrders,
  ROUND(AVG(sessions_per_month),2) AS AvgSessionsPerMonth
FROM ecommerce-churn-analysis.ecom.clean_customers
GROUP BY preferred_os
ORDER BY ChurnRatePct DESC;

-- churn by preferred_payment
SELECT
  preferred_payment,
  COUNT(*)                      AS TotalCustomers,
  COUNTIF(is_churned=1)          AS TotalChurned,
  ROUND(COUNTIF(is_churned=1)*100.0/COUNT(*),2) AS ChurnRatePct,
  ROUND(SUM(CASE WHEN is_churned=1 THEN total_spent_inr ELSE 0 END),2) AS ChurnedRevenue,
  ROUND(AVG(total_spent_inr),2) AS avgSpent,
  ROUND(AVG(total_orders),2) AS AvgOrders,
  ROUND(AVG(sessions_per_month),2) AS AvgSessionsPerMonth
FROM ecommerce-churn-analysis.ecom.clean_customers
GROUP BY preferred_payment
ORDER BY ChurnRatePct DESC;

-- churn by favorite_category
SELECT
  favorite_category,
  COUNT(*)                      AS TotalCustomers,
  COUNTIF(is_churned=1)          AS TotalChurned,
  ROUND(COUNTIF(is_churned=1)*100.0/COUNT(*),2) AS ChurnRatePct,
  ROUND(SUM(CASE WHEN is_churned=1 THEN total_spent_inr ELSE 0 END),2) AS ChurnedRevenue,
  ROUND(AVG(total_spent_inr),2) AS avgSpent,
  ROUND(AVG(total_orders),2) AS AvgOrders,
  ROUND(AVG(sessions_per_month),2) AS AvgSessionsPerMonth
FROM ecommerce-churn-analysis.ecom.clean_customers
GROUP BY favorite_category
ORDER BY ChurnRatePct DESC;

-- churn by favorite_subcategory
SELECT
  favorite_subcategory,
  COUNT(*)                      AS TotalCustomers,
  COUNTIF(is_churned=1)          AS TotalChurned,
  ROUND(COUNTIF(is_churned=1)*100.0/COUNT(*),2) AS ChurnRatePct,
  ROUND(SUM(CASE WHEN is_churned=1 THEN total_spent_inr ELSE 0 END),2) AS ChurnedRevenue,
  ROUND(AVG(total_spent_inr),2) AS avgSpent,
  ROUND(AVG(total_orders),2) AS AvgOrders,
  ROUND(AVG(sessions_per_month),2) AS AvgSessionsPerMonth
FROM ecommerce-churn-analysis.ecom.clean_customers
GROUP BY favorite_subcategory
ORDER BY ChurnRatePct DESC;

-- LAYER4 - REVENUE IMPACT

SELECT
  ROUND(SUM(CASE WHEN is_churned=1 THEN total_spent_inr ELSE 0 END),2) AS historical_Revenue_from_churned,
  ROUND(SUM(CASE WHEN is_churned=1 THEN Avg_order_value_inr ELSE 0 END),2) AS potential_next_order_revenue_lost,
  ROUND(AVG(CASE WHEN is_churned=1 THEN total_spent_inr END),2) AS AvgRevenuePerChurnedCustomer,
  ROUND(SUM(CASE WHEN is_churned=0 THEN total_spent_inr END),2) AS AvgRevenuePerActiveCustomer
FROM ecommerce-churn-analysis.ecom.clean_customers;

SELECT
  membership_tier,
  favorite_category,
  COUNTIF(is_churned=1) as ChurnedCustomers,
  ROUND(SUM(CASE WHEN is_churned=1 THEN Avg_order_value_inr ELSE 0 END),2) AS Monthly_revune_at_risk,
  ROUND(SUM(CASE WHEN is_churned=1 THEN Avg_order_value_inr ELSE 0 END)*12,2) AS Annual_revune_at_risk
FROM ecommerce-churn-analysis.ecom.clean_customers
GROUP BY membership_tier,favorite_category
ORDER BY Annual_revune_at_risk DESC;

-- LAYER5 - RFM + CHURN RISK SCORING 

CREATE OR REPLACE VIEW ecommerce-churn-analysis.ecom.rfm_scores AS

WITH rfm_raw AS(
SELECT
  customer_id,
  FullName,
  membership_tier,
  favorite_category,
  city,
  total_complaints,
  is_churned,
  churn_reason,
  Avg_order_value_inr,

  days_since_last_purchase as recency_days,
  NTILE(5) OVER(ORDER BY days_since_last_purchase DESC) AS r_score,

  total_orders,
  NTILE(5) OVER(ORDER BY total_orders) AS f_score,

  total_spent_inr,
  NTILE(5) OVER(ORDER BY total_spent_inr) AS m_score

FROM ecommerce-churn-analysis.ecom.clean_customers
WHERE days_since_last_purchase IS NOT NULL AND total_orders IS NOT NULL AND total_spent_inr IS NOT NULL
)

SELECT 
  *,
  (r_score+f_score+m_score) as Total_RFM_Score,

  CASE
    WHEN r_score+f_score+m_score>=13 THEN 'Champions'
    WHEN r_score+f_score+m_score>=10 THEN 'Loyal Customers'
    WHEN r_score+f_score+m_score>=7 THEN 'At Risk'
    WHEN r_score+f_score+m_score>=4 THEN 'About to churn'
    ELSE 'Lost'
  END AS customer_segment,
  (
  CASE
    WHEN recency_days>365 THEN 30
    WHEN recency_days>180 THEN 15
    WHEN recency_days>90 THEN 9
    ELSE 0
  END
  +
  CASE
    WHEN total_orders<=2 THEN 20
    WHEN total_orders<=5 THEN 10
    ELSE 0
  END
  +
  CASE
    WHEN total_spent_inr<500 THEN 15
    WHEN total_spent_inr<2000 THEN 8
    ELSE 0
  END
  +
  CASE
    WHEN membership_tier='None' THEN 15
    WHEN membership_tier='Silver' THEN 8
    WHEN membership_tier='Gold' THEN 3
    ELSE 0
  END
  +
  10*LEAST(1,total_complaints)
  ) AS risk_score
FROM rfm_raw;


-- Step 2: Summarise risk tiers
SELECT
  CASE
    WHEN risk_score>=70 THEN '🔴 High Risk'
    WHEN risk_score>=40 THEN '🟡 Medium Risk'
    ELSE '🟢 Low Risk'
  END AS risk_tier,
  COUNT(*)                      AS TotalCustomers,
  COUNTIF(is_churned=1)          AS TotalChurned,
  ROUND(COUNTIF(is_churned=1)*100.0/COUNT(*),2) AS ChurnRatePct,
  ROUND(AVG(total_spent_inr),2) AS avgSpent
FROM ecommerce-churn-analysis.ecom.rfm_scores
GROUP BY risk_tier
ORDER BY ChurnRatePct DESC;