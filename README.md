# 🕵️‍♂️ URL Obfuscator

A lightweight web application that encodes and manages URLs using Base64 to prevent non-technical end users from directly viewing the actual addresses (including sensitive or NSFW links).
The system runs on a serverless AWS backend for scalable, cost-efficient operation.

## 🧩 Project Overview
url-obfuscator allows you to encode, store, and decode URLs securely.
Its frontend offers a clean dashboard interface, while the backend utilizes AWS Lambda and DynamoDB to manage data without traditional servers.

## Project Structure

```
b64web/
├── frontend/           # Client-side application
│   ├── index.html     # Main dashboard interface
│   ├── script.js      # Core JavaScript functionality
│   ├── style.css      # Application styling
│   ├── config.js      # Configuration settings
│   ├── create_entry.js # Entry creation logic
│   └── get_entry.js   # Entry retrieval logic
├── backend/           # AWS Lambda functions
│   ├── get_url/       # URL retrieval function
│   ├── post_url/      # URL storage function
│   └── requirements.txt
├── infrastructure/    # AWS infrastructure code
├── deploy.sh         # Deployment script
└── destroy.sh        # Cleanup script
```

## ⚙️ Features

- 🔐 Base64 Encoding/Decoding for URL obfuscation
- ☁️ Serverless Backend powered by AWS Lambda
- 🗃️ DynamoDB Integration for persistent URL storage
- 💻 Web Dashboard Interface for managing entries
- 🚀 Automated Deployment Scripts for easy setup and teardown

## 📦 Prerequisites

- AWS CLI authenticated and configured
- Python 3.x (for backend)
- Terraform (for infrastructure)

## Setup

1. Clone the repository
2. Configure AWS credentials
3. Run deployment script:
   ```bash
   ./deploy.sh
   ```

## Usage

Access the web dashboard to:
- Add new URL entries
- View existing entries
- Manage encoded URLs

## Deployment

Use the provided scripts:
- `./deploy.sh` - Deploy infrastructure and application
- `./destroy.sh` - Clean up AWS resources

## Technology Stack

- Frontend: Purely HTML, CSS, JavaScript
- Backend: AWS Lambda (Python)
- Database: AWS DynamoDB
- Infrastructure: Terraform
