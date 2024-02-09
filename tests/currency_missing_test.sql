-- Return records where the currency does not match the ones we have mapped.
select
    a.id,
    a.invoice_id,
    a.period_start,
    a.period_end,
    a.currency,
    a.amount
from {{ source("billing_data", "invoice_item") }} a
left join {{ source("billing_data", "currency_conversion") }} b ON a.currency = b.currency
where b.currency is null