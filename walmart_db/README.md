# Walmart dbt project

The `walmart_db` profile reads its Databricks connection settings from the
repository-root `.env` file. dbt does not load `.env` files automatically. Run
dbt through the included wrapper from this directory so the settings are loaded
every time:

```sh
bash run_dbt.sh debug
bash run_dbt.sh run
```

Make sure `DATABRICKS_HOST`, `DATABRICKS_HTTP_PATH`, and `DATABRICKS_TOKEN` are
set in `.env`. `DATABRICKS_HTTP_PATH` must be the SQL warehouse HTTP path, in
the form `/sql/1.0/warehouses/<warehouse-id>`, not the workspace hostname.
