#!/bin/bash
netstat -tupln |grep haproxy >>null
[ $? -eq 0 ]
if [ $? -eq 0 ];then
   exit
else
   systemctl start haproxy.service
fi