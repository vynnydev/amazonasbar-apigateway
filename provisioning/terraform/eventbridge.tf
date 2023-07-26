module "eventbridge" {
  source  = "terraform-aws-modules/eventbridge/aws"
  version = "1.14.1"

  bus_name = local.stack_name
  attach_cloudwatch_policy = true

  cloudwatch_target_arns = [
    aws_cloudwatch_log_group.orders_events.arn
  ]

  rules = {
    orders = {
      description   = "Capture all order data"
      event_pattern = jsonencode({ "source" : ["amazonasbar.orders"] })
      enabled       = true
    }
  }
  
  targets = {
    orders = [
      {
        name = "log-orders-to-cloudwatch"
        arn  = aws_cloudwatch_log_group.orders_events.arn
      },
      {
        name = "send orders to delivery"
        arn = aws_lambda_function.delivery.arn
      }
    ]
  }
#   policy = ""
#   policy_json = ""
#   role_description = ""
#   role_name = ""
#   role_path =""
    role_permissions_boundary = length(data.aws_iam_policy.boundary) == 0 ? null: data.aws_iam_policy.boundary[0].arn
  # insert the 6 required variables here

  tags = {
    Environment = var.environment
    Application = var.application
  }
}

resource "aws_schemas_discoverer" "this" {
  source_arn  = module.eventbridge.eventbridge_bus_arn
  description = "Auto discover event schemas"
}