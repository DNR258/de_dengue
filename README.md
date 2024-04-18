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

The data set is a very detailed time series. I decided to look at the development of new corona cases over the course of the year, on the one hand. In doing so, I would like to compare the development in Germany with the rest of the world. Furthermore, I am interested in the vaccination rate in a worldwide comparison and whether there is a correlation between poverty and excess mortality.
<br>
<br>
Since the data by Our World in Data is updated daily early in the morning, my goal is also to have fresh data every day at 7 am.

## Structure of the Repo
- .github/workflows: .yml-files for GitHub Actions
- dbt: all directories, .yml, .scl files, etc. for the transformations in dbt
- flows: .py files for the prefect flows
- images: used images in the repo
- terraform: terraform files


## Try it yourself
If you want to reproduce my pipeline and play around with the data, you can find the 

## Visualizations
