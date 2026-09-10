# 03_Implementation_Reference

> **VB-AZ-Ecommerce-DE — Complete Technical Implementation & Reproduction Guide**
>
> **PPT = WHAT we built + visual evidence**  
> **This Markdown = EXACTLY HOW we built it + how another person can reproduce it**
>
> **Repository:** `PVBaiju/VB-AZ-Ecommerce-DE`

---

## 0. How to Use This Document

This is the technical source of truth for rebuilding, understanding, validating, troubleshooting, and maintaining the project.

A student should be able to start from the beginning and follow this document even with limited Azure, ADF, Databricks, or Snowflake experience.

For every implementation component, use this sequence:

1. **What** are we building?
2. **Why** are we building it?
3. **Where** do we open it?
4. **What exactly do we click?**
5. **What exactly do we type/configure?**
6. **Which actual project expression/code/query is used?**
7. **What should happen after execution?**
8. **How do we validate it?**
9. **What error can occur?**
10. **What was the root cause?**
11. **What was the fix?**
12. **What is the final working state?**
13. **Which screenshot proves it?**

### Source-of-truth rule

```text
Actual Azure / ADF / Databricks / Snowflake implementation
                    ↓
Project GitHub repository
                    ↓
03_Implementation_Reference.md
                    ↓
Phase PPTs
```

Never invent a configuration just to make the document look complete. If a value has not yet been verified, mark it **VERIFY AGAINST CURRENT ENVIRONMENT**.

---

# 1. PPT vs Technical Reference

## PPT

The PPT is the **visual teaching layer**. It contains architecture, concepts, build sequence, important configuration, selected real screenshots, important results, major errors/fixes, and final working state.

It should remain readable during a training session.

## This Markdown

This is the **detailed implementation/runbook layer**. It contains exact navigation, resource names, dataset names, linked-service names, parameters, ADF expressions, complete SQL, complete PySpark, configuration, validation, troubleshooting, screenshots at implementation points, lessons learned, and cost/cleanup guidance.

**Some screenshots may appear in both. That is intentional. The information depth is different.**

---

# 2. Project Implementation Map

```text
PHASE 00 | ENVIRONMENT & PREREQUISITES
        ↓
PHASE 01 | PROJECT DEFINITION
        ↓
PHASE 02 | ARCHITECTURE
        ↓
PHASE 03 | IMPLEMENTATION
        ├── 03.1 Environment & Access
        ├── 03.2 ADF Connectivity
        ├── 03.3 SQL Control Framework
        ├── 03.4 Stored Procedures
        ├── 03.5 ADF Linked Services
        ├── 03.6 Datasets, Parameters & Dynamic Paths
        ├── 03.7 Master Pipeline
        ├── 03.8 Source-Specific Child Pipelines
        ├── 03.9 ADLS Landing → Bronze
        ├── 03.10 Databricks Transformation
        ├── 03.11 Silver / Gold
        ├── 03.12 SCD1 / SCD2
        ├── 03.13 Kafka / Event Hubs Streaming
        ├── 03.14 Snowflake
        ├── 03.15 Execution, Validation & Troubleshooting
        └── 03.16 Implementation Completion
        ↓
PHASE 04 | VALIDATION & TESTING
        ↓
PHASE 05 | OPERATIONS, MONITORING & TROUBLESHOOTING
```

---

# 3. Phase 03 — Implementation

## 3.1 Environment & Access Setup

### 3.1.1 Objective

Prepare the Azure, ADF, Databricks, security, and connectivity components required by the project.

### 3.1.2 Project Azure Resources

| Component | Project resource |
|---|---|
| Resource Group | `rg-vb-az-ecommerce-dev` |
| Region | Central India |
| ADLS Gen2 | `adlsvbecommercedev` |
| ADF | `adfvbecommercedev` |
| Databricks Workspace | `dbw-vb-ecommerce-dev` |
| Key Vault | `kv-vb-ecommerce-dev` |
| Event Hubs Namespace | `eh-vb-ecommerce-dev` |
| Event Hub | `ecommerce_orders` |

> **Security:** Never place passwords, access keys, SAS tokens, connection strings, or Databricks access tokens in this document or GitHub.

### 3.1.3 ADLS Gen2

