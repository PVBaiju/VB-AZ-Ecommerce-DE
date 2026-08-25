/* ============================================================
   Project  : VB Azure E-Commerce Data Engineering
   Database : sqldb-vb-ecommerce-dev
   Purpose  : Metadata-driven control framework
   ============================================================ */


/* ============================================================
   1. SOURCE MASTER
   Stores information about source systems.
   ============================================================ */

IF OBJECT_ID('dbo.vb_tbl_source', 'U') IS NOT NULL
    DROP TABLE dbo.vb_tbl_source;
GO

CREATE TABLE dbo.vb_tbl_source
(
    source_id           INT IDENTITY(1,1) PRIMARY KEY,
    source_name         VARCHAR(200) NOT NULL,
    source_type         VARCHAR(50) NOT NULL,
    connection_name     VARCHAR(200) NULL,
    description         VARCHAR(500) NULL,
    active_flag         BIT NOT NULL DEFAULT 1,

    created_user        VARCHAR(100) NOT NULL DEFAULT SYSTEM_USER,
    created_date        DATETIME2 NOT NULL DEFAULT GETDATE(),
    updated_user        VARCHAR(100) NULL,
    updated_date        DATETIME2 NULL
);
GO


/* ============================================================
   2. JOB MASTER
   Stores ingestion/processing jobs.
   ============================================================ */

IF OBJECT_ID('dbo.vb_tbl_job', 'U') IS NOT NULL
    DROP TABLE dbo.vb_tbl_job;
GO

CREATE TABLE dbo.vb_tbl_job
(
    job_id              INT IDENTITY(1,1) PRIMARY KEY,

    source_id           INT NOT NULL,

    job_name            VARCHAR(200) NOT NULL,
    job_description     VARCHAR(500) NULL,

    layer_name          VARCHAR(50) NULL,

    load_type           VARCHAR(50) NULL,

    pipeline_name       VARCHAR(200) NULL,

    active_flag         BIT NOT NULL DEFAULT 1,

    created_user        VARCHAR(100) NOT NULL DEFAULT SYSTEM_USER,
    created_date        DATETIME2 NOT NULL DEFAULT GETDATE(),
    updated_user        VARCHAR(100) NULL,
    updated_date        DATETIME2 NULL,

    CONSTRAINT FK_vb_tbl_job_source
        FOREIGN KEY (source_id)
        REFERENCES dbo.vb_tbl_source(source_id)
);
GO


/* ============================================================
   3. JOB DETAILS
   Dynamic key/value configuration.
   This replaces the flexible configuration mechanism
   used in the previous project.
   ============================================================ */

IF OBJECT_ID('dbo.vb_tbl_job_dtls', 'U') IS NOT NULL
    DROP TABLE dbo.vb_tbl_job_dtls;
GO

CREATE TABLE dbo.vb_tbl_job_dtls
(
    job_dtls_id         INT IDENTITY(1,1) PRIMARY KEY,

    job_id              INT NOT NULL,

    dtls_key            VARCHAR(100) NOT NULL,

    dtls_value          VARCHAR(MAX) NULL,

    created_user        VARCHAR(100) NOT NULL DEFAULT SYSTEM_USER,
    created_date        DATETIME2 NOT NULL DEFAULT GETDATE(),
    updated_user        VARCHAR(100) NULL,
    updated_date        DATETIME2 NULL,

    CONSTRAINT FK_vb_tbl_job_dtls_job
        FOREIGN KEY (job_id)
        REFERENCES dbo.vb_tbl_job(job_id)
);
GO


/* ============================================================
   4. PIPELINE EXECUTION LOG
   Stores every pipeline execution.
   ============================================================ */

IF OBJECT_ID('dbo.vb_tbl_log_dtls', 'U') IS NOT NULL
    DROP TABLE dbo.vb_tbl_log_dtls;
GO

CREATE TABLE dbo.vb_tbl_log_dtls
(
    log_id              BIGINT IDENTITY(1,1) PRIMARY KEY,

    job_id              INT NOT NULL,

    pipeline_id         VARCHAR(200) NULL,
    pipeline_run_id     VARCHAR(200) NULL,

    job_start_time      DATETIME2 NOT NULL,
    job_end_time        DATETIME2 NULL,

    job_status          VARCHAR(30) NOT NULL,

    records_read        BIGINT NULL,
    records_written     BIGINT NULL,

    source_file         VARCHAR(500) NULL,
    target_path         VARCHAR(1000) NULL,

    error_dtls          VARCHAR(MAX) NULL,

    created_user        VARCHAR(100) NOT NULL DEFAULT SYSTEM_USER,
    created_date        DATETIME2 NOT NULL DEFAULT GETDATE(),
    updated_user        VARCHAR(100) NULL,
    updated_date        DATETIME2 NULL,

    CONSTRAINT FK_vb_tbl_log_dtls_job
        FOREIGN KEY (job_id)
        REFERENCES dbo.vb_tbl_job(job_id)
);
GO


/* ============================================================
   5. WATERMARK TABLE
   Used for incremental processing.
   ============================================================ */

IF OBJECT_ID('dbo.vb_tbl_watermark', 'U') IS NOT NULL
    DROP TABLE dbo.vb_tbl_watermark;
GO

CREATE TABLE dbo.vb_tbl_watermark
(
    watermark_id        INT IDENTITY(1,1) PRIMARY KEY,

    job_id              INT NOT NULL,

    watermark_column    VARCHAR(200) NULL,

    last_watermark_value VARCHAR(500) NULL,

    updated_date        DATETIME2 NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_vb_tbl_watermark_job
        FOREIGN KEY (job_id)
        REFERENCES dbo.vb_tbl_job(job_id)
);
GO