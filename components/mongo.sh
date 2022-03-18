#! /usr/bin/bash

logFile=/tmp/roboshop.log
rm -f $logFile

Print(){
  echo -e "\e[34m \n ---------${1}---------\n \e[0m" &>>$logFile
  echo -e "\e[34m \n\n ${1} \n\n \e[0m"
}
exitStatusCheck(){
 if [ "${1}" -eq 0 ]; then
  Print "${2} Successfully"
 else
   Print "${2} failed"
 #  echo -e "\e[32m nginx installed failed\e[0m"
   exit 2
 fi

}



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


curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$logFile
exitStatusCheck $? "mongodb zip downloaded - "

rm -rf /tmp/mongodb-main
cd /tmp &>>$logFile && unzip mongodb.zip &>>$logFile && cd mongodb-main &>>$logFile
exitStatusCheck $? "mongodb unzipped - "
mongo < catalogue.js &>>$logFile && mongo < users.js &>>$logFile
exitStatusCheck $? "mongodb database created -"



#Symbol `<` will take the input from a file and give that input to the command.