# serverless-poc

## Use TerraForm to build the following:
* Lambda function
* API Gateway
* API Gateway resouces
* API Gateway deployment
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
curl -X GET <output url from terraform run>
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