#!/bin/bash
if [ -e ./playlist ]
then
	cp playlist playlist.org.`date "+%Y%m%d-%H%M%S"`
fi

find -name \*.mp3 > ./playlist
sed -i s'/^\(.*\ .*\)$/"\1"/' ./playlist
#sed -i s'/^/"/' ./playlist
#sed -i s'/$/"/' ./playlist
