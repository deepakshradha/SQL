/*
=====================================================
Stored Procedured : Load Bronze Layer (Source > Bronze)
=====================================================

Script Purpose : 
     This stored procedure load data into the bronze schema from external CSV file,.
	 It perform the following action:
	 - Truncate the bronze table before loading data.
	 - Uses the 'BULK INSERT' command to load data from external CSV file.

Parameters:
     None.
	 This stored procedure does not accept any parameter or return values.

Uses Example:

   EXEC bronze.load_bronze;

*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
      DECLARE @start_time DATETIME , @end_time DATETIME,  @procedure_start_time DATETIME, @procedure_end_time DATETIME;
	  BEGIN TRY
	        SET  @procedure_start_time = GETDATE();
			PRINT '================================================';
			PRINT 'Loding Bronze layer';
			PRINT '================================================';

	
			PRINT '------------------------------------------------';
			PRINT 'Loding CRM table ';
			PRINT '------------------------------------------------';
  
            SET @start_time = GETDATE();
			PRINT '>> Truncating Table: bronze.crm_cust_info ';
			TRUNCATE TABLE bronze.crm_cust_info
			PRINT '>> Inserting Data into: bronze.crm_cust_info ';
			BULK INSERT bronze.crm_cust_info
			FROM 'C:\Users\deepak\Study Material\The Data Analyst Course Complete Data Analyst Bootcamp\gdb041.sql\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
			WITH (
					FIRSTROW = 2 ,
					FIELDTERMINATOR = ',' ,
					TABLOCK
					);
            SET @end_time = GETDATE();
            PRINT '>>Loading time : ' + CAST(DATEDIFF(second,@start_time , @end_time) AS NVARCHAR) + 'Seconds'  ;
			PRINT '-------------------';

			SET @start_time = GETDATE();
			PRINT '>> Truncating Table: bronze.crm_prd_info';
			TRUNCATE TABLE bronze.crm_prd_info
			PRINT '>> Inserting Data into: bronze.crm_prd_info ';
			BULK INSERT bronze.crm_prd_info
			FROM 'C:\Users\deepak\Study Material\The Data Analyst Course Complete Data Analyst Bootcamp\gdb041.sql\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
			WITH (
					FIRSTROW = 2 ,
					FIELDTERMINATOR = ',' ,
					TABLOCK
					);
			SET @end_time = GETDATE();
            PRINT '>>Loading time : ' + CAST(DATEDIFF(second,@start_time , @end_time) AS NVARCHAR) + 'Seconds'  ;
			PRINT '-------------------';

            SET @start_time = GETDATE();
			PRINT '>> Truncating Table: bronze.crm_sales_details ';
			TRUNCATE TABLE bronze.crm_sales_details
			PRINT '>> Inserting Data into: bronze.crm_sales_details';
			BULK INSERT bronze.crm_sales_details
			FROM 'C:\Users\deepak\Study Material\The Data Analyst Course Complete Data Analyst Bootcamp\gdb041.sql\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
			WITH (
					FIRSTROW = 2 ,
					FIELDTERMINATOR = ',' ,
					TABLOCK
					);
            SET @end_time = GETDATE();
            PRINT '>>Loading time : ' + CAST(DATEDIFF(second,@start_time , @end_time) AS NVARCHAR) + 'Seconds'  ;
			PRINT '-------------------';

          
 
			PRINT '------------------------------------------------';
			PRINT 'Loding ERP table ';
			PRINT '------------------------------------------------';

			SET @start_time = GETDATE();
			PRINT '>> Truncating Table: bronze.erp_cust_az12 '
			TRUNCATE TABLE bronze.erp_cust_az12
			PRINT '>> Inserting Data into: bronze.erp_cust_az12 '
			BULK INSERT bronze.erp_cust_az12
			FROM 'C:\Users\deepak\Study Material\The Data Analyst Course Complete Data Analyst Bootcamp\gdb041.sql\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
			WITH (
					FIRSTROW = 2 ,
					FIELDTERMINATOR = ',' ,
					TABLOCK
					);
			SET @end_time = GETDATE();
            PRINT '>>Loading time : ' + CAST(DATEDIFF(second,@start_time , @end_time) AS NVARCHAR) + 'Seconds'  ;
			PRINT '-------------------';
		
			SET @start_time = GETDATE();
			PRINT '>> Truncating Table: bronze.erp_loc_a101  ';
			TRUNCATE TABLE bronze.erp_loc_a101
			PRINT '>> Inserting Data into: bronze.erp_loc_a101 ';
			BULK INSERT bronze.erp_loc_a101
			FROM 'C:\Users\deepak\Study Material\The Data Analyst Course Complete Data Analyst Bootcamp\gdb041.sql\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
			WITH (
					FIRSTROW = 2 ,
					FIELDTERMINATOR = ',' ,
					TABLOCK
					);
            SET @end_time = GETDATE();
            PRINT '>>Loading time : ' + CAST(DATEDIFF(second,@start_time , @end_time) AS NVARCHAR) + 'Seconds'  ;
			PRINT '-------------------';

            SET @start_time = GETDATE();
			PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2 ';	
			TRUNCATE TABLE bronze.erp_px_cat_g1v2
			PRINT '>> Inserting Data into: bronze.erp_cat_g1v2 ';
			BULK INSERT bronze.erp_px_cat_g1v2
			FROM 'C:\Users\deepak\Study Material\The Data Analyst Course Complete Data Analyst Bootcamp\gdb041.sql\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
			WITH (
					FIRSTROW = 2 ,
					FIELDTERMINATOR = ',' ,
					TABLOCK
					);
            SET @end_time = GETDATE();
            PRINT '>>Loading time : ' + CAST(DATEDIFF(second,@start_time , @end_time) AS NVARCHAR) + 'Seconds'  ;
			PRINT '-------------------';
			SET @procedure_end_time = GETDATE();
			PRINT '>> Total loding time: ' + CAST(DATEDIFF(second,@procedure_start_time, @procedure_end_time) AS NVARCHAR) + 'Seconds'  ;
			PRINT'--------------------';



	 END TRY
	 BEGIN CATCH
	  PRINT'=======================================';
	  PRINT' ERROR OCCURED DURING LOADING BRONZE LAYER';
	  PRINT'=======================================';

	 END CATCH

END
