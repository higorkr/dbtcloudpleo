{{
    config(
        materialized="incremental",
        unique_key="id",
        incremental_strategy="merge",
        partition_by={
            "field": "subscription_date",
            "data_type": "date",
            "granularity": "day",
        },
    )
}}


with
    invoice_item as (
        select *
        from {{ ref("int_billing_data__invoice_item") }}
        where period_end_day >= period_start_day and amount_in_eur is not null
    -- {% if is_incremental() %}
    -- and a._synced >= timestamp_add(current_timestamp(), interval - 5 day) --
    -- Incremental Strategy
    -- {% endif %}
    ),

    invoice as (select * from {{ ref("stg_billing_data__invoice") }})

select
    concat(a.id, '-', a.invoice_id, '-', unix_date(day)) as id,  -- # New ID daily granular logic
    a.invoice_id,
    a.id as item_id,
    round(a.amount_in_eur / a.period_diff, 2)
    amount_daily_eur,
    a.currency as currency_original,
    a.amount as amount_original,
    c.customer_id,
    a._synced,
    day as subscription_date,
    extract(week from day) as week_num,
    date_trunc(day, week(sunday)) week_date_monday,
    extract(year from day) as year,
    extract(quarter from day) as quarter,
    extract(day from day) as day_of_month,
    extract(dayofweek from day) as day_of_week

from
    invoice_item a,
    unnest(generate_date_array(date(period_start_day), date(a.period_end_day))) as day  -- # Date Array Strategy
left join invoice c on a.invoice_id = c.invoice_id
