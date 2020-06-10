#!/bin/bash
export LANG="en_US.UTF-8"
BEGIN_TIME=`date '+%s'`
#获得执行参数
arg1=$1
arg2=$2
arg3=$3

echo $arg1"--"$arg2"--"$arg3

if=0
ifarg=$(($if+1))

echo $ifarg

#while 循环
while [ $ifarg -le 20 ]
do
	#if 判断
	if [ $ifarg -lt 5 ] ;then 
		ifarg=$(($ifarg+2))
	elif [ $ifarg -gt 5 ] ;then 
		ifarg=$(($ifarg+3))
	else
		ifarg=$(($ifarg+1))
	fi
	echo "--while--"$ifarg
done

#for 循环 
for((i=1;i<=4;i++))
do
	ifarg=$(($ifarg-$i))
	echo "--for--"$ifarg
done



#单行
hivesql=`hive -e "select concat_ws('-','1','2') ;"`
echo "单行字符串"$hivesql
array=(${hivesql//-/})
for i in ${array[@]}
do
	echo "单行循环"$i
done


#多行中直接取值都是以 空格 分割
hivesql2=`hive -e "select '3A','3B' union all select '4A','4B' union all select '5A','5B' ;"`
echo "多行字符串"$hivesql2

array2=(${hivesql2// /})

for i in ${array2[@]}
do
	echo "多行循环"$i
done

END_TIME=`date '+%s'`
echo "本次脚本所有计算结束，总耗时$(($END_TIME-$BEGIN_TIME))秒"


