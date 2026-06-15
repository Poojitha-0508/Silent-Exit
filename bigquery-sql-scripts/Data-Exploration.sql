-- Basic Overview
SELECT
  COUNT(*) AS TotalRows,
  COUNT(customer_id) as TotalCustomers,
  MIN(signup_date) as minSignDate,
  MAX(signup_date) as maxSignDate,
  SUM(total_orders) as TotalOrdersReceived,
  COUNTIF(churn = TRUE) as churned,
  COUNTIF(churn = FALSE) as active
FROM ecommerce-churn-analysis.ecom.raw_customers;

-- Checking distinct values
SELECT DISTINCT state
FROM ecommerce-churn-analysis.ecom.raw_customers;

SELECT DISTINCT city
FROM ecommerce-churn-analysis.ecom.raw_customers;

SELECT DISTINCT gender
FROM ecommerce-churn-analysis.ecom.raw_customers;

SELECT DISTINCT membership_tier
FROM ecommerce-churn-analysis.ecom.raw_customers;

SELECT DISTINCT acquisition_channel
FROM ecommerce-churn-analysis.ecom.raw_customers;

SELECT DISTINCT preferred_device
FROM ecommerce-churn-analysis.ecom.raw_customers;

SELECT DISTINCT preferred_os
FROM ecommerce-churn-analysis.ecom.raw_customers;

SELECT DISTINCT preferred_payment
FROM ecommerce-churn-analysis.ecom.raw_customers;

SELECT DISTINCT favorite_category
FROM ecommerce-churn-analysis.ecom.raw_customers;

SELECT DISTINCT favorite_subcategory
FROM ecommerce-churn-analysis.ecom.raw_customers;

SELECT DISTINCT churn_reason
FROM ecommerce-churn-analysis.ecom.raw_customers;

SELECT DISTINCT return_reason
FROM ecommerce-churn-analysis.ecom.raw_customers;

SELECT DISTINCT is_duplicate_flag
FROM ecommerce-churn-analysis.ecom.raw_customers;

--Count NULLs
SELECT
  COUNTIF(email IS NULL OR TRIM(email)='')        AS null_emails,
  COUNTIF(phone IS NULL)                          AS null_phones,
  COUNTIF(gender IS NULL)                         AS null_genders,
  COUNTIF(age IS NULL)                            AS null_ages,
  COUNTIF(total_spent_inr IS NULL)                AS null_total_spent,
  COUNTIF(avg_order_value_inr IS NULL)            AS null_avg_order,
  COUNTIF(avg_product_rating IS NULL)             AS null_ratings,
  COUNTIF(pincode IS NULL)                        AS null_pincodes,
  COUNTIF(churn_date IS NULL)                     AS null_churn_dates
FROM ecommerce-churn-analysis.ecom.raw_customers;

-- Spot Invalid Values

-- Ages that are impossible
SELECT AGE,COUNT(*) AS count
FROM ecommerce-churn-analysis.ecom.raw_customers
WHERE AGE IS NOT NULL AND (CAST(AGE AS FLOAT64)<18 OR CAST(AGE AS FLOAT64)>100)
GROUP BY AGE
ORDER BY AGE DESC;

-- Ratings out of range
SELECT avg_product_rating,COUNT(*) AS count
FROM ecommerce-churn-analysis.ecom.raw_customers
WHERE avg_product_rating IS NOT NULL AND (CAST(avg_product_rating AS FLOAT64)<1 OR CAST(avg_product_rating AS FLOAT64)>5)
GROUP BY avg_product_rating
ORDER BY avg_product_rating DESC;

-- Negative spend
SELECT COUNT(*) AS negative_spend_records
FROM ecommerce-churn-analysis.ecom.raw_customers
WHERE total_spent_inr < 0;

-- Impossible returns
SELECT COUNT(*) AS Impossible_returns
FROM ecommerce-churn-analysis.ecom.raw_customers
WHERE total_orders<total_returns;

