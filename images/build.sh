#!/bin/bash
# warning: very dummy script

#USERNAME="tbronchain"
#EMAIL_RAW='thibault! bronchain? me'
USERNAME="visualops"
EMAIL_RAW='thibault! visualops? io'
EMAIL=$(echo $EMAIL_RAW | sed -e 's|! |@|g' -e 's|? |.|g')

if [ "$1" = "" ]; then
    echo "Choose which image to build:"
    echo " [1] httpd_base"
    echo " [2] httpd_hello"
    echo " [3] httpd_wordpress"
    echo " [4] httpd_demo"
    echo " [5] sshd"
    echo
    read CHOICE

    if [ "$CHOICE" = "1" ]; then
        IMAGE="httpd_base"
    elif [ "$CHOICE" = "2" ]; then
        IMAGE="httpd_hello"
    elif [ "$CHOICE" = "3" ]; then
        IMAGE="httpd_wordpress"
    elif [ "$CHOICE" = "4" ]; then
        IMAGE="httpd_demo"
    elif [ "$CHOICE" = "5" ]; then
        IMAGE="sshd"
    fi
else
    IMAGE="$1"
fi

docker build -t $USERNAME/$IMAGE $IMAGE
docker login -e "$EMAIL" -u "$USERNAME"
docker push $USERNAME/$IMAGE
