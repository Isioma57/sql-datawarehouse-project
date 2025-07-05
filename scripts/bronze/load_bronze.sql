/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================

Script Purpose:
    This stored procedure or funtions loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `COPY` command to load data from CSV files into bronze tables.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    CALL bronze.load_bronze();

===============================================================================
*/


CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
DECLARE
    start_time TIMESTAMP;
    end_time TIMESTAMP;
    batch_start_time TIMESTAMP := clock_timestamp();
    batch_end_time TIMESTAMP;
BEGIN
    RAISE NOTICE '================================================';
    RAISE NOTICE 'Loading Bronze Layer';
    RAISE NOTICE '================================================';

-- CRM Tables
RAISE NOTICE 'Loading CRM Tables';

-- Load crm_cust_info data
start_time := clock_timestamp();
TRUNCATE TABLE bronze.crm_cust_info;
COPY bronze.crm_cust_info
FROM '/datasets/source_crm/cust_info.csv'
WITH (FORMAT csv, HEADER);
end_time := clock_timestamp();
RAISE NOTICE 'crm_cust_info loaded in % seconds', extract(epoch FROM end_time - start_time);

-- Load crm_prd_info
    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.crm_prd_info;
    COPY bronze.crm_prd_info
    FROM '/datasets/source_crm/prd_info.csv'
    WITH (FORMAT csv, HEADER);
    end_time := clock_timestamp();
    RAISE NOTICE 'crm_prd_info loaded in % seconds', extract(epoch FROM end_time - start_time);

    -- Load crm_sales_details
    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.crm_sales_details;
    COPY bronze.crm_sales_details
    FROM '/datasets/source_crm/sales_details.csv'
    WITH (FORMAT csv, HEADER);
    end_time := clock_timestamp();
    RAISE NOTICE 'crm_sales_details loaded in % seconds', extract(epoch FROM end_time - start_time);

    -- ERP TABLES
    RAISE NOTICE 'Loading ERP Tables';

    -- erp_loc_a101
    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.erp_loc_a101;
    COPY bronze.erp_loc_a101
    FROM '/datasets/source_erp/loc_a101.csv'
    WITH (FORMAT csv, HEADER);
    end_time := clock_timestamp();
    RAISE NOTICE 'erp_loc_a101 loaded in % seconds', extract(epoch FROM end_time - start_time);

    -- erp_cust_az12
    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.erp_cust_az12;
    COPY bronze.erp_cust_az12
    FROM '/datasets/source_erp/cust_az12.csv'
    WITH (FORMAT csv, HEADER);
    end_time := clock_timestamp();
    RAISE NOTICE 'erp_cust_az12 loaded in % seconds', extract(epoch FROM end_time - start_time);

    -- erp_px_cat_g1v2
    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.erp_px_cat_g1v2;
    COPY bronze.erp_px_cat_g1v2
    FROM '/datasets/source_erp/px_cat_g1v2.csv'
    WITH (FORMAT csv, HEADER);
    end_time := clock_timestamp();
    RAISE NOTICE 'erp_px_cat_g1v2 loaded in % seconds', extract(epoch FROM end_time - start_time);

    batch_end_time := clock_timestamp();
    RAISE NOTICE '✅ Bronze load completed in % seconds', extract(epoch FROM batch_end_time - batch_start_time);

EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE '❌ Error loading bronze layer: %', SQLERRM;
END;
$$;

