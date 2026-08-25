/* ============================================================
   Project : VB Azure E-Commerce Data Engineering
   Purpose : Insert metadata-driven ingestion jobs
   ============================================================ */

INSERT INTO dbo.vb_tbl_job
(
    job_id,
    job_name,
    source_id,
    layer_name,
    load_type,
    pipeline_name,
    active_flag
)
VALUES
(1, 'JOB_CSV_ORDERS',          1, 'LANDING', 'FULL',        'PL_MASTER_INGESTION',    1),
(2, 'JOB_EXCEL_PRODUCTS',      2, 'LANDING', 'FULL',        'PL_MASTER_INGESTION',    1),
(3, 'JOB_JSON_CUSTOMERS',      3, 'LANDING', 'FULL',        'PL_MASTER_INGESTION',    1),
(4, 'JOB_RESTAPI_ORDERS',      4, 'LANDING', 'INCREMENTAL', 'PL_MASTER_INGESTION',    1),
(5, 'JOB_SQL_ORDERS',          5, 'LANDING', 'INCREMENTAL', 'PL_MASTER_INGESTION',    1),
(6, 'JOB_SNOWFLAKE_CUSTOMERS', 6, 'LANDING', 'INCREMENTAL', 'PL_MASTER_INGESTION',    1),
(7, 'JOB_SFTP_TRANSACTIONS',   7, 'LANDING', 'FULL',        'PL_MASTER_INGESTION',    1),
(8, 'JOB_BULK_FILES',          8, 'LANDING', 'FULL',        'PL_MASTER_INGESTION',    1),
(9, 'JOB_KAFKA_EVENTS',        9, 'BRONZE',  'STREAMING',   'PL_STREAMING_INGESTION', 1);GO