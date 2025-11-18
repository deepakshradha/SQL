## 📘 GOLD LAYER DATA DICTIONARY (Data Catalog)
Included Tables:

dim_customer

dim_product

fact_sales


## 🟦 1. dim_customer
📌 Table Purpose

dim_customer stores the master customer information used for analytics.
It provides cleaned, standardized customer attributes that allow analysts to slice sales data by customer name, segment, city, and other characteristics


| Column Name       | Data Type     | Description |
|-------------------|---------------|-------------|
| customer_key      | INT           | Surrogate primary key uniquely identifying each customer record. |
| customer_number   | INT           | Unique business/customer number assigned by the source system. |
| customer_id       | NVARCHAR(50)   | Customer identifier from operational systems (natural key). |
| first_name        | NVARCHAR(100)  | Customer’s first name. |
| last_name         | NVARCHAR(100)  | Customer’s last name. |
| marriage_stauts   | NVARCHAR(20)   | Customer’s marital status (e.g., Single, Married). |
| gender            | NVARCHAR(10)   | Customer’s gender. |
| country           | NVARCHAR(50)   | Country where the customer resides. |
| birth_date        | DATE          | Customer’s date of birth. |
| create_date       | DATE          | Record creation date in the data warehouse. |



## 🟦 2. dim_product
📌 Table Purpose

dim_product stores product-related information that describes each item sold.
It ensures consistent product naming, categorization, and pricing across the warehouse.

| Column Name             | Data Type      | Description |
|-------------------------|----------------|-------------|
| product_key             | INT            | Surrogate primary key uniquely identifying each product record. |
| product_number          | INT            | Unique product number assigned by the business or source system. |
| product_id              | NVARCHAR(50)   | Natural product identifier from operational systems. |
| product_name            | NVARCHAR(200)  | Name of the product. |
| product_category_id     | NVARCHAR(50)   | Identifier for the product category from source system. |
| product_category        | NVARCHAR(100)  | High-level category to which the product belongs. |
| product_subcategory     | NVARCHAR(100)  | Subcategory providing further classification of the product. |
| product_cost            | INT            | Cost associated with the product. |
| product_line            | NVARCHAR(100)  | Product line or family grouping. |
| productio_start_date    | DATE           | Date when the product entered production. |
| maintenance             | NVARCHAR(50)   | Maintenance status (e.g., YES, NO). |


## 🟦 3. fact_sales
📌 Table Purpose

fact_sales contains transaction-level sales data, recording each order and items sold.
It integrates keys from DIM_CUSTOMER and DIM_PRODUCT to enable deep business analysis.


| Column Name         | Data Type      | Description |
|---------------------|----------------|-------------|
| sales_order_number  | VARCHAR(50)    | Unique identifier for each sales order from the source system. |
| product_key         | INT            | Foreign key referencing Dim_Product to identify the sold product. |
| customer_key        | INT            | Foreign key referencing Dim_Customer to identify the customer. |
| order_date          | DATE           | Date when the sales order was created. |
| ship_date           | DATE           | Date when the order was shipped. |
| due_date            | DATE           | Date by which the order is expected to be delivered. |
| sales               | INT            | Total sales amount . |
| quantity            | INT            | Number of units sold. |
| price               | INT            | Price per unit at the time of sale. |
