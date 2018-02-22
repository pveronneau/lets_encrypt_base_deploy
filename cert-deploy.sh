#!/bin/bash
# Deploy certificates from acme.sh to services

####
# Variables
####
HOSTNAME=`hostname`
CERTLOCATION="/etc/$HOSTNAME.cert"
PKCS12LOCATION="/etc/$HOSTNAME.pfx"

####
# Create combined pem file
cat /root/.acme.sh/$HOSTNAME/$HOSTNAME.key > $CERTLOCATION && cat /root/.acme.sh/$HOSTNAME/$HOSTNAME.cer >> $CERTLOCATION
chmod 600 $CERTLOCATION
####
####
# Create pkcs12 file
####
openssl pkcs12 -export -in /root/.acme.sh/$HOSTNAME/$HOSTNAME.cer -inkey /root/.acme.sh/$HOSTNAME/$HOSTNAME.key -out $PKCS12LOCATION -certfile /root/.acme.sh/$HOSTNAME/ca.cer -passout pass:
chmod 600 $PKCS12LOCATION
####
# Deploy to servies
####
# Copy host cert over default cockpit cert and restart
cp $CERTLOCATION /etc/cockpit/ws-certs.d/0-self-signed.cert && systemctl restart cockpit
# Copy host cert over default 3dm2 cert and restart
cp $CERTLOCATION /etc/3dm2/3dm2.pem && systemctl restart tdm2