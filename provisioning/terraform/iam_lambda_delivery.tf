resource "aws_iam_role" "delivery_lambda_exec_role" {
  name = "${local.stack_name}-delivery-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
  permissions_boundary = length(data.aws_iam_policy.boundary) == 0 ? null : data.aws_iam_policy.boundary[0].arn
}

resource "aws_iam_role_policy_attachment" "delivery_lambda_execution_policy" {
  role       = aws_iam_role.delivery_lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "delivery_lambda_logging" {
  name        = "${aws_lambda_function.delivery.function_name}-cloudwatch"
  path        = "/"
  description = "IAM policy for logging from the delivery lambda function"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Effect   = "Allow"
      Resource = aws_cloudwatch_log_group.delivery_lambda.arn
    }]
  })
}

resource "aws_iam_role_policy_attachment" "delivery_lambda_logs_policy" {
  role       = aws_iam_role.delivery_lambda_exec_role.name
  policy_arn = aws_iam_policy.delivery_lambda_logging.arn
}