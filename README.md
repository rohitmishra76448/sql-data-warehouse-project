# SQL Data Warehouse Project

A complete end-to-end data warehousing and analytics solution built with PostgreSQL, demonstrating industry best practices in data engineering and analytical reporting.

---

## Project Overview

This project consolidates sales data from two source systems — a CRM and an ERP — into a unified data warehouse using a **medallion architecture** (Bronze → Silver → Gold). The result is a clean, analytics-ready star schema that supports business intelligence and reporting.

---

## Architecture

```
Source Systems          Bronze Layer         Silver Layer         Gold Layer
                        (Raw Data)           (Cleaned Data)       (Analytics Ready)

CRM System    ───────►  bronze.crm_*  ────►  silver.crm_*  ────►  gold.dim_customers
ERP System    ───────►  bronze.erp_*  ────►  silver.erp_*  ────►  gold.dim_products
                                                                   gold.fact_sales
```

### Layer Descriptions

| Layer | Description |
|-------|-------------|
| **Bronze** | Raw data loaded directly from CSV source files with no transformations |
| **Silver** | Cleaned, standardized, and deduplicated data ready for integration |
| **Gold** | Business-ready star schema views combining silver tables for analytics |

---

## Star Schema

```
                    dim_customers
                         │
                         │ customer_key
                         │
dim_products ────── fact_sales
  product_key │
              │
              └── order_date, sales_amount, quantity, price
```

**Fact Table:** `gold.fact_sales` — transactional sales data

**Dimension Tables:**
- `gold.dim_customers` — customer profile combining CRM and ERP data
- `gold.dim_products` — product catalog with category information

---

## Data Sources

| Source | Tables | Description |
|--------|--------|-------------|
| CRM | crm_cust_info, crm_prd_info, crm_sales_details | Customer profiles, product info, sales transactions |
| ERP | erp_cust_az12, erp_loc_a101, erp_px_cat_g1v2 | Customer demographics, location data, product categories |

---

## Key Transformations (Silver Layer)

- **Deduplication** — ROW_NUMBER() to keep most recent customer record per ID
- **Name standardization** — TRIM to remove leading/trailing whitespace
- **Gender normalization** — mapped 'M'/'F' codes to 'Male'/'Female'
- **Marital status normalization** — mapped 'S'/'M' codes to 'Single'/'Married'
- **Date conversion** — integer date fields (YYYYMMDD) converted to proper DATE type
- **Invalid date handling** — zero values and incorrect formats set to NULL
- **Sales validation** — recalculated sales when original value was missing or inconsistent
- **Product key extraction** — SUBSTRING and REPLACE to derive category ID and clean product key
- **Product end dates** — LEAD() window function to calculate end date from next product's start date
- **Country standardization** — mapped country codes to full country names
- **Customer ID cleanup** — removed 'NAS' prefix from ERP customer IDs

---

## Project Structure

```
sql-data-warehouse-project/
├── scripts/
│   ├── bronze_layer.sql      # Schema creation, table definitions, load procedure
│   ├── silver_layer.sql      # Table definitions and ETL stored procedure
│   └── gold_layer.sql        # Dimension and fact views (star schema)
├── analysis/
│   ├── eda.sql               # Exploratory data analysis queries
│   └── business_insights.sql # Business KPI and reporting queries
└── README.md
```

---

## How to Run

1. **Set up PostgreSQL** and create a new database called `Data_where_house`
2. **Run bronze_layer.sql** — creates schemas and bronze tables
3. **Update file paths** in the COPY commands to match your local dataset location
4. **Import CSV files** using pgAdmin Import/Export or the COPY command
5. **Run silver_layer.sql** — creates silver tables and executes transformations
6. **Run gold_layer.sql** — creates analytical views

```sql
-- Execute the load procedures
CALL bronze.load_bronze();
CALL silver.load_silver();

-- Query the gold layer
SELECT * FROM gold.fact_sales LIMIT 10;
SELECT * FROM gold.dim_customers LIMIT 10;
SELECT * FROM gold.dim_products LIMIT 10;
```

---

## Tech Stack

- **Database:** PostgreSQL 18
- **Tools:** pgAdmin 4
- **Concepts:** Medallion Architecture, Star Schema, ETL, Data Modelling, Stored Procedures, Window Functions, CTEs

---

## Key SQL Concepts Demonstrated

- Stored procedures with error handling
- Window functions (ROW_NUMBER, LEAD)
- Complex CASE statements for data standardization
- Multi-table JOINs across source systems
- Data type conversions and NULL handling
- View creation for analytics layer

---

## Author

**Rohit Mishra**  
M.Sc. AI and Data Science | Data Analyst  
[LinkedIn](https://linkedin.com/in/rohit-mishra-316883284) | [GitHub](https://github.com/rohitmishra76448)
