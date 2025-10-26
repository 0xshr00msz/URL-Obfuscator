#!/bin/bash
set -e

echo "Building Lambda functions..."
cd backend
pip install -r requirements.txt -t get_url/
pip install -r requirements.txt -t post_url/

echo "Packaging Lambda functions..."
cd get_url && zip -r ../get_url.zip . && cd ..
cd post_url && zip -r ../post_url.zip . && cd ..

echo "Deploying infrastructure..."
cd ../infrastructure
terraform init
terraform plan
terraform apply -auto-approve

echo "Getting API Gateway URL..."
API_URL=$(terraform output -raw api_gateway_url)

echo "Updating frontend config..."
cd ../frontend

echo "Deployment complete!"
echo "API Gateway URL: $API_URL"
