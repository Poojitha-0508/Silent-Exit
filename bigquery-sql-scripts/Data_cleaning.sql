CREATE OR REPLACE TABLE `ecommerce-churn-analysis.ecom.clean_customers` AS 

SELECT 
  customer_id,
  first_name,
  FullName,
  email,
  Phone,
  Gender,
  Age,
  age_group,
  City,
  State,
  Pincode,
  Signup_date,
  membership_tier,
  acquisition_channel,
  preferred_device,
  preferred_os,
  preferred_payment,
  total_orders,
  total_spent_inr,
  Avg_order_value_inr,
  favorite_category,
  favorite_subcategory,
  last_purchase_date,
  days_since_last_purchase,
  recency_bucket,
  total_returns,
  return_reason,
  avg_rating,
  sessions_per_month,
  discount_usage_pct,
  coupons_used,
  total_complaints,
  churn,
  is_churned,
  churn_date,
  churn_reason
FROM(
SELECT 
    customer_id,
    first_name,
    last_name,
    CONCAT(first_name,' ',last_name) AS FullName,

    CASE
      WHEN email IS NULL OR email NOT LIKE '%@%' THEN NULL
      WHEN LOWER(TRIM(email)) LIKE 'null%' OR LOWER(TRIM(email)) LIKE 'test%' THEN NULL
      WHEN TRIM(LOWER(email)) IN ('n/a','na','null','none','-','test','') THEN NULL
      ELSE LOWER(TRIM(email))
    END AS email,

    CASE
      WHEN PHONE IS NULL THEN NULL
      WHEN LENGTH((CAST(PHONE AS STRING)))<10 THEN NULL
      WHEN CAST(PHONE AS STRING)='0000000000' THEN NULL
      ELSE RIGHT(CAST(PHONE AS STRING),10)
    END AS Phone,

    CASE 
      WHEN UPPER(TRIM(GENDER)) IN ('MALE','M','1') THEN 'Male'
      WHEN UPPER(TRIM(GENDER)) IN ('FEMALE','F','0') THEN 'Female'
      WHEN UPPER(TRIM(GENDER)) IN ('OTHER') THEN 'Others'
      ELSE 'Unknown'
    END AS Gender,

    CASE
      WHEN AGE IS NULL OR AGE<18 OR AGE>100 THEN NULL
      ELSE Age
    END AS Age,

    CASE
      WHEN CAST(age AS FLOAT64) BETWEEN 18 AND 25 THEN '18-25'
      WHEN CAST(age AS FLOAT64) BETWEEN 26 AND 35 THEN '26-35'
      WHEN CAST(age AS FLOAT64) BETWEEN 36 AND 45 THEN '36-45'
      WHEN CAST(age AS FLOAT64) BETWEEN 46 AND 55 THEN '46-55'
      WHEN CAST(age AS FLOAT64) BETWEEN 56 AND 90 THEN '56+'
      ELSE 'Unknown'
    END AS age_group,

    CONCAT(UPPER(LEFT(city,1)),LOWER(SUBSTRING(city,2,length(city)))) as City,

    CONCAT(UPPER(LEFT(state,1)),LOWER(SUBSTRING(state,2,length(state)))) as State,

    CASE
      WHEN pincode IS NULL OR CAST(pincode AS STRING)='000000' THEN NULL
      ELSE pincode
    END AS Pincode,

    CASE
      WHEN CURRENT_DATE()<CAST(SIGNUP_DATE AS DATE) THEN NULL
      ELSE CAST(SIGNUP_DATE AS DATE)
    END AS Signup_date,

    CASE
      WHEN UPPER(TRIM(membership_tier)) IN ('SILVER','SIVLER','SLIVER') THEN 'Silver'
      WHEN UPPER(TRIM(membership_tier)) IN ('GOLD','GOL','G0LD') THEN 'Gold'
      WHEN UPPER(TRIM(membership_tier)) IN ('PLATINUM','PLATINIUM','PLATNIUM') THEN 'Platinum'
      WHEN UPPER(TRIM(membership_tier)) IN ('NONE') THEN 'None'
      ELSE NULL
    END AS membership_tier,

    acquisition_channel,
    preferred_device,
    preferred_os,

    CASE
      WHEN LOWER(TRIM(preferred_payment)) IN ('upi')                    THEN 'UPI'
      WHEN LOWER(TRIM(preferred_payment)) IN ('credit card')            THEN 'Credit Card'
      WHEN LOWER(TRIM(preferred_payment)) IN ('debit card')             THEN 'Debit Card'
      WHEN LOWER(TRIM(preferred_payment)) IN ('cod','cash on delivery') THEN 'Cash on Delivery'
      WHEN LOWER(TRIM(preferred_payment)) IN ('net banking','net bank') THEN 'Net Banking'
      WHEN LOWER(TRIM(preferred_payment)) IN ('emi')                    THEN 'EMI'
      WHEN LOWER(TRIM(preferred_payment)) IN ('wallet')                 THEN 'Wallet'
      ELSE preferred_payment
    END AS preferred_payment,

    total_orders,

    CASE
      WHEN total_spent_inr IS NULL THEN NULL
      WHEN total_spent_inr < 0 THEN ABS(total_spent_inr)  
      WHEN total_spent_inr = 0 AND total_orders > 0 THEN NULL 
      ELSE total_spent_inr
    END AS total_spent_inr,

    CASE
      WHEN avg_order_value_inr IS NULL AND total_spent_inr > 0 AND total_orders > 0 THEN ROUND(ABS(total_spent_inr)/total_orders,2)
      ELSE avg_order_value_inr 
    END AS Avg_order_value_inr,

    favorite_category,
    favorite_subcategory,
    CAST(last_purchase_date AS DATE) AS last_purchase_date,
    CASE
      WHEN days_since_last_purchase < 0 THEN NULL
      ELSE days_since_last_purchase
    END AS days_since_last_purchase,

    CASE
      WHEN days_since_last_purchase BETWEEN 0 AND 30   THEN '0-30 days'
      WHEN days_since_last_purchase BETWEEN 31 AND 90  THEN '31-90 days'
      WHEN days_since_last_purchase BETWEEN 91 AND 180 THEN '91-180 days'
      WHEN days_since_last_purchase BETWEEN 181 AND 365 THEN '181-365 days'
      WHEN days_since_last_purchase > 365              THEN '365+ days'
      ELSE 'Unknown'
    END AS recency_bucket,

    CASE
      WHEN total_returns > total_orders THEN total_orders
      ELSE total_returns
    END AS total_returns,

    NULLIF(TRIM(return_reason),'') AS return_reason,

    CASE
      WHEN avg_product_rating IS NULL THEN NULL
      WHEN avg_product_rating < 1 OR avg_product_rating > 5 THEN NULL
      ELSE ROUND(avg_product_rating, 1)
    END AS avg_rating,

    sessions_per_month,
    discount_usage_pct,
    coupons_used,
    total_complaints,
    
    churn,
    CASE WHEN churn = TRUE THEN 1 ELSE 0 END AS is_churned,
    churn_date,
    NULLIF(TRIM(churn_reason),'') AS churn_reason,

    ROW_NUMBER() OVER(PARTITION BY first_name,last_name,COALESCE(LOWER(TRIM(email)), customer_id)) AS RANKED

FROM `ecommerce-churn-analysis.ecom.raw_customers`)
WHERE RANKED=1;