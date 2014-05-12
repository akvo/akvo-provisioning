#!/bin/bash

/usr/local/bin/virtualenv /opt/sentry/venv --system-site-packages

PIP=/opt/sentry/venv/bin/pip

$PIP install sentry[mysql]

/opt/sentry/venv/bin/sentry init /opt/sentry/conf.py --noinput

touch /opt/sentry/.installed
