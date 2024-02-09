-- Return records where period end is before period start
select
    id,
    invoice_id,
    period_start,
    period_end
from {{ source("billing_data", "invoice_item") }}
where period_end > period_start