#!/bin/bash

if [ "$1" = "" ]; then
    echo "Choose which image to build:"
    echo " [1] httpd_base"
    echo " [2] httpd_hello"
    echo " [3] httpd_wordpress"
    echo
    read CHOICE

    if [ "$CHOICE" = "1" ]; then
        IMAGE="httpd_base"
    elif [ "$CHOICE" = "2" ]; then
        IMAGE="httpd_hello"
    else
        IMAGE="httpd_wordpress"
    fi
else
    IMAGE="$1"
fi

docker build -t visualops/ubuntu_wordpress $IMAGE
docker push visualops/ubuntu_wordpress
