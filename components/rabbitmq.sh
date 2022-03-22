#!/usr/bin/bash

source components/common.sh
#RabbitMQ is a messaging Queue which is used by some components of the applications.

## **Manual Installation**

#1. Erlang is a dependency which is needed for RabbitMQ.
Print "Configure YUM Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>"${logFile}"
exitStatusCheck $?

Print "Install Erlang & RabbitMQ"
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm rabbitmq-server -y &>>"${logFile}"
exitStatusCheck $?
#with 1 yum cmd we are installing two
#1. Setup YUM repositories for RabbitMQ.





#1. Install RabbitMQ


#yum install rabbitmq-server -y &>>"${logFile}"


#1. Start RabbitMQ

Print "start RabbitMQ service"
systemctl enable rabbitmq-server &>>"${logFile}" && systemctl start rabbitmq-server &>>"${logFile}"
exitStatusCheck $?

#RabbitMQ comes with a default username / password as`guest`/`guest`. But this user cannot be used to connect. Hence we need to create one user for the application.

#1. Create application user

rabbitmqctl list_users | grep roboshop &>>"${logFile}"
if [ $? -ne 0 ]; then
  Print "create application server"
  rabbitmqctl add_user roboshop roboshop123 &>>"${logFile}"
  exitStatusCheck $?
fi

Print "configuration application user"
rabbitmqctl set_user_tags roboshop administrator &>>"${logFile}" && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>"${logFile}"
exitStatusCheck $?


#Ref link : [https://www.rabbitmq.com/rabbitmqctl.8.html#User_Management](https://www.rabbitmq.com/rabbitmqctl.8.html#User_Management)