#!/bin/bash
if [ -z "$1" ]
then
    HOST=10.131.37.254
else
    HOST=$1
fi

i=0;
sudo ls /tmp >&/dev/null

while [ $i -lt 10 ]
do
    sudo ping -i 0.1 -l 10 -p 35 -s 10240 -n $HOST &
    let i=$i+1
done



