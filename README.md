## MMR - Data Modelling - Higor Kirchermair

From the raw tables provided it was developed a pipeline of data modelling in DBT to create a refined table that will be connected to the BI.

- **Part 1**: BigQuery Initial Treatment Procedures
- **Part 2**: DBT Data Modeling Code
- **Part 3**: DBT Data Quality Tests

## Part 1 - Pre Processing

- **Table 1**: SQL procedure [billing_data_invoice.sql](billing_data_invoice.sql) for improving source table columns names.
- **Table 2**: SQL procedure [billing_data_invoice_item.sql](billing_data_invoice_item.sql) for making source table partitioned for later incremental ingestion.
- **Table 3**: Conversion values coming from an interface that can be easily updated and reflect directly in the Data Warehouse with no extra work ([Google Sheets](https://docs.google.com/spreadsheets/d/1CUUtUdnuPlH4g4a3AZ4ZWlcE_8nT1KFKyu0Q70V-OS0/edit#gid=0)).

## Part 2 - DBT Modelling

It was followed a granular modelling strategy, **MRR_refined** Model in DBT that builds a by-day records for each pair invoice-item that extends from the period start to period end. For example: A unique subscription that lasts for **30 days** will have a **total amount/30** daily average value so to be able to build the BI from the different segmentations we want. From the **most granular (day - customer - item)** to the **most grouped (year - quarter)**.

The analytical table increase in row size and the query efficiency was improved with partitioning by day - where BI will use to filter the desired period to not use the whole table - and the ingestion is being developed with incremental strategy, so each run we do an update of the registries instead of recreated the table every time.

```python
    config(
        materialized="incremental",
        unique_key="id",
        incremental_strategy="merge",
        partition_by={
            "field": "subscription_date",
            "data_type": "date",
            "granularity": "day",
        }
```

## Part 3 - Data Quality Tests
We have developed 4 specific tests considering this project data scenario.
- [currency_missing_test.sql](tests/currency_missing_test.sql): Return records where the currency in source was not mapped in conversion table.
- [invoice_missing_customer.sql](tests/invoice_missing_customer.sql): Return records where customer is not found.
- [period_dates_test.sql](tests/period_dates_test.sql): Return records where period end is before period start.
- [total_amount_test.sql](tests/total_amount_test.sql): Return records where Subscription Amount is negative or null.

## Authors

- **Higor Kirchermair** - *February, 2024* 
