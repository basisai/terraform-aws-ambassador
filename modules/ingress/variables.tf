variable "name" {
  description = "Name of the Ingress"
  type        = string
  default     = "ambassador"
}

variable "ambassador_service_name" {
  description = "Ambassador service name. Defaults to var.name"
  type        = string
  default     = ""
}

variable "ambassador_http_port" {
  description = "HTTP port number for Ambassador service"
  type        = number
  default     = 80
}

variable "ambassador_ssl_port" {
  description = "SSL port number for Ambassador service"
  type        = number
  default     = 443
}

variable "namespace" {
  description = "Namespace of object to create"
  type        = string
  default     = "ambassador"
}

variable "labels" {
  description = "Labels for ingress"
  type        = map(string)
  default = {
    "app.kubernetes.io/instance"   = "ambassador"
    "app.kubernetes.io/managed-by" = "Terraform"
    "app.kubernetes.io/name"       = "ambassador"
  }
}

variable "tags" {
  description = "Resource tags"

  default = {
    Terraform = "true"
  }
}


variable "annotations" {
  description = "Additional annotations for Ingress"
  type        = map(string)
  default     = {}
}

variable "annotations_plaintext" {
  description = "Additional annotations for plaintext Ingress workaround"
  type        = map(string)
  default     = {}
}

variable "group_name" {
  description = "The `IngressGroup` name of the Ingresses to create. Defaults to the ingress name. See https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/guide/ingress/annotations/#ingressgroup"
  type        = string
  default     = ""
}

variable "scheme" {
  description = "Scheme for the ALB. Either `internal` or `internet-facing`"
  type        = string
  default     = "internet-facing"

  validation {
    condition     = contains(var.scheme, ["internal", "internet-facing"])
    error_message = "The scheme value must be either 'internal' or 'internet-facing'."
  }
}

variable "certificates" {
  description = "ARN of certificates in ACM to use"
  type        = list(string)
}

variable "ssl_policy" {
  description = "SSL Policy for L7 Load Balancer. See https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html#describe-ssl-policies"
  type        = string
  default     = "ELBSecurityPolicy-FS-1-2-2019-08"
}

variable "idle_timeout_seconds" {
  description = "The idle timeout value, in seconds. The valid range is 1-4000 seconds."
  type        = number
  default     = 60
}

variable "listen_ports" {
  description = "Ports to listen to on the ELB. If HTTP/2 is enabled, only HTTPS is supported. You can still enable plaintext redirection."
  type        = list(map(number))
  default     = [{ HTTPS = 443 }]
}

variable "enable_plaintext_redirect" {
  description = "Redirect HTTP to HTTPS"
  type        = bool
  default     = true
}

variable "ip_address_type" {
  description = "IP Address type of the listener."
  type        = string
  default     = "ipv4"

  validation {
    condition     = contains(["ipv4", "dualstack"], var.ip_address_type)
    error_message = "The variable ip_address_type can only be either 'ipv4' or 'dualstack'."
  }
}

variable "target_type" {
  description = "Target type of the backends. See https://kubernetes-sigs.github.io/aws-load-balancer-controller/guide/ingress/annotations/#target-type"
  type        = string
  default     = "ip"

  validation {
    condition     = contains(["ip", "instance"], var.target_type)
    error_message = "The variable target_type can only be either 'ip' or 'instance'."
  }
}

variable "backend_protocol_https" {
  description = "Use HTTPS with backend Ambassador"
  type        = bool
  default     = true
}

variable "backend_protocol_version" {
  description = "Backend protocol version. See https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html#target-group-protocol-version"
  type        = string
  default     = "HTTP2"

  validation {
    condition     = contains(["HTTP1", "HTTP2", "GRPC"], var.backend_protocol_version)
    error_message = "The variable backend_protocol_version can only be either 'HTTP1', 'HTTP2' or 'GRPC'."
  }
}

variable "subnets" {
  description = "List of subnets for ALB to route traffic to. See https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-subnets.html"
  type        = list(string)
  default     = []
}

