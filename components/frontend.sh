#! /usr/bin/bash

source components/common.sh

Print "installing nginx"
#echo -e "\e[32m installing nginx \e[0m"

yum install nginx -y &>>$logFile
exitStatusCheck $? " Nginx installed -"
#if [ $? -eq 0 ]; then
# echo -e "\e[32m nginx installed successfully\n\n\n \e[0m"
# Print "nginx installed successfully"
#else
#  Print "nginx installed failed"
#  echo -e "\e[32m nginx installed failed\e[0m"
#  exit 2
#fi

#Let's download the HTDOCS content and deploy under the Nginx path
Print "download the HTDOCS content and deploy under the Nginx path"
#echo -e "\e[32m \n\n download the HTDOCS content and deploy under the Nginx path \e[0m"
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$logFile
# curl -f will change the exit if the download fails otherwise curl wont give an exit error code
exitStatusCheck $? "download HTDOCS content -"
#if [ $? -eq 0 ]; then
#  Print " download the HTDOCS content successful"
# echo -e "\e[32m nginx installed successfully\n\n\n \e[0m"
#else
#  Print " download the HTDOCS content failure"
#  echo -e "\e[32m nginx installed failed\e[0m"
#  exit 2
#fi

#Deploy in Nginx Default Location.

Print "clean old nginx location "
#echo -e "\e[32m \n\n\n clean old nginx location &  Deploy in Nginx Default Location \e[0m"
#cd /usr/share/nginx/html &>>$logFile
rm -rf /usr/share/nginx/html/* &>>$logFile
exitStatusCheck $? "clean old nginx -"

#Print ""

#exitStatusCheck $? "extracted -"
cd /usr/share/nginx/html/
Print "extracting archive && moving to current working directory"
unzip /tmp/frontend.zip &>>$logFile && mv frontend-main/* . &>>$logFile && mv static/* . &>>$logFile && rm -rf frontend-main README.md &>>$logFile
exitStatusCheck $? "moving to current - "


Print "edit roboshop.conf file and add dns for different components"
mv localhost.conf /etc/nginx/default.d/roboshop.conf &>>"${logFile}"
for components in catalogue user cart ; do
  Print "updating ${compents} configuration"
  sed -i -e "/"${components}"/s/localhost/"${components}".roboshop.internal/" /etc/nginx/default.d/roboshop.conf &>>"${logFile}"
done
exitStatusCheck $?
#sed -i -e '/catalogue/s/localhost/catalogue.roboshop.internal/' /etc/nginx/default.d/roboshop.conf &>>"${logFile}"

# dns created for catalogue and edited in place of ip in roboshop.conf file


  Print " cleaning and deployed successfully"
#if [ $? -eq 0 ]; then
## echo -e "\e[32m nginx installed successfully\n\n\n \e[0m"
#else
#  Print " cleaning or deployed failure"
##  echo -e "\e[32m nginx installed failed\e[0m"
#  exit 2
#fi

#Finally restart the service once to effect the changes.
Print "restart and enable the service to effect the changes"
#echo -e "\e[32m restart and enable the service to effect the changes \e[0m"
systemctl restart nginx &>>$logFile
exitStatusCheck $? "restart nginx - "
#if [ $? -eq 0 ]; then
#  Print " nginx restarted successfully "
## echo -e "\e[32m nginx installed successfully\n\n\n \e[0m"
#else
#  Print " nginx restart failure "
##  echo -e "\e[32m nginx installed failed\e[0m"
#  exit 2
#fi

systemctl enable nginx &>>$logFile
exitStatusCheck $? "enabled nginx"
#if [ $? -eq 0 ]; then
#  Print " nginx enabled successfully "
## echo -e "\e[32m nginx installed successfully\n\n\n \e[0m"
#else
#  Print " nginx enabled failure "
##  echo -e "\e[32m ngi
# nx installed failed\e[0m"
#  exit 2
#fi