resource "kubernetes_ingress" "ambassador" {
  wait_for_load_balancer = true

  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = var.labels

    # See https://kubernetes-sigs.github.io/aws-load-balancer-controller/guide/ingress/annotations/
    annotations = merge(
      {
        "kubernetes.io/ingress.class"          = "alb"
        "alb.ingress.kubernetes.io/group.name" = coalesce(var.group_name, var.name)

        "alb.ingress.kubernetes.io/scheme"                   = var.scheme
        "alb.ingress.kubernetes.io/listen-ports"             = jsonencode(var.listen_ports)
        "alb.ingress.kubernetes.io/ip-address-type"          = var.ip_address_type
        "alb.ingress.kubernetes.io/target-type"              = var.target_type
        "alb.ingress.kubernetes.io/backend-protocol"         = var.backend_protocol_https ? "HTTPS" : "HTTP"
        "alb.ingress.kubernetes.io/backend-protocol-version" = var.backend_protocol_version

        "alb.ingress.kubernetes.io/healthcheck-protocol"         = var.backend_protocol_https ? "HTTPS" : "HTTP"
        "alb.ingress.kubernetes.io/healthcheck-port"             = tostring(var.backend_protocol_https ? var.ambassador_ssl_port : var.ambassador_http_port)
        "alb.ingress.kubernetes.io/healthcheck-path"             = "/ambassador/v0/check_alive"
        "alb.ingress.kubernetes.io/success-codes"                = var.health_check.success_codes
        "alb.ingress.kubernetes.io/healthcheck-interval-seconds" = tostring(var.health_check.interval_seconds)
        "alb.ingress.kubernetes.io/healthcheck-timeout-seconds"  = tostring(var.health_check.timeout_seconds)
        "alb.ingress.kubernetes.io/healthy-threshold-count"      = tostring(var.health_check.healthy_threshold_count)
        "alb.ingress.kubernetes.io/unhealthy-threshold-count"    = tostring(var.health_check.unhealthy_threshold_count)

        "alb.ingress.kubernetes.io/certificate-arn" = join(",", var.certificates)
        "alb.ingress.kubernetes.io/ssl-policy"      = var.ssl_policy

        # https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_LoadBalancerAttribute.html
        "alb.ingress.kubernetes.io/load-balancer-attributes" = join(",", [
          for k, v in {
            "idle_timeout.timeout_seconds" = var.idle_timeout_seconds
            "routing.http2.enabled"        = var.enable_http2

            "routing.http.desync_mitigation_mode"             = var.desync_mitigation_mode
            "routing.http.drop_invalid_header_fields.enabled" = var.drop_invalid_header_fields
            "waf.fail_open.enabled"                           = var.waf_fail_open

            "access_logs.s3.enabled" = var.access_log
            "access_logs.s3.bucket " = var.access_log ? var.l7_logging_bucket : null
            "access_logs.s3.prefix " = var.access_log ? coalesce(var.l7_logging_prefix, var.name) : null
          } : "${k}=${v}" if v != null
        ])

        # https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html#target-group-attributes
        "alb.ingress.kubernetes.io/target-group-attributes" = join(",", [
          for k, v in {
            "deregistration_delay.timeout_seconds" = 30
            "load_balancing.algorithm.type"        = "least_outstanding_requests"
          } : "${k}=${v}" if v != null
        ])
      },
      { for k, v in {
        "alb.ingress.kubernetes.io/subnets" = join(",", var.subnets)

        "alb.ingress.kubernetes.io/inbound-cidrs"   = try(join(",", var.access_control.cidrs), null)
        "alb.ingress.kubernetes.io/security-groups" = try(join(",", var.access_control.security_groups), null)

        "alb.ingress.kubernetes.io/wafv2-acl-arn"              = var.wafv2_arn
        "alb.ingress.kubernetes.io/shield-advanced-protection" = var.shield_advanced_protect ? "true" : null
      } : k => v if v != null && v != "" },
      var.annotations,
    )
  }

  spec {
    rule {
      http {
        path {
          path = "/*"
          backend {
            service_name = coalesce(var.ambassador_service_name, var.name)
            service_port = var.backend_protocol_https ? var.ambassador_ssl_port : var.ambassador_http_port
          }
        }
      }
    }
  }
}

# HTTP Redirection workaround.
# See https://github.com/kubernetes-sigs/aws-load-balancer-controller/issues/1937#issuecomment-823597736
resource "kubernetes_ingress" "ambassador_plaintext" {
  count = var.enable_plaintext_redirect ? 1 : 0

  wait_for_load_balancer = false

  metadata {
    name      = "${var.name}-plaintext"
    namespace = var.namespace
    labels    = var.labels
    # See https://kubernetes-sigs.github.io/aws-load-balancer-controller/guide/ingress/annotations/
    annotations = merge(
      {
        "kubernetes.io/ingress.class"          = "alb"
        "alb.ingress.kubernetes.io/group.name" = coalesce(var.group_name, var.name)

        "alb.ingress.kubernetes.io/listen-ports" = jsonencode([{ HTTP = 80 }])
        "alb.ingress.kubernetes.io/actions.ssl-redirect" = jsonencode({
          Type = "redirect"
          RedirectConfig = {
            Protocol   = "HTTPS"
            Port       = "443"
            StatusCode = "HTTP_301"
          }
        })
      },
      var.annotations_plaintext,
    )
  }

  spec {
    rule {
      http {
        path {
          path = "/*"
          backend {
            service_name = "ssl-redirect"
            service_port = "use-annotation"
          }
        }
      }
    }
  }
}