Document the actual project steps for opening the storage account, confirming hierarchical namespace, creating containers/folders, verifying files, connectivity, authentication, and network settings.

Project containers:

```text
landing
bronze
silver
gold
quarantine
audit
```

### 3.1.4 Azure SQL Control Environment

Document locating the SQL database, Query Editor, SSMS alternative, database verification, control tables, stored procedures, metadata population, and validation.

### 3.1.5 ADF + SHIR

Document ADF Studio → Manage → Integration runtimes, Self-hosted IR creation, installer, registration, Running status, SQL Server linked service, and Test connection.

### 3.1.6 Databricks + Unity Catalog

Document workspace, compute, catalog, schemas, storage credentials, external locations, access connector, permissions, secret scope, notebooks, and jobs.

### 3.1.7 Compute Cost Rule

> 🚨 **START COMPUTE NOW — `cmp-vb-ecommerce-dev`. Allow 5+ minutes for startup.**

Only start compute when an execution actually requires Spark. Keep compute stopped during documentation, architecture discussion, ADF design, SQL metadata work that does not execute Spark, code review, and GitHub review.

---

# 3.2 ADF Connectivity Setup

## 3.2.1 Current Linked Services

Current project inventory:

1. `Ecommerce_REST_API`
2. `LS_ADLS_ECOMMERCE`
3. `LS_ADLS_SNOWFLAKE_STAGE`
4. `LS_AZSQL_CONTROL`
5. `LS_AZURE_DATABRICKS`
6. `LS_SFTP_ECOMMERCE`
7. `LS_SNOWFLAKE_ECOMMERCE`
8. `LS_SQLSERVER_ECOMMERCE_ONPREM`

For each service document: open ADF Studio → Manage → Linked services → + New → connector → authentication → exact project configuration → Test connection → Save → Validate → screenshot → troubleshooting.

## 3.2.2 Current Dataset Inventory

1. `DS_ADLS_CSV_SOURCE`
2. `DS_ADLS_EXCEL_SOURCE`
3. `DS_ADLS_JSON_SOURCE`
4. `DS_ADLS_MULTIPLE_FILE_SINK`
5. `DS_ADLS_MULTIPLE_FILE_SOURCE`
6. `DS_ADLS_PARQUET_SINK`
7. `DS_REST_API_SOURCE`
8. `DS_SFTP_SOURCE`
9. `DS_SNOWFLAKE_ORDERS`
10. `DS_SQL_CONTROL`
11. `DS_SQLSERVER_SOURCE`
12. `DS_SQLSERVER_TABLE_LIST`

## 3.2.3 Parameterized ADLS Dataset Pattern

Example project parameters:

```text
p_container
p_folder_path
p_file_name
```

Runtime examples used by the project:

```text
@activity('Lookup_Get_Job_Metadata').output.value[0].source_path
```

```text
@activity('Lookup_Get_Job_Metadata').output.value[0].file_pattern
```

> If ADF Lookup has **First row only** enabled, use `output.firstRow`. If multiple rows are returned, `output.value` is an array and `[0]` selects the first row.

---

# 3.3 SQL Control Framework

# 3.3.1 Azure SQL Control Database & Control Tables

## Objective

Create the metadata/control layer used by the metadata-driven ADF framework.

Instead of hard-coding every source and pipeline configuration inside ADF, the framework stores configuration in SQL tables.

```text
                 Azure SQL Control DB
                         │
        ┌────────────────┼────────────────┐
        ↓                ↓                ↓
   Source Metadata   Job Metadata    Trigger Metadata
        │                │                │
        └────────────────┼────────────────┘
                         ↓
                  ADF Master Pipeline
                         ↓
                  Read Job Metadata
                         ↓
                  Execute Child Job
                         ↓
                  Log / Watermark
```

## 3.3.1.1 Open Azure Portal

1. Open **Azure Portal**.
2. Sign in.
3. Search for **SQL databases**.
4. Open the SQL database used by the project control framework.
5. Verify that it is the intended project database.

> **VERIFY AGAINST CURRENT ENVIRONMENT:** The exact SQL server/database resource name must be confirmed from the live Azure environment before being frozen as a documentation value.

## 3.3.1.2 Open Query Editor

1. Inside the SQL Database, select **Query editor**.
2. Sign in using the supported authentication method.
3. Wait for the editor to load.
4. Open a new query window.

