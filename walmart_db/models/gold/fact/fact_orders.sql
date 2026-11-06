select
    distinct
    order_id,
    product_id,
    employee_id,
    store_id,
    customer_id,
    total_amount,
    payment_method
from {{ ref("metadata_driven_ingestion") }}
