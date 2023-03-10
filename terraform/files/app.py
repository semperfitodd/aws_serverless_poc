import json


def lambda_handler(event, context):
    name = event.get('name', 'Unknown')
    message = f'This is your serverless application using API Gateway and Lambda.'
    return {
        'statusCode': 200,
        'body': json.dumps(message)
    }
