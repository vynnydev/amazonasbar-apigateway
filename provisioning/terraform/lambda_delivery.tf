resource "aws_lambda_function" "delivery" {
  function_name = "${local.stack_name}-delivery"
  description = "Amazonas bar delivery processing"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_delivery.key

  runtime = "nodejs16.x"
  handler = "delivery.lambdaHandler"

  source_code_hash = filebase64sha256(local.delivery_package)

  role = aws_iam_role.delivery_lambda_exec_role.arn

  environment {
    variables = {
      EVENT_BUS_NAME = module.eventbridge.eventbridge_bus_name
      INTERNAL_EVENTS_API_URI = aws_api_gateway_stage.events.invoke_url
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.delivery_lambda,
  ]
}

# give Event bridge permission to invoke your lambda function. This is configured as a resource based 
# policy on the lambda function
resource "aws_lambda_permission" "event_bridge" {
  statement_id  = "AllowExecutionFromEventBridgedelivery"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delivery.function_name
  principal     = "events.amazonaws.com"
  source_arn = module.eventbridge.eventbridge_rule_arns["orders"]
}