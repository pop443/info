#!/usr/bin/env bash

#string
names=$1
#string
usergroup=$2



function find_available_uid() {
 for ((i=1001; i<=2000; i++))
 do
   grep -q $i /etc/passwd
   if [ "$?" -ne 0 ]
   then
    newUid=$i
    break
   fi
 done
}
#array
arrayName=(${names//,/ })

for username in ${arrayName[@]}
do
    echo "deal " $username "---"  $usergroup

    if [ $username == 'root' ]; then
        continue;
    fi

    # group is not exists
    egrep $usergroup /etc/group >& /dev/null
    if [ $? -ne 0 ];then
        groupadd $usergroup
    fi

    # user is not exists
    egrep $username /etc/passwd >& /dev/null
    if [ $? -ne 0 ]; then
        useradd -g $usergroup $username
    else
        # user is exists
        # uid is security
        test $(id -u $username) -gt 1000
        if [ $? -eq 0 ];then
            continue;
        else
            # uid is not security
            find_available_uid

            if [ $newUid -eq 0 ]
            then
              echo "Failed to find Uid between 1000 and 2000"
              exit 1 ;
            fi

    	    #change user uid and change file and dir
    	    old_uid=$(id -u $username)
            usermod  -u $newUid  $username
            find / -user $old_uid -exec chown $newUid {} \;

            continue;
        fi
    fi
done





