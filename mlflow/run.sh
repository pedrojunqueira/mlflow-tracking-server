#!/bin/sh
# run.sh
mlflow server --backend-store-uri sqlite:////mnt/mlflow/mlruns.db --default-artifact-root s3://mlflow-pedro/ --host 0.0.0.0 -p 5000