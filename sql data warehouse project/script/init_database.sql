-- Create Datbase  "DataWarehouse"

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