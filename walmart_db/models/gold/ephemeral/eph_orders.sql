select 
    order_id, 
    customer_id,
    store_id,
    employee_id,
    order_status, 
    payment_method,
    total_amount,
    order_created_timestamp,
    order_updated_timestamp
from {{ ref("metadata_driven_ingestion") }}

