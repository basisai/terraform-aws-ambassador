locals {
  l7_logging_prefixes = [for prefix in var.l7_logging_prefixes :
    "arn:aws:s3:::${var.l7_logging_bucket}/${prefix}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
  ]
}

resource "aws_s3_bucket" "l7_access_logs" {
  bucket = var.l7_logging_bucket
  tags   = var.tags

  force_destroy = !var.l7_object_lock_enabled

  # Enable versioning to simplify supporting object locks
  versioning {
    enabled = true
  }

  # ONLY supports SSE-S3
  # See https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html#access-logging-bucket-permissions
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  # Expiration
  dynamic "lifecycle_rule" {
    for_each = var.l7_logging_expiration

    content {
      id      = lifecycle_rule.value.id
      enabled = lifecycle_rule.value.enabled

      expiration {
        date = lifecycle_rule.value.date
        days = lifecycle_rule.value.days
      }
    }
  }

  # Because the bucket is versioned, we need two extra rules to delete markers and expire non-concurrent versions
  # https://docs.aws.amazon.com/AmazonS3/latest/userguide/lifecycle-configuration-examples.html#lifecycle-config-conceptual-ex7
  lifecycle_rule {
    enabled = true

    expiration {
      expired_object_delete_marker = true
    }
  }
  lifecycle_rule {
    enabled = true

    noncurrent_version_expiration {
      days = 1
    }
  }

  # Transitions
  dynamic "lifecycle_rule" {
    for_each = var.l7_logging_transition

    content {
      id      = lifecycle_rule.value.id
      enabled = lifecycle_rule.value.enabled

      transition {
        date = lifecycle_rule.value.date
        days = lifecycle_rule.value.days

        storage_class = lifecycle_rule.value.storage_class
      }
    }
  }

  dynamic "object_lock_configuration" {
    for_each = var.l7_object_lock_enabled ? [var.l7_object_default_retention] : []

    content {
      object_lock_enabled = "Enabled"

      rule {
        default_retention {
          mode  = object_lock_configuration.value.mode
          days  = object_lock_configuration.value.days
          years = object_lock_configuration.value.years
        }
      }
    }
  }

  policy = data.aws_iam_policy_document.l7_logging_policy.json
}

# See https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html#access-logging-bucket-permissions
locals {
  elb_account_id = {
    us-east-1      = "127311923021"
    us-east-2      = "33677994240"
    us-west-1      = "27434742980"
    us-west-2      = "797873946194"
    af-south-1     = "98369216593"
    ca-central-1   = "985666609251"
    eu-central-1   = "54676820928"
    eu-west-1      = "156460612806"
    eu-west-2      = "652711504416"
    eu-south-1     = "635631232127"
    eu-west-3      = "9996457667"
    eu-north-1     = "897822967062"
    ap-east-1      = "754344448648"
    ap-northeast-1 = "582318560864"
    ap-northeast-2 = "600734575887"
    ap-northeast-3 = "383597477331"
    ap-southeast-1 = "114774131450"
    ap-southeast-2 = "783225319266"
    ap-south-1     = "718504428378"
    me-south-1     = "76674570225"
    sa-east-1      = "507241528517"
    us-gov-west-1  = "48591011584"
    us-gov-east-1  = "190560391635"
    cn-north-1     = "638102146993"
    cn-northwest-1 = "37604701340"
  }
}

data "aws_iam_policy_document" "l7_logging_elb" {
  statement {
    actions   = ["s3:PutObject"]
    resources = local.l7_logging_prefixes

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.elb_account_id[data.aws_region.current.name]}:root"]
    }
  }

  statement {
    actions   = ["s3:PutObject"]
    resources = local.l7_logging_prefixes

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  statement {
    actions   = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::${var.l7_logging_bucket}"]

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "l7_logging_policy" {
  override_policy_documents = compact([
    data.aws_iam_policy_document.l7_logging_elb.json,
    var.l7_logging_bucket_policy,
  ])
}
