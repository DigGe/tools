#!/bin/bash
BACK_DIR=/mytmp/samba
FILE=`ls -1 --sort time $BACK_DIR/*.tar | head -n 1`
cd /mnt/samba/Public
tar xf $FILE
