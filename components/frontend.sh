#! /usr/bin/bash

echo frontend component

# checking for root user permissions

userId=$(id -u)
if [ "$userId" -ne 0 ]; then
  echo Please run your cmds as root user permissions
exit 1
fi


echo -e "\e[32m installing nginx \e[0m"
yum install nginx -y

if [ $? -eq 0 ]; then
 echo -e "\e[32m nginx installed successfully \e[0m"
else
  echo -e "\e[32m nginx installed failed\e[0m"
  exit 2
fi

#Let's download the HTDOCS content and deploy under the Nginx path

echo -e "\e[32m download the HTDOCS content and deploy under the Nginx path \e[0m"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"

#Deploy in Nginx Default Location.

echo -e "\e[32m clean old nginx location &  Deploy in Nginx Default Location \e[0m"
cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf


#Finally restart the service once to effect the changes.

echo -e "\e[32m restart and enable the service to effect the changes \e[0m"
systemctl restart nginx
systemctl enable nginx