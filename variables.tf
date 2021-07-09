variable "release_name" {
  description = "Chart release name"
  type        = string
  default     = "ambassador"
}

variable "chart_namespace" {
  description = "Namespace to run the chart in"
  type        = string
  default     = "ambassador"
}

variable "chart_version" {
  description = "Version of Chart to install. Set to empty to install the latest version"
  type        = string
  default     = "6.7.2"
}

variable "crds_enable" {
  description = "Enable CRDs"
  type        = bool
  default     = true
}

variable "crds_create" {
  description = "Create CRDs"
  type        = bool
  default     = true
}

variable "crds_keep" {
  description = "Keep CRDs"
  type        = bool
  default     = true
}

variable "image_repository" {
  # One of
  # docker.io/datawire/ambassador
  # quay.io/datawire/ambassador
  # gcr.io/datawire/ambassador
  description = "Image repository for Ambassador image"
  type        = string
  default     = "quay.io/datawire/ambassador"
}

variable "image_tag" {
  description = "Image tag for Ambassador image"
  type        = string
  default     = "1.13.9"
}

variable "replicas" {
  description = "Number of replicas"
  default     = 3
}

variable "hpa_enabled" {
  description = "Enable HPA"
  type        = bool
  default     = true
}

variable "hpa_min_replica" {
  description = "Minimum Number of replica"
  type        = number
  default     = 2
}

variable "hpa_max_replica" {
  description = "Max Number of replica"
  type        = number
  default     = 3
}

variable "hpa_metrics" {
  description = "Metrics for HPA Scaling"
  type        = any
  default = [
    {
      type = "Resource"
      resource = {
        name = "cpu"
        target = {
          type               = "Utilization"
          averageUtilization = 80
        }
      }
    },
    {
      type = "Resource"
      resource = {
        name = "memory"
        target = {
          type               = "Utilization"
          averageUtilization = 80
        }
      }
    },
  ]
}

variable "pod_disruption_budget" {
  description = "PDB values"
  type        = any
  default = {
    minAvailable = 1
  }
}

variable "resources" {
  description = "Pod resources"
  type        = any
  default = {
    requests = {
      cpu    = "200m"
      memory = "1500Mi"
    }
    limits = {
      cpu    = "1000m"
      memory = "1500Mi"
    }
  }
}

variable "priority_class_name" {
  description = "Priority class names"
  type        = string
  default     = ""
}

variable "affinity" {
  description = "Pod Affinity"
  type        = any
  default     = {}
}

variable "tolerations" {
  description = "Pod Tolerations"
  type        = list(any)
  default     = []
}

variable "labels" {
  description = "Labels for resources"
  type        = map(string)
  default = {
    "app.kubernetes.io/managed-by" = "Terraform"
  }
}

variable "env" {
  description = "Environment variables for container"
  type        = map(string)
  default     = {}
}

variable "env_raw" {
  description = "Raw environment variables for container"
  type        = list(any)
  default     = []
}

variable "pod_security_context" {
  description = "Pod securityContext"
  type        = any
  default     = {}
}

variable "container_security_context" {
  description = "Container securityContext"
  type        = any
  default     = {}
}

variable "volumes" {
  description = "Volumes for containers"
  type        = list(any)
  default     = []
}

variable "volume_mounts" {
  description = "Volumes mounts for container"
  type        = list(any)
  default     = []
}

variable "ambassador_id" {
  description = "Ambassador ID"
  type        = string
  default     = "default"
}

variable "ambassador_configurations" {
  description = "Configuration options for Ambassador. See https://www.getambassador.io/docs/edge-stack/latest/topics/running/ambassador/"
  type        = any
  default = {
    diagnostics = {
      enabled = false
    }
  }
}

##########################################
# AWS Configuration
##########################################
variable "tags" {
  description = "Tags for AWS resources where supported"
  type        = map(string)
  default = {
    Terraform = "true"
  }
}

variable "dns_names" {
  description = "Map of DNS names to create records for. Key is DNS name, value is the Zone ID"
  type        = map(string)
  default     = {}
}

##########################################
# Service
##########################################
variable "enable_l7_load_balancing" {
  description = "Use L7 (ALB) for load balancing. Otherwise, L4 (NLB) is used"
  type        = bool
  default     = true
}

variable "internet_facing" {
  description = "Whether the Load Balancer, L7 or L4 is internet facing"
  type        = bool
  default     = true
}

variable "service_annotations" {
  description = "Additional annotations for the service"
  type        = map(string)
  default     = {}
}

variable "load_balancer_source_ranges" {
  description = "Load balancer source range for L4 Load balancing"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "external_traffic_policy" {
  description = "External traffic policy for L4 Load balancing"
  type        = string
  default     = "Local"
}

variable "admin_service_annotations" {
  description = "Annotations for the admin service"
  type        = map(string)
  default = {
    "prometheus.io/scrape" = "true"
  }
}

##########################################
# L7 Service
##########################################
variable "certificates" {
  description = "ARN of certificates in ACM to use"
  type        = list(string)
  default     = []
}

variable "ssl_policy" {
  description = "SSL Policy for L7 Load Balancer. See https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html#describe-ssl-policies"
  type        = string
  default     = "ELBSecurityPolicy-FS-1-2-2019-08"
}

variable "subnets" {
  description = "List of subnets for ALB to route traffic to. See https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-subnets.html"
  type        = list(string)
  default     = []
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

##########################################
# Ambassador Edge Stack Configuration
##########################################
variable "enable_aes" {
  description = "Enable Edge Stack"
  default     = false
}

variable "license_key" {
  description = "License key for AES"
  default     = ""
}

variable "license_key_create_secret" {
  description = "Create secret for license key"
  default     = true
}

variable "license_key_secret_name" {
  description = "Secret name for license"
  default     = ""
}

variable "license_key_secret_annotations" {
  description = "License key secret annotations"
  default     = {}
}

variable "create_dev_portal_mappings" {
  description = "# The DevPortal is exposed at /docs/ endpoint in the AES container. Setting this to true will automatically create routes for the DevPortal."
  default     = true
}

variable "redis_url" {
  description = "Custom Redis URL"
  default     = ""
}

variable "redis_create" {
  description = "Create Redis"
  default     = true
}

variable "redis_image" {
  description = "Redis image"
  default     = "redis"
}

variable "redis_tag" {
  description = "Redis image tag"
  default     = "5.0.1"
}

variable "redis_deployment_annotations" {
  description = "Redis deployment annotations"
  default     = {}
}

variable "redis_service_annotations" {
  description = "Redis service annotations"
  default     = {}
}

variable "redis_resources" {
  description = "Redis resources"
  default     = {}
}

variable "redis_affinity" {
  description = "Affinity for redis pods"
  default     = {}
}

variable "redis_tolerations" {
  description = "Redis tolerations"
  default     = []
}

variable "auth_service_create" {
  description = "Deploy AuthService"
  default     = true
}

variable "auth_service_config" {
  description = "Configuration for AuthService"
  default     = {}
}

variable "rate_limit_create" {
  description = "Create the RateLimitService"
  default     = true
}

variable "registry_create" {
  description = "Enable Projects beta feature"
  default     = false
}
