import mlflow
remote_server_uri = "http://0.0.0.0:5555" # set to your server URI
mlflow.set_tracking_uri(remote_server_uri)

with mlflow.start_run():
    mlflow.log_param("a", 1)
    mlflow.log_metric("b", 2)

    # Log an artifact (output file)
    with open("output.txt", "w") as f:
        f.write("Hello world!")
    #mlflow.log_artifact("output.txt")

