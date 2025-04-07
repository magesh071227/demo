#!/bin/bash
#
# Script to set the parameters for the cafe application in the Parameter Store.
#
#
# Get the region where the instance is running, and set as it the default AWS region.
# This ensures that we are using the Parameter Store in the region where the instance is running.
#
echo
echo "Setting the default AWS region..."
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
#curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/

az=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/placement/availability-zone)
region=${az%?}
export AWS_DEFAULT_REGION=$region
echo "Region =" $AWS_DEFAULT_REGION
#
# Set the application parameter values.
#
publicDNS=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/public-hostname)
echo "Public DNS =" $publicDNS

echo "Setting the application parameter values in the Secrets Manager..."
aws secretsmanager create-secret --name "/cafe/showServerInfo1" --secret-string "false"
aws secretsmanager create-secret --name "/cafe/timeZone1" --secret-string "America/New_York"
aws secretsmanager create-secret --name "/cafe/currency1" --secret-string "$"
aws secretsmanager create-secret --name "/cafe/dbUrl1" --secret-string $publicDNS
aws secretsmanager create-secret --name "/cafe/dbName1" --secret-string "cafe_db"
aws secretsmanager create-secret --name "/cafe/dbUser1" --secret-string "admin"
aws secretsmanager create-secret --name "/cafe/dbPassword1" --secret-string "Lab123#"

echo
echo "Application Secrets Setup script completed."
echo
