#! /usr/bin/bash

# case and if are conditional cmds, if commands is widely used because it has more options than case `command`
# if conditions are of 3 types
#1:if []; then cmds fi
#2: if []; then cmds else cmds fi
#3:if []; then cmd elif []; then cmds else cmds fi
# if is found in in 3forms
# 1. spring tests
if [ "$a" == 'abc' ]
then
  echo both are equal
fi


if [ "$a" != "abc" ]
then
  echo "both are not equal"
fi

if [ -z ! "$b" ]
then
  echo"b variable is empty"
fi


# operators : ==, !=, -z
#2. mumber tests
#3. file tests