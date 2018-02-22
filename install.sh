#!/bin/bash

HOSTNAME=`hostname`
# Verify this is run by root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
echo "Copying cert deploy to /usr/bin"
cp ./cert-deploy.sh /usr/bin/cert-deploy.sh
chmod 755 /usr/bin/cert-deploy.sh
curl https://get.acme.sh | sh
/root/.acme.sh/acme.sh --issue --dns --renew-hook /usr/bin/cert-deploy.sh -d $HOSTNAME
echo "Add the TXT entry above before proceding"
read -n1 -r -p "Press space to continue... or any other key to abort" key

if [ "$key" = '' ]; then
    echo "Renewing Certificate"
else
    echo "Space not pressed, aborting"
    exit 1
fi
/root/.acme.sh/acme.sh --renew -d $HOSTNAME