### SSMS alternative

SQL Server Management Studio can also be used when required. Connect to the same server/database and use a New Query window.

## 3.3.1.3 Verify the Current Database

Run:

```sql
SELECT DB_NAME() AS CurrentDatabase;
```

### Why?

This prevents creating project objects in the wrong database.

### Expected result

The returned database name must match the project control database.

## 3.3.1.4 Control Tables

| Table | Purpose |
|---|---|
| `vb_tbl_source` | Source-system/source-type metadata |
| `vb_tbl_job` | Job-level metadata |
| `vb_tbl_job_dtls` | Detailed key/value configuration for jobs |
| `vb_tbl_trigger` | Trigger metadata |
| `vb_tbl_log_dtls` | Pipeline/job execution logging |
| `vb_tbl_watermark` | Incremental-load watermark tracking |

## 3.3.1.5 Create the Control Tables

Create the tables in this project order:

1. `vb_tbl_source`
2. `vb_tbl_job`
3. `vb_tbl_job_dtls`
4. `vb_tbl_trigger`
5. `vb_tbl_log_dtls`
6. `vb_tbl_watermark`

> **PENDING SOURCE CAPTURE — DO NOT INVENT DDL.** The final version of this section must contain the exact DDL executed for the project, copied from the verified project SQL source or captured from the verified implementation.

## 3.3.1.6 Verify All Six Tables

Run:

```sql
SELECT TABLE_SCHEMA,
       TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME IN
(
    'vb_tbl_source',
    'vb_tbl_job',
    'vb_tbl_job_dtls',
    'vb_tbl_trigger',
    'vb_tbl_log_dtls',
    'vb_tbl_watermark'
)
ORDER BY TABLE_NAME;
```

All six project control tables should be returned.

If one is missing:

1. Check the SQL execution result.
2. Check the database context.
3. Check table-name spelling.
4. Re-run the relevant verified CREATE TABLE statement.

## 3.3.1.7 Verify from SSMS

Refresh the Tables node and confirm:

```text
Database
  └── Tables
      ├── dbo.vb_tbl_source
      ├── dbo.vb_tbl_job
      ├── dbo.vb_tbl_job_dtls
      ├── dbo.vb_tbl_trigger
      ├── dbo.vb_tbl_log_dtls
      └── dbo.vb_tbl_watermark
```

**Screenshot 03.3.1-A — Control tables created successfully**

Capture the database/table list and useful query results. Do not capture credentials.

## 3.3.1.8 Populate Source Metadata

`vb_tbl_source` defines the sources known to the framework.

Project source types include:

```text
Ecommerce CSV
Excel
JSON
REST API
SQL Server
Snowflake
SFTP
Multiple Files
Kafka
```

Use the actual project metadata rows from the verified implementation.

Validation:

```sql
SELECT *
FROM dbo.vb_tbl_source
ORDER BY source_id;
```

**Screenshot 03.3.1-B — `vb_tbl_source` populated**

## 3.3.1.9 Populate Job Metadata

`vb_tbl_job` defines executable jobs.

Known project examples include:

```text
JOB_CSV_ORDERS
JOB_BULK_FILES
JOB_KAFKA_EVENTS
```

Validation:

```sql
SELECT *
FROM dbo.vb_tbl_job
ORDER BY job_id;
```

## 3.3.1.10 Populate Job Detail Metadata

`vb_tbl_job_dtls` stores job-specific configuration as key/value metadata.

Validation:

```sql
SELECT *
FROM dbo.vb_tbl_job_dtls
ORDER BY job_id, dtls_key;
```

Configuration concepts used by the project include:

```text
source_path
file_pattern
target_container
target_path
layer_name
load_type
pipeline_name
eventhub_namespace
eventhub_name
consumer_group
bootstrap_server
```

The exact current values must come from verified project metadata.

## 3.3.1.11 Bulk File Job Example

Known project metadata:

```text
job_id             = 17
job_name           = JOB_BULK_FILES
source_id          = 44
layer_name         = LANDING
load_type          = FULL
pipeline_name      = PL_MASTER_INGESTION
file_pattern       = *
source_path        = /incoming/bulk
target_container   = landing
target_path        = ecommerce/multiple_files
```

