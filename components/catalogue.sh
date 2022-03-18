#! /usr/bin/bash

source components/common.sh

#This service is responsible for showing the list of items that are to be sold by the RobotShop e-commerce portal.

#1. This service is written in NodeJS, Hence need to install NodeJS in the system.

Print " download "
curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>>"${logFile}"
exitStatusCheck $?

Print "install nodejs"
yum install nodejs gcc-c++ -y &>>"${logFile}"
exitStatusCheck $?


#1. Let's now set up the catalogue application.

#As part of operating system standards, we run all the applications and databases as a normal user but not with root user.

#So to run the catalogue service we choose to run as a normal user and that user name should be more relevant to the project. Hence we will use `roboshop` as the username to run the service.

Print "add application user"

id "${appUser}" &>>logFile
if [ $? -ne 0 ]; then
useradd "${appUser}" &>>"${logFile}"
exitStatusCheck $? "application user - "
fi


#1. So let's switch to the `roboshop` user and run the following commands.

Print "download app content"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>"${logFile}"
exitStatusCheck $?

Print "clean up old content"
rm -rf /home/"${appUser}"/catalogue &>>"${logFile}"
exitStatusCheck $?


Print "extract app content"
cd /home/"${appUser}" &>>"${logFile}"  && unzip -o /tmp/catalogue.zip &>>"${logFile}" && mv catalogue-main catalogue &>>"${logFile}"
exitStatusCheck $?

# shellcheck disable=SC2164
Print "install dependencies"
cd /home/"${appUser}"/catalogue &>>"${logFile}" && npm install &>>"${logFile}"
exitStatusCheck $?


#1. Update SystemD file with correct IP addresses

#Update `MONGO_DNSNAME` with MongoDB Server IP

Print "Update `MONGO_DNSNAME` with MongoDB Server DNS name"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/"${appUser}"/catalogue/systemd.service &>>"${logFile}" &&
mv /home/"${appUser}"/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>"${logFile}"
exitStatusCheck $?

#2. Now, lets set up the service with systemctl.




Print "set up the service with systemctl after updating changes"
systemctl daemon-reload &>>"$logFile" && systemctl start catalogue &>>"$logFile" && systemctl enable catalogue &>>"${logFile}"
exitStatusCheck $?

