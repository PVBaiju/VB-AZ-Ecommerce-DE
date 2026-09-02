# Environment Prerequisites

## 1. Purpose

This document defines the software, Azure services, accounts, permissions, connectivity, and subscription requirements needed to build and execute the **VB-AZ-Ecommerce-DE** end-to-end Azure Data Engineering project.

The project contains batch and streaming ingestion using Azure Data Factory, ADLS Gen2, Azure Databricks, Azure SQL, Snowflake, SFTP, REST API, and Azure Event Hubs/Kafka.

---

## 2. Important: Choose the Correct Learning/Subscription Option

| Option | Suitable for this complete project? | What it provides | Recommendation |
|---|---|---|---|
| **Databricks Free Edition** | **No – only partial practice** | Serverless Databricks for learning; limited compute and features | Good for learning Databricks concepts, but cannot reproduce the complete Azure-integrated project |
| **Azure Databricks Trial** | **Yes, for temporary POC/testing** | Full Azure Databricks platform with trial DBU credits for 14 days | Recommended for students who want to reproduce the Azure Databricks portion temporarily |
| **Azure Pay-As-You-Go** | **Yes – full project** | Full Azure services and Azure-integrated architecture | Recommended for the complete project/PDC/POC implementation |

### Current Microsoft guidance

- Azure Databricks **Free Edition** is intended for students, educators, hobbyists, and learning. It is serverless-only and has feature/usage limits.
- Azure Databricks **Free Trial** is intended for evaluating the full platform and provides free Databricks usage credits for 14 days.
- For the Azure Databricks trial, Microsoft currently requires an Azure subscription that is **not an Azure Free Trial subscription**; if starting from an Azure free account, Microsoft instructs users to move to Pay-As-You-Go, remove the spending limit, and request regional vCPU quota as required.
- After the trial/credits are exhausted, Azure Databricks usage is billed according to the selected Azure/Databricks pricing model.

References:
- Microsoft Learn – Azure Databricks Free Trial: https://learn.microsoft.com/en-us/azure/databricks/getting-started/free-trial
- Microsoft Learn – Free Trial vs Free Edition: https://learn.microsoft.com/en-us/azure/databricks/getting-started/free-trial-vs-free-edition
- Microsoft Learn – Free Edition limitations: https://learn.microsoft.com/en-us/azure/databricks/getting-started/free-edition-limitations
- Azure Databricks Pricing: https://azure.microsoft.com/en-us/pricing/details/databricks/

---

## 3. Overall Project Prerequisite Matrix

| Area / POC | Required software/account/service | Install required? | Subscription / cost requirement | Used in this project |
|---|---|---:|---|---|
| Azure account | Microsoft Azure account | No | **Pay-As-You-Go recommended for complete project** | Yes |
| Resource Group | Azure Resource Group | No | Azure resource | `rg-vb-az-ecommerce-dev` |
| ADLS Gen2 | Azure Storage Account with hierarchical namespace | No | Azure storage charges may apply | `adlsvbecommercedev` |
| Azure Data Factory | Azure Data Factory | No | Azure service; activity/IR usage may incur charges | Yes |
| Self-hosted Integration Runtime | SHIR on Windows machine | **Yes** | Machine must remain available while on-prem SQL ingestion runs | `SHIR-ECOMMERCE-ONPREM` |
| Azure SQL Database | Azure SQL Server + Database | No | Azure SQL charges may apply | `sqldb-vb-ecommerce-dev` |
| Azure Databricks | Azure Databricks workspace | No | Trial credits or Pay-As-You-Go | `dbw-vb-ecommerce-dev` |
| Databricks compute | Cluster / job compute | No | **Consumes DBUs + underlying Azure compute when running** | `cmp-vb-ecommerce-dev` |
| Unity Catalog | Databricks Unity Catalog | No | Depends on workspace/tier/features | `vb_ecommerce` catalog |
| Key Vault | Azure Key Vault | No | Azure service; charges may apply depending on operations/tier | `kv-vb-ecommerce-dev` |
| Databricks secrets | Databricks secret scope | No | Databricks feature | `vb-ecommerce-secrets` |
| Snowflake | Snowflake account/trial | No | Snowflake trial/paid account | Snowflake POC |
| SFTP | SFTP server/storage endpoint | No for Azure Storage SFTP | Azure storage + SFTP feature charges may apply | Azure Storage SFTP |
| REST API | Accessible REST API endpoint | No | Depends on API provider | REST API POC |
| Event Hubs | Azure Event Hubs namespace + event hub | No | **Azure service; Standard tier used in project** | `eh-vb-ecommerce-dev` / `ecommerce_orders` |
| Kafka | Kafka-compatible Event Hubs endpoint | No separate Kafka installation for this POC | Event Hubs cost applies | Kafka POC |
| Power BI | Power BI Desktop | **Yes** | Desktop is free; Power BI service licensing may apply for sharing/collaboration | Final reporting |
| Git | Git + GitHub account | Recommended | GitHub Free is sufficient for repository work | Project source control |
| Browser | Chrome / Edge | Yes | Free | Azure / ADF / Databricks / GitHub |
| VS Code | Visual Studio Code | Recommended | Free | Editing/maintaining project files |

