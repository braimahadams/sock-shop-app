#!/bin/bash

echo "Sleeping for 4min so that the dns is fully provisioned..."
sleep 2m

# Retrieve the Amazon DNS Name
AMAZON_DNS=$(kubectl get service/ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

echo "Sleeping for another 2 min ..."
sleep 1m

# Retrieve the External IP Address using nslookup
EXTERNAL_IP=$(nslookup "$AMAZON_DNS" | awk '/^Address: / { if (!printed) { print $2; printed=1 } }')

# Retrieve the current DNS record for your domain
CURRENT_DNS_RECORD=$(aws route53 list-resource-record-sets --hosted-zone-id Z103990236N60BIDDT81K --query "ResourceRecordSets[?Name=='braimahadams.com.' && Type=='A'].ResourceRecords[0].Value" --output text)

# Check if the current DNS record matches the external IP
if [ "$CURRENT_DNS_RECORD" == "$EXTERNAL_IP" ]; then
    echo "DNS record is already up to date. Skipping update."
else
    # Update the DNS record using the AWS CLI
    aws route53 change-resource-record-sets --hosted-zone-id Z103990236N60BIDDT81K --change-batch "{\"Changes\":[{\"Action\":\"UPSERT\",\"ResourceRecordSet\":{\"Name\":\"braimahadams.com\",\"Type\":\"A\",\"TTL\":300,\"ResourceRecords\":[{\"Value\":\"$EXTERNAL_IP\"}]}}]}"
    echo "DNS record updated to $EXTERNAL_IP"
fi

echo $EXTERNAL_IP
