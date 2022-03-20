#!/usr/bin/bash

source components/common.sh

#1. Setup MySQL Repo

Print "configure yum repos"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>"${logFile}"
exitStatusCheck $?

#1. Install MySQL
Print "install MySQL"
yum install mysql-community-server -y &>>"${logFile}"
exitStatusCheck $?


Print "enable and start mysql service"
systemctl enable mysqld &>>"${logFile}" && systemctl start mysqld &>>"${logFile}"
exitStatusCheck $?

#1. Now a default root password will be generated and given in the log file.

#in mysql we dont need to give spaces between options and inputs like in -uroot -u is option and root is input slrly -p is for passwd and Roboshop@1 is password
#we use condition because if we are running script again & again the the password is already changed so we cant change it again and again so if condition is checking whether password is changed by validating the password
echo "show databases" | mysql -uroot -pRoboShop@1 &>>"${logFile}"
if [ $? -ne 0 ]; then
  Print "changing default root password for mysql"
  echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('Roboshop@1');" >/tmp/rootpass.sql
  defaultRootPassword=$(grep "temporary password" /var/log/mysqld.log | awk '{print $NF}')
  #here we used round brackets because we are assigning a variable a command
#Nth field means last field but if u want 2nd last NF-1 or similar
  mysql --connect-expired-password -uroot -p${defaultRootPassword} </tmp/rootpass.sql &>>"${logFile}"
  #we use --connect-expired-password as default password is expired so we have to got with this so we have to use this option
  exitStatusCheck $?
fi
#to uninstall password plugin we have to make sure that it exists
echo "show plugins" | mysql -uroot -pRoboShop@1 2>>"${logFile}" | grep "validate_password" &>>"${logFile}"
#we used 2>> because we just want error to go to this file
if [ $? -eq 0 ]; then
  Print "uninstalling validate password plugin"
  echo "uninstall plugin validate_password" >/tmp/pass-validate.sql
  mysql --connect-expired-password -uroot -pRoboShop@1 </tmp/pass-validate.sql &>>"${logFile}"
  exitStatusCheck $?
fi


Print "download schema"
curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>>"${logFile}"
exitStatusCheck $?


#Load the schema for Services.

Print  "exracting schema"
cd /tmp && unzip -o mysql.zip &>>"${logFile}"
exitStatusCheck $?

Print "loading schema"
cd mysql-main && mysql -u root -pRoboShop@1 <shipping.sql &>>"${logFile}"
exitStatusCheck $?
