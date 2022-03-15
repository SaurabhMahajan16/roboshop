#! /usr/bin/bash

# case and if are conditional commands, if commands is widely used because it has more options than case `command`
# if conditions are of 3 types
#1:if []; then commands fi
#2: if []; then commands else command fi
#3:if []; then cmd elif []; then commands else commands fi
# if is found in in 3forms
# 1. spring tests
a="abc"
if [ "$a" == 'abc' ]
then
  echo both are equal
fi


if [ "$a" != "abc" ]
then
  echo "both are not equal"
fi

if [ -z "$b" ]
then
  echo"b variable is empty"
fi


# operators : ==, !=, -z
#2. number tests
#operators : -eq, -ne, -le, -lt, -gt, -ge
#3. file tests
#-e -> returns true if file exists
# -f returns true if file is a file not a directory
# -d returns true if a file is a directory
#-r, -w, -x returns true if file has read, wrote or execute permissions for user running the file
