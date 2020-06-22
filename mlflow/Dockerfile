FROM python:3.7-slim-buster

# Install python packages
RUN pip install mlflow boto3 psycopg2-binary==2.8.5

WORKDIR "/mnt/mlflow"

COPY run.sh /mnt/mlflow

RUN chmod +x /mnt/mlflow/run.sh 

CMD ["bash", "/mnt/mlflow/run.sh"]