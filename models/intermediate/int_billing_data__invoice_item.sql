{{
    config(
        materialized="table",
        unique_key="id",
        partition_by={
            "field": "period_end_day",
            "data_type": "date",
            "granularity": "day",
        },
    )
}}


with

    staging as (select * from {{ ref("stg_billing_data__invoice_item") }}),

    inter as (

        select
            type,
            period_end_ts,
            period_end_day,
            period_start_day,
            period_start_ts,
            case
                when date_diff(period_end_day, period_start_day, day) = 0
                then 1
                else date_diff(period_end_day, period_start_day, day)
            end period_diff,
            amount,
            currency,
            {{ eur_conversion("currency", "amount") }} as amount_in_eur,
            _synced,
            invoice_id,
            id

        from staging s

    )

select *
from inter
