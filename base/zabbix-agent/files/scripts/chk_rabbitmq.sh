#!/bin/bash
case $1 in
total)
    process_status=`rabbitmqctl status |grep "total," |awk -F "," '{print $2}'  |awk -F "}" '{print $1}'`
       if [[ $process_status != "" ]]; then
           echo $process_status
       else
           echo 0
       fi
;;
queue_procs)
    process_status=`rabbitmqctl status |grep queue_procs|awk -F "," '{print $2}'  |awk -F "}" '{print $1}'`
       if [[ $process_status != "" ]]; then
           echo $process_status
       else
           echo 0
       fi
;;
other_proc)
    process_status=`rabbitmqctl status |grep other_proc|awk -F "," '{print $2}'  |awk -F "}" '{print $1}'`
       if [[ $process_status != "" ]]; then
           echo $process_status
       else
           echo 0
       fi
;;
connection_other)
    process_status=`rabbitmqctl status |grep connection_other |awk -F "," '{print $2}' |awk -F "}" '{print $1}'`
       if [[ $process_status != "" ]]; then
           echo $process_status
       else
           echo 0
       fi
;;
connection_channels)
    process_status=`rabbitmqctl status |grep connection_channels |awk -F "," '{print $2}' |awk -F "}" '{print $1}'`
       if [[ $process_status != "" ]]; then
           echo $process_status
       else
           echo 0
       fi
;;
connection_readers)
    process_status=`rabbitmqctl status |grep connection_readers |awk -F "," '{print $2}' |awk -F "}" '{print $1}'`
       if [[ $process_status != "" ]]; then
           echo $process_status
       else
           echo 0
       fi
;;
connection_writers)
    process_status=`rabbitmqctl status |grep connection_writers |awk -F "," '{print $2}' |awk -F "}" '{print $1}'`
       if [[ $process_status != "" ]]; then
           echo $process_status
       else
           echo 0
       fi
;;

esac
