import json
import boto3
import os

# Get Environment Variables Safely
AWS_REGION = os.environ.get('AWS_REGION', 'ap-southeast-1')
URL_TABLE = os.environ.get('URL_TABLE')

# Set up DynamoDB
dynamodb = boto3.resource('dynamodb', region_name=AWS_REGION)
table = dynamodb.Table(URL_TABLE)


# Lambda Handler
def handler(event, context):
    headers = {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Methods': 'GET, OPTIONS',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization'
    }

    # Handle Preflight Request
    if event['httpMethod'] == 'OPTIONS':
        return {
            'statusCode': 200,
            'headers': headers,
            'body': ''
        }

    # Ensure method is GET
    if event['httpMethod'] != 'GET':
        return {
            'statusCode': 405,
            'headers': headers,
            'body': json.dumps({'error': 'Method Not Allowed'})
        }

    # Extract query string parameters safely
    params = event.get('queryStringParameters', {}) or {}
    entry_id = params.get('id')

    if not entry_id:
        return {
            'statusCode': 400,
            'headers': headers,
            'body': json.dumps({'error': 'Missing id parameter'})
        }

    try:
        # Fetch item from DynamoDB
        response = table.get_item(Key={'id': entry_id})

        if 'Item' not in response:
            return {
                'statusCode': 404,
                'headers': headers,
                'body': json.dumps({'error': 'Entry not found'})
            }

        # Return item
        return {
            'statusCode': 200,
            'headers': headers,
            'body': json.dumps(response['Item'])
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'headers': headers,
            'body': json.dumps({'error': str(e)})
        }
