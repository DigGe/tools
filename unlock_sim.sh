#!/bin/bash

PORT=/dev/ttyUSB0
WRITE_AT=`which write_at`
RESPONSE=""
CODE=""

if [ -n "$1" ]
then
    PORT=$1
fi

if [ ! -r $PORT ] || [ ! -w $PORT ]
then
    echo "Cannot access $PORT"
    exit 1
fi

if [ -z "$WRITE_AT" ] || [ ! -x "$WRITE_AT" ]
then
    WRITE_AT="./write_at"
    if [ ! -x "$WRITE_AT" ]
    then
        echo "Cannot execute $WRITE_AT"
        exit 1
    fi
fi

send_at() {
    if [ $# -lt 1 ]
    then
        echo "No AT Command to be sent"
        RESPONSE=""
        return 1
    fi

    RESPONSE=`$WRITE_AT $PORT $* 2>&1`

    echo $RESPONSE | grep "OK" >&/dev/null
    return $?

}

get_lock_type() {
    # 0: SIM Ready
    # 1: SIM PIN locked currently
    # 2: SIM PIN unlocked currently
    # 3: SIM PUK
    # 99:Unknown
    send_at "at+cpin?"
    if [ -n "$RESPONSE" ]
    then
        echo "$RESPONSE" | grep "^\+CPIN: SIM PIN" >&/dev/null
        if [ $? -eq 0 ]
        then
            return 1
        fi

        echo "$RESPONSE" | grep "^\+CPIN: SIM PUK" >&/dev/null
        if [ $? -eq 0 ]
        then
            return 3
        fi

        echo "$RESPONSE" | grep "^\+CPIN: READY" >&/dev/null
        if [ $? -eq 0 ]
        then
            send_at at+clck=\"sc\",2
            echo "$RESPONSE" | grep "^\+CLCK: 0" >&/dev/null
            if [ $? -eq 0 ]
            then
                return 0
            fi
            # pin lock enabled
            return 2
        fi
    fi

    return 99
}

get_code() {
    if [ -z "$1" ]
    then
        echo "Arguments error in get_code"
        exit 1
    fi

    CODE=""
    while [ -z "$CODE" ]
    do
        echo -n "$1"
        read CODE
    done
}

unlock_and_disable_pin() {
    local PIN
    echo "PIN Locked"
    get_code "Please Enter PIN Code: "
    PIN=$CODE
    send_at at+cpin=\"$PIN\"
    disable_pin $PIN
}

disable_pin() {
    local PIN
    if [ $# -ne 1 ]
    then
        echo "PIN Lock enabled"
        get_code "Please Enter PIN Code: "
        PIN=$CODE
    else
        PIN=$1
    fi

    send_at at+clck=\"sc\",0,\"$PIN\"
    if [ $? -eq 0 ]
    then
        get_lock_type
        if [ $? -eq 0 ]
        then
            echo "Pin Unlocked"
            return 0
        fi
    fi

    echo "PIN ERROR"
    return 1
}

unlock_puk() {
    local PUK
    local NEW_PIN
    echo "PUK Locked"
    get_code "Please enter PUK Code: "
    PUK=$CODE
    get_code "Please enter New PIN Code: "
    NEW_PIN=$CODE
    send_at at+cpin=\"$PUK\",\"$NEW_PIN\"
    if [ $? -eq 0 ]
    then
        get_lock_type
        if [ $? -eq 2 ]
        then
            disable_pin $NEW_PIN
            if [ $? -eq 0 ]
            then
                echo "PUK Unlocked and PIN Disabled"
                return 0
            fi
        elif [$? -eq 0 ]
        then
            echo "PUK Unlocked"
            return 0
        fi
    fi

    echo "PUK ERROR"
    return 1
}

initial_module() {
    send_at ate0
    send_at at+cmee=0
}

initial_module
get_lock_type
case $? in
    0)
        echo "SIM is ready"
        exit 0
        ;;
    1)
        #send_at at+cpin=\"1111\"
        unlock_and_disable_pin
        ;;
    2)
        disable_pin
        ;;
    3)
        unlock_puk
        ;;
    *)
        echo "Unknown error"
        exit 1
esac
