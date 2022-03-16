#! /usr/bin/bash

ls - l &>/dev/null
#this wont store the result as this file is used for nullifying the o/p
touch /tmp/abc
ls -l >/tmp/abc
#redirecting o/p of ls -l to a file
cd /roboshop
ls -l >/tmp/abc
#cat /tmp/abc
#this will override the data in the abc file
#in order to append data in file we have to use >>
cd
ls - l >>/temp/abc
#cat /tmp/abc
cd /roboshop
ls -l >>/tmp/abc
#cat /tmp/abc
#now this redirector will append the data in the file

#output and error des not redirect to same file unless specified
#in order to redirect both o/p & error to same file use &>
ls -l &>/tmp/def
#cat /tmp/def