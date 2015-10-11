#!/bin/bash
## by Thibault Bronchain

USAGE="$0 build|run|start|stop|kill|ssh|ps|docker|push"

USERNAME="tbronchain"
EMAIL_RAW='thibault! bronchain? me'
MACHINE="default"
EMAIL=$(echo $EMAIL_RAW | sed -e 's|! |@|g' -e 's|? |.|g')
NAME=devenv
REPO=$USERNAME/$NAME

STATUS=$(docker-machine status $MACHINE)
if [ "$STATUS" != "running" ]; then
    docker-machine start $MACHINE
    eval "$(docker-machine env $MACHINE)"
    echo -e "Shell variable for independant actions:\n"
    docker-machine env $MACHINE 2> /dev/null
    echo
else
    eval "$(docker-machine env $MACHINE 2> /dev/null)"
fi

# get script path
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

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
        echo "Input new password [user]:"
        read PASSWD
        if [ "$PASSWD" != "" ]; then
            PASSWD=$(echo $PASSWD | sed -e 's/[]\/$*.^&|[]/\\&/g')
            cat $DIR/Dockerfile.tpl | sed s/user:user/user:$PASSWD/ > $DIR/Dockerfile
        else
            cp $DIR/Dockerfile.tpl $DIR/Dockerfile
        fi
        docker build -t $REPO $DIR
        rm $DIR/Dockerfile
        ;;
    run)
        #echo -e "Shell variable for independant actions:\n"
        #docker-machine env $MACHINE 2> /dev/null
        #echo
        docker run -d --name=$NAME --hostname=$NAME \
               -v /Users/$USER/Sources:/sources \
               -v /Users/$USER/Sources/github:/github \
               -v /Users/$USER/.emacs:/home/user/.emacs \
               -v /Users/$USER/.emacs.d:/home/user/.emacs.d \
               -v /Users/$USER/.ssh:/home/user/.ssh \
               -v /Users/$USER/.bash_aliases:/home/user/.bash_aliases \
               -v /Users/$USER/git-completion.bash:/home/user/git-completion.bash \
               --expose=22 -p 2222:22 --privileged=true $REPO
        if [ $? -ne 0 ]; then
           docker start $NAME
        fi
        ;;
    start)
        #echo -e "Shell variable for independant actions:\n"
        #docker-machine env $MACHINE 2> /dev/null
        #echo
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
    #ssh)
    #    docker-machine ssh $MACHINE
    #    ;;
    ssh)
        ip=$(docker-machine ip $MACHINE 2> /dev/null)
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
