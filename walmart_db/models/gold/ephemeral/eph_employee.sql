select
    employee_id,
    employee_first_name,
    employee_last_name,
    employee_job_title,
    employee_salary,
    employee_created_timestamp
from 
{{ ref('metadata_driven_ingestion') }}