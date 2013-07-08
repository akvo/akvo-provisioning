#!/bin/bash

while true
do
    touch /tmp/lastcheck
    CODE_PATH='/var/akvo/rsr/git/current/akvo/'
    CHANGED_COUNT=`find $CODE_PATH -newer /tmp/lastcheck | wc -l`

    if [ "$CHANGED_COUNT" -gt "0" ]
    then
      echo 'Restarting RSR'
      sudo supervisorctl restart rsr
    fi
done