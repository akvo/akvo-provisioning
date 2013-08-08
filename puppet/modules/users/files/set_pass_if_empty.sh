#!/bin/bash

SET_PASS=$?

if [ "$SET_PASS" -eq 0 ]
then
    echo "------"
    echo
    echo "You do not have a password set - set one now:"
    echo
    passwd

    if [ "$?" -ne 0 ]
    then
        echo "Setting password failed; logging you out"
        kill -HUP `pgrep -s 0 -o`
    fi
fi
