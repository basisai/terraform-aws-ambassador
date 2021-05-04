# Host name of a LB is <LB_NAME>-<LB_ID>.elb.<region>.amazonaws.com
locals {
  lb      = split("-", split(".", var.lb_dns_name)[0])
  lb_name = join("-", slice(local.lb, 0, length(local.lb) - 1))
}

data "aws_region" "current" {
}

data "aws_caller_identity" "current" {
}

data "aws_lb" "lb" {
  name = local.lb_name
}

# tflint-ignore: aws_route53_record_invalid_name
resource "aws_route53_record" "alias" {
  for_each = var.dns_names

  zone_id = each.value
  name    = each.key
  type    = "A"

  alias {
    name                   = data.aws_lb.lb.dns_name
    zone_id                = data.aws_lb.lb.zone_id
    evaluate_target_health = true
  }
}
