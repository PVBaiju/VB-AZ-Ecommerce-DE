# Azure E-Commerce Data Engineering Project
## Project Plan

**Project Name:** VB-AZ-Ecommerce-DE

**Project Type:** End-to-End Azure Data Engineering Project

**Primary Objective:**  
Build a production-style, metadata-driven e-commerce data engineering platform using Microsoft Azure services. The project will demonstrate batch ingestion, event-driven ingestion, streaming, lakehouse processing, data quality, SCD Type 1, SCD Type 2, data governance, and business reporting.

---

# 1. Project Objective

The objective of this project is to design and implement an end-to-end Azure Data Engineering solution for an e-commerce business.

The platform will ingest data from multiple heterogeneous sources, store the data in Azure Data Lake Storage Gen2, process and transform the data using Azure Databricks, implement Medallion Architecture, maintain historical dimensions using SCD Type 1 and SCD Type 2, and expose business-ready data through Power BI.

The project will also implement a metadata-driven execution framework using Azure Data Factory and a control database to dynamically control ingestion, logging, routing, and configuration.

---

# 2. Source Systems

The project will demonstrate ingestion from the following sources:

| # | Source | Processing Pattern | Primary Tool |
|---|---|---|---|
| 1 | Excel | Batch | Azure Data Factory |
| 2 | CSV | Batch | Azure Data Factory |
| 3 | JSON | Batch | Azure Data Factory |
| 4 | REST API | Batch | Azure Data Factory |
| 5 | Multiple Files | Batch / Dynamic | Azure Data Factory |
| 6 | SQL Server / Relational DB | Batch / Incremental | Azure Data Factory |
| 7 | Snowflake | Batch / Incremental | Azure Data Factory |
| 8 | SFTP | Batch | Azure Data Factory |
| 9 | Kafka / Event Streaming | Streaming | Databricks Structured Streaming |

The final streaming implementation will be selected after evaluating the feasibility and cost of Kafka and/or Azure Event Hubs in the available Azure subscription.

---

# 3. Azure Technologies

The project will use the following technologies:

- Azure Resource Group
- Azure Data Factory
- Azure Data Lake Storage Gen2
- Azure Databricks
- Unity Catalog
- Azure Key Vault
- Azure SQL Database / SQL Server for metadata and control tables
- Azure Event Hubs and/or Kafka for streaming
- Power BI
- GitHub
- PySpark
- Databricks SQL
- Delta Lake

---

# 4. Architecture

The project will follow a layered Medallion Architecture:

```text
Source Systems
      |
      v
Azure Data Factory
      |
      v
ADLS Gen2 - Landing
      |
      v
Bronze
      |
      v
Silver
      |
      v
Gold
      |
      v
Power BI