#!/bin/bash

/usr/local/bin/virtualenv /opt/graphite/venv --system-site-packages

PIP=/opt/graphite/venv/bin/pip

$PIP install graphite-web whisper carbon gunicorn django twisted django-tagging simplejson mysql-python

export PYTHONPATH=/opt/graphite/webapp/graphite
/opt/graphite/venv/bin/django-admin.py syncdb --settings=settings --noinput

touch /opt/graphite/.installed