Known successful log example:

```text
job_status       = SUCCESS
records_read     = 4
records_written  = 4
source_file      = *
target_path      = ecommerce/multiple_files
```

## 3.3.1.12 Kafka/Event Hub Job Example

Known project metadata:

```text
job_id               = 18
job_name             = JOB_KAFKA_EVENTS
source_id            = 45
layer_name           = BRONZE
load_type            = STREAMING
pipeline_name        = PL_MASTER_INGESTION
active_flag          = TRUE
eventhub_namespace   = eh-vb-ecommerce-dev
eventhub_name        = ecommerce_orders
consumer_group       = $Default
bootstrap_server     = eh-vb-ecommerce-dev.servicebus.windows.net:9093
target_container     = landing
target_path          = ecommerce/kafka/bronze/ecommerce_orders
```

> Kafka/Event Hubs streaming is implemented separately using Databricks Structured Streaming. It is not presented as a normal finite batch child branch of the master pipeline.

## 3.3.1.13 Final Control Framework Validation

Run:

```sql
SELECT *
FROM dbo.vb_tbl_source
ORDER BY source_id;

SELECT *
FROM dbo.vb_tbl_job
ORDER BY job_id;

SELECT *
FROM dbo.vb_tbl_job_dtls
ORDER BY job_id, dtls_key;
```

Confirm sources, jobs, details, IDs, paths, target containers, active flags, and pipeline names are correct.

## 3.3.1.14 Evidence Checklist

- [ ] Database opened
- [ ] Query Editor connected
- [ ] `SELECT DB_NAME()` result
- [ ] Six control tables created
- [ ] `vb_tbl_source` populated
- [ ] `vb_tbl_job` populated
- [ ] `vb_tbl_job_dtls` populated
- [ ] Validation queries successful
- [ ] SSMS/Object Explorer evidence

---

# 3.4 Stored Procedures

The project control framework uses:

1. `dbo.vb_start_log_entry`
2. `dbo.vb_end_log_entry`
3. `dbo.vb_get_job_dtls`
4. `dbo.vb_get_job_config`
5. `dbo.vb_update_watermark`

For each procedure document: purpose, where to open the SQL editor, exact CREATE/ALTER script, parameters, how ADF calls it, expected output, validation, failure behavior, and screenshot.

## 3.4.1 `vb_start_log_entry`

Purpose: insert a log entry when a pipeline/job starts.

The exact current project procedure definition must be copied from the verified project implementation.

## 3.4.2 `vb_end_log_entry`

Purpose: update the running log record when the job finishes.

Current verified procedure:

```sql
CREATE PROCEDURE dbo.vb_end_log_entry
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
```

### Logging rules

- Do not pass the string `'NULL'` to an integer parameter.
- Use a numeric value or actual null where appropriate.
- Failure error text should use the actual activity error message.
- `target_path` must contain the target path, not the source file pattern.

## 3.4.3 `vb_get_job_dtls`

Purpose: retrieve detailed configuration for a selected job.

Document the exact current implementation and ADF activity that calls it.

## 3.4.4 `vb_get_job_config`

Purpose: fetch job configuration dynamically for a trigger/job and expose the configuration for ADF execution.

Document parameters, Lookup activity, result structure, First row only behavior, and `.output.firstRow` versus `.output.value`.

## 3.4.5 `vb_update_watermark`

Purpose: update the incremental-load watermark after a successful incremental load.

Document source/job key, watermark column, previous value, new value, update timing, and failure behavior.

---

# 3.5 ADF Linked Services

Document each of the eight current linked services individually.

Standard flow:

```text
OPEN ADF
  ↓
MANAGE
  ↓
LINKED SERVICES
  ↓
+ NEW
  ↓
SELECT CONNECTOR
  ↓
ENTER CONFIGURATION
  ↓
AUTHENTICATE
  ↓
TEST CONNECTION
  ↓
SAVE
  ↓
VALIDATE
```

Linked services:

- `Ecommerce_REST_API`
- `LS_ADLS_ECOMMERCE`
- `LS_ADLS_SNOWFLAKE_STAGE`
- `LS_AZSQL_CONTROL`
- `LS_AZURE_DATABRICKS`
- `LS_SFTP_ECOMMERCE`
- `LS_SNOWFLAKE_ECOMMERCE`
- `LS_SQLSERVER_ECOMMERCE_ONPREM`

