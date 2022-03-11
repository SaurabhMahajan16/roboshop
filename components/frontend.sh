#! /usr/bin/bash

echo frontend component


yum install nginx -y
systemctl enable nginx
systemctl start nginx

#Let's download the HTDOCS content and deploy under the Nginx pat#

curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"

#Deploy in Nginx Default Location.


cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf


#Finally restart the service once to effect the changes.

systemctl restart nginx
systemctl enable nginx