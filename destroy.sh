#!/bin/bash

set -e

echo "Starting infrastructure destroy process..."

# Navigate to the infrastructure directory
cd infrastructure

echo "Destroying Terraform-managed infrastructure..."
terraform destroy -auto-approve

# Clean up build artifacts
echo "Cleaning up Lambda package files and temporary directories..."

cd ../backend

# Remove any Lambda package directories and ZIP archives
rm -rf get_url.zip post_url.zip
rm -rf get_url/__pycache__ post_url/__pycache__
rm -rf get_url/* post_url/*

echo "Cleanup complete!"

cd ..

echo "All resources have been destroyed successfully."
