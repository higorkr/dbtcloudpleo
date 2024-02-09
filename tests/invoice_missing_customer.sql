-- Return records where customer is not found
select
    a.id,
    a.invoice_id,
    a.period_start,
    a.period_end,
    c.customer
from {{ source("billing_data", "invoice_item") }} a
left join {{ source("billing_data", "invoice") }} c on a.invoice_id = c.invoice_id
where c.customer_id is null