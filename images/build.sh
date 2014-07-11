#!/bin/bash

if [ "$1" = "" ]; then
    echo "Choose which image to build:"
    echo " [1] httpd_base"
    echo " [2] httpd_wordpress"
    echo
    read CHOICE

    if [ "$CHOICE" = "2" ]; then
        IMAGE="httpd_wordpress"
    else
        IMAGE="httpd_base"
    fi
else
    IMAGE="$1"
fi

docker build -t visualops/ubuntu_wordpress $IMAGE
