#!/bin/sh

#
#日志
#
function log(){
	local nowData=`date '+%Y:%m:%d %H:%M:%S'`
    echo $nowData"----"$1 |tee -a $logPath
}

#
#基础目录
#
basePath=`dirname $(readlink -f $0)`
logPath=$basePath/op.log
pid=$1
n=$2
#log $basePath




while true ;do
	threadInfo=`ps -mp $pid  -o THREAD,tid,time | sort -rn |sed -n '3,5p'`
	IFS='
	'
	for line in $threadInfo
	do
		temp_line=$line
		x_cpu=`echo  $temp_line | awk '{print $2}'`
		x_tid=`echo  $temp_line | awk '{print $8}'`
		x_time=`echo  $temp_line | awk '{print $9}'`
		x_tid16=`printf "%x\n" $x_tid`
		echo "------------pid:"$pid";cpu:"$x_cpu";time:"$x_time"------------"
		jstack $pid |grep $x_tid16 -A 30
		echo "------------------------------------"
		sleep 1
	done
sleep $n
done

