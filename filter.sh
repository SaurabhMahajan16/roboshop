#! /usr/bin/bash

source components/common.sh

#filter data based on cloumns
grep "does" /roboshop/testFile.txt | awk "{print $1}"
#fetch the first coloumn
#but in order to fetch the result from unknown column # but aware of that it is a last cloumn
grep "does" /roboshop/testFile.txt | awk "{print $NF}"

Print "${code}"
