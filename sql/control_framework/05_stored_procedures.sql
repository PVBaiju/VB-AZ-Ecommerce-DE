/* ============================================================
   Project : VB Azure E-Commerce Data Engineering
   Purpose : Metadata-driven stored procedures
   ============================================================ */


/* ============================================================
   1. START LOG
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.vb_start_log_entry
    @job_id INT,
    @pipeline_name VARCHAR(200),
    @pipeline_run_id VARCHAR(200)
AS
BEGIN

    SET NOCOUNT ON;

    INSERT INTO dbo.vb_tbl_log_dtls
    (
        job_id,
        pipeline_id,
        pipeline_run_id,
        job_start_time,
        job_status,
        created_user,
        created_date
    )
    VALUES
    (
        @job_id,
        @pipeline_name,
        @pipeline_run_id,
        GETDATE(),
        'Running',
        SYSTEM_USER,
        GETDATE()
    );

END;
GO


/* ============================================================
   2. END LOG
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.vb_end_log_entry
    @job_id INT,
    @pipeline_run_id VARCHAR(200),
    @job_status VARCHAR(30),
    @records_read BIGINT = NULL,
    @records_written BIGINT = NULL,
    @source_file VARCHAR(500) = NULL,
    @target_path VARCHAR(1000) = NULL,
    @error VARCHAR(MAX) = NULL
AS
BEGIN

    SET NOCOUNT ON;

    UPDATE dbo.vb_tbl_log_dtls
    SET
        job_end_time = GETDATE(),
        job_status = @job_status,
        records_read = @records_read,
        records_written = @records_written,
        source_file = @source_file,
        target_path = @target_path,
        error_dtls = @error,
        updated_user = SYSTEM_USER,
        updated_date = GETDATE()
    WHERE job_id = @job_id
      AND pipeline_run_id = @pipeline_run_id
      AND job_status = 'Running';

END;
GO


/* ============================================================
   3. GET JOB DETAILS
   Returns metadata for a specific job.
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.vb_get_job_dtls
    @job_id INT
AS
BEGIN

    SET NOCOUNT ON;

    SELECT
        j.job_id,
        j.job_name,
        j.source_id,
        s.source_name,
        s.source_type,
        s.connection_name,
        j.layer_name,
        j.load_type,
        j.pipeline_name,
        j.active_flag,

        MAX(
            CASE
                WHEN d.dtls_key = 'file_format'
                THEN d.dtls_value
            END
        ) AS file_format,

        MAX(
            CASE
                WHEN d.dtls_key = 'file_pattern'
                THEN d.dtls_value
            END
        ) AS file_pattern,

        MAX(
            CASE
                WHEN d.dtls_key = 'source_path'
                THEN d.dtls_value
            END
        ) AS source_path,

        MAX(
            CASE
                WHEN d.dtls_key = 'source_directory'
                THEN d.dtls_value
            END
        ) AS source_directory,

        MAX(
            CASE
                WHEN d.dtls_key = 'delimiter'
                THEN d.dtls_value
            END
        ) AS delimiter,

        MAX(
            CASE
                WHEN d.dtls_key = 'header'
                THEN d.dtls_value
            END
        ) AS header,

        MAX(
            CASE
                WHEN d.dtls_key = 'sheet_name'
                THEN d.dtls_value
            END
        ) AS sheet_name,

        MAX(
            CASE
                WHEN d.dtls_key = 'api_method'
                THEN d.dtls_value
            END
        ) AS api_method,

        MAX(
            CASE
                WHEN d.dtls_key = 'api_endpoint'
                THEN d.dtls_value
            END
        ) AS api_endpoint,

        MAX(
            CASE
                WHEN d.dtls_key = 'api_page_size'
                THEN d.dtls_value
            END
        ) AS api_page_size,

        MAX(
            CASE
                WHEN d.dtls_key = 'source_schema'
                THEN d.dtls_value
            END
        ) AS source_schema,

        MAX(
            CASE
                WHEN d.dtls_key = 'source_table'
                THEN d.dtls_value
            END
        ) AS source_table,

        MAX(
            CASE
                WHEN d.dtls_key = 'watermark_column'
                THEN d.dtls_value
            END
        ) AS watermark_column,

        MAX(
            CASE
                WHEN d.dtls_key = 'target_container'
                THEN d.dtls_value
            END
        ) AS target_container,

        MAX(
            CASE
                WHEN d.dtls_key = 'target_path'
                THEN d.dtls_value
            END
        ) AS target_path,

        MAX(
            CASE
                WHEN d.dtls_key = 'stream_format'
                THEN d.dtls_value
            END
        ) AS stream_format,

        MAX(
            CASE
                WHEN d.dtls_key = 'topic_name'
                THEN d.dtls_value
            END
        ) AS topic_name,

        MAX(
            CASE
                WHEN d.dtls_key = 'consumer_group'
                THEN d.dtls_value
            END
        ) AS consumer_group

    FROM dbo.vb_tbl_job j

    INNER JOIN dbo.vb_tbl_source s
        ON j.source_id = s.source_id

    LEFT JOIN dbo.vb_tbl_job_dtls d
        ON j.job_id = d.job_id

    WHERE j.job_id = @job_id

    GROUP BY
        j.job_id,
        j.job_name,
        j.source_id,
        s.source_name,
        s.source_type,
        s.connection_name,
        j.layer_name,
        j.load_type,
        j.pipeline_name,
        j.active_flag;

END;
GO


/* ============================================================
   4. UPDATE WATERMARK
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.vb_update_watermark
    @job_id INT,
    @watermark_column VARCHAR(200),
    @watermark_value VARCHAR(500)
AS
BEGIN

    SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.vb_tbl_watermark
        WHERE job_id = @job_id
    )
    BEGIN

        UPDATE dbo.vb_tbl_watermark
        SET
            watermark_column = @watermark_column,
            last_watermark_value = @watermark_value,
            updated_date = GETDATE()
        WHERE job_id = @job_id;

    END

    ELSE
    BEGIN

        INSERT INTO dbo.vb_tbl_watermark
        (
            job_id,
            watermark_column,
            last_watermark_value,
            updated_date
        )
        VALUES
        (
            @job_id,
            @watermark_column,
            @watermark_value,
            GETDATE()
        );

    END

END;
GO