#!/bin/bash

git clone https://github.com/urbanairship/tessera.git /opt/tessera/code
cd /opt/tessera/code
COMMIT_HASH=fd526f0a3129f87cfa1c2852dc907ae349e5ebba
git checkout $COMMIT_HASH

virtualenv /opt/tessera/venv
source /opt/tessera/venv/bin/activate

pip install -r /opt/tessera/code/requirements.txt
pip install -r /opt/tessera/code/dev-requirements.txt
pip install gunicorn mysql-python

inv initdb
npm install
grunt

touch /opt/tessera/.installed
