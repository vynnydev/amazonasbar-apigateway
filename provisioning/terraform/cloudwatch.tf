resource "aws_cloudwatch_log_group" "orders_lambda" {
  name = "/aws/lambda/${local.stack_name}-orders"

  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "delivery_lambda" {
  name = "/aws/lambda/${local.stack_name}-delivery"

  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "orders_events" {
  name              = "/aws/events/${module.eventbridge.eventbridge_bus_name}"
  retention_in_days = 7
  tags = {
    Environment = var.environment
    Application = var.application
  }
}