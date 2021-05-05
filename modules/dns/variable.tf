variable "lb_dns_name" {
  description = "LoadBalancer DNS name"
}

variable "dns_names" {
  description = "Map of DNS names to create records for. Key is DNS name, value is the Zone ID"
  type        = map(string)
  default     = {}
}
