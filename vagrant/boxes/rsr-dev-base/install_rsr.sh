
if [ ! -e /var/akvo/rsr/venv ]
then
    sudo -H -u rsr virtualenv --quiet /var/akvo/rsr/venv
    REQS_URL="https://raw.github.com/akvo/akvo-rsr/master/scripts/deployment/pip/requirements/2_rsr.txt"
    curl $REQS_URL > /tmp/requirements.txt
    sudo -H -u rsr /var/akvo/rsr/venv/bin/pip install -r /tmp/requirements.txt
fi
