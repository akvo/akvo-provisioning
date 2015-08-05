#!/bin/bash
set -v

curl -X POST -H "Content-Type: application/json" http://192.168.50.101:8080/v2/apps -d@$1
