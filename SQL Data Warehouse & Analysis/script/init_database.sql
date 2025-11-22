/* 

=============================================

Create Database and Schemas

====================================================

Script purpose :

  This script is made for the purpose of creating a database name DataWareHouse,
  if database already contain DataWareHouse then it drop it and create a new database.
  It also contain Schemas naming Bronze, Silver, Gold.


Warning:

  Running this script will delete all the previous historis of database and permanently delete
  all data within it. Proceed with caution and ensure proper backups before running.
*/


USE master;
GO
-- Drop the database if it already exists
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
--DROP the database
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END
GO
-- Create the database
CREATE DATABASE DataWarehouse;  
GO
USE DataWarehouse;
GO 
-- Create Schemas: bronze, silver, gold
 
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;