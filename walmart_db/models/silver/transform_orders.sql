
{{
    config(
        materialized="table",
        unique_key = "order_id"
    )
}}

select 
    *,
    current_timestamp() as processed_at
from 
    {{ source("walmart", "raw_orders")}}
where 
    is_active = 'Y'
{% if is_incremental() %}
    and processed_at >= (select coalesce(max(updated_timestamp), '1900-01-01') from {{ this }})
{% endif %}
