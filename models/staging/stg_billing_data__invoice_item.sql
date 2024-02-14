with 

source as (

    select * from {{ source('billing_data', 'invoice_item') }}

),

staging as (

    select
        type,
        period_end as period_end_ts,
        DATE(period_end) as period_end_day,
        DATE(period_start) as period_start_day,
        period_start as period_start_ts,
        CAST(amount as INTEGER) as amount,
        currency,
        _synced,
        invoice_id,
        id

    from source

)

select * from staging