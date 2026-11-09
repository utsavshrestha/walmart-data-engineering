from airflow.sdk import dag, task
from airflow.operators.bash import BashOperator
@dag
def walmart():
    @task
    def postgres_ingestion():
        return "Ingesting data from Postgres to Databricks"

    @task.bash
    def silver_load():
        return "rm -rf /opt/airflow/walmart_db/target && cd /opt/airflow/walmart_db && dbt run -s metadata_driven_ingestion"


    postgres_ingestion() >> silver_load()

orchestrate_dag = walmart()