# serverless-poc

## Use TerraForm to build the following:
* Lambda functions
* API Gateways
* API Gateway resources
* API Gateway deployments
* Step Function
* IAM policies and roles
## Set variables in variables.tf
* my_name
* tags
## Set backend
* give valid S3 bucket and key where you want your state held
## Run Terraform
```
terraform init
terraform validate
terraform plan -out=plan.out
terraform apply plan.out
```
## Curl Endpoint to test API gateway
```
curl -X GET <output url from api_gateway_lambda_base_url>
```
## Test API Gateway > Lambda > DynamoDB
* Write new record (try a few)
```
curl -X POST "<api_gateway_lambda_dynamodb_base_url>" \
    -H "Content-Type: application/json" \
    -d '{
        "CustomerId": 0,
        "LastName": "Doe",
        "FirstName": "Jane",
        "MiddleInitial": "M",
        "Gender": "F",
        "Age": 35,
        "HairColor": "Brown"
    }'
```
* Check on a specific record
```
curl -G "<api_gateway_lambda_dynamodb_base_url>" \
    --data-urlencode "operation=read" \
    --data-urlencode "CustomerId=0" \
    --data-urlencode "LastName=Doe"
```
* List all records
```
curl -G "<api_gateway_lambda_dynamodb_base_url>" \
    --data-urlencode "operation=query_all"
```
## Execute Step Function to get response
* Go to step functions in the console
![step_function.png](files%2Fstep_function.png)
* Insert appropriate json input
```
{
  "name": "<your_name>"
}
```
* Check the InvokeLambda state for the ouput
![invoke_lambda.png](files%2Finvoke_lambda.png)
## Clean up Terraform
```
terraform destroy
```