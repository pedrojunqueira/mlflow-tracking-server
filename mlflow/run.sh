#!/bin/sh
# run.sh

if [ "$DATABASE" = "postgres" ]
then
    echo "Waiting for postgres..."

    while ! nc -z $SQL_HOST $SQL_PORT; do
      sleep 0.1
    done

    echo "PostgreSQL started"
fi

exec "$@"

mlflow server --backend-store-uri postgresql://postgres:postgres@db:5432/mlruns --default-artifact-root s3://mlflow-pedro/ --host 0.0.0.0 -p 5000

#mlflow server --backend-store-uri sqlite:////mnt/mlflow/mlruns.db --default-artifact-root s3://mlflow-pedro/ --host 0.0.0.0 -p 5000

