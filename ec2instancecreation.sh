#! /usr/bin/bash
source components/common.sh
# we need access key and passcode for this
#the command is aws configure
#paste key from iam by creating a user and then in policies gives admin access and then create a user
#then after exec aws configure cmd paste key and passcode and zone code and then enter and enter
#then use cmd aws ec2 describe-images   --owners amazon this will give you big o/p u can scroll down to see the o/p and to exit type q from keyboard
#while creating a user we have to worry about username and passcode, we cant keep it in code so best practice is to use role where we dont need to worry about pass and username, in search bar type administrator access and give only that use aws services and then ec2
#then go to ec2 instance and in security modify iam under it give name of ur role
#now try going to ec2 instance and re run the aws ec2 describe-images   --owners amazon and u will find there is error so in order to exec the above cmd just clean the i/p of user and password, to clean goto cd .aws/ and list using ls in delete the credentials file
# now after this that ec2 service should have admin access so u have created that role and that role now that role u took to ec2 instance and that ec2 instance is admin now, now u have full access only who logins in that ec2 machine will full access
#if we think admin access is wider access, we can eliminate it by deleting and then give particular access such as ec2 and route53 full access
# we can consider role as it can only be assign to a service and user is just like a human being with username and passcode
#Role only works in inside amazon
#now we can find and create an instance using filters which ownerid amiid, name of ami, but we cant use ami id as every week if there is an update ami id wold change so we cant keep a dynamic thing stored in our script so we can find using name as well
#aws ec2 describe-images --filters "Name=name,Values=Centos-7-DevOps-Practise"
#this will give us big o/p in json format from here we will search for ami id and use it
#aws ec2 describe-images --filters "Name=name,Values=Centos-7-DevOps-Practise" | jq '.Images[].ImageId'
#after fetching ami id we can use this command to run an instance
# aws ec2 run-instances --image-id ami-0abcdef1234567890 --instance-type t2.micro --key-name MyKeyPaircommand
# as we have to create dns record wrt the name of server so we will take input before running

if [-z "$1"];then
  Print "input machine name is needed"
  exit 1
fi

component=$1

#in order create tag for machine creation


AmiId=$(aws ec2 describe-images --filters "Name=name,Values=Centos-7-DevOps-Practice" | jq '.Images[].ImageId' | sed -e 's/"//g') &>>"${logFile}"
exitStatusCheck $?

echo "${AmiId}"

Print "create instance"
aws ec2 run-instances --image-id "${AmiId}" --instance-type t3.micro --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${component}}]" &>>"${logFile}"
exitStatusCheck $?


