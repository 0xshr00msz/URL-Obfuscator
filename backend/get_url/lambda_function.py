import json
import boto3
import os

# Get environment Variables Safely
AWS_REGION = os.environ.get('AWS_REGION', 'ap-southeast-1')
URL_TABLE = os.environ.get('URL_TABLE')

# set up dynamodb
dynamodb = boto3.resource('dynamodb', region_name=AWS_REGION)
table = dynamodb.Table(URL_TABLE)

def lambda_handler(event, context):
    try:
        # Getting specific attribute using ProjectionExpression for saving performance
        response = table.scan(
            ProjectionExpression="#encoded",
            ExpressionAttributeNames={
                "#encoded": "encode_url"
            }
        )
        items = response.get('Items', [])
        
        
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Methods': 'GET,OPTIONS'
            },
            'body': json.dumps(items)
        }
        
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
