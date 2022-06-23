#!/usr/bin/bash
echo "Enter the String : "
read string
len=`echo -n $string | wc -c`
if [ $len -lt 10 ]
    then
        # if length is smaller
        # print this message
        echo "String is too short."
fi
