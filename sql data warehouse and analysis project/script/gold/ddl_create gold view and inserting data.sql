/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================



*/

--==============================================
--Create Dimension Table: gold.dim_customer
--==============================================

IF OBJECT_ID('gold.dim_customer', 'V') IS NOT NULL
DROP VIEW gold.dim_customer;

GO

CREATE VIEW gold.dim_customer AS
SELECT
ROW_NUMBER() OVER(ORDER BY cst_id) AS customer_key,
ci.cst_id AS customer_number,
ci.cst_key AS customer_id,
ci.cst_firstname AS first_name,
ci.cst_lastname  AS last_name,
ci.cst_marital_status AS marriage_stauts,
CASE 
	WHEN ci.cst_gndr != 'N/A' THEN ci.cst_gndr
	ELSE COALESCE(ce.gen, 'n/a')
END AS gender,
la.cntry AS country,
ce.bdate AS birth_date,
ci.cst_createa_date AS create_date
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ce
ON ci.cst_key = ce.cid
LEFT JOIN silver.erp_loc_a101 AS la
ON ci.cst_key = la.cid;

GO


--============================================
--Create Dimension Table: gold.dim_product
--============================================
IF OBJECT_ID('gold.dim_product' , 'V') IS NOT NULL
DROP VIEW gold.dim_product;

GO

CREATE VIEW gold.dim_product AS
SELECT 
ROW_NUMBER() OVER( ORDER BY prd_id) AS product_key,
cp.prd_id AS product_number,
cp.prd_key AS product_id,
cp.prd_nm As product_name,
cp.prd_cat_id AS product_category_id,
ep.cat AS product_category,
ep.subcat AS product_subcategory,
cp.prd_cost AS product_cost,
cp.prd_line AS product_line, 
cp.prd_start_dt AS productio_start_date,
ep.maintenance
FROM silver.crm_prd_info AS cp
LEFT JOIN silver.erp_px_cat_g1v2 AS  ep
ON cp.prd_cat_id = ep.id
WHERE prd_end_dt IS NULL;
GO



--======================================
--Create Fact Table: gold.fact_sales
--======================================
IF OBJECT_ID('gold.fact_sales','V') IS NOT NULL
DROP VIEW gold.fact_sales;

GO
CREATE VIEW gold.fact_sales AS
SELECT 
sd.sls_ord_num AS sales_order_number,
dp.product_key ,
dc.customer_key,
sd.sls_order_dt AS order_date,
sd.sls_ship_dt AS ship_date,
sd.sls_due_dt AS due_date,
sd.sls_sales AS sales,
sd.sls_quantity AS quantity,
sd.sls_price AS price
FROM silver.crm_sales_details AS sd
LEFT JOIN gold.dim_product AS dp
ON sd.sls_prd_key = dp.product_id
LEFT JOIN gold.dim_customer AS dc
ON sd.sls_cus_key = dc.customer_number;

GO

