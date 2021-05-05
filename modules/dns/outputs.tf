output "lb" {
  description = "LB Object"
  value       = data.aws_lb.lb
}

output "lb_arn" {
  description = "ARN of LB"
  value       = data.aws_lb.lb.arn
}
