# Dengue cases in Argentine and the world
Data pipeline for Dengue data visualization

## Technologies
In this project I used:

- Terraform as Infrastructure-as-Code (IaC) for cloud setup,
- Mage AI for orchestration,
- Google Cloud Storage (GCS) as data lake for data storage,
- Google BigQuery as Data Warehouse,
- dbt for the transformation of data the data,
- Google Looker studio for visualizations.

The data pipeline pulls Dengue data from two different sources, loads it into Google Cloud Storage and then into BigQuery using Mage. After that, the data is transformed inside the data warehouse with dbt, and visualized in Looker Studio:

![Mi primer tablero (1)](https://github.com/DNR258/de_dengue/assets/97068501/e1af016c-1c3a-449a-877c-8624496a79b1)

## Problem Description


## Structure of the Repo
- 
- dbt: all directories, .yml, .scl files, etc. for the transformations in dbt
- 
- 
- terraform: terraform files


## Try it yourself
If you want to reproduce this pipeline just follow the instructions.

## Visualizations
