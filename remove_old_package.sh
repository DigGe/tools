#!/bin/bash

USER=`env | grep LOGNAME | cut -d\= -f2`
if [ -z "$USER" ] || [ "$USER" != "root" ]
then
	echo "you must run this script as root"
	exit 1
fi

PKG_FILE=/tmp/pkg.list
cd /var/cache/apt/archives/
dpkg -l > $PKG_FILE

for file in `ls | sort | cut -d_ -f1`
do
	grep "\ $file\ " $PKG_FILE >&/dev/null
	if [ $? -ne 0 ]
	then
		echo "$file not installed"
		mv "$file"_* ./tobedelete/
	fi
	count=`ls "$file"_*| wc -l`
	if [ $count -ne 1 ]
	then
		echo $file $count
		count=`expr $count - 1`
		mv `ls "$file"_*| head -n $count` ./tobedelete/
	fi
done

cd -

