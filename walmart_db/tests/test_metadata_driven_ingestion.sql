{{
    config(
        severity="warn"
    )
}}

select 1
from 
    {{ ref("metadata_driven_ingestion")}} as mdt
where 
    mdt.order_id is null
or
    mdt.product_id is null
or
    mdt.customer_id is null
or 
    mdt.employee_id is null
or 
    mdt.store_id is null
or 
    mdt.customer_id is null