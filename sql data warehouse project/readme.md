## 🧱 SQL Data Warehouse 

This project focused on designing and implementing a modern data warehouse using SQL and a Star Schema model. The goal is to consolidate operational data from multiple source systems (ERP and CRM) into an optimized, business-ready format for high-performance analytical queries and reporting.

## 🎯 Objectives

Design a Modern DWH: Implement a scalable data warehouse following the Medallion Architecture (Bronze, Silver, Gold layers).

Build ETL Pipelines: Develop robust SQL scripts to handle data extraction, cleansing, transformation, and loading (ETL).

Model Data for Analytics: Transform source data into a Star Schema model optimized for reporting efficiency.


## 🏗️ Data Architecture: The Medallion Approach

The project utilizes a layered data architecture to ensure data quality, traceability, and consistency before it reaches the end-user.

| Layer                 | Purpose         | Content                              | SQL Activity                                   |
| --------------------- | --------------- | ------------------------------------ | ---------------------------------------------- |
| **Bronze (Raw)**      | Ingestion       | Raw source data exactly as received  | Initial loading                                |
| **Silver (Cleansed)** | Standardization | Cleaned, validated, structured data  | Deduplication, type fixes, normalization       |
| **Gold (Analytical)** | Business-Ready  | Star Schema: Fact & Dimension tables | Fact creation, dimension loading, aggregations |


## ⭐️ Data Modeling: Star Schema

The Gold Layer is implemented using a Star Schema, which separates transactional data from descriptive data, allowing for fast analytical query performance.

Fact Table (gold.fact_sales)

Contains quantitative measures (sales amount, quantity, cost).

Includes foreign keys linking to the dimension tables.

Dimension Tables (gold.dim_customer, gold.dim_product)

Contain descriptive attributes (customer name, product category, etc).

These are used to filter, group, and segment the data in reports.


## ⚙️ ETL Processes & Key Steps

The project's ETL scripts (/scripts folder) cover the entire data lifecycle:

Schema Setup: Creating the database and schemas for the Bronze, Silver, and Gold layers.

Raw Ingestion: Importing raw ERP and CRM data into the Bronze layer tables.

Data Cleansing: Handling missing values, standardizing data types, and resolving data inconsistencies in the Silver layer.

Dimension Loading: Populating all dimension tables in the Gold layer.

Fact Loading: Creating the final FactSales table by performing lookups and joins across dimension tables.

## 🧰 Tools & Technologies

| Category             | Tools / Skills                                    |
| -------------------- | ------------------------------------------------- |
| **Database**         | SQL Server                                        |
| **Language**         |  SQL                                              |
| **Concepts**         | ETL/ELT, Star Schema, Data Quality, Normalization |
| **SQL Techniques**   | CTEs, Window Functions, Stored Procedures, Joins  |
| **Management Tools** | SSMS                                              |



## 📂 Repository Structure

The repository is organized to clearly separate raw data, scripts, tests and documentation.

sql-data-warehouse-project/
├── datasets/             # Raw CSV files from source systems (ERP, CRM)
├── scripts/              # All SQL scripts for ETL, schema creation, and analytics
│   ├── 01_schema_setup.sql
│   ├── 02_bronze_ingestion.sql
│   ├── 03_silver_cleansing.sql
│   ├── 04_gold_dimensions.sql
│   └── 05_gold_facts_and_analytics.sql
└── test/                 # Checking the data cleaniness of silver layer 
└── docs/                 # Documentation, including data model diagrams and architecture flow
└── README.md             # This file


 ## 📊 Business Insights (Analytical Queries)

The data warehouse can enables efficient execution of complex analytical queries to derive actionable business intelligence, including:

Sales Performance: Calculating Monthly/Quarterly/Annual Sales, Year-Over-Year Growth.

Customer Segmentation: Identifying Top N customers by revenue, average order value (AOV).

Product Analysis: Determining top-selling products, products with the highest profit margin, and inventory turnover.

Time-Based Analysis: Analyzing sales trends using window functions (e.g., running totals and moving averages).
