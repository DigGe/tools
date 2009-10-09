#!/bin/bash

#killall `cat /tmp/.play.pid` >&/dev/null
PLAY_SCRIPT="play.sh"
PLAYER="mpg123"

#vPS=`ps -Ao cmd,pid,ppid | grep "$PLAYER"`
#vPS=`ps -Ao cmd,ppid | grep "$PLAYER"`
vPS=`ps h -C "$PLAYER" -o ppid`

IS_PLAY_SCRIPT()
{
	if [ -z "$1" ]
	then
		return 1
	fi

	ps -p $1 -ocmd | grep "$PLAY_SCRIPT" >&/dev/null
	if [ $? -eq 0 ]
	then
		return 1
	fi

	return 0
}

for vPPID in $vPS
do
	if [ -z "$vPPID" ]
	then
		continue
	fi

	IS_PLAY_SCRIPT $vPPID

	if [ $? -eq 1 ]
	then
		vPID=`ps h -C "$PLAYER" -o pid`
		kill $vPPID $vPID
	fi
done


#vPPID=`echo $PS | awk '{system("echo " $0 " | cut -d\\   -f7")}'`
#vPID=`echo $PS | awk '{system("echo " $0 " | cut -d\\   -f6")}'`

#for LINE in $PS
#do
#	echo $LINE
#	vPID=`echo $LINE | awk '{print $6}'`
#	vPPID=`echo $LINE | awk '{print $7}'`
#	if [ -z "$vPPID" ] || [ -z "$vPID" ]
#	then
#		continue
#	fi

#	IS_PLAY_SCRIPT $vPPID
#	if [ $? -eq 1 ]
#	then
#		kill $PID $PPID
#	fi
#done

