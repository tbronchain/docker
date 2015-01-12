#!/bin/bash

USAGE="$0 build|run|start|stop|kill|ssh|ps|docker"

STATUS=$(boot2docker status)
if [ "$STATUS" = "poweroff" ]; then
    boot2docker start
fi
$(boot2docker shellinit)
boot2docker shellinit

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
        ip=$(boot2docker ip)
        ssh -p 2222 root@$ip
        ;;
    ps)
        docker ps
        ;;
    docker)
        shift
        docker $@
        ;;
    *)
        echo -e "Syntax error\nusage: $USAGE"
        ;;
esac
