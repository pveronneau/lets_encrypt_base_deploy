#!/bin/bash
# Deploy certificates from acme.sh to services

####
# Variables
####
HOSTNAME=`hostname`
CERTLOCATION="/etc/$HOSTNAME.cert"

####
# Create combined pem file
cat /root/.acme.sh/$HOSTNAME/$HOSTNAME.key > $CERTLOCATION && cat /root/.acme.sh/$HOSTNAME/$HOSTNAME.cer >> $CERTLOCATION
chmod 600 $CERTLOCATION
####
####
# Deploy to servies
####
# Copy host cert over default cockpit cert and restart
cp $CERTLOCATION /etc/cockpit/ws-certs.d/0-self-signed.cert && systemctl restart cockpit
# Copy host cert over default 3dm2 cert and restart
cp $CERTLOCATION /etc/3dm2/3dm2.pem && systemctl restart tdm2