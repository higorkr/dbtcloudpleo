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

select
    concat(a.id, '-', a.invoice_id, '-', unix_date(day)) as id,  -- # New ID daily granular logic
    a.invoice_id,
    a.id as item_id,
    case
        when date_diff(a.period_end, a.period_start, day) = 0
        then 1
        else
            round(
                (b.eur_converison * a.amount)
                / date_diff(a.period_end, a.period_start, day),
                2
            )
    end amount_daily_eur,
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
    {{ source("billing_data", "invoice_item") }} a,
    unnest(generate_date_array(date(period_start), date(a.period_end))) as day  -- # Date Array Strategy
left join
    {{ source("billing_data", "currency_conversion") }} b on a.currency = b.currency
left join {{ source("billing_data", "invoice") }} c on a.invoice_id = c.invoice_id
where
    b.currency is not null  -- # Rule 1 for testing
    and period_end >= period_start  -- # Rule 2 for testing


{% if is_incremental() %}
    and a._synced >= timestamp_add(current_timestamp(), interval - 5 day)
-- Here we want to capture last 5 days of change an 'upsert' it with incremental strategy
-- Also we should have raw layer partitioned
-- This should be configured after a first 'full table' run
{% endif %}
