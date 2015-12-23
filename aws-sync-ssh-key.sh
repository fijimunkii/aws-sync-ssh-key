#!/usr/bin/env bash

keyname=$USER
publickeyfile=/Users/$USER/.ssh/id_rsa.pub

echo Uploading public ssh key to all ec2 regions as: $keyname

regions=$(aws ec2 describe-regions \
  --output text \
  --query 'Regions[*].RegionName')

for region in $regions; do
  echo $region
  aws ec2 delete-key-pair \
    --region "$region" \
    --key-name "$keyname"
  aws ec2 import-key-pair \
    --region "$region" \
    --key-name "$keyname" \
    --public-key-material "file://$publickeyfile"
done
