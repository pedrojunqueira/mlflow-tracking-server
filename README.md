# Mlflow server running on Nginx with a Postgreslq DB

This is a simple example on setting up a containerized application to run a Mlflow with a Nginx proxy server, using and a Postgresql database with a persistent volume to store runs for the `--backend-store-uri` and AWS S3 to store artifact `--default-artifact-root` 

## Usage

```bash
git clone https://github.com/pedrojunqueira/mlflow-tracking-server.git
cd mlflow-docker-MLinProduction
```

Then to build the containers and run the application

`docker-compose up --build`

The server will run on `http://0.0.0.0/` or `http://localhost/` if you like.

## Running your machine learning code and posting on the server

I created a quick scrip to record something on the server database and also some artifact just to test the server and the back-end storage. However, I am sure you can run a much more complex Machine Learning code to train and test something more useful than that

So just run `python track_remote.py`

make sure you have `mlflow` installed in your environment. It is as simple as `pip install mlflow`

```python
#track_remote.py

import mlflow
remote_server_uri = "http://0.0.0.0" # set to your server URI
mlflow.set_tracking_uri(remote_server_uri)

with mlflow.start_run():
    mlflow.log_param("a", 1)
    mlflow.log_metric("b", 2)

    # Log an artifact (output file)
    with open("output.txt", "w") as f:
        f.write("Hello world!")
    mlflow.log_artifact("output.txt")

```

The runs will be recorded on the Postgresql db.

To access the db use any client tool as it runs port `5432`. You may want to change that if you are already running a Postgresql instance on your host machine i.e. your own pc 😀.

or you can simply check by getting inside the db container

### Check containers running

```bash
$ docker ps
CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS              PORTS                    NAMES
442fb9b16468        docker-mlflow_nginx   "nginx -g 'daemon of…"   20 minutes ago      Up 20 minutes       0.0.0.0:80->80/tcp       docker-mlflow_nginx_1
1ef11e311cf1        mlflow_server         "bash /mnt/mlflow/ru…"   20 minutes ago      Up 20 minutes       0.0.0.0:5555->5000/tcp   mlflow_server
aed2f2f7bfd2        postgres:12-alpine    "docker-entrypoint.s…"   20 minutes ago      Up 20 minutes       5432/tcp                 docker-mlflow_db_1
```

### Get inside the database container

`docker exec -it docker-mlflow_db_1 psql -U postgres -p 5432 -h 0.0.0.0`

then inside the psql cli 

```bash
postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-----------+----------+----------+------------+------------+-----------------------
 mlruns    | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(4 rows)

postgres=# \c mlruns
You are now connected to database "mlruns" as user "postgres".
mlruns=# select * from runs;

```

### Checking S3 storage

The artifacts get recorded on your S3 bucket.

If you want to access it and have your AWS credentials as environnement variables then

As an example

```bash
aws s3 ls s3://mlflow-pedro/0/
                           PRE 21e96896842d4398a8a39537a1bd515d/
                           PRE 5847aa44127f435f96fe51cdb1eea54a/
                           PRE 591fcf9983c94c4088d439957de57a5c/
                           PRE fc809693a7a34bc78d2ba4c3dc9ee770/
```

Then to put the model you are happy with just deploy it to production using mlflow 

I did another [git repository](https://github.com/pedrojunqueira/mlflow-docker-MLinProduction) for just that

To give credit where credit is due I got most of the ideas and code [here](https://towardsdatascience.com/deploy-mlflow-with-docker-compose-8059f16b6039) and did my own modifications on the compose file and used Postgresql rather than Mysql.