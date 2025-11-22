--=======================================
--Checking silver.crm_cust_info
--=======================================

--Check the duplicate and null in primary key
--Expected Output: No result

	SELECT 
	cst_id,
	COUNT(*)
	FROM silver.crm_cust_info
	GROUP BY cst_id
	HAVING COUNT(*) > 1


--Check for unwanted Space
--Expected Output: no result

	SELECT
	cst_firstname
	--cst_lastname,
	--cst_key
	FROM silver.crm_cust_info
	--WHERE cst_firstname != TRIM(cst_firstname) OR cst_lastname != TRIM(cst_lastname) OR cst_key != TRIM(cst_key)
	where cst_firstname != TRIM(cst_firstname)

--Check for data Consistency
--Expected Output: If consistence go for Data Normalization(eg:- M change to Male, F to Female)  

	SELECT DISTINCT cst_gndr
	FROM silver.crm_cust_info



--=======================================
--Checking silver.crm_prd_info
--=======================================


--check for duplicate and null
SELECT 
prd_id,
COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

--check for unwanted space 
SELECT 
prd_key
FROM silver.crm_prd_info
WHERE prd_key != TRIM(prd_key)


--check for null
SELECT 
prd_cost
FROM silver.crm_prd_info
WHERE prd_cost IS NULL


--check for unwanted space
SELECT 
prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

SELECT DISTINCT
prd_line
FROM silver.crm_prd_info


--check for invalid date order
SELECT 
*
FROM silver.crm_prd_info
WHERE prd_start_dt > prd_end_dt



--=======================================
--Checking silver.crm_sales_deatils
--=======================================


--check unwanted space
SELECT 
sls_ord_num
FROM silver.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num)

--check null, zero, negetive
SELECT 
NULLIF(sls_order_dt,0),
sls_ship_dt,
sls_due_dt
FROM silver.crm_sales_details
WHERE sls_order_dt <= 0 OR sls_order_dt IS NULL OR LEN(sls_order_dt) != 8
OR sls_ship_dt <= 0 OR sls_ship_dt IS NULL  OR LEN(sls_ship_dt) != 8 
OR sls_due_dt <= 0 OR sls_due_dt IS NULL OR LEN(sls_due_dt) != 8 

--check for invalid date
SELECT
sls_order_dt,
sls_ship_dt,
sls_due_dt
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt

--check for bussiness logic
SELECT 
sls_quantity,
sls_price,
sls_sales
FROM silver.crm_sales_details
WHERE sls_quantity < = 0 OR sls_quantity IS NULL
OR sls_price < = 0 OR sls_quantity IS NULL
OR sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != sls_quantity*sls_price 
ORDER BY sls_sales,sls_price,sls_quantity

                   




--=======================================
--Checking silver.erp_cust_az12
--=======================================


--CHECK DUPLICATE OR NULL
SELECT 
cid,
COUNT(*)
FROM silver.erp_cust_az12
GROUP BY cid
HAVING COUNT(*) > 1 OR cid IS NULL

--CHECK FOR UNWANTED SPACE
SELECT 
cid
FROM silver.erp_cust_az12
WHERE cid != TRIM(cid)


--check data standarisation and consistency
SELECT DISTINCT
gen
FROM silver.erp_cust_az12

--check for bad data for date
SELECT
bdate
FROM silver.erp_cust_az12
WHERE bdate > GETDATE()



--=======================================
--Checking silver.erp_loc_a101
--=======================================


--Check for Duplicate and null value in cid

SELECT 
cid,
COUNT(*)
FROM silver.erp_loc_a101
GROUP BY cid
HAVING COUNT(*) > 1 OR cid IS NULL

--Check for data standardization and consistency

SELECT  DISTINCT 
cntry
FROM silver.erp_loc_a101
ORDER BY cntry;


--=======================================
--Checking silver.erp_px_cat_g1v2
--=======================================



--check for duplicate and null 
SELECT
id,
COUNT(*)
FROM silver.erp_px_cat_g1v2
GROUP BY id
HAVING COUNT(*) > 1 OR id IS NULL

--check for data standardization and consistency
SELECT DISTINCT
cat
FROM silver.erp_px_cat_g1v2


--check for unwanted space
SELECT 
cat
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat)

--check for data standardization and consistency
SELECT DISTINCT
subcat
FROM silver.erp_px_cat_g1v2
ORDER BY subcat

--check for unwanted space
SELECT 
subcat
FROM silver.erp_px_cat_g1v2
WHERE subcat != TRIM(subcat)


--check for data standardization and consistency
SELECT DISTINCT
maintenance
FROM silver.erp_px_cat_g1v2
ORDER BY maintenance
