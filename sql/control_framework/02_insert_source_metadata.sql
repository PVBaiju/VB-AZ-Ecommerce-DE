/* ============================================================
   Project : VB Azure E-Commerce Data Engineering
   Purpose : Insert source-system metadata
   ============================================================ */

INSERT INTO dbo.vb_tbl_source
(
    source_id,
    source_name,
    source_type,
    connection_name,
    active_flag
)
VALUES
(1, 'Ecommerce CSV',          'CSV',           NULL,                  1),
(2, 'Ecommerce Excel',        'EXCEL',         NULL,                  1),
(3, 'Ecommerce JSON',         'JSON',          NULL,                  1),
(4, 'Ecommerce REST API',     'REST_API',      'Ecommerce_REST_API',  1),
(5, 'Ecommerce SQL Server',   'SQL_SERVER',    'Ecommerce_SQL_Server',1),
(6, 'Ecommerce Snowflake',    'SNOWFLAKE',     'Ecommerce_Snowflake', 1),
(7, 'Ecommerce SFTP',         'SFTP',          'Ecommerce_SFTP',      1),
(8, 'Ecommerce Multiple Files','MULTIPLE_FILE', NULL,                 1),
(9, 'Ecommerce Kafka',        'KAFKA',         'Ecommerce_Kafka',     1);GO