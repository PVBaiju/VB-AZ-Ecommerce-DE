/* ============================================================
   Project : VB Azure E-Commerce Data Engineering
   Purpose : Insert dynamic job configuration
   ============================================================ */


/* ============================================================
   JOB 1 - CSV ORDERS
   ============================================================ */

INSERT INTO dbo.vb_tbl_job_dtls
(job_id, dtls_key, dtls_value)
VALUES
(1, 'file_format',      'csv'),
(1, 'file_pattern',     'orders_*.csv'),
(1, 'source_container', 'ecommerce'),
(1, 'source_path',      'orders'),
(1, 'delimiter',        ','),
(1, 'header',           'true'),
(1, 'target_container', 'landing'),
(1, 'target_path',      'ecommerce/orders');


/* ============================================================
   JOB 2 - EXCEL PRODUCTS
   ============================================================ */

INSERT INTO dbo.vb_tbl_job_dtls
(job_id, dtls_key, dtls_value)
VALUES
(2, 'file_format', 'excel'),
(2, 'file_pattern', 'products_*.xlsx'),
(2, 'source_path', 'ecommerce/products'),
(2, 'sheet_name', 'products'),
(2, 'target_container', 'landing'),
(2, 'target_path', 'ecommerce/products');


/* ============================================================
   JOB 3 - JSON CUSTOMERS
   ============================================================ */

INSERT INTO dbo.vb_tbl_job_dtls
(job_id, dtls_key, dtls_value)
VALUES
(3, 'file_format', 'json'),
(3, 'file_pattern', 'customers_*.json'),
(3, 'source_path', 'ecommerce/customers'),
(3, 'target_container', 'landing'),
(3, 'target_path', 'ecommerce/customers');


/* ============================================================
   JOB 4 - REST API
   ============================================================ */

INSERT INTO dbo.vb_tbl_job_dtls
(job_id, dtls_key, dtls_value)
VALUES
(4, 'api_method', 'GET'),
(4, 'api_endpoint', '/orders'),
(4, 'api_page_size', '100'),
(4, 'target_container', 'landing'),
(4, 'target_path', 'ecommerce/restapi/orders'),
(4, 'watermark_column', 'modified_date');


/* ============================================================
   JOB 5 - SQL SERVER
   ============================================================ */

INSERT INTO dbo.vb_tbl_job_dtls
(job_id, dtls_key, dtls_value)
VALUES
(5, 'source_schema', 'dbo'),
(5, 'source_table', 'orders'),
(5, 'watermark_column', 'modified_date'),
(5, 'target_container', 'landing'),
(5, 'target_path', 'ecommerce/sql/orders');


/* ============================================================
   JOB 6 - SNOWFLAKE
   ============================================================ */

INSERT INTO dbo.vb_tbl_job_dtls
(job_id, dtls_key, dtls_value)
VALUES
(6, 'source_schema', 'ECOMMERCE'),
(6, 'source_table', 'CUSTOMERS'),
(6, 'watermark_column', 'MODIFIED_DATE'),
(6, 'target_container', 'landing'),
(6, 'target_path', 'ecommerce/snowflake/customers');


/* ============================================================
   JOB 7 - SFTP
   ============================================================ */

INSERT INTO dbo.vb_tbl_job_dtls
(job_id, dtls_key, dtls_value)
VALUES
(7, 'file_format', 'csv'),
(7, 'file_pattern', 'transactions_*.csv'),
(7, 'source_directory', '/incoming/ecommerce'),
(7, 'target_container', 'landing'),
(7, 'target_path', 'ecommerce/sftp/transactions');


/* ============================================================
   JOB 8 - MULTIPLE FILES
   ============================================================ */

INSERT INTO dbo.vb_tbl_job_dtls
(job_id, dtls_key, dtls_value)
VALUES
(8, 'file_pattern', '*'),
(8, 'source_path', 'ecommerce/bulk'),
(8, 'supported_formats', 'csv,excel,json'),
(8, 'target_container', 'landing'),
(8, 'target_path', 'ecommerce/bulk');


/* ============================================================
   JOB 9 - KAFKA
   ============================================================ */

INSERT INTO dbo.vb_tbl_job_dtls
(job_id, dtls_key, dtls_value)
VALUES
(9, 'stream_format', 'json'),
(9, 'topic_name', 'ecommerce-events'),
(9, 'consumer_group', 'vb-ecommerce-consumer'),
(9, 'target_container', 'bronze'),
(9, 'target_path', 'ecommerce/events');


GO