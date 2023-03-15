data "archive_file" "api_step" {
  source_file = "${path.module}/files/app.py"
  output_path = "app.zip"
  type        = "zip"
}

data "archive_file" "dynamo" {
  source_file = "${path.module}/files/dynamo.py"
  output_path = "dynamo.zip"
  type        = "zip"
}

resource "aws_lambda_function" "api_step" {
  filename      = "app.zip"
  function_name = var.environment
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "app.lambda_handler"
  runtime       = "python3.9"

  source_code_hash = data.archive_file.api_step.output_path

  tags = var.tags
}

resource "aws_lambda_function" "dynamo" {
  filename      = "dynamo.zip"
  function_name = "${var.environment}_dynamo"
  role          = aws_iam_role.dynamo_lambda_execution_role.arn
  handler       = "dynamo.lambda_handler"
  runtime       = "python3.9"

  source_code_hash = data.archive_file.api_step.output_path

  tags = var.tags
}
