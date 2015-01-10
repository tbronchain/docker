#!/bin/bash

USAGE="$0 build|run|start|stop|kill|ssh"

case $1 in
    build)
        docker build -t ssh .
        ;;
    run)
        docker run --name=ssh -v ~/Sources:/sources --expose=22 -p 2222:22 ssh &
        ;;
    start)
        docker start ssh
        ;;
    stop)
        docker stop ssh
        ;;
    kill)
        docker kill ssh
        ;;
    ssh)
        ssh -p 2222 root@`boot2docker ip`
        ;;
    *)
        echo -e "Syntax error\nusage: $USAGE"
        ;;
esac
