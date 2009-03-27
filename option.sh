DIR="/sys/class/scsi_generic"
for file in `ls $DIR`
do
	if [ "ZCOPTION" == $(cat $DIR/$file/device/vendor) ] && [[ "HSDPA Modem     " == "$(cat $DIR/$file/device/model)" ]]
	then
		echo $file;
		rezero /dev/$file
	fi
done

