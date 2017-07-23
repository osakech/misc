#!/bin/sh
SERVICE_NAME=$1
PORT=$2
SERVICE_NAME_LC=$(echo -n "$SERVICE_NAME" | tr '[:upper:]' '[:lower:]')

echo "building service $SERVICE_NAME ..."
docker build -f "Dockerfile.build" -t "$SERVICE_NAME_LC-build" --build-arg dirname=$SERVICE_NAME .
docker create --name "$SERVICE_NAME_LC-build-container" "$SERVICE_NAME_LC-build" .

if [ -d "publish" ]
    then
    echo "deleting publish directory"
    rm -rf "publish"
fi

echo "starting service $SERVICE_NAME  ..."
docker cp "$SERVICE_NAME_LC-build-container:/out" ./publish
docker build -t $SERVICE_NAME_LC -f "Dockerfile" --build-arg dll=$SERVICE_NAME .
docker run -p "$PORT:80" -d $SERVICE_NAME_LC

exit 0;
