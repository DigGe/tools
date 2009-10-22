#!/bin/bash
urls=`curl https://launchpad.net/ubuntu/+archivemirrors | \
grep -B 2 '>http</a>' | grep http | awk -F '"' '{print $2}'`
rm res
echo "$urls" | while read url;do 
rm T
wget -q --no-cache -O T "$url/ls-lR.gz" &
sleep 3
kill %% 
echo "testing... $url"
echo -n "$url " >> res
ls -l T >>res
done
 
sort -k 6 -n res > fast_mirror
rm res T
