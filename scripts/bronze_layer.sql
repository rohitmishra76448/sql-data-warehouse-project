-- ============================================
-- Bronze Layer - SQL Data Warehouse Project
-- Database: PostgreSQL
-- ============================================

-- Create Schemas
CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;

-- ============================================
-- Create Bronze Tables
-- ============================================

CREATE TABLE IF NOT EXISTS bronze.crm_cust_info (
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_material_status VARCHAR(50),
    cst_gndr VARCHAR(50),
    cst_create_date DATE
);

CREATE TABLE IF NOT EXISTS bronze.crm_prd_info (
    prd_id INT,
    prd_key VARCHAR(50),
    prd_nm VARCHAR(50),
    prd_cost INT,
    prd_line VARCHAR(50),
    prd_start_dt TIMESTAMP,
    prd_end_dt TIMESTAMP
);

CREATE TABLE IF NOT EXISTS bronze.crm_sales_details (
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
);

CREATE TABLE IF NOT EXISTS bronze.erp_cust_az12 (
    cid VARCHAR(50),
    bdate DATE,
    gen VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS bronze.erp_loc_a101 (
    cid VARCHAR(50),
    cntry VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS bronze.erp_px_cat_g1v2 (
    id VARCHAR(50),
    cat VARCHAR(50),
    subcat VARCHAR(50),
    maintenance VARCHAR(50)
);

-- ============================================
-- Load Bronze Layer Procedure
-- Note: Update file paths to match your local
-- dataset location before running
-- ============================================

CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
DECLARE
    v_start_time TIMESTAMP;
    v_end_time TIMESTAMP;
    v_batch_start TIMESTAMP;
    v_batch_end TIMESTAMP;
BEGIN
    v_batch_start := NOW();
    RAISE NOTICE '================================================';
    RAISE NOTICE 'Loading Bronze Layer';
    RAISE NOTICE '================================================';

    -- CRM Tables
    RAISE NOTICE 'Loading CRM Tables';

    v_start_time := NOW();
    TRUNCATE TABLE bronze.crm_cust_info;
    COPY bronze.crm_cust_info 
    FROM '/path/to/datasets/source_crm/cust_info.csv' 
    DELIMITER ',' CSV HEADER;
    v_end_time := NOW();
    RAISE NOTICE 'crm_cust_info loaded in % seconds', EXTRACT(EPOCH FROM (v_end_time - v_start_time));

    v_start_time := NOW();
    TRUNCATE TABLE bronze.crm_prd_info;
    COPY bronze.crm_prd_info 
    FROM '/path/to/datasets/source_crm/prd_info.csv' 
    DELIMITER ',' CSV HEADER;
    v_end_time := NOW();
    RAISE NOTICE 'crm_prd_info loaded in % seconds', EXTRACT(EPOCH FROM (v_end_time - v_start_time));

    v_start_time := NOW();
    TRUNCATE TABLE bronze.crm_sales_details;
    COPY bronze.crm_sales_details 
    FROM '/path/to/datasets/source_crm/sales_details.csv' 
    DELIMITER ',' CSV HEADER;
    v_end_time := NOW();
    RAISE NOTICE 'crm_sales_details loaded in % seconds', EXTRACT(EPOCH FROM (v_end_time - v_start_time));

    -- ERP Tables
    RAISE NOTICE 'Loading ERP Tables';

    v_start_time := NOW();
    TRUNCATE TABLE bronze.erp_cust_az12;
    COPY bronze.erp_cust_az12 
    FROM '/path/to/datasets/source_erp/CUST_AZ12.csv' 
    DELIMITER ',' CSV HEADER;
    v_end_time := NOW();
    RAISE NOTICE 'erp_cust_az12 loaded in % seconds', EXTRACT(EPOCH FROM (v_end_time - v_start_time));

    v_start_time := NOW();
    TRUNCATE TABLE bronze.erp_loc_a101;
    COPY bronze.erp_loc_a101 
    FROM '/path/to/datasets/source_erp/LOC_A101.csv' 
    DELIMITER ',' CSV HEADER;
    v_end_time := NOW();
    RAISE NOTICE 'erp_loc_a101 loaded in % seconds', EXTRACT(EPOCH FROM (v_end_time - v_start_time));

    v_start_time := NOW();
    TRUNCATE TABLE bronze.erp_px_cat_g1v2;
    COPY bronze.erp_px_cat_g1v2 
    FROM '/path/to/datasets/source_erp/PX_CAT_G1V2.csv' 
    DELIMITER ',' CSV HEADER;
    v_end_time := NOW();
    RAISE NOTICE 'erp_px_cat_g1v2 loaded in % seconds', EXTRACT(EPOCH FROM (v_end_time - v_start_time));

    v_batch_end := NOW();
    RAISE NOTICE 'Bronze Layer Load Complete in % seconds', 
    EXTRACT(EPOCH FROM (v_batch_end - v_batch_start));

EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'ERROR: %', SQLERRM;
END;
$$;
