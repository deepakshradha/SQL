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

* `Data_architechture` ![alt text](https://github.com/deepakshradha/SQL/blob/main/sql%20data%20warehouse%20project/docs/data_architecture.drawio.png)

* `Data Flow` ![alt text](https://github.com/deepakshradha/SQL/blob/main/sql%20data%20warehouse%20project/docs/data%20flow%20diagram.drawio.png)


## ⭐️ Data Modeling: Star Schema

The Gold Layer is implemented using a Star Schema, which separates transactional data from descriptive data, allowing for fast analytical query performance.

Fact Table (gold.fact_sales)

Contains quantitative measures (sales amount, quantity, cost).

Includes foreign keys linking to the dimension tables.

Dimension Tables (gold.dim_customer, gold.dim_product)

Contain descriptive attributes (customer name, product category, etc).

These are used to filter, group, and segment the data in reports.

* `Data Mart(star_schema)` ![alt text](https://github.com/deepakshradha/SQL/blob/main/sql%20data%20warehouse%20project/docs/Data%20Mart.drawio.png)

* `Intregation Model` ![alt text](https://github.com/deepakshradha/SQL/blob/main/sql%20data%20warehouse%20project/docs/integration%20model.drawio.png) 
  


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

```
sql-data-warehouse-project/
├── datasets/                           # Raw CSV files (ERP & CRM)
├── scripts/                            # End-to-end SQL ETL scripts
│   ├── 01_schema_setup.sql
│   ├── 02_bronze_ingestion.sql
│   ├── 03_silver_cleansing.sql
│   ├── 04_gold_dimensions.sql
│   └── 05_gold_facts_and_analytics.sql
    └── data analysis/
        ├── data_analysis_customer_report.sql
        ├── data_analysis_product_report.sql
├── tests/                               # Check the data cleaniness of silver layer
├── docs/                               # Architecture diagrams & documentation
└── README.md                           # Project overview

 

```

 ## 📊 Business Insights (Analytical Queries)

This section presents the business analysis layer of the project, executed within the scripts/data-analysis/ directory.
After building the Data Warehouse, these SQL scripts transform the curated tables into actionable business reports, enabling insights for decision-making.
To generate ready-to-use analytical views directly inside the Data Warehouse (Gold Layer), focusing on:

- Customer behavior analysis

- Product performance evaluation

- KPI computation for stakeholders

| **Category**             | **Details**                                                                                                                                                                                                                                                                                                         |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Script File**          | `data_analysis_product_report.sql`                                                                                                                                                                                                                                                                                  |
| **Output View**          | `gold.report_product`                                                                                                                                                                                                                                                                                               |
| **Purpose**              | Provide product-level performance insights for business & analytics teams.                                                                                                                                                                                                                                          |
| **What the Script Does** | ✔ Retrieves product & fact table data<br>✔ Summarizes key performance metrics:<br>• Total Orders<br>• Revenue<br>• Total Quantity Sold<br>• Unique Consumers<br>• Product Lifespan (months)<br>• Recency (months since last sale)<br>✔ Computes KPIs:<br>• Average Order Revenue (AOR)<br>• Average Monthly Revenue |
| **Segmentation Logic**   | • **High-Performer**<br>• **Mid-Performer**<br>• **Low-Performer**                                                                                                                                                                                                                                                  |
| **Final Output**         | A ready-to-query view supporting product analytics and revenue dashboards.                                                                                                                                                                                                                                          |

These reports can now be used directly in:

Power BI

Tableau

Excel

Any BI layer or API extraction
