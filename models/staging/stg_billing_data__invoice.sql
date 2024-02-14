with 

source as (

    select * from {{ source('billing_data', 'invoice') }}

),

staging as (

    select
        invoice_id,
        customer_id

    from source

)

select * from staging
