#!/bin/bash
for dir in `find -maxdepth 1 -type d`
do
    du -sm $dir
done
