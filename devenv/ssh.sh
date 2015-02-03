#!/bin/bash

USAGE="$0 build|run|start|stop|kill|ssh|ps|docker|push"

USERNAME="tbronchain"
EMAIL_RAW='thibault! bronchain? me'
EMAIL=$(echo $EMAIL_RAW | sed -e 's|! |@|g' -e 's|? |.|g')
NAME=devenv
REPO=$USERNAME/$NAME

STATUS=$(boot2docker status)
if [ "$STATUS" != "running" ]; then
    boot2docker start
    $(boot2docker shellinit)
else
    $(boot2docker shellinit 2> /dev/null)
fi
echo -e "Shell variable for independant actions:\n"
boot2docker shellinit 2> /dev/null
echo

function ssh_fix () {
    cat ~/.ssh/known_hosts | grep -v $1 > ~/.ssh/known_hosts.tmp
    mv -f ~/.ssh/known_hosts.tmp ~/.ssh/known_hosts
}

function confirm () {
    if [ "$1" = "-f" ]; then
        return 0
    else
        echo "Are you sure? [y/N]"
        read res
        case $res in
            y*)
                return 0
                ;;
            *)
                return 1
                ;;
        esac
    fi
}

case $1 in
    build)
        docker build -t $REPO .
        ;;
    run)
        docker run -d --name=$NAME \
               -v /Users/$USER/Sources:/sources \
               -v /Users/$USER/Sources/github:/github \
               -v /Users/$USER/.emacs:/home/user/.emacs \
               -v /Users/$USER/.emacs.d:/home/user/.emacs.d \
               -v /Users/$USER/.bash_aliases:/home/user/.bash_aliases \
               -v /Users/$USER/git-completion.bash:/home/user/git-completion.bash \
               --expose=22 -p 2222:22 --privileged=true $REPO
        if [ $? -ne 0 ]; then
           docker start $NAME
        fi
        ;;
    start)
        docker start $NAME
        ;;
    stop)
        docker stop $NAME
        ;;
    kill)
        confirm $2
        if [ $? -eq 0 ]; then
            docker kill $NAME
        fi
        ;;
    rm)
        confirm $2
        if [ $? -eq 0 ]; then
            docker rm -f $NAME
        fi
        ;;
    ssh)
        ip=$(boot2docker ip 2> /dev/null)
        export LANG=C.UTF-8
        echo "Default password is 'user'"
        ssh -p 2222 user@$ip
        if [ $? -eq 255 ]; then
            ssh_fix $ip
            echo "Default password is 'user'"
            ssh -p 2222 user@$ip
        fi
        ;;
    ps)
        docker ps
        ;;
    docker)
        shift
        docker $@
        ;;
    push)
        docker login -e "$EMAIL" -u "$USERNAME"
        docker push $REPO
        ;;
    pull)
        docker login -e "$EMAIL" -u "$USERNAME"
        docker pull $REPO
        ;;
    *)
        echo -e "Syntax error\nusage: $USAGE"
        ;;
esac
