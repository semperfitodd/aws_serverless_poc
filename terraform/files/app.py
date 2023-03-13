import json


def lambda_handler(event, context):
    print(f"Event: {json.dumps(event)}")
    message = "Hello, "
    if 'name' in event and isinstance(event['name'], str):
        name = event['name']
        print(f"Type of name: {type(name)}")
        message += f"My name is {name}."
    else:
        message += "I didn't receive a valid name."
    output = {
        'Message': message,
        'IAM Role': context.invoked_function_arn.split(':')[-1]
    }
    print(f"Output: {json.dumps(output)}")
    return {
        'statusCode': 200,
        'body': json.dumps(output)
    }
