# This policy can be used to give permissions to other resources (e.g. lambda, apigateway)
# to put events on eventbridge
resource "aws_iam_policy" "eventbridge_basic" {
  name        = "AWSEventBridgeBasic"
  path        = "/"
  description = "Allows putting events and describing rules on the specified event bus"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "events:PutEvents",
        "events:DescribeRule"
      ]
      Effect   = "Allow"
      Sid      = ""
      Resource = module.eventbridge.eventbridge_bus_arn
      }
    ]
  })
}