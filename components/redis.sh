#! /usr/bin/bash

#Redis is used for in-memory data storage and allows users to access the data over API.

#1. Install Redis.

source components/common.sh

Print "downloading redis"

 curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>"${logFile}"
# yum install redis -y &>>"${logfile}"
exitStatusCheck $?

Print "installing redis"
yum install redis -y &>>"${logFile}"
exitStatusCheck $?

#2. Update the BindIP from`127.0.0.1`to`0.0.0.0`in config file `/etc/redis.conf` & `/etc/redis/redis.conf`

Print "updating redis.conf file to listen to all"
if [ -f /etc/redis.conf ]
then
  sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf &>>"${logFile}"
  exitStatusCheck $?
fi
if [ -f /etc/redis/redis.conf ]
then
  sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf &>>"${logFile}"
  exitStatusCheck $?
fi
#3. Start Redis Database

Print "enable and restart redis "
systemctl enable redis &>>"${logFile}" && systemctl restart redis &>>"${logFile}"
exitStatusCheck $?
