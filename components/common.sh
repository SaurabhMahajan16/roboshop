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