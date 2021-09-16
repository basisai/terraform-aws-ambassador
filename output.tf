output "lb_dns_name" {
  description = "DNS name of the LB"
  value       = local.lb_dns_name
}

output "lb_arn" {
  description = "ARN of the LB"
  value       = module.dns.lb_arn
}

output "ambassador_id" {
  description = "Ambassador ID"
  value       = var.ambassador_id
}

output "dns_records" {
  description = "DNS records pointing to the load balancers"
  value = [
    for fqdn, _ in var.dns_names:
    {
      fqdn = fqdn
      type = "CNAME"
      record = local.lb_dns_name
    }
  ]
}
