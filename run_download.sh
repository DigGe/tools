#!/bin/bash

DOWNLOAD_DIR="download"

RETRY=10
WGET=wget

LOG_FILE="`pwd`/log.`date +%Y-%m-%d_%H-%M-%S`"
echo "LOG_FILE: $LOG_FILE"

SUCCESS_COUNT=0
FAIL_COUNT=0


if [[ ! -e $DOWNLOAD_DIR ]]
then
	mkdir "$DOWNLOAD_DIR"
fi

i=1

while [[ $i -le `wc -l list | cut -d\  -f1` ]]
do

	URL=`head -n $i list | tail -n1`

	cd $DOWNLOAD_DIR

	FILENAME=`basename $URL`

	echo "============== start download $FILENAME ============="

	retry=$RETRY
	while [ $retry -gt 0 ]
	do
		#echo $WGET --tries=20 $URL
		$WGET --tries=20 $URL
		#$WGET --tries=20 $URL 2>/dev/null >/dev/null

		if [ $? -eq 0 ]
		then
			echo "Download $FILENAME Success" | tee -a $LOG_FILE
			let SUCCESS_COUNT=$SUCCESS_COUNT+1
			break
		else
			echo "Download $FILENAME Failed, retry $retry ..." | tee -a $LOG_FILE
			if [ $retry -eq 1 ]
			then
				echo "Download $FILENAME Failed and will not try again" | tee -a $LOG_FILE
				let FAIL_COUNT=$FAIL_COUNT+1
				break
			fi
		fi

		let retry=$retry-1
	done

	let i=$i+1

	cd -

done

echo "---------------------" | tee -a $LOG_FILE
echo "Alldown" | tee -a $LOG_FILE
echo "Success: $SUCCESS_COUNT, Fail: $FAIL_COUNT" | tee -a $LOG_FILE

