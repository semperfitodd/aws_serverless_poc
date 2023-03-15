output "api_gateway_lambda_base_url" {
  value = aws_api_gateway_deployment.apigw_lambda.invoke_url
}

output "api_gateway_lambda_dynamodb_base_url" {
  value = "${aws_api_gateway_deployment.dynamo.invoke_url}/query"
}