---

## 4. What Students Need to Install on Their Laptop

### Mandatory

1. **Modern web browser**
   - Google Chrome or Microsoft Edge
   - Required for Azure Portal, ADF, Databricks, Snowflake, Power BI Service, and GitHub.

2. **Power BI Desktop**
   - Required for building and testing the reporting layer.

3. **Git**
   - Required if students clone/pull/push the project repository locally.

### Recommended

4. **Visual Studio Code**
   - Recommended for editing JSON, Markdown, Python, SQL, and project files.

5. **Python**
   - Not required for the main Azure POC because PySpark runs inside Databricks.
   - Useful for local development, REST API testing, utilities, and interview practice.

6. **Postman** (optional)
   - Useful for testing REST APIs.
   - Not required if the API can be tested directly from ADF.

### No local installation required

The following are cloud services and normally do not require local installation:

- Azure Data Factory
- ADLS Gen2
- Azure SQL Database
- Azure Databricks
- Unity Catalog
- Azure Key Vault
- Azure Event Hubs
- Snowflake
- Azure Storage SFTP endpoint

---

## 5. Azure Services Required for the Complete Project

Create the following resources before starting the corresponding POCs:

| Azure resource | Purpose | Needed from which phase |
|---|---|---|
| Resource Group | Logical resource management | Project start |
| ADLS Gen2 Storage | Landing, Bronze, Silver, Gold and supporting data | Storage / ingestion |
| Azure Data Factory | Metadata-driven orchestration and ingestion | ADF framework |
| Self-hosted IR | Connect ADF to on-prem SQL Server | SQL Server POC |
| Azure SQL Database | Control tables, metadata, logging, watermark and stored procedures | Control framework |
| Azure Databricks | Spark processing and Delta Lake | Databricks / transformation |
| Unity Catalog | Data governance/cataloging where enabled | Databricks governance |
| Azure Key Vault | Secure secrets | Security / external connections |
| Event Hubs | Streaming event source | Kafka/Event Stream POC |

Optional/external services:

- Snowflake account
- SFTP endpoint
- REST API endpoint
- On-prem SQL Server and Windows machine for SHIR
- Power BI

---

## 6. Subscription Guidance: When to Use Free Edition, Trial, or Pay-As-You-Go

### A. Databricks Free Edition

Use this when the objective is only to learn Databricks concepts such as:

- PySpark
- DataFrames
- Delta Lake
- Basic streaming concepts
- Lakeflow concepts where supported
- SQL and catalog exploration

**Important:** Free Edition is serverless-only, does not provide classic compute, and has usage/feature limitations. It should not be presented as a full replacement for this Azure project.

### B. Azure Databricks Trial

Use this when the objective is to reproduce the **Azure Databricks portion** of the project temporarily.

