#!/bin/bash

DB_ID="test-web-downgrade"

DB_ID_SANDBOX="nymbl-db-sandbox"

VPC_ID_TEST=$(aws rds describe-db-instances \
  --db-instance-identifier ${DB_ID} \
  --query 'DBInstances[0].DBSubnetGroup.VpcId' \
  --output text)

VPC_ID_SANDBOX=$(aws rds describe-db-instances \
  --db-instance-identifier ${DB_ID_SANDBOX} \
  --query 'DBInstances[0].DBSubnetGroup.VpcId' \
  --output text)

  echo "vpc test: $VPC_ID_TEST"
  echo "vpc sandbox: $VPC_ID_SANDBOX"

IGW_ID_TEST=$(aws ec2 describe-internet-gateways \
  --filters Name=attachment.vpc-id,Values="${VPC_ID_TEST}" \
  --query 'InternetGateways[0].InternetGatewayId' \
  --output text)

IGW_ID_SANDBOX=$(aws ec2 describe-internet-gateways \
  --filters Name=attachment.vpc-id,Values="${VPC_ID_SANDBOX}" \
  --query 'InternetGateways[0].InternetGatewayId' \
  --output text)

  echo "igw test: $IGW_ID_TEST"
  echo "igw sandbox: $IGW_ID_SANDBOX"

PUBLIC_SUBNETS_TEST=$(aws ec2 describe-route-tables \
  --query  'RouteTables[*].Associations[].SubnetId' \
  --filters Name=vpc-id,Values="${VPC_ID_TEST}" \
            Name=route.gateway-id,Values="${IGW_ID_TEST}" \
            | jq . -c)

echo "public_test"
echo "$PUBLIC_SUBNETS_TEST"

PUBLIC_SUBNETS_SANDBOX=$(aws ec2 describe-route-tables \
  --query  'RouteTables[*].Associations[].SubnetId' \
  --filters Name=vpc-id,Values="${VPC_ID_SANDBOX}" \
            Name=route.gateway-id,Values="${IGW_ID_SANDBOX}" \
            | jq . -c)

echo "public_sandbox"
echo "$PUBLIC_SUBNETS_SANDBOX"

#PRIVATE_SUBNETS=$(aws ec2 describe-subnets \
#  --filter Name=vpc-id,Values=${VPC_ID} \
#  --query 'Subnets[].SubnetId' \
#  | jq -c '[ .[] | select( . as $i | '${PUBLIC_SUBNETS}' | index($i) | not) ]')
#
#echo "private"
#echo "$PRIVATE_SUBNETS"