#!/bin/bash

pDIR=`pwd`
MUSIC_DIR=/home/dig/music/
PLAYLIST_FILE="$MUSIC_DIR/playlist"

while true
do
	#RAND=`rand`
	#COUNT=`wc -l $PLAYLIST_FILE`
	#NEXT=`expr $RAND % $COUNT`
	cd $MUSIC_DIR
	mpg123 -Z `cat $PLAYLIST_FILE`
	cd $pDIR
done
