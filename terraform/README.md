# serverless-poc

## Use TerraForm to build the following:
* Lambda function
* API Gateway
* API Gateway resouces
* API Gateway deployment
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
## Curl Endpoint
```
curl -X GET <output url from terraform run>
```
## Clean up Terraform
```
terraform destroy
```