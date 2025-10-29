#!/bin/bash

set -e

echo "🚀 Deploying URL Obfuscator with API Gateway Direct Integrations..."

# Package Lambda function for encoding only
echo "📦 Packaging encode Lambda function..."
cd backend/encode_url
zip -r ../encode_url.zip .
cd ../..

# Deploy infrastructure
echo "🏗️ Deploying infrastructure..."
cd infrastructure
terraform init
terraform plan
terraform apply -auto-approve

# Get API Gateway URL
API_URL=$(terraform output -raw api_gateway_url)
echo "✅ Deployment complete!"
echo "🌐 API Gateway URL: $API_URL"
echo ""
echo "📋 Available endpoints:"
echo "  POST $API_URL/encode  - Base64 encode URLs (Lambda)"
echo "  POST $API_URL/store   - Store URLs (Direct DynamoDB)"
echo "  GET  $API_URL/urls    - Get all URLs (Direct DynamoDB)"

cd ..
