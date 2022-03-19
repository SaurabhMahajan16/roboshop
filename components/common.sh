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

appUser=roboshop

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

  Print "add application user"

  id "${appUser}" &>>logFile
  if [ $? -ne 0 ]; then
  useradd "${appUser}" &>>"${logFile}"
  exitStatusCheck $? "application user - "
  fi


  #1. So let's switch to the `roboshop` user and run the following commands.

  Print "download app content"
  curl -s -L -o /tmp/"${component}".zip "https://github.com/roboshop-devops-project/"${component}"/archive/main.zip" &>>"${logFile}"
  exitStatusCheck $?

  Print "clean up old content"
  rm -rf /home/"${appUser}"/"${component}" &>>"${logFile}"
  exitStatusCheck $?


  Print "extract app content"
  cd /home/"${appUser}" &>>"${logFile}"  && unzip -o /tmp/"${component}".zip &>>"${logFile}" && mv "${component}"-main "${component}" &>>"${logFile}"
  exitStatusCheck $?

  # shellcheck disable=SC2164
  Print "install dependencies"
  cd /home/"${appUser}"/"${component}" &>>"${logFile}" && npm install &>>"${logFile}"
  exitStatusCheck $?

  Print "Fix app user permissions"
  chown -R "${appUser}":"${appUser}" /home/"${appUser}"
  exitStatusCheck $?


  #1. Update SystemD file with correct IP addresses

  #Update `MONGO_DNSNAME` with MongoDB Server IP

  Print "Update `MONGO_DNSNAME` with MongoDB Server DNS name"
  #for value in
  sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' /home/"${appUser}"/"${component}"/systemd.service &>>"${logFile}" &&
  mv /home/"${appUser}"/"${component}"/systemd.service /etc/systemd/system/"${component}".service &>>"${logFile}"
  exitStatusCheck $?
  #before using dns always ensure you have proper dns record before using it
  #2. Now, lets set up the service with systemctl.




  Print "set up the service with systemctl after updating changes"
  systemctl daemon-reload &>>"$logFile" && systemctl start "${component}" &>>"$logFile" && systemctl enable "${component}" &>>"${logFile}"
  exitStatusCheck $?




}