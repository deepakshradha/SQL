/*
===============================================================================
Customer Report
===============================================================================
Purpose:
      - This report consolidates key customer mertics and behaviours


Highlights:
      1. Gather essestial fields such a names,age and trasaction details.
      2. Segments customer into categories (VIP, Regular, New) and age groups.
      3. Aggregates customer- level metrics:
         - total orders
         - total sales
         - total quantity purchased
         - total products
         - lifespan ( in months)
      4. Calculate valuable KPIs:
         - recency ( months since last order)
         - average order value
         - average monthly spend

=================================================================================
*/

IF OBJECT_ID('gold.report_customer', 'V') IS NOT NULL 
DROP VIEW gold.report_customer;

GO 

CREATE VIEW gold.report_customer AS

WITH base_query AS (
-- 1. Base Query: Retrives core column from tables
SELECT 
f.sales_order_number,
f.product_key,
f.order_date,
f.sales AS sales_amount,
f.quantity,
c.customer_key AS customer_key,
c.customer_id AS customer_id,
CONCAT(c.first_name,' ', c.last_name) AS customer_name,
DATEDIFF(YEAR,c.birth_date, GETDATE()) AS age
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customer AS c 
ON c.customer_key = f.customer_key
WHERE f.order_date IS NOT NULL
)
, customer_aggregation AS (
-- Customer aggregations querry : summarize key metrics at the customer level

SELECT 
    customer_key,
    customer_id,
    customer_name,
    age,
    COUNT(DISTINCT(sales_order_number)) AS total_order,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT(product_key)) AS total_products,
    MAX(order_date) AS last_order_date,
    DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) AS lifespan
FROM base_query
GROUP BY 
    customer_key,
    customer_id,
    customer_name,
    age
) 
--3. Final Queryy: Combines all customer results into one output

SELECT
    customer_key,
    customer_id,
    customer_name,
    age,
    CASE
        WHEN age >= 60 THEN 'Senior citizen '
        WHEN age < 60 THEN  'Working Citizen'
        ELSE 'Adolesence or kid'
    END AS age_group,
    CASE 
        WHEN lifespan >= 12 AND  total_sales > = 5000 THEN 'VIP'
        WHEN lifespan >= 12 AND total_sales < 5000 THEN 'Regular'
    ELSE 'New Customer'
    END AS customer_segment,
    last_order_date,
    DATEDIFF(MONTH,last_order_date,GETDATE())AS recency,
    total_quantity,
    total_products,
    total_order,
    total_sales,
    lifespan,
    CASE
        WHEN total_sales = 0 THEN 0
        ELSE total_sales/total_order
    END AS avg_order_value,
    CASE 
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales/lifespan
    END AS avg_monthly_spends

    


FROM customer_aggregation
