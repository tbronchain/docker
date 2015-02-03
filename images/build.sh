#!/bin/bash
# warning: very dummy script

USERNAME="tbronchain"
EMAIL_RAW='thibault! bronchain? me'
EMAIL=$(echo $EMAIL_RAW | sed -e 's|! |@|g' -e 's|? |.|g')

if [ "$1" = "" ]; then
    echo "Choose which image to build:"
    echo " [1] httpd_base"
    echo " [2] httpd_hello"
    echo " [3] httpd_wordpress"
    echo " [4] sshd"
    echo
    read CHOICE

    if [ "$CHOICE" = "1" ]; then
        IMAGE="httpd_base"
    elif [ "$CHOICE" = "2" ]; then
        IMAGE="httpd_hello"
    elif [ "$CHOICE" = "3" ]; then
        IMAGE="httpd_wordpress"
    elif [ "$CHOICE" = "4" ]; then
        IMAGE="sshd"
    fi
else
    IMAGE="$1"
fi

docker build -t $USERNAME/$IMAGE $IMAGE
docker login -e "$EMAIL" -u "$USERNAME"
docker push $USERNAME/$IMAGE
