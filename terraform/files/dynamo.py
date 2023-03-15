import boto3
import decimal
import json
import logging

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('serverless_poc')
dynamodb_client = boto3.client('dynamodb')

logger = logging.getLogger()
logger.setLevel(logging.INFO)


class DecimalEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, decimal.Decimal):
            return int(obj)
        return super(DecimalEncoder, self).default(obj)


def lambda_handler(event, context):
    http_method = event['httpMethod']

    if http_method == 'GET':
        operation = event['queryStringParameters']['operation']

        if operation == 'read':
            customer_id = event['queryStringParameters']['CustomerId']
            last_name = event['queryStringParameters']['LastName']
            logger.info(f"Getting item with CustomerId: {customer_id}, LastName: {last_name}")
            response = dynamodb_client.get_item(
                TableName='serverless_poc',
                Key={
                    'CustomerId': {'N': str(customer_id)},
                    'LastName': {'S': last_name}
                }
            )
            return {
                'statusCode': 200,
                'body': json.dumps(response['Item']),
                'headers': {'Content-Type': 'application/json'}
            }

        elif operation == 'query_all':
            response = table.scan()
            items = response['Items']
            return {
                'statusCode': 200,
                'body': json.dumps(items, cls=DecimalEncoder),
                'headers': {'Content-Type': 'application/json'}
            }

        else:
            return {
                'statusCode': 400,
                'body': json.dumps({'status': 'error', 'message': 'Invalid operation'}),
                'headers': {'Content-Type': 'application/json'}
            }

    elif http_method == 'POST':
        event_body = json.loads(event['body'])
        item = {
            'CustomerId': decimal.Decimal(str(event_body['CustomerId'])),
            'LastName': event_body['LastName'],
            'FirstName': event_body['FirstName'],
            'MiddleInitial': event_body['MiddleInitial'],
            'Gender': event_body['Gender'],
            'Age': event_body['Age'],
            'HairColor': event_body['HairColor']
        }
        response = table.put_item(Item=item)
        return {
            'statusCode': 200,
            'body': json.dumps({
                'status': 'success',
                'message': 'Item written to the table',
                'item': item,
                'dynamodb_response': response
            }, cls=DecimalEncoder),
            'headers': {'Content-Type': 'application/json'}
        }

    else:
        return {
            'statusCode': 400,
            'body': json.dumps({'status': 'error', 'message': 'Invalid HTTP method'}),
            'headers': {'Content-Type': 'application/json'}
        }
