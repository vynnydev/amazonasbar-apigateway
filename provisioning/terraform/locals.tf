locals {
  stack_name = "amazonasbar-awstf"

  orders_package = "${path.module}/../../applications/build/orders.zip"
  delivery_package = "${path.module}/../../applications/build/delivery.zip"
}