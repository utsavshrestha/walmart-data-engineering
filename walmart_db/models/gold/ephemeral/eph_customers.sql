select
    distinct
    customer_id,
    first_name as customer_firstname,
    last_name as customer_lastname,
    email as customer_email,
    phone as customer_phone,
    city as customer_city,
    country as customer_country,
    customer_created_timestamp,
    customer_updated_timestamp,
    current_timestamp() as processed_at
from {{ ref("metadata_driven_ingestion") }}
    