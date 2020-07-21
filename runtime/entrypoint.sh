#!/bin/bash

_int()
{
    kill -INT ${pid}
    sync
    echo "Catched and handled SIGINT"

}

_term()
{
    kill -TERM ${pid}
    sync
    echo "Catched and handled SIGTERM"
}

trap _term SIGTERM
trap _int SIGINT

${1} &
pid=$!

wait -n ${pid}
exit $?
