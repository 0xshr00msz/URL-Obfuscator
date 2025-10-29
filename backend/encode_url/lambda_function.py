import json
import base64
import uuid

def lambda_handler(event, context):
    headers = {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'POST, OPTIONS'
    }

    if event['httpMethod'] == 'OPTIONS':
        return {'statusCode': 200, 'headers': headers, 'body': ''}

    try:
        body = json.loads(event.get("body", "{}"))
        url = body.get('content', '').strip()
    except (ValueError, AttributeError):
        return {
            'statusCode': 400,
            'headers': headers,
            'body': json.dumps({'error': 'Invalid JSON'})
        }

    if not url:
        return {
            'statusCode': 400,
            'headers': headers,
            'body': json.dumps({'error': 'URL is empty'})
        }

    entry_id = str(uuid.uuid4())
    encoded_url = base64.b64encode(url.encode('utf-8')).decode('utf-8')

    return {
        'statusCode': 200,
        'headers': headers,
        'body': json.dumps({
            'id': entry_id,
            'url': url,
            'encode_url': encoded_url
        })
    }
