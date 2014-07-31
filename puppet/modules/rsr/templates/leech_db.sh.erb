#!/bin/bash

# params
HOST=<%= @data_source_host %>
TIMESTAMP=$(date +'%Y-%m-%d-%H-%M-%S')
FILENAME="rsr-db-dump-${TIMESTAMP}.sql.gz"
KEY=<%= @approot %>/.ssh/rsrleech


echo 'step 1: create the dump'
ssh -i $KEY $HOST:dumpdb.sh $FILENAME

echo 'step 2: copy the dump'
scp -i $KEY $HOST:$FILENAME /tmp/

echo 'step 3: remove dump on data source'
ssh -i $KEY $HOST rm -v $FILENAME

echo 'step 4: load the dump'

echo 'step 5: clean up leech'
#rm -v $FILENAME

