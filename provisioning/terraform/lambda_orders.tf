resource "aws_lambda_function" "orders" {
  function_name = "${local.stack_name}-orders"
  description = "Amazonas bar orders processing"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_orders.key

  runtime = "nodejs16.x"
  handler = "orders.lambdaHandler"

  source_code_hash = filebase64sha256(local.orders_package)

  role = aws_iam_role.lambda_exec_role.arn

   environment {
    variables = {
      EVENT_BUS_NAME = module.eventbridge.eventbridge_bus_name
      INTERNAL_EVENTS_API_URI = aws_api_gateway_stage.events.invoke_url
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.orders_lambda,
  ]
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}