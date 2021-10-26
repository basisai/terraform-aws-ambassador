variable "create_dns_records" {
  description = "Create DNS records"
  type        = bool
  default     = true
}

variable "lb_dns_name" {
  description = "LoadBalancer DNS name"
  type        = string
}

variable "enable_l7_load_balancing" {
  description = "Use L7 (ALB) for load balancing. Otherwise, L4 (NLB) is used"
  type        = bool
  default     = false
}

variable "internet_facing" {
  description = "Whether the Load Balancer, L7 or L4 is internet facing"
  type        = bool
  default     = true
}

variable "dns_names" {
  description = "Map of DNS names to create records for. Key is DNS name, value is the Zone ID"
  type        = map(string)
  default     = {}
}
