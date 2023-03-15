resource "aws_api_gateway_deployment" "apigw_lambda" {
  depends_on = [
    aws_api_gateway_integration.dynamo_query_all,
    aws_api_gateway_integration.lambda,
    aws_api_gateway_integration.lambda_root,
  ]

  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = "test"
}

resource "aws_api_gateway_deployment" "dynamo" {
  depends_on = [
    aws_api_gateway_integration.dynamo_query_all,
    aws_api_gateway_integration.dynamo_root,
  ]

  rest_api_id = aws_api_gateway_rest_api.dynamo.id
  stage_name  = "test"
}

resource "aws_api_gateway_integration" "dynamo_query_all" {
  rest_api_id = aws_api_gateway_rest_api.dynamo.id
  resource_id = aws_api_gateway_resource.dynamo_query_all.id
  http_method = aws_api_gateway_method.dynamo_query_all.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.dynamo.invoke_arn

  request_templates = {
    "application/json" = "{\"operation\": \"query\"}"
  }
}

resource "aws_api_gateway_integration" "dynamo_root" {
  rest_api_id = aws_api_gateway_rest_api.dynamo.id
  resource_id = aws_api_gateway_method.dynamo_root.resource_id
  http_method = aws_api_gateway_method.dynamo_root.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.dynamo.invoke_arn
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_method.proxy.resource_id
  http_method = aws_api_gateway_method.proxy.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.api_step.invoke_arn
}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_method.proxy_root.resource_id
  http_method = aws_api_gateway_method.proxy_root.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.api_step.invoke_arn
}

resource "aws_api_gateway_method" "dynamo_query_all" {
  rest_api_id   = aws_api_gateway_rest_api.dynamo.id
  resource_id   = aws_api_gateway_resource.dynamo_query_all.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "dynamo_root" {
  rest_api_id   = aws_api_gateway_rest_api.dynamo.id
  resource_id   = aws_api_gateway_rest_api.dynamo.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_rest_api.this.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_resource" "dynamo_query_all" {
  rest_api_id = aws_api_gateway_rest_api.dynamo.id
  parent_id   = aws_api_gateway_rest_api.dynamo.root_resource_id
  path_part   = "query"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "hello"
}

resource "aws_api_gateway_rest_api" "dynamo" {
  name        = "${var.environment}_dynamo"
  description = "${var.environment} dynamo rest api gateway"

  tags = var.tags
}

resource "aws_api_gateway_rest_api" "this" {
  name        = var.environment
  description = "${var.environment} rest api gateway"

  tags = var.tags
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api_step.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.this.execution_arn}/*/*"
}

resource "aws_lambda_permission" "dynamo" {
  statement_id  = "AllowAPIGatewayInvokeCreateMovie"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.dynamo.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.dynamo.execution_arn}/*/*"
}
