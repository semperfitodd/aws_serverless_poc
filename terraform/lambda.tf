data "archive_file" "app" {
  source_file = "${path.module}/files/app.py"
  output_path = "app.zip"
  type        = "zip"
}

resource "aws_lambda_function" "this" {
  filename      = "app.zip"
  function_name = var.environment
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "app.lambda_handler"
  runtime       = "python3.9"

  source_code_hash = data.archive_file.app.output_path

  tags = var.tags
}