Microsoft currently provides trial DBU credits for 14 days. The Azure Databricks trial is intended for evaluation of the full platform.

Before starting, verify:

- Azure subscription eligibility
- Regional vCPU quota
- Required Azure permissions
- Trial availability
- Cost/credit status

### C. Azure Pay-As-You-Go

Use Pay-As-You-Go when students want to perform the **complete Azure project**, including:

- ADLS Gen2
- ADF
- Azure SQL
- Self-hosted IR
- Azure Databricks
- Key Vault
- Event Hubs/Kafka
- Azure Storage SFTP
- Azure networking/integration

This is the recommended environment for reproducing the complete project architecture.

**Important:** Pay-As-You-Go means Azure usage is billable. Students should create a budget/alert, use the smallest practical compute configuration, and stop/terminate compute immediately after testing.

---

## 7. POC-by-POC Prerequisites

| POC | Prerequisites before starting | Compute needed? | Subscription requirement |
|---|---|---:|---|
| CSV ingestion | Azure Storage + ADF + source CSV + ADLS datasets | No Databricks compute for ADF copy | Azure subscription |
| Excel ingestion | Azure Storage + ADF + Excel source + appropriate dataset/configuration | No Databricks compute for ADF copy | Azure subscription |
| JSON ingestion | Azure Storage + ADF + JSON source + ADLS datasets | No Databricks compute for ADF copy | Azure subscription |
| SQL Server ingestion | On-prem SQL Server + Windows machine + SHIR + ADF + network connectivity | No Databricks compute for ADF copy | Azure subscription + on-prem machine |
| SFTP ingestion | SFTP endpoint + credentials/host key + ADF | No Databricks compute for ADF copy | Azure subscription + SFTP source |
| Multiple-file ingestion | Source folder containing multiple files + ADF + suitable datasets | No Databricks compute for ADF copy | Azure subscription |
| Snowflake ingestion | Snowflake account + warehouse/database/schema/table + Azure staging/connection configuration | No Databricks compute for ADF copy | Azure + Snowflake |
| REST API ingestion | API URL + authentication if required + ADF REST linked service | No Databricks compute for ADF copy | Azure + API availability |
| Kafka/Event Hubs | Event Hubs namespace + event hub + Kafka-compatible endpoint + Key Vault + Databricks secret | **Yes – only when running Databricks streaming** | Azure subscription |
| Databricks Bronze/Silver/Gold | Databricks workspace + ADLS access + Delta configuration | **Yes** | Azure Databricks |
| SCD1/SCD2 | Source data + Delta target tables + Spark/Delta environment | **Yes** | Azure Databricks |
| OPTIMIZE/ZORDER | Delta tables + Databricks compute | **Yes** | Azure Databricks |
| Power BI | Power BI Desktop + Gold data | No Databricks compute for visualization itself | Power BI licensing depends on sharing requirements |

---

## 8. On-Prem SQL Server Prerequisites

The SQL Server POC requires an accessible Windows/on-premises environment.

Required:

- SQL Server installed and running
- Source tables available
- Windows machine/server to host SHIR
- Self-hosted Integration Runtime installed
- SHIR registered with Azure Data Factory
- Network connectivity from SHIR machine to SQL Server
- SQL authentication or Windows authentication as configured
- Required firewall rules/ports opened
- ADF linked service tested successfully

Source tables used in the project include:

- Customers
- Products
- Stores
- SalesOrders
- SalesOrderItems
- Payments

---

## 9. Kafka / Event Hubs Prerequisites

For the completed Kafka POC:

- Azure Event Hubs namespace
- Event Hub: `ecommerce_orders`
- Kafka-compatible endpoint
- Event Hub connection string/policy
- Azure Key Vault
- Databricks secret scope
- Databricks workspace
- Structured Streaming-capable Databricks runtime
- Delta/ADLS target location
- Checkpoint location

Test events used in the POC:

- Order 1001
- Order 1002
- Order 1003
- Order 1004

The project uses **Databricks Structured Streaming** for the Kafka/Event Hubs implementation.

