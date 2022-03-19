#!/usr/bin/bash

source components/common.sh

#MySQL is the database service which is needed for the application. So we need to install it and configure it for the application to work.

## **Manual Steps to Install MySQL**

#As per the Application need, we are choosing MySQL 5.7 version.

#1. Setup MySQL Repo

Print "configure yum repos"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>"${logFile}"
exitStatusCheck $?

#1. Install MySQL
Print "install MySQL"
yum install mysql-community-server -y &>>"${logFile}"
exitStatusCheck $?

#1. Start MySQL.

Print "enable and start mysql service"
systemctl enable mysqld &>>"${logFile}" && systemctl start mysqld &>>"${logFile}"
exitStatusCheck $?

#1. Now a default root password will be generated and given in the log file.
defaultRootPassword=${grep "temporary password" /var/log/mysql.log | awk "{print $NF}"}

grep temp /var/log/mysqld.log


#1. Next, We need to change the default root password in order to start using the database service. Use password `RoboShop@1` or any other as per your choice. Rest of the options you can choose `No`


# mysql_secure_installation


#1. You can check the new password working or not using the following command in MySQL

#First lets connect to MySQL


# mysql -uroot -pRoboShop@1


#Once after login to MySQL prompt then run this SQL Command.

#sql
> uninstall plugin validate_password;


## **Setup Needed for Application.**

#As per the architecture diagram, MySQL is needed by

- Shipping Service

#So we need to load that schema into the database, So those applications will detect them and run accordingly.

#To download schema, Use the following command


curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"


Load the schema for Services.


cd /tmp
unzip mysql.zip
cd mysql-main
mysql -u root -pRoboShop@1 <shipping.sql