---

# 3.6 Datasets, Parameters & Dynamic Paths

Document every current dataset.

For each dataset:

1. Open ADF Studio.
2. Open **Author**.
3. Open **Datasets**.
4. Select the dataset.
5. Explain the linked service.
6. Explain the dataset type.
7. Explain parameters.
8. Explain connection/path.
9. Explain dynamic expressions.
10. Test/preview where applicable.
11. Capture screenshot.

### Wildcard rule

A wildcard such as:

```text
orders_*.csv
```

must be handled using the appropriate Copy activity wildcard configuration. Do not assume a dataset filename field interprets a wildcard as a pattern.

### Sink-path rule

Avoid duplicating the container/path.

Correct pattern:

```text
File system/container = @dataset().p_container
Directory              = @dataset().p_folder_path
File name              = dynamic/blank as required
```

---

# 3.7 Master Pipeline

## Pipeline

```text
PL_MASTER_INGESTION
```

Document every activity in order.

Teaching flow:

```text
Trigger
  ↓
Get Job Metadata
  ↓
Lookup / Metadata Retrieval
  ↓
Select Job
  ↓
Execute Child Pipeline
  ↓
Start Log
  ↓
Copy/Process
  ↓
Success or Failure
  ↓
End Log
  ↓
Watermark Update
```

For every activity document activity type, name, where it is added, configuration, dynamic content, dependency, expected output, screenshot, and troubleshooting.

---

# 3.8 Source-Specific Child Pipelines

Current batch child pipelines:

1. `PL_INGEST_CSV`
2. `PL_INGEST_EXCEL`
3. `PL_INGEST_JSON`
4. `PL_INGEST_SQL`
5. `PL_INGEST_SFTP`
6. `PL_INGEST_MULTIPLE_FILE`
7. `PL_INGEST_SNOWFLAKE`
8. `PL_INGEST_REST_API`

Streaming orchestration:

9. `PL_INGEST_KAFKA`

> `PL_INGEST_KAFKA` is documented as the streaming orchestration path; Kafka/Event Hubs ingestion itself is implemented through Databricks Structured Streaming.

Each pipeline gets its own complete click-by-click section.

---

# 3.9 ADLS Landing → Bronze

Document landing structure, file arrival, Copy activity, file format, target format, Bronze storage, validation, row counts, file counts, and failure handling.

---

# 3.10 Databricks Transformation

## Current workspace

```text
dbw-vb-ecommerce-dev
```

## Current cluster

```text
cmp-vb-ecommerce-dev
```

> 🚨 **START COMPUTE NOW — `cmp-vb-ecommerce-dev`. Allow 5+ minutes.**

Only display this warning before a step that actually requires compute.

Document workspace navigation, compute, cluster configuration, catalog, schemas, storage credentials, external locations, permissions, secret scope, notebooks, and jobs.

Current catalog:

```text
vb_ecommerce
```

Current schemas include:

```text
bronze
silver
gold
control
default
information_schema
```

---

# 3.11 Bronze / Silver / Gold

Transformation notebook:

```text
NB_VB_ECOMMERCE_bronze_silver_TRANSFORMATION.ipynb
```

Actual flow:

```text
LANDING
   ↓
READ
   ↓
BUSINESS-KEY DEDUPLICATION
   ↓
BRONZE
   ↓
CLEAN / TRANSFORM
   ↓
SILVER
   ↓
GOLD
```

Document Delta tables, Delta history, time travel, OPTIMIZE, ZORDER, ADLS Parquet outputs, Unity Catalog external locations, bad-path testing, and storage access validation.

> `OPTIMIZE` and `ZORDER` apply to Delta tables, not plain Parquet files.

---

# 3.12 SCD1 / SCD2

Transformation notebook:

```text
NB_VB_ECOMMERCE_GOLD_TRANSFORMATIONS.ipynb
```

## SCD1

```text
Existing record
      ↓
Changed source value
      ↓
UPDATE current row
```

## SCD2

```text
Existing current row
      ↓
Detect business change
      ↓
Expire old row
      ↓
Insert new version
```

SCD1 and SCD2 are alternative dimension-history strategies; they are not sequential processing stages.

