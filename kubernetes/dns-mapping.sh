#!/bin/bash

echo "Sleeping for 4min so that the dns is fully provisioned..."
sleep 4m


# Retrieve the Amazon DNS Name
AMAZON_DNS=$(kubectl get service/ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')


echo "Sleeping for another 2 min ..."
sleep 2m

# Retrieve the External IP Address using nslookup
EXTERNAL_IP=$(nslookup "$AMAZON_DNS" | awk '/^Address: / { if (!printed) { print $2; printed=1 } }')


# Update the DNS record using the AWS CLI
aws route53 change-resource-record-sets --hosted-zone-id Z103990236N60BIDDT81K --change-batch "{\"Changes\":[{\"Action\":\"UPSERT\",\"ResourceRecordSet\":{\"Name\":\"braimahadams.com\",\"Type\":\"A\",\"TTL\":300,\"ResourceRecords\":[{\"Value\":\"$EXTERNAL_IP\"}]}}]}"


echo $EXTERNAL_IP
