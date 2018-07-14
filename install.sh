#!/bin/bash
# AWS user must have the following policy
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "route53:ListHostedZones"
#             ],
#             "Resource": "*"
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "route53:GetHostedZone",
#                 "route53:ListResourceRecordSets",
#                 "route53:ChangeResourceRecordSets"
#             ],
#             "Resource": "arn:aws:route53:::hostedzone/<PUT YOUR DOMAIN ID HERE>"
#         }
#     ]
# }
####
##Set your AWS keys here
export  AWS_ACCESS_KEY_ID=XXXXXXXXXX
export  AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXXXX
####

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
/root/.acme.sh/acme.sh --issue --dns dns_aws --deploy-hook /usr/bin/cert-deploy.sh --renew-hook /usr/bin/cert-deploy.sh -d $HOSTNAME
