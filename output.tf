output "lb_dns_name" {
  description = "DNS name of the LB"
  value       = local.lb_dns_name
}

output "lb_arn" {
  description = "ARN of the LB"
  value       = module.dns.lb_arn
}
