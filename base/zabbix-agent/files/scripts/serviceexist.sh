#!/bin/sh
#:***********************************************
#:Program:
# check if service exists, 1~3 input parameters.
# if service exists, will print 1, others will print 0
# case ($2= aaa, $3 = aa) is not handled.
# $1 is service name
#:
#:Author: keanli
#:
#:History: 2017-06-20
#:
#:Version: 1.0
#:***********************************************

if [ $# = 0 -o $# -gt 3 ]; then
    echo "wrong parameters number, it should be [1~3], \$1 should be service name "
    exit 0
fi


serviceExist=`systemctl status $1 | grep Active | grep -E "running|exited" | wc -l`
echo $serviceExist
exit 0
