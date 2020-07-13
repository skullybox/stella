#! /bin/bash

ZONE_ID=''
HOST_RECORD=''
PUB_IP=$(curl -s https://checkip.amazonaws.com)

aws route53 change-resource-record-sets --hosted-zone-id $ZONE_ID --change-batch \
'{"Changes":[{"Action":"UPSERT","ResourceRecordSet":{"Name":"'$HOST_RECORD'","Type":"A","TTL":300,"ResourceRecords":[{"Value":"'$PUB_IP'"}]}}]}'

