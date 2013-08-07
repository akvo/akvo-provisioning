#!/bin/bash
touch /tmp/rsr_lastcheck

while true
do
    echo "checking..."
    CODE_PATH='/var/akvo/rsr/code/akvo/'
    CHANGED_COUNT=`find $CODE_PATH -newer /tmp/rsr_lastcheck | wc -l`
    touch /tmp/rsr_lastcheck

    if [ "$CHANGED_COUNT" -gt "0" ]
    then
      echo 'Restarting RSR'
      sudo supervisorctl restart rsr
    fi
done
