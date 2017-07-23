#!/bin/bash

DOCKERS="$(docker ps -a -q)"
if [ -n "$DOCKERS" ]
    then
    echo "stopping and deleting existing containers."
    docker stop ${DOCKERS}
    docker rm ${DOCKERS}
fi