variable "health_check" {
  description = "Health check configuration"
  type = object({
    success_codes             = string
    interval_seconds          = number
    timeout_seconds           = number
    healthy_threshold_count   = number
    unhealthy_threshold_count = number
  })
  default = {
    success_codes             = "200-300"
    interval_seconds          = 10
    timeout_seconds           = 2
    healthy_threshold_count   = 5
    unhealthy_threshold_count = 2
  }
}

variable "enable_http2" {
  description = "Enable HTTP/2 on the ELB"
  type        = bool
  default     = true
}

variable "desync_mitigation_mode" {
  description = "Determines how the load balancer handles requests that might pose a security risk to your application. The possible values are monitor, defensive, and strictest. The default is defensive."
  type        = string
  default     = "defensive"
}

variable "drop_invalid_header_fields" {
  description = " Indicates whether HTTP headers with invalid header fields are removed by the load balancer (true) or routed to targets (false). The default is false. "
  type        = bool
  default     = false
}

variable "waf_fail_open" {
  description = "Indicates whether to allow a WAF-enabled load balancer to route requests to targets if it is unable to forward the request to AWS WAF. The value is true or false."
  type        = bool
  default     = true
}

variable "access_control" {
  description = "Either specify CIDR ranges or list of security groups. Both name or ID of securityGroups are supported. Name matches a Name tag, not the groupName attribute."
  type = object({
    cidrs           = optional(list(string))
    security_groups = optional(list(string))
  })
  default = {
    cidrs = ["0.0.0.0/0"]
  }
  validation {
    condition     = !alltrue([var.access_control.cidrs != null, var.access_control.security_groups != null])
    error_message = "The external_l7_access_control variable cannot have both set to non-null."
  }
}

variable "wafv2_arn" {
  description = "WAFV2 ARN to attach to the ALB"
  type        = string
  default     = null
}

variable "shield_advanced_protect" {
  description = "Enable AWS Shield Advanced protection for the load balancer. Requires a subscription"
  type        = bool
  default     = false
}

#####################################
# L7 Logging
#####################################
variable "access_log" {
  description = "Enable access logging for L7 Load Balancer"
  type        = bool
  default     = false
}

variable "create_access_log_bucket" {
  description = "Create Access Log bucket. Set to false if you want to use an existing bucket. You will have to set the IAM permissions yourself."
  type        = bool
  default     = false
}

variable "l7_logging_bucket" {
  description = "Name of L7 Access Logging bucket to use or create"
  type        = string
  default     = ""
}

variable "l7_logging_expiration" {
  description = "Expiration lifecycle rules for access logging bucket"
  type = list(object({
    enabled = bool

    date = optional(string) # Specifies the date after which you want the corresponding action to take effect.
    days = optional(number) # Specifies the number of days after object creation when the specific rule action takes effect.
    id   = optional(string)
  }))
  default = [
    {
      id      = "Delete2Years"
      enabled = true
      days    = 730
    },
  ]
}

variable "l7_logging_transition" {
  description = "L7 Logging class storage transitions"
  type = list(object({
    enabled       = bool
    storage_class = string

    date = optional(string) # Specifies the date after which you want the corresponding action to take effect.
    days = optional(number) # Specifies the number of days after object creation when the specific rule action takes effect.
    id   = optional(string)
  }))
  default = [
    {
      id            = "IA"
      enabled       = true
      days          = 30
      storage_class = "STANDARD_IA"
    },
    {
      id            = "Glacier"
      enabled       = true
      days          = 365
      storage_class = "GLACIER"
    },
  ]
}

variable "l7_object_lock_enabled" {
  description = "Enable Object Lock on the bucket. See https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lock.html"
  type        = bool
  default     = false
}

variable "l7_object_default_retention" {
  description = "Object lock default retention configuration. See https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lock-overview.html"
  type = object({
    mode  = string
    days  = optional(number)
    years = optional(number)
  })
  default = {
    mode  = "GOVERNANCE"
    years = 2
  }
}

variable "l7_logging_bucket_policy" {
  description = "Bucket policy document, if any"
  type        = string
  default     = ""
}

variable "l7_logging_prefix" {
  description = "Prefix to create log objects. Defaults to var.name"
  type        = string
  default     = ""
}

variable "l7_addiitonal_logging_prefixes" {
  description = "Additional prefixes you want to include in the resource policy for the bucket"
  type        = list(string)
  default     = []
}
