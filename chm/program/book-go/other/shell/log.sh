#!/bin/bash

function log_echo
{
	typeset LOG_LEVEL=$1
	typeset DATESTRING=`date +%Y%m%d%H%M%S`
	typeset FUNCTION_NAME=$2
	typeset LINE_NUM=$3
	typeset LOG_MES=$4
	echo "[${DATESTRING}][${LOG_LEVEL}][${FUNCTION_NAME}][${LINE_NUM}] ${LOG_MES}" | tee -a a.log
}


function clearFirst
{
	dirArray=(
	/icodeV3/heart
	/icodeV3/heart_server
	)
	
	for var in ${dirArray[@]}
	do
		checkDate=$(date -d '15 days ago' '+%Y%m%d')
		dirpath=$var"/"$checkDate
		log_echo "INFO" "clearFirst" "$LINENO" "deal"$dirpath
		hdfs dfs -test -e ${dirpath}
		if [ $? -eq 0 ]
		then
			log_echo "INFO" "clearFirst" "$LINENO" "delete"$dirpath
			hdfs dfs -rm -r ${dirpath}
		fi
	done

}


clearFirst