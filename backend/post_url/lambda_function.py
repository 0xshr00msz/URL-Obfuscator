import json
import boto3
import os
import uuid

# Get Environment Variables Safely
AWS_REGION = os.environ.get('AWS_REGION', 'ap-southeast-1')
URL_TABLE = os.environ.get('URL_TABLE')

# Set up DynamoDB
dynamodb = boto3.resource('dynamodb', region_name=AWS_REGION)
table = dynamodb.Table(URL_TABLE)

# Helper Function -> Base64 Encoder
import base64
def encode_base64(url:str) -> str:
    encoded = base64.b64encode(url.encode('utf-8'))
    return encoded.decode('utf-8')

# Lambda Handler
def handler(event, context):
    headers = {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Methods': 'POST, OPTIONS',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization'
    }

    # Handle Preflight Request
    if event['httpMethod'] == 'OPTIONS':
        return {
            'statusCode': 200,
            'headers'   : headers,
            'body'      : ''
        }

    # Parse Input Safely
    try:
        # event.get("body") means it accesses the key safely.
        # If the key does not exist, it returns NONE. It gracefully handle errors.
        # "{}" means to display empty string if it is indeed empty
        body = json.loads(event.get("body", "{}"))
        # The 'url' is a variable or key-pair from the frontend
        url = body.get('content', '').strip()

    except (ValueError, AttributeError):
        return {
            'statusCode': 400,
            'headers'   : headers,
            'body'      : json.dumps({
                'error': 'Invalid JSON'
            })
        }

    # Checks if URL is empty or not
    if not url:
        return {
            'statusCode': 400,
            'headers'   : headers,
            'body'      : json.dumps({
                'error': 'URL is empty'
            })
        }

    # Entry ID for DynamoDB
    entry_id = str(uuid.uuid4())
    # Encode URL Submitted into Base64
    encode_url = encode_base64(url)

    # Put item into DynamoDB
    table.put_item(
        Item={
            'id': entry_id,
            'url': url,
            'encode_url': encode_url
        }
    )

    return {
        'statusCode': 200,
        'headers'   : headers,
        # Return event output for debugging purposes only
        # Do not return event when in Production!
        'body'      : json.dumps({
            'message': 'URL saved successfully',
            'id': entry_id,
            'encode_url': encode_url
        })
    }