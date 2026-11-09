from airflow.sdk import dag, task
from airflow.providers.standard.operators.bash import BashOperator
@dag
def walmart():
    @task
    def postgres_ingestion():
        return "Ingesting data from Postgres to Databricks"

    @task.bash
    def silver_load():
        return "rm -rf /opt/airflow/walmart_db/target && cd /opt/airflow/walmart_db && dbt run -s metadata_driven_ingestion"

    gold_facts = BashOperator(
        task_id = "gold_facts_table",
        bash_command = "cd /opt/airflow/walmart_db && dbt run -s gold"
    )

    postgres_ingestion() >> silver_load() >> gold_facts

orchestrate_dag = walmart()