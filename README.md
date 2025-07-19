# BigQuery Analytics

This repository contains the dbt project for the Jaffle Shop's analytical platform. It's designed to transform raw data from various sources into clean, reliable, and analysis-ready data marts for business intelligence and operational reporting.

## Table of Contents

  - [Overview](https://www.google.com/search?q=%23overview)
  - [Tech Stack](https://www.google.com/search?q=%23tech-stack)
  - [Getting Started](https://www.google.com/search?q=%23getting-started)
      - [Prerequisites](https://www.google.com/search?q=%23prerequisites)
      - [Installation](https://www.google.com/search?q=%23installation)
      - [Configuration](https://www.google.com/search?q=%23configuration)
  - [Running the Project](https://www.google.com/search?q=%23running-the-project)
  - [Project Structure](https://www.google.com/search?q=%23project-structure)
      - [Model Layering Strategy](https://www.google.com/search?q=%23model-layering-strategy)
  - [Data Quality](https://www.google.com/search?q=%23data-quality)

## Overview

The primary goal of this project is to model the Jaffle Shop's data to support key business areas, specifically Finance and Marketing. It follows modern data engineering principles to create a single source of truth for metrics like Lifetime Value (LTV) and order history.

The project handles:

  - Ingesting raw data from source systems (simulated via seeds).
  - Cleaning, deduplicating, and standardizing data.
  - Structuring data into staging, intermediate, and mart layers.
  - Defining relationships and data quality tests to ensure reliability.

## Tech Stack

  - **dbt Core**: For data transformation and modeling.
  - **Google BigQuery**: As the cloud data warehouse.
  - **Python**: For scripting and tooling.
  - **pre-commit**: For code quality control.

## Getting Started

Follow these instructions to get a local copy of the project up and running for development and testing.

### Prerequisites

  - Python 3.13 and `pip`
  - A Google Cloud Platform (GCP) project with BigQuery enabled.
  - A GCP service account keyfile with BigQuery permissions (`roles/bigquery.user`, `roles/bigquery.dataEditor`).
  - dbt Core and the BigQuery adapter (`dbt-bigquery`).

### Installation

1.  **Clone the repository:**

    ```sh
    git clone https://github.com/BrunoChiconato/bigquery-analytics.git
    cd bigquery-analytics
    ```

2.  **Install Python dependencies (including dbt and the BigQuery adapter):**

    ```sh
    pip install dbt-core dbt-bigquery
    ```

### Configuration

This project uses environment variables for dbt profile configuration, which is a security best practice. Create a `.env` file in the root directory or export the following variables in your shell session:

```sh
# .env file
export DBT_PROJECT="your-gcp-project-id"
export DBT_DATASET="your_development_dataset_name" # e.g., dbt_jdoe
export DBT_LOCATION="your-gcp-region" # e.g., US
export DBT_METHOD="service-account"
export DBT_KEYFILE_PATH="/path/to/your/keyfile.json"
export DBT_THREADS=4
export DBT_JOB_TIMEOUT=300
export DBT_PRIORITY="interactive"
export DBT_JOB_RETRIES=1
```

Your local dbt profile, defined in `profiles.yml`, is already configured to read these variables.

## Running the Project

Execute the following commands from the root of the project directory.

1.  **Load Raw Data:**
    This project uses dbt seeds to simulate raw data loading. This command loads the CSV files from the `seeds` directory into your `raw` schema in BigQuery.

    ```sh
    dbt seed
    ```

2.  **Run Models:**
    This command executes all models in the correct order.

    ```sh
    dbt run
    ```

    To run models from a specific sub-directory (e.g., marts):

    ```sh
    dbt run --select marts
    ```

3.  **Test Data Quality:**
    This command runs all data tests defined in the `.yml` files (e.g., `unique`, `not_null`, `relationships`).

    ```sh
    dbt test
    ```

## Project Structure

The project follows a layered modeling approach to promote modularity, reusability, and maintainability.

  - **`models/staging`**: The first layer of transformation.

      - **`base/`**: Contains models that perform initial data cleansing, such as deduplication and unioning of source tables (e.g., `base_jaffle_shop__orders` unions data from 2023 and 2024).
      - Models in this layer connect directly to the raw sources, performing light transformations like column renaming, type casting, and basic calculations. They serve as a clean foundation for downstream models. Example: `stg_jaffle_shop__customers`.

  - **`models/intermediate`**: An optional layer for complex transformations that are shared by multiple downstream models. This helps avoid re-writing complex logic. Example: `int_orders_with_product_details` joins orders with product information.

  - **`models/marts`**: The final layer, providing data in a format ready for business consumption (e.g., BI tools, dashboards).

      - **`finance/`**: Contains financial models, like the `fct_orders` table.
      - **`marketing/`**: Contains marketing-focused models, like `dim_customers` which includes aggregated metrics like LTV.

  - **`macros/`**: Contains custom Jinja macros, such as `generate_schema_name.sql`, which standardizes how database schemas are named across different environments.

### Model Layering Strategy

The data flows through the system as follows:

`Sources (raw)` -> `Staging` -> `Intermediate` -> `Marts`

This layered approach ensures that raw data is separated from transformed data, and business logic is built up in clear, sequential steps.

## Data Quality

Data integrity is enforced through dbt tests. Generic tests (e.g., `unique`, `not_null`) and relationship tests are defined in the `.yml` files alongside their corresponding models. These tests are crucial for validating the data at each stage of the transformation pipeline.
