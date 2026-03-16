def lambda_handler(event, context):
    
    message = "Hello from AWS Lambda!123"

    return {
        'statusCode': 200,
        'body': message
    }