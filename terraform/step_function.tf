resource "aws_sfn_state_machine" "sfn_state_machine" {
  name     = var.environment
  role_arn = aws_iam_role.step_function_execution_role.arn

  definition = <<EOF
{
  "Comment": "A Step Functions state machine that invokes a Lambda function with input, conditionally including the user's name.",
  "StartAt": "ValidateInput",
  "States": {
    "ValidateInput": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.name",
          "StringEquals": "",
          "Next": "InvalidInput"
        },
        {
          "Variable": "$.name",
          "IsPresent": false,
          "Next": "InvalidInput"
        }
      ],
      "Default": "GetName"
    },
    "InvalidInput": {
      "Type": "Fail",
      "Cause": "Invalid input format",
      "Error": "InvalidInput"
    },
    "GetName": {
      "Type": "Pass",
      "ResultPath": "$",
      "Next": "InvokeLambda"
    },
    "InvokeLambda": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.this.arn}",
      "InputPath": "$",
      "ResultPath": "$.lambda_output",
      "OutputPath": "$.lambda_output",
      "End": true
    }
  }
}
EOF

  logging_configuration {
    log_destination        = "${aws_cloudwatch_log_group.step_function.arn}:*"
    include_execution_data = true
    level                  = "ERROR"
  }

  type = "STANDARD"

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "step_function" {
  name = "${var.environment}_step_function"

  retention_in_days = 7

  tags = var.tags
}