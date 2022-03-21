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
userId=$(id -u)
if [ "$userId" -ne 0 ]; then
  Print "Please run your commands as root user permissions"
exit 1
fi

appDaemonUser=roboshop

createDaemonUser(){

  id "${appDaemonUser}" &>>logFile
  if [ $? -ne 0 ]; then
    Print "add application user"
    useradd "${appDaemonUser}" &>>"${logFile}"
    exitStatusCheck $?
  fi
}

#this function is part of coding practise as in every application we are using downloading cleaning and extracting app content
settingUpApplication(){

  Print"downloading ${component}"
  curl -s -L -o /tmp/"${component}".zip "https://github.com/roboshop-devops-project/"${component}"/archive/main.zip" &>>"${logFile}"
    exitStatusCheck $?

    Print "clean up old content"
    rm -rf /home/"${appDaemonUser}"/"${component}" &>>"${logFile}"
    exitStatusCheck $?


    Print "extract app content"
    cd /home/"${appDaemonUser}" &>>"${logFile}"  && unzip -o /tmp/"${component}".zip &>>"${logFile}" && mv "${component}"-main "${component}" &>>"${logFile}"
    exitStatusCheck $?
}

settingUpPermissionAndService(){

  Print "Fix app user permissions"
  chown -R "${appDaemonUser}":"${appDaemonUser}" /home/"${appDaemonUser}"
  exitStatusCheck $?

  Print "Update Server DNS name by configuring systemd file"
  #\ means line has no ended here and it is still continuing for code readability
  sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' \
         -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' \
         -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' \
         -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' \
         -e 's/CARTENDPOINT/crt.roboshop.internal/' \
         -e 's/DBHOST/mysql.roboshop.internal/' \
         /home/"${appUser}"/"${component}"/systemd.service &>>"${logFile}" &&
  mv /home/"${appDaemonUser}"/"${component}"/systemd.service /etc/systemd/system/"${component}".service &>>"${logFile}"
  exitStatusCheck $?
  #before using dns always ensure you have proper dns record before using it
  #2. Now, lets set up the service with systemctl.




  Print "set up the service with systemctl after updating changes"
  systemctl daemon-reload &>>"$logFile" && systemctl start "${component}" &>>"$logFile" && systemctl enable "${component}" &>>"${logFile}"
  exitStatusCheck $?
}


code=RoboShop@1
tempcode="'RoboShop@1'"
# created for password for mysql

nodeJs(){
  Print " download nodejs "
  curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>>"${logFile}"
  exitStatusCheck $?

  Print "install nodejs"
  yum install nodejs gcc-c++ -y &>>"${logFile}"
  exitStatusCheck $?


  #1. Let's now set up the catalogue application.

  #As part of operating system standards, we run all the applications and databases as a normal user but not with root user.

  #So to run the catalogue service we choose to run as a normal user and that user name should be more relevant to the project. Hence we will use `roboshop` as the username to run the service.

  #calling a function which setting up a daemon user and setting up application which means downloading, cleaning old content and extracting
  createDaemonUser
  settingUpApplication


  #1. So let's switch to the `roboshop` user and run the following commands.


  # shellcheck disable=SC2164
  Print "install dependencies"
  cd /home/"${appDaemonUser}"/"${component}" &>>"${logFile}" && npm install &>>"${logFile}"
  exitStatusCheck $?

   #calling function which will setup permissions edit systemd.conf file and enable and restart the service
  settingUpPermissionAndService

# Print "Fix app user permissions"
# chown -R "${appUser}":"${appUser}" /home/"${appUser}"
# exitStatusCheck $?


# #Update systemd.conf file with proper dns

# Print "Update Server DNS name by configuring systemd file"
# #for value in
# sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' /home/"${appUser}"/"${component}"/systemd.service &>>"${logFile}" &&
# mv /home/"${appUser}"/"${component}"/systemd.service /etc/systemd/system/"${component}".service &>>"${logFile}"
# exitStatusCheck $?
# #before using dns always ensure you have proper dns record before using it
# #2. Now, lets set up the service with systemctl.




# Print "set up the service with systemctl after updating changes"
# systemctl daemon-reload &>>"$logFile" && systemctl start "${component}" &>>"$logFile" && systemctl enable "${component}" &>>"${logFile}"
# exitStatusCheck $?
}



#create function for maven as in future we might have more applications running on maven
mavenForApplication(){

  #Shipping service is written in Java, Hence we need to install Java.

  #1. Install Maven, This will install Java too

  Print "install maven"
  yum install maven -y &>>"$logFile"
  exitStatusCheck $?

  createDaemonUser
  settingUpApplication

  Print "maven packaging"
  cd /home/"${appDaemonUser}"/"${component}" &>>"$logFile" && mvn clean package &>>"$logFile" && mv target/shipping-1.0.jar shipping.jar &>>"$logFile"
  exitStatusCheck $?

  #calling function which will setup permissions edit systemd.conf file and enable and restart the service
  settingUpPermissionAndService

}