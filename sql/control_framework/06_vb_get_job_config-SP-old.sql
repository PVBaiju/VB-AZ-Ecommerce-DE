CREATE OR ALTER PROCEDURE dbo.vb_get_job_config
    @job_id INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        j.job_id,
        j.job_name,

        s.source_id,
        s.source_name,
        s.source_type,
        s.connection_name,

        j.layer_name,
        j.load_type,
        j.pipeline_name,
        j.active_flag,

        MAX(CASE WHEN d.dtls_key = 'file_format'
                 THEN d.dtls_value END) AS file_format,

        MAX(CASE WHEN d.dtls_key = 'file_pattern'
                 THEN d.dtls_value END) AS file_pattern,

       MAX(CASE WHEN d.dtls_key = 'source_container'
                 THEN d.dtls_value END) AS source_container,

        MAX(CASE WHEN d.dtls_key = 'source_path'
                 THEN d.dtls_value END) AS source_path,

        MAX(CASE WHEN d.dtls_key = 'source_directory'
                 THEN d.dtls_value END) AS source_directory,

        MAX(CASE WHEN d.dtls_key = 'delimiter'
                 THEN d.dtls_value END) AS delimiter,

        MAX(CASE WHEN d.dtls_key = 'header'
                 THEN d.dtls_value END) AS header,

        MAX(CASE WHEN d.dtls_key = 'sheet_name'
                 THEN d.dtls_value END) AS sheet_name,

        MAX(CASE WHEN d.dtls_key = 'api_method'
                 THEN d.dtls_value END) AS api_method,

        MAX(CASE WHEN d.dtls_key = 'api_endpoint'
                 THEN d.dtls_value END) AS api_endpoint,

        MAX(CASE WHEN d.dtls_key = 'api_page_size'
                 THEN d.dtls_value END) AS api_page_size,

        MAX(CASE WHEN d.dtls_key = 'source_schema'
                 THEN d.dtls_value END) AS source_schema,

        MAX(CASE WHEN d.dtls_key = 'source_table'
                 THEN d.dtls_value END) AS source_table,

        MAX(CASE WHEN d.dtls_key = 'watermark_column'
                 THEN d.dtls_value END) AS watermark_column,

        MAX(CASE WHEN d.dtls_key = 'target_container'
                 THEN d.dtls_value END) AS target_container,

        MAX(CASE WHEN d.dtls_key = 'target_path'
                 THEN d.dtls_value END) AS target_path,

        MAX(CASE WHEN d.dtls_key = 'stream_format'
                 THEN d.dtls_value END) AS stream_format,

        MAX(CASE WHEN d.dtls_key = 'topic_name'
                 THEN d.dtls_value END) AS topic_name,

        MAX(CASE WHEN d.dtls_key = 'consumer_group'
                 THEN d.dtls_value END) AS consumer_group

    FROM dbo.vb_tbl_job j

    INNER JOIN dbo.vb_tbl_source s
        ON j.source_id = s.source_id

    LEFT JOIN dbo.vb_tbl_job_dtls d
        ON j.job_id = d.job_id

    WHERE j.job_id = @job_id
      AND j.active_flag = 1
      AND s.active_flag = 1

    GROUP BY
        j.job_id,
        j.job_name,
        s.source_id,
        s.source_name,
        s.source_type,
        s.connection_name,
        j.layer_name,
        j.load_type,
        j.pipeline_name,
        j.active_flag;
END;