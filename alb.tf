locals {
  logging_prefix = coalesce(var.l7_logging_prefix, var.release_name)
}

module "ingress" {
  source     = "./modules/ingress"
  count      = var.enable_l7_load_balancing ? 1 : 0
  depends_on = [module.helm]

  name      = var.release_name
  namespace = var.chart_namespace

  scheme       = var.internet_facing ? "internet-facing" : "internal"
  certificates = var.certificates
  ssl_policy   = var.ssl_policy
  subnets      = var.subnets

  backend_protocol_https   = var.backend_protocol_https
  backend_protocol_version = var.backend_protocol_version

  enable_http2               = var.enable_http2
  desync_mitigation_mode     = var.desync_mitigation_mode
  drop_invalid_header_fields = var.drop_invalid_header_fields
  waf_fail_open              = var.waf_fail_open
  access_control             = var.access_control
  wafv2_arn                  = var.wafv2_arn
  shield_advanced_protect    = var.shield_advanced_protect

  access_log        = var.access_log
  l7_logging_bucket = var.create_access_log_bucket ? module.ingress_logging[0].name : var.l7_logging_bucket
  l7_logging_prefix = local.logging_prefix

  labels = var.labels
  tags   = var.tags
}

module "ingress_logging" {
  source = "./modules/logging"
  count  = var.create_access_log_bucket ? 1 : 0

  l7_logging_bucket           = var.l7_logging_bucket
  l7_logging_expiration       = var.l7_logging_expiration
  l7_logging_transition       = var.l7_logging_transition
  l7_object_lock_enabled      = var.l7_object_lock_enabled
  l7_object_default_retention = var.l7_object_default_retention
  l7_logging_bucket_policy    = var.l7_logging_bucket_policy
  l7_logging_prefixes         = distinct(concat([local.logging_prefix], var.l7_addiitonal_logging_prefixes))

  tags = var.tags
}
