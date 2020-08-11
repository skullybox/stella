#! /bin/sh

# grab host zones
# aws route53 list-hosted-zones

ZONE_ID=''
HOST_RECORD=''
PUB_IP=$(curl -s https://checkip.amazonaws.com)

python -m awscli route53 change-resource-record-sets --hosted-zone-id $ZONE_ID --change-batch \
'{"Changes":[{"Action":"UPSERT","ResourceRecordSet":{"Name":"'$HOST_RECORD'","Type":"A","TTL":300,"ResourceRecords":[{"Value":"'$PUB_IP'"}]}}]}'

