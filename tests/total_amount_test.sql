-- Return records where Subscription Amount is negative or null
select
    id,
    invoice_id,
    sum(amount) as total_amount
from {{ source("billing_data", "invoice_item") }}
group by 1,2
having total_amount < 0 OR total_amount is null