Lakeflow Declarative Pipelines were evaluated separately but are **not part of the completed Kafka implementation** in this project.

---

## 10. Cost-Control Rules for Students

This project contains cloud services that can incur charges. Follow these rules:

1. Do not leave Databricks clusters running when not required.
2. Do not leave continuous Structured Streaming jobs running after testing.
3. Use the smallest practical cluster for a POC.
4. Check the Azure subscription cost/budget before starting a long-running workload.
5. Stop/terminate compute immediately after verification.
6. Do not delete resources unnecessarily; stop/terminate compute where possible so the project can be reused.
7. For streaming POCs, remember that a continuous stream can remain active and consume compute even when no new events are being produced.
8. For Azure Databricks trial accounts, monitor remaining trial credits and the trial end date.
9. Pay-As-You-Go users should create Azure Cost Management budgets and alerts.

---

## 11. Recommended Student Setup

### Minimum learning setup

```text
Laptop
  |
  +-- Chrome / Edge
  +-- Git
  +-- VS Code (recommended)
  +-- Power BI Desktop
  |
  +-- Databricks Free Edition
```

Suitable for learning:

- PySpark
- Delta Lake
- Databricks notebooks
- SQL
- Basic streaming concepts

### Full project setup

```text
Laptop
  |
  +-- Chrome / Edge
  +-- Git
  +-- VS Code
  +-- Power BI Desktop
  |
  +-- Azure Pay-As-You-Go
        |
        +-- ADLS Gen2
        +-- Azure Data Factory
        +-- Azure SQL
        +-- SHIR + On-Prem SQL Server
        +-- Azure Databricks
        +-- Unity Catalog
        +-- Key Vault
        +-- Event Hubs / Kafka
        +-- SFTP
        |
        +-- Snowflake account
        +-- REST API
```

---

## 12. Before Starting the POCs – Checklist

- [ ] Azure account available
- [ ] Correct Azure subscription selected
- [ ] Pay-As-You-Go enabled for the complete Azure project where required
- [ ] Azure spending/budget alerts configured
- [ ] Resource group created
- [ ] ADLS Gen2 created
- [ ] ADF created
- [ ] Azure SQL Database created
- [ ] Control tables and stored procedures created
- [ ] Databricks workspace created
- [ ] Databricks access verified
- [ ] Unity Catalog configured if used
- [ ] Key Vault created
- [ ] Required secrets stored securely
- [ ] Event Hubs created for Kafka POC
- [ ] Snowflake account available for Snowflake POC
- [ ] SFTP endpoint available for SFTP POC
- [ ] REST API endpoint available for REST API POC
- [ ] On-prem SQL Server available
- [ ] SHIR installed and registered
- [ ] Power BI Desktop installed
- [ ] Git/GitHub access verified
- [ ] Project repository cloned or accessible

---

## 13. Project-Specific Environment

The completed POC uses the following environment naming:

| Component | Project value |
|---|---|
| Resource Group | `rg-vb-az-ecommerce-dev` |
| Region | Central India |
| ADLS Gen2 | `adlsvbecommercedev` |
| Databricks Workspace | `dbw-vb-ecommerce-dev` |
| Databricks Cluster | `cmp-vb-ecommerce-dev` |
| Event Hubs Namespace | `eh-vb-ecommerce-dev` |
| Event Hub | `ecommerce_orders` |
| Key Vault | `kv-vb-ecommerce-dev` |
| Secret Scope | `vb-ecommerce-secrets` |
| ADF | `adfvbecommercedev` |
| SHIR | `SHIR-ECOMMERCE-ONPREM` |

---

## 14. Key Student Message

**Free Edition is excellent for learning Databricks, but it is not the same as having the full Azure environment used in this project.**

For the complete end-to-end POC, students should plan for an Azure subscription and use Pay-As-You-Go when required. The Azure Databricks trial can be used for temporary evaluation, but students must check eligibility, trial duration, credits, regional quota, and Azure resource charges before starting.

Always start with the cheapest practical configuration and stop compute after each POC is verified.
