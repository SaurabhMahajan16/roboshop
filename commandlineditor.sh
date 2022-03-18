#! /usr/bin/bash
Print(){

  echo -e "\e[34m \n-----${1} ------\n\e[0m "
}
#touch sedTestFile
cat testfile.txt >> sedTestFile
Print "substitute operation from is to was not globally"
sed -i 's/is/was/' sedTestFile
cat sedTestFile
#to edit the file we use -i option as otherwise it will only change the o?p just for command
#in order to substitute all text with other text, we have to use /g which is global
#in order to use case insensitive we use /i
Print "substitute operation from is to was globally"
sed -i 's/is/was/g' sedTestFile
cat sedTestFile
Print "delete operation line #1"
sed -i -e  1d sedTestFile
cat sedTestFile

Print "delete operation on line #1 & #2"
sed -i -e '1d' -e '5d' sedTestFile
cat sedTestFile

Print "delete operation based on search criteria"
#remove two line
sed -i -e '/was/ d' sedTestFile
cat sedTestFile
#without -i option the the file wont be updated only o/p would be
Print "i is for insert and we are inserting hello in first line"
sed -i -e '1 i Hello' sedTestFile
cat sedTestFile

Print "change first line"
sed -i -e '1 c Hi How are you' sedTestFile
cat sedTestFile

#find a  regular expression in a line and in that line substitute other word with anything
Print "finding a line with a word and then substituting something in that line"
sed -i -e '/does/s/denote/represent/' sedTestFile