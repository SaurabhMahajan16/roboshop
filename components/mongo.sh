#! /usr/bin/bash

source components/common.sh



Print " download mongodb"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$logFile
exitStatusCheck $? "mongodb downloaded - "


#1. Install Mongo & Start Service.


yum install -y mongodb-org &>>$logFile
exitStatusCheck $? "mongodb-org installed - "

Print "update /etc/mongod.conf file Listen IP address from 127.0.0.1 to 0.0.0.0 in config file"

sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
exitStatusCheck $? "configuration update in mongod.conf - "

systemctl enable mongod &>>$logFile && systemctl start mongod &>>$logFile
exitStatusCheck $? "mongodb service enabled and started -"



#1. Update Listen IP address from 127.0.0.1 to 0.0.0.0 in config file

#Config file: `/etc/mongod.conf`

#then restart the service


systemctl restart mongod &>>$logFile
exitStatusCheck $? "mongodb service restarted after changes - "



## Every Database needs the schema to be loaded for the application to work.

#Download the schema and load it.

Print "Download schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$logFile
exitStatusCheck $? "mongodb zip downloaded - "

Print "extract schema"
#rm -rf /tmp/mongodb-main
cd /tmp &>>$logFile && unzip -o mongodb.zip &>>$logFile
# -o make it work even if mongodb.zip already unzipped so it will replace it
exitStatusCheck $? "mongodb unzipped - "
# shellcheck disable=SC2164
#&>>"$logFile"
Print "load schema"
cd mongodb-main

for schema in catalogue users ; do
  Print "load ${schema} schema "
  mongo < ${schema}.js &>>$logFile
exitStatusCheck $? "mongodb database created -"



#Symbol `<` will take the input from a file and give that input to the command.