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
        "alb.ingress.kubernetes.io/listen-ports"             = jsonencode([{ HTTPS = 443 }])
        "alb.ingress.kubernetes.io/ip-address-type"          = "ipv4"
        "alb.ingress.kubernetes.io/target-type"              = "ip"
        "alb.ingress.kubernetes.io/backend-protocol"         = "HTTPS"
        "alb.ingress.kubernetes.io/backend-protocol-version" = "HTTP2"

        "alb.ingress.kubernetes.io/healthcheck-protocol"         = "HTTPS"
        "alb.ingress.kubernetes.io/healthcheck-port"             = "https"
        "alb.ingress.kubernetes.io/healthcheck-path"             = "/ambassador/v0/check_alive"
        "alb.ingress.kubernetes.io/success-codes"                = "200-300"
        "alb.ingress.kubernetes.io/healthcheck-interval-seconds" = "10"
        "alb.ingress.kubernetes.io/healthcheck-timeout-seconds"  = "2"
        "alb.ingress.kubernetes.io/healthy-threshold-count"      = "5"
        "alb.ingress.kubernetes.io/unhealthy-threshold-count"    = "2"

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
            "access_logs.s3.bucket " = var.access_log ? coalescelist(aws_s3_bucket.l7_access_logs.*.bucket, [var.l7_logging_bucket])[0] : null
            "access_logs.s3.prefix " = var.access_log ? var.l7_logging_prefix : null
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
        "alb.ingress.kubernetes.io/inbound-cidrs"   = var.access_control.cidrs
        "alb.ingress.kubernetes.io/security-groups" = var.access_control.security_groups

        "alb.ingress.kubernetes.io/wafv2-acl-arn"              = var.wafv2_arn
        "alb.ingress.kubernetes.io/shield-advanced-protection" = var.shield_advanced_protect ? "true" : null
      } : k => v if v != null },
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
            service_port = var.ambassador_ssl_port
          }
        }
      }
    }
  }
}
