#!/bin/bash

_int()
{
    echo "Catched SIGINT"
    kill -INT ${pid}
}

_term()
{
    echo "Catched SIGTERM"
    killall -TERM ${pid}
}

trap _term SIGTERM
trap _int SIGINT

${1} &
pid=$!

wait -n ${pid}
exit $?