### Known lessons

- Do not explicitly insert an identity-generated `CustomerKey` for a new SCD2 row.
- If `CustomerStatus` is absent from the source, derive it from available source logic before selecting it.
- A `NameError` such as `change_condition is not defined` can occur when the defining notebook cell has not been executed.

---

# 3.13 Kafka / Event Hubs Streaming

## Architecture

```text
Azure Event Hubs
      ↓
Kafka Protocol
      ↓
Databricks Structured Streaming
      ↓
JSON Parsing
      ↓
Bronze Delta
      ↓
Checkpoint
```

Notebook: `NB_KAFKA_BRONZE_INGESTION`  
Job: `JOB_KAFKA_BRONZE_INGESTION`  
Task: `KAFKA_BRONZE_STREAM`  
Pipeline: `PL_INGEST_KAFKA`

### Secure secret retrieval

```python
EH_CONN_STR = dbutils.secrets.get(
    scope="vb-ecommerce-secrets",
    key="eventhub-connection-string"
)
```

Never replace this with a hard-coded connection string.

### Bronze path

```text
abfss://landing@adlsvbecommercedev.dfs.core.windows.net/ecommerce/kafka/bronze/ecommerce_orders
```

### Checkpoint path

```text
abfss://landing@adlsvbecommercedev.dfs.core.windows.net/ecommerce/kafka/checkpoint/ecommerce_orders
```

### Operational behavior

A continuous streaming query is intentionally long-running.

```text
ADF activity timeout
        ≠
Databricks streaming workload failure
```

Do not break a working continuous stream merely to make an ADF orchestration activity finish.

---

# 3.14 Snowflake

Current project configuration:

```text
Database  = VB_ECOMMERCE_SF
Schema    = ECOMMERCE
Warehouse = VB_ECOMMERCE_WH
```

Source table:

```text
CUSTOMER_ORDERS
```

The project SQL source contains database, schema, warehouse, table, sample data, Azure storage integration, stage, Parquet export, verification, and incremental-load test logic.

Source file:

```text
snw-databse-schema creation.sql
```

Document opening Snowflake, creating database/schema/warehouse/table/test data, storage integration, external stage, Azure staging, ADF linked service, dataset, full load, incremental load, watermark, validation, and connection troubleshooting.

### Incremental-load lesson

If the watermark equals the current maximum `MODIFIED_DATE`, an incremental query can correctly return zero rows.

For a test:

1. Update an existing record with a newer `MODIFIED_DATE`, or insert a new record with a newer timestamp.
2. Run the incremental query.
3. Verify only new/changed data is selected.
4. Validate the new maximum watermark.

---

# 3.15 Execution, Validation & Troubleshooting

Every component should have an execution record:

```text
Test ID:
Component:
Date:
Input:
Expected:
Actual:
Status:
Evidence:
Issue:
Root Cause:
Fix:
Retest:
Final Result:
```

## Common ADF issues captured by this project

### ADLS Forbidden

Investigate permissions, authentication, firewall/network settings, and identity/access configuration.

### ADLS File Not Found / FilesystemNotFound

Verify storage account, container/file system, directory, filename, wildcard configuration, and dataset parameters.

### Sink path duplication

If the output becomes something like:

```text
landing/landing/...
```

check whether the container/path has been configured at more than one layer.

### Lookup array issue

Multiple rows:

```text
@activity('Lookup_Get_Job_Metadata').output.value[0].source_path
```

First row only:

```text
@activity('Lookup_Get_Job_Metadata').output.firstRow.source_path
```

### Logging data-type issue

Do not send:

```text
'NULL'
```

to an integer parameter. Use an appropriate numeric value or actual null where supported.

---

# 3.16 Cost Control & Cleanup

Before stopping/deleting resources, capture screenshots, successful runs, Databricks output, Event Hub test result, Snowflake result, SQL metadata, GitHub code, and configuration evidence.

### Databricks

Stop compute when not in use.

### Event Hubs

If the streaming POC is complete and no further live demo is needed, consider deleting the Event Hubs resource after preserving the evidence and configuration. Standard tier capacity can incur ongoing cost while provisioned.

### Azure SQL

Review the current SKU and pause/cleanup options before leaving the environment running.

### Do not delete the whole project blindly

