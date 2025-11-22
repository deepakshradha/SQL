/*
=====================================================
Stored Procedured : Load Silver Layer (Bronze >> Silver)
=====================================================

Script Purpose : 
     This stored procedure load data into the silver schema from bronze schema,.
	 It perform the following action:
	 - Truncate the silver layer table before loading data.
	 - Uses the 'INSERT INTO' command to load data from bronze table.

Parameters:
     None.
	 This stored procedure does not accept any parameter or return values.

Uses Example:

   EXEC silver.load_silver;

*/


CREATE OR ALTER PROCEDURE silver.load_silver AS 
BEGIN
    DECLARE @start_time DATETIME , @end_time DATETIME , @procedure_start_time DATETIME , @procedure_end_time DATETIME
	BEGIN TRY
	        SET @procedure_start_time = GETDATE();
			PRINT'====================================================';
			PRINT'>> Loading Silver Layer';
			PRINT'====================================================';


			PRINT '------------------------------------------------';
			PRINT 'Loding CRM table ';
			PRINT '------------------------------------------------';

			SET @start_time = GETDATE();
			PRINT '>> Truncating Table : silver.crm_cust_info';
			TRUNCATE TABLE silver.crm_cust_info;
			PRINT '>> Inserting Data into : silver.crm_cust_info'

			--Inserting data into silver cus info
			INSERT INTO silver.crm_cust_info(
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_createa_date
			)
			---------------------------------------------------
			--Cleaning data for silver layer

			SELECT 
			cst_id,
			cst_key,
			--Remove unwanted space
			TRIM(cst_firstname) AS cst_firstname,
			TRIM(cst_lastname) AS cst_lastname,

			--Normalized maritaial status
			CASE
				WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
				WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
				ELSE 'N/A'
			END AS cst_maritial_status,

			--Normalized gender status
			CASE
				WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
				WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
				ELSE 'N/A'
			END AS cst_gndr,
			cst_createa_date

			--Remove the Duplicte and Null prom primary key
			FROM(
					SELECT 
					* ,
					ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_createa_date DESC) AS flag_last
					FROM bronze.crm_cust_info
				)t WHERE flag_last = 1 AND cst_id  IS NOT NULL


			SET @end_time = GETDATE();
			PRINT '>>Loading time : ' + CAST(DATEDIFF(second,@start_time , @end_time) AS NVARCHAR) + 'Seconds'  ;
			PRINT'---------------------------------------------------------------------';

			SET @start_time = GETDATE();
			PRINT '>> Truncating Table : silver.crm_prd_info';
			TRUNCATE TABLE silver.crm_prd_info;
			PRINT '>> Inserting Data into : silver.crm_prd_info'
			/*
			This script is used because one new table called prd_cat_id is created.

			IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
			   DROP TABLE silver.crm_prd_info;

			CREATE TABLE silver.crm_prd_info(
			prd_id INT,
			prd_cat_id NVARCHAR(50),
			prd_key NVARCHAR(50),
			prd_nm NVARCHAR(50),
			prd_cost INT,
			prd_line NVARCHAR(50),
			prd_start_dt DATE,
			prd_end_dt DATE,
			dwh_create_date DATETIME2 DEFAULT GETDATE()
			);*/

			---------------------------------------------------------------------------------

			--Inserting data into Silver layer

			INSERT INTO silver.crm_prd_info(
			prd_id,
			prd_cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
			)
			-----------------------------------------------------------------------------------
			--Cleaning the Data for silver layer

			SELECT 
			prd_id,
			REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS prd_cat_id,
			SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key,
			prd_nm,
			COALESCE(prd_cost,0) AS prd_cost,
			CASE 
				WHEN prd_line = 'M' THEN 'Mountain'
				WHEN prd_line = 'R' THEN 'Road'
				WHEN prd_line = 'S' THEN 'Others'
				WHEN prd_line = 'T' THEN 'Tourist'
				ELSE 'N/A'
			END AS prd_line,
			prd_start_dt,
			DATEADD(DAY,-1,LEAD(prd_start_dt) OVER ( PARTITION BY prd_key ORDER BY prd_start_dt ASC)) AS prd_end_dt

			FROM bronze.crm_prd_info

			SET @end_time = GETDATE();
			PRINT '>>Loading time : ' + CAST(DATEDIFF(second,@start_time , @end_time) AS NVARCHAR) + 'Seconds'  ;
			PRINT'---------------------------------------------------------------------';

			SET @start_time = GETDATE();
			PRINT '>> Truncating Table : silver.crm_sales_details';
			TRUNCATE TABLE silver.crm_sales_details;
			PRINT '>> Inserting Data into : silver.crm_sales_details'
			/*This script is used because  data type of order,ship,due date is change from int to DATE

			IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
			   DROP TABLE silver.crm_sales_details;


			CREATE TABLE silver.crm_sales_details(
			sls_ord_num	NVARCHAR(50),
			sls_prd_key NVARCHAR(50) ,
			sls_cus_key INT,
			sls_order_dt DATE,
			sls_ship_dt DATE,
			sls_due_dt DATE,
			sls_sales INT,
			sls_quantity INT,
			sls_price INT,
			dwh_create_date DATETIME2 DEFAULT GETDATE()
			);
			*/
			----------------------------------------------------------------------

			--Inserting data into silver layer

			INSERT INTO silver.crm_sales_details(
			sls_ord_num,
			sls_prd_key,
			sls_cus_key,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price
			)
			--------------------------------------------------------------------

			--Cleaning data for silver layer
			SELECT 
			sls_ord_num,
			sls_prd_key,
			sls_cus_key,
			CASE
				WHEN sls_order_dt <= 0 OR LEN(sls_order_dt) != 8 THEN NULL
				ELSE CAST(CAST(sls_order_dt AS varchar) AS DATE)
			END AS sls_order_dt,
			CASE
				WHEN sls_ship_dt <= 0 OR LEN(sls_ship_dt) != 8 THEN NULL
				ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE) 
			END AS sls_ship_date,
			CASE
				WHEN sls_due_dt <= 0 OR LEN(sls_due_dt) != 8 THEN NULL
				ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE) 
			END AS sls_due_date,
			CASE
				WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != sls_quantity*ABS(sls_price) THEN sls_quantity*ABS(sls_price)
				ELSE sls_sales
			END AS sls_sales,
			sls_quantity,
			CASE 
				WHEN sls_price < = 0 OR sls_price IS NULL THEN sls_sales/ NULLIF(sls_quantity,0)
				ELSE sls_price
			END AS sls_price
			FROM bronze.crm_sales_details
			SET @end_time = GETDATE();
			PRINT '>>Loading time : ' + CAST(DATEDIFF(second,@start_time , @end_time) AS NVARCHAR) + 'Seconds'  ;
			PRINT'---------------------------------------------------------------------';

			PRINT '------------------------------------------------';
			PRINT 'Loding ERP table ';
			PRINT '------------------------------------------------';


			SET @start_time = GETDATE();
			PRINT '>> Truncating Table : silver.erp_cust_az12';
			TRUNCATE TABLE silver.erp_cust_az12;
			PRINT '>> Inserting Data into : silver.erp_cust_az12'
			--Insert data into silver erp cust

			INSERT INTO silver.erp_cust_az12(
			cid,
			bdate,
			gen
			)
			----------------------------------------------------------
			--Cleaning data for Silver layer

			SELECT
			CASE
				WHEN LEN(cid) != 10 THEN SUBSTRING(cid,4,LEN(cid))
				ELSE cid
			END AS cid,
			CASE 
			WHEN bdate > GETDATE() THEN NULL
			ELSE bdate
			END AS bdate,
			CASE
				WHEN UPPER(TRIM(gen)) IN ('F' , 'Female') THEN 'Female'
				WHEN UPPER(TRIM(gen)) IN ('M', 'Male') THEN 'Male'
				WHEN gen = NULL THEN 'n/a'
				ELSE 'n/a'
			END AS gen
			FROM bronze.erp_cust_az12

			SET @end_time = GETDATE();
			PRINT '>>Loading time : ' + CAST(DATEDIFF(second,@start_time , @end_time) AS NVARCHAR) + 'Seconds'  ;
			PRINT'---------------------------------------------------------------------';

			SET @start_time = GETDATE();
			PRINT '>> Truncating Table : silver.erp_loc_a101';
			TRUNCATE TABLE silver.erp_loc_a101;
			PRINT '>> Inserting Data into : silver.erp_loc_a101'
			--Insert data into silver erp location

			INSERT INTO silver.erp_loc_a101(
			cid,
			cntry
			)
			--------------------------------------------------------
			--Cleaning data for Silver layer

			SELECT 
			REPLACE(cid,'-','') AS cid,
			CASE
				WHEN UPPER(TRIM(cntry)) = 'DE' THEN 'Germany'
				WHEN UPPER(TRIM(cntry)) IN ('US', 'USA') THEN 'United States'
				WHEN TRIM(cntry) IS NULL OR cntry= '' THEN 'N/A'
				ELSE TRIM(cntry)
			END AS cntry --Normalize and handle missing value

			FROM bronze.erp_loc_a101

			SET @end_time = GETDATE();
			PRINT '>>Loading time : ' + CAST(DATEDIFF(second,@start_time , @end_time) AS NVARCHAR) + 'Seconds'  ;
			PRINT'---------------------------------------------------------------------';

			SET @start_time = GETDATE();
			PRINT '>> Truncating Table : silver.erp_px_cat_g1v2';
			TRUNCATE TABLE silver.erp_px_cat_g1v2;
			PRINT '>> Inserting Data into : silver.erp_px_cat_g1v2'
			--Inserting data in silver product category

			INSERT INTO silver.erp_px_cat_g1v2(
			id,
			cat,
			subcat,
			maintenance
			)

			-----------------------------------------------------
			--Cleaning data for silver layer

			SELECT 
			id,
			cat,
			subcat,
			maintenance
			FROM bronze.erp_px_cat_g1v2
			SET @end_time = GETDATE();
			PRINT '>>Loading time : ' + CAST(DATEDIFF(second,@start_time , @end_time) AS NVARCHAR) + 'Seconds'  ;
			PRINT'-----------------------------------------------------------------'

			SET @procedure_end_time = GETDATE();
			PRINT'==========================';
			PRINT'Loding Silver Layer is completed'
			PRINT' - Total Load Duration: ' + CAST( DATEDIFF(SECOND,@procedure_start_time, @procedure_end_time) AS NVARCHAR) + 'Seconds'
			PRINT'===================================='

    END TRY
	BEGIN CATCH
	        PRINT'=======================================';
	        PRINT' ERROR OCCURED DURING LOADING BRONZE LAYER';
			PRINT' ERROR MESSAGE : ' + ERROR_MESSAGE();
			PRINT' ERROR MESSAGE : ' + CAST(ERROR_NUMBER() AS NVARCHAR);
			PRINT' ERROR MESSAGE : ' + CAST(ERROR_STATE() AS NVARCHAR);
	        PRINT'=======================================';




	END CATCH

END
