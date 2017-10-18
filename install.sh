#!/bin/bash

HOSTNAME=`hostname`

curl https://get.acme.sh | sh
acme.sh --issue --dns --renew-hook /usr/bin/cert-deploy.sh -d $HOSTNAME
echo "Add the TXT entry above before proceding"
read -n1 -r -p "Press space to continue... or any other key to abort" key

if [ "$key" = '' ]; then
    echo "Renewing Certificate"
else
    echo "Space not pressed, aborting"
    exit 1
fi
acme.sh --renew -d $HOSTNAME
echo "Copying cert deploy to /usr/bin"
cp ./cert-deploy.sh /usr/bin/cert-deploy.sh
chmod 755 /usr/bin/cert-deploy.sh