Keep the resources needed for remaining transformation/documentation work unless the project is genuinely complete.

---

# 4. Screenshot Standards

Every implementation screenshot should have:

```text
Screenshot ID
Component
What it proves
Where it belongs in PPT
Where it belongs in Markdown
```

Example:

```text
Screenshot 03.3.1-A
Control tables created
Proves all six SQL control tables exist
PPT: 03.3.1
MD: 03.3.1.7
```

Do not take screenshots just to fill pages. A screenshot must prove configuration, execution, validation, result, error, fix, or final working state.

---

# 5. Security Standards

Never document actual passwords, access keys, SAS tokens, client secrets, Databricks PATs, connection strings, or private keys.

Use:

```text
<REDACTED>
```

or explain the secure mechanism used.

The project should teach secret management, least privilege, secure authentication, no credentials in Git, no credentials in screenshots, no credentials in notebooks, and no credentials in Markdown.

---

# 6. Final Reproduction Checklist

## Azure

- [ ] Resource group
- [ ] ADLS Gen2
- [ ] containers
- [ ] SQL
- [ ] Key Vault
- [ ] Event Hubs

## ADF

- [ ] Linked services
- [ ] SHIR
- [ ] datasets
- [ ] parameters
- [ ] expressions
- [ ] master pipeline
- [ ] child pipelines
- [ ] logging
- [ ] watermark

## Databricks

- [ ] workspace
- [ ] compute
- [ ] catalog
- [ ] schemas
- [ ] storage credentials
- [ ] external locations
- [ ] secrets
- [ ] notebooks
- [ ] jobs
- [ ] Bronze
- [ ] Silver
- [ ] Gold
- [ ] SCD1
- [ ] SCD2

## Streaming

- [ ] Event Hub
- [ ] Kafka protocol
- [ ] Structured Streaming
- [ ] JSON parsing
- [ ] checkpoint
- [ ] Bronze Delta
- [ ] test event
- [ ] validation

## Snowflake

- [ ] database
- [ ] schema
- [ ] warehouse
- [ ] source table
- [ ] sample data
- [ ] Azure stage
- [ ] ADF connection
- [ ] full load
- [ ] incremental load
- [ ] watermark validation

## Documentation

- [ ] screenshots
- [ ] actual code
- [ ] actual SQL
- [ ] actual ADF expressions
- [ ] errors
- [ ] root causes
- [ ] fixes
- [ ] final validation
- [ ] cost cleanup
- [ ] GitHub source-of-truth check

---

# 7. Maintenance Rule

Whenever the project changes:

```text
CHANGE IMPLEMENTATION
        ↓
VERIFY
        ↓
UPDATE REPOSITORY
        ↓
UPDATE THIS REFERENCE
        ↓
UPDATE PPT SUMMARY
```

Never update the PPT alone.

The technical reference must remain synchronized with the actual implementation.

---

# 8. Implementation Status

| Section | Status |
|---|---|
| 03.1 Environment & Access | Foundation documented |
| 03.2 ADF Connectivity | Foundation documented |
| 03.3 SQL Control Framework | In progress — exact table DDL to be captured from verified implementation |
| 03.4 Stored Procedures | Structure documented; remaining exact procedures to be captured |
| 03.5 Linked Services | Structure documented |
| 03.6 Datasets | Structure documented |
| 03.7 Master Pipeline | To be expanded from actual pipeline JSON |
| 03.8 Child Pipelines | To be expanded from actual pipeline JSON |
| 03.9 ADLS → Bronze | To be expanded |
| 03.10 Databricks | To be expanded from actual notebooks/config |
| 03.11 Silver / Gold | To be expanded from actual notebooks |
| 03.12 SCD1 / SCD2 | To be expanded from actual notebook implementation |
| 03.13 Kafka / Event Hubs | Implementation evidence available; detailed runbook to be expanded |
| 03.14 Snowflake | Actual SQL source available; detailed runbook to be expanded |
| 03.15 Troubleshooting | Project issues captured; expand with evidence |
| 03.16 Completion | Finalize after all components are validated |

---

## Golden Rule

> **If a student cannot reproduce the implementation from this document, the implementation documentation is not finished.**

> **If the PPT becomes difficult to present because it contains too much technical detail, that detail belongs here instead.**
