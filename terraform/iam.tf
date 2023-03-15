data "aws_iam_policy" "AWSLambdaBasicExecutionRole" {
  name = "AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "dynamo_lambda_policy" {
  statement {
    actions = [
      "dynamodb:Get*",
      "dynamodb:Put*",
      "dynamodb:Scan",
    ]
    effect    = "Allow"
    resources = [aws_dynamodb_table.customer.arn]
  }
}

data "aws_iam_policy_document" "lambda_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "step_function_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      identifiers = ["states.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "step_function_policy" {
  statement {
    actions = [
      "xray:GetSamplingRules",
      "xray:GetSamplingTargets",
      "xray:PutTelemetryRecords",
      "xray:PutTraceSegments",
    ]
    effect    = "Allow"
    resources = ["*"]
  }
  statement {
    actions = ["lambda:InvokeFunction"]
    effect  = "Allow"
    resources = [
      aws_lambda_function.api_step.arn,
      aws_lambda_function.dynamo.arn,
    ]
  }
  statement {
    actions = [
      "logs:CreateLogDelivery",
      "logs:DeleteLogDelivery",
      "logs:DescribeLogGroups",
      "logs:DescribeResourcePolicies",
      "logs:GetLogDelivery",
      "logs:ListLogDeliveries",
      "logs:PutLogEvents",
      "logs:PutResourcePolicy",
      "logs:UpdateLogDelivery",
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "dynamo_lambda_policy" {
  name = "${var.environment}_dynamo_lambda_policy"

  policy = data.aws_iam_policy_document.dynamo_lambda_policy.json

  tags = var.tags
}

resource "aws_iam_policy" "step_function_policy" {
  name = "${var.environment}_step_function_policy"

  policy = data.aws_iam_policy_document.step_function_policy.json

  tags = var.tags
}

resource "aws_iam_role" "dynamo_lambda_execution_role" {
  name = "${var.environment}_dynamo_lambda_execution_role"

  assume_role_policy = data.aws_iam_policy_document.lambda_execution_role.json

  tags = var.tags
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "${var.environment}_lambda_execution_role"

  assume_role_policy = data.aws_iam_policy_document.lambda_execution_role.json

  tags = var.tags
}

resource "aws_iam_role" "step_function_execution_role" {
  name = "${var.environment}_step_function_execution_role"

  assume_role_policy = data.aws_iam_policy_document.step_function_execution_role.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "dynamo_basic_lambda_execution_policy" {
  policy_arn = data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn
  role       = aws_iam_role.dynamo_lambda_execution_role.name
}

resource "aws_iam_role_policy_attachment" "dynamo_lambda_policy" {
  policy_arn = aws_iam_policy.dynamo_lambda_policy.arn
  role       = aws_iam_role.dynamo_lambda_execution_role.name
}

resource "aws_iam_role_policy_attachment" "lambda_execution_policy" {
  policy_arn = data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn
  role       = aws_iam_role.lambda_execution_role.name
}

resource "aws_iam_role_policy_attachment" "step_function_policy" {
  policy_arn = aws_iam_policy.step_function_policy.arn
  role       = aws_iam_role.step_function_execution_role.name
}
