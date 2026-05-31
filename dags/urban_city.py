from datetime import datetime, timedelta

from airflow import DAG
from airflow.sdk import task
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow.providers.microsoft.azure.operators.data_factory import (
    AzureDataFactoryRunPipelineOperator
)


from include.transform import transform
from include.upload_raw_data import upload_data

default_args = {
    'owner': 'aviator',
    'depends_on_past': False,
    'start_date': datetime(2026, 5, 31),
    'retries': 1,
    'retry_delay': timedelta(minutes=1),
    'schedule_interval': '@hourly',
    "azure_data_factory_conn_id": "azure-factory",
    "factory_name": "urbancityadf",
    "resource_group_name": "urban-city-rg"  
}


@task()
def extract_data_from_api():
  api_response = upload_data()
  return api_response

@task()
def transform_data():
  clean_data = transform()
  return clean_data

with DAG(dag_id='urban_city_requests', 
         catchup=False, default_args=default_args) as dag: 

  create_db_table = SQLExecuteQueryOperator(
    sql = "sql/urban_city.sql",
    task_id = "urban_city_table",
    conn_id = "postgres_conn"
  )
  
  data_factory = AzureDataFactoryRunPipelineOperator(
    task_id="run_data_factory",
    pipeline_name="urban_city_factory",
  )


  (
    extract_data_from_api()
    >> transform_data()
    >> create_db_table
    >> data_factory
  )