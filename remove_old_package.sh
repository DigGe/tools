#!/bin/bash

cd /var/cache/apt/archives/

for file in `ls | sort | cut -d_ -f1`
do
	count=`ls "$file"_*| wc -l`
	#echo $file $count
	if [[ $count -ne 1 ]]
	then
		echo $file $count
		count=`expr $count - 1`
		sudo mv `ls "$file"_*| head -n $count` ./tobedelete/
	fi
done

cd -

