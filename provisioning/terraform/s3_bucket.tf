resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.stack.id
  # acl           = "private"
  force_destroy = true
}

resource "aws_s3_object" "lambda_orders" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "orders.zip"
  source = local.orders_package

  etag = filemd5(local.orders_package)
}

resource "aws_s3_object" "lambda_delivery" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "delivery.zip"
  source = local.delivery_package

  etag = filemd5(local.delivery_package)
}