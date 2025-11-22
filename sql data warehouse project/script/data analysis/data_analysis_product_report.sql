/*
===============================================================================
Product Report
===============================================================================
Purpose:
      - This report consolidates key product mertics and behaviours


Highlights:
      1. Gather essestial fields such a product names, category, subcategory, and cost.
      2. Segments product by revenue to identify High-Performance, Mid-Range, or Low-Performers.
      3. Aggregates product - level metrics:
         - total orders
         - total sales
         - total quantity sold
         - total consumer(unique)
         - lifespan ( in months)
      4. Calculate valuable KPIs:
         - recency ( months since last sales)
         - average order revenue(AOR)
         - average monthly revenue

=================================================================================
*/
IF OBJECT_ID('gold.report_product', 'V') IS NOT NULL 
DROP VIEW gold.report_product;

GO 

CREATE VIEW gold.report_product AS

WITH base_querry AS(
-- 1. Base Querry: Retrive core column from table
SELECT  
f.sales_order_number,
f.customer_key,
p.product_id,
f.product_key,
p.product_name,
p.product_category,
p.product_subcategory,
p.product_cost,
f.price,
f.sales AS sales_amount,
f.quantity,
f.order_date

FROM gold.fact_sales AS f
LEFT JOIN gold.dim_product AS p
ON f.product_key = p.product_key
WHERE f.order_date IS NOT NULL
),
aggregation_query AS(
-- Product aggregations querry : summarize key metrics at the product level

SELECT 
product_key,
product_id,
product_name,
product_category,
product_subcategory,
COUNT(DISTINCT(sales_order_number)) AS total_order,
SUM(sales_amount) AS revenue,
SUM(quantity) AS total_quatity_sold,
price,
COUNT(DISTINCT(customer_key)) AS total_consumer,
DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) AS life_span_in_months,
DATEDIFF(MONTH,MAX(order_date),GETDATE()) AS recency_in_days
FROM base_querry
GROUP BY
    product_id,
    product_key,
    product_name,
    product_category,
    product_subcategory,
    price
)

--3. Final Queryy: Combines all product results into one output

SELECT 
product_key,
product_id,
product_name,
product_category,
product_subcategory,
total_order,
total_quatity_sold,
revenue,
CASE
    WHEN revenue > 50000 THEN 'High-Performer'
    WHEN revenue >= 10000  THEN 'Mid-Performer'
    ELSE 'Low-Performer'
End AS product_segment,
total_consumer,
life_span_in_months,
recency_in_days,
CASE
    WHEN revenue =0 THEN 0
    ELSE revenue/total_order
End AS average_order_revenue,
CASE 
    WHEN life_span_in_months = 0 THEN revenue
    ELSE revenue/life_span_in_months
END AS average_monthly_revenue
FROM aggregation_query