-- Impossible dates
SELECT COUNT(*) AS future_signups
FROM ecommerce-churn-analysis.ecom.raw_customers
WHERE signup_date>CURRENT_DATE('Asia/Kolkata');

-- invalid Discounts
SELECT COUNT(*) AS discount_usage_pct
FROM ecommerce-churn-analysis.ecom.raw_customers
WHERE discount_usage_pct >100;

-- Impossible churn dates
SELECT COUNT(*) AS future_signups
FROM ecommerce-churn-analysis.ecom.raw_customers
WHERE churn_date>CURRENT_DATE('Asia/Kolkata');

-- Days since purchase: check for negatives
SELECT COUNT(*) AS negative_days
FROM ecommerce-churn-analysis.ecom.raw_customers
WHERE days_since_last_purchase < 0;

-- Impossible: total_complaints check (should not be negative)
SELECT COUNT(*) AS negative_complaints
FROM ecommerce-churn-analysis.ecom.raw_customers
WHERE total_complaints < 0;

-- Churn = TRUE but churn_date is NULL (inconsistency)
SELECT COUNT(*) AS churned_but_no_date
FROM ecommerce-churn-analysis.ecom.raw_customers
WHERE churn = TRUE AND churn_date IS NULL;

-- Churn = FALSE but churn_date exists (inconsistency)
SELECT COUNT(*) AS active_but_has_churn_date
FROM ecommerce-churn-analysis.ecom.raw_customers
WHERE churn = FALSE AND churn_date IS NOT NULL;

-- Check sessions_per_month for 0 or negative
SELECT COUNT(*) AS zero_sessions
FROM ecommerce-churn-analysis.ecom.raw_customers
WHERE sessions_per_month <= 0;

-- SPOT MESSY CATEGORICAL VALUES

-- Gender: See unique values and their counts
SELECT gender, COUNT(*) AS count
FROM ecommerce-churn-analysis.ecom.raw_customers
GROUP BY gender
ORDER BY count DESC;

-- Membership tier: See unique values and their counts
SELECT membership_tier, COUNT(*) AS count
FROM ecommerce-churn-analysis.ecom.raw_customers
GROUP BY membership_tier
ORDER BY count DESC;

-- acquisition_channel: See unique values and their counts
SELECT acquisition_channel, COUNT(*) AS count
FROM ecommerce-churn-analysis.ecom.raw_customers
GROUP BY acquisition_channel
ORDER BY count DESC;

-- preferred_device: See unique values and their counts
SELECT preferred_device, COUNT(*) AS count
FROM ecommerce-churn-analysis.ecom.raw_customers
GROUP BY preferred_device
ORDER BY count DESC;

-- preferred_os: See unique values and their counts
SELECT preferred_os, COUNT(*) AS count
FROM ecommerce-churn-analysis.ecom.raw_customers
GROUP BY preferred_os
ORDER BY count DESC;

-- preferred_payment: See unique values and their counts
SELECT preferred_payment, COUNT(*) AS count
FROM ecommerce-churn-analysis.ecom.raw_customers
GROUP BY preferred_payment
ORDER BY count DESC;

-- favorite_category: See unique values and their counts
SELECT favorite_category, COUNT(*) AS count
FROM ecommerce-churn-analysis.ecom.raw_customers
GROUP BY favorite_category
ORDER BY count DESC;

-- favorite_subcategory: See unique values and their counts
SELECT favorite_subcategory, COUNT(*) AS count
FROM ecommerce-churn-analysis.ecom.raw_customers
GROUP BY favorite_subcategory
ORDER BY count DESC;

-- CHECK DUPLICATES

SELECT first_name, last_name, email, signup_date, COUNT(*) AS Appearences
FROM ecommerce-churn-analysis.ecom.raw_customers
WHERE email IS NOT NULL AND TRIM(email) NOT IN ('N/A','na','null','NULL','-','none','test')
GROUP BY first_name, last_name, email, signup_date
HAVING COUNT(*) > 1
ORDER BY Appearences DESC;