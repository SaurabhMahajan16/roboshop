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

component=$1
securityGroupInput=$2



  if [ "${component}" == '' ]; then
    Print "input machine name is needed"
    exit 1
  fi
  if [ "${securityGroupInput}" == "" ]; then
      Print "input security Group name is needed"
      exit 2
  fi


ZoneId="Z09328736PFKQWEPDBCW"

createEc2(){

  PrivateIpAddressForRoute53=$(aws ec2 run-instances \
      --image-id "${AmiId}" \
      --instance-type t3.micro \
      --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${component}}]"\
      --instance-market-options "MarketType=spot,SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}" \
       --security-group-ids "${SecurityGroupId}" \
       | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g') &>>"${logFile}"
  #as this cmd will give an O/p but if u | jq it will automatically come out of it
  exitStatusCheck $?

  sed -e "s/IPADDRESS/${PrivateIpAddress}/" -e "s/componentName/${component}/" route53.json >/tmp/record.json

  aws route53 change-resource-record-sets --hosted-zone-id ${ZoneId} --change-batch file:///tmp/record.json | jq

}

#in order create tag for machine creation we are taking input from user and putting that i/p as name in tags for the machine


checkValueProvided

AmiId=$(aws ec2 describe-images --filters "Name=name,Values=Centos-7-DevOps-Practice" | jq '.Images[].ImageId' | sed -e 's/"//g') &>>"${logFile}"
exitStatusCheck $?
Print "${AmiId}"

Print "getting security group Id"
Print "${securityGroupInput}"
SecurityGroupId=$(aws ec2 describe-security-groups --filters Name=group-name,Values="${securityGroupInput}" | jq '.SecurityGroups[].GroupId' | sed -e 's/"//g') &>>"${logFile}"
exitStatusCheck $?
Print "${SecurityGroupId}"


Print "create instance"
createEc2

#now as we are assigning each ami our security group we created so in order to do that we have to describe security group by name and then get the id of security group











