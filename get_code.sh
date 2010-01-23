#!/bin/bash

LOG_FILE=`date +%Y%m%d-%H%M%S`.log

truncate -s 0 $LOG_FILE
tail -f $LOG_FILE &
TAIL_PID=$!

function log() {
    if [ -n "$*" ]
    then
        echo $* >>$LOG_FILE
    fi
}

function getcode() {
    gclient sync 2>&1 >>$LOG_FILE
    return $?
}

log "Log File: $LOG_FILE"
getcode
while [ $? -ne 0 ]
do
    log "============================="
    log "          Retry              "
    log "============================="
    sleep 1
    getcode
done

kill $TAIL_PID >&/dev/null
log "Done"

