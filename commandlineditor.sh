#! /usr/bin/bash
touch sedTestFile
cat testfile.txt >> sedTestFile
sed -i 's/is/was/'
cat sedTestFile
#to edit the file we use -i option as otherwise it will only change the o?p just for command
#in order to substitute all text with other text, we have to use /g which is global
#in order to use case insensitive we use /i

sed -i 's/is/was/g'
cat sedTestFile

sed -e 1d sedTestFile

sed -e '1d' -e '5d' sedTestFile
#remove two line
sed -e '/was/ d' sedTestFile