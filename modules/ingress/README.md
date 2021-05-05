# Ingress for Ambassador

This module allows you to provision the `Ingress` for Ambassador separately from the Helm Chart
installation. You will have to set the appropriate values for Ambassador Helm chart yourself.

See the root module for more information.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.28 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0, >= 2.0.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.28 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.0, >= 2.0.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_ingress.ambassador](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress) | resource |
| [kubernetes_ingress.ambassador_plaintext](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_control"></a> [access\_control](#input\_access\_control) | Either specify CIDR ranges or list of security groups. Both name or ID of securityGroups are supported. Name matches a Name tag, not the groupName attribute. | <pre>object({<br>    cidrs           = optional(list(string))<br>    security_groups = optional(list(string))<br>  })</pre> | <pre>{<br>  "cidrs": [<br>    "0.0.0.0/0"<br>  ]<br>}</pre> | no |
| <a name="input_access_log"></a> [access\_log](#input\_access\_log) | Enable access logging for L7 Load Balancer | `bool` | `false` | no |
| <a name="input_ambassador_http_port"></a> [ambassador\_http\_port](#input\_ambassador\_http\_port) | HTTP port number for Ambassador service | `number` | `80` | no |
| <a name="input_ambassador_service_name"></a> [ambassador\_service\_name](#input\_ambassador\_service\_name) | Ambassador service name. Defaults to var.name | `string` | `""` | no |
| <a name="input_ambassador_ssl_port"></a> [ambassador\_ssl\_port](#input\_ambassador\_ssl\_port) | SSL port number for Ambassador service | `number` | `443` | no |
| <a name="input_annotations"></a> [annotations](#input\_annotations) | Additional annotations for Ingress | `map(string)` | `{}` | no |
| <a name="input_annotations_plaintext"></a> [annotations\_plaintext](#input\_annotations\_plaintext) | Additional annotations for plaintext Ingress workaround | `map(string)` | `{}` | no |
| <a name="input_backend_protocol_https"></a> [backend\_protocol\_https](#input\_backend\_protocol\_https) | Use HTTPS with backend Ambassador | `bool` | `true` | no |
| <a name="input_backend_protocol_version"></a> [backend\_protocol\_version](#input\_backend\_protocol\_version) | Backend protocol version. See https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html#target-group-protocol-version | `string` | `"HTTP2"` | no |
| <a name="input_certificates"></a> [certificates](#input\_certificates) | ARN of certificates in ACM to use | `list(string)` | `[]` | no |
| <a name="input_desync_mitigation_mode"></a> [desync\_mitigation\_mode](#input\_desync\_mitigation\_mode) | Determines how the load balancer handles requests that might pose a security risk to your application. The possible values are monitor, defensive, and strictest. The default is defensive. | `string` | `"defensive"` | no |
| <a name="input_drop_invalid_header_fields"></a> [drop\_invalid\_header\_fields](#input\_drop\_invalid\_header\_fields) | Indicates whether HTTP headers with invalid header fields are removed by the load balancer (true) or routed to targets (false). The default is false. | `bool` | `false` | no |
| <a name="input_enable_http2"></a> [enable\_http2](#input\_enable\_http2) | Enable HTTP/2 on the ELB | `bool` | `true` | no |
| <a name="input_enable_plaintext_redirect"></a> [enable\_plaintext\_redirect](#input\_enable\_plaintext\_redirect) | Redirect HTTP to HTTPS | `bool` | `true` | no |
| <a name="input_group_name"></a> [group\_name](#input\_group\_name) | The `IngressGroup` name of the Ingresses to create. Defaults to the ingress name. See https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/guide/ingress/annotations/#ingressgroup | `string` | `""` | no |
| <a name="input_health_check"></a> [health\_check](#input\_health\_check) | Health check configuration | <pre>object({<br>    success_codes             = string<br>    interval_seconds          = number<br>    timeout_seconds           = number<br>    healthy_threshold_count   = number<br>    unhealthy_threshold_count = number<br>  })</pre> | <pre>{<br>  "healthy_threshold_count": 5,<br>  "interval_seconds": 10,<br>  "success_codes": "200-300",<br>  "timeout_seconds": 2,<br>  "unhealthy_threshold_count": 2<br>}</pre> | no |
| <a name="input_idle_timeout_seconds"></a> [idle\_timeout\_seconds](#input\_idle\_timeout\_seconds) | The idle timeout value, in seconds. The valid range is 1-4000 seconds. | `number` | `60` | no |
| <a name="input_ip_address_type"></a> [ip\_address\_type](#input\_ip\_address\_type) | IP Address type of the listener. | `string` | `"ipv4"` | no |
| <a name="input_l7_logging_bucket"></a> [l7\_logging\_bucket](#input\_l7\_logging\_bucket) | Name of L7 Access Logging bucket to use | `string` | `""` | no |
| <a name="input_l7_logging_prefix"></a> [l7\_logging\_prefix](#input\_l7\_logging\_prefix) | Prefix to create log objects. Defaults to ingress name | `string` | `""` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels for ingress | `map(string)` | <pre>{<br>  "app.kubernetes.io/instance": "ambassador",<br>  "app.kubernetes.io/managed-by": "Terraform",<br>  "app.kubernetes.io/name": "ambassador"<br>}</pre> | no |
| <a name="input_listen_ports"></a> [listen\_ports](#input\_listen\_ports) | Ports to listen to on the ELB. If HTTP/2 is enabled, only HTTPS is supported. You can still enable plaintext redirection. | `list(map(number))` | <pre>[<br>  {<br>    "HTTPS": 443<br>  }<br>]</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the Ingress | `string` | `"ambassador"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace of object to create | `string` | `"ambassador"` | no |
| <a name="input_scheme"></a> [scheme](#input\_scheme) | Scheme for the ALB. Either `internal` or `internet-facing` | `string` | `"internet-facing"` | no |
| <a name="input_shield_advanced_protect"></a> [shield\_advanced\_protect](#input\_shield\_advanced\_protect) | Enable AWS Shield Advanced protection for the load balancer. Requires a subscription | `bool` | `false` | no |
| <a name="input_ssl_policy"></a> [ssl\_policy](#input\_ssl\_policy) | SSL Policy for L7 Load Balancer. See https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html#describe-ssl-policies | `string` | `"ELBSecurityPolicy-FS-1-2-2019-08"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of subnets for ALB to route traffic to. See https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-subnets.html | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags | `map` | <pre>{<br>  "Terraform": "true"<br>}</pre> | no |
| <a name="input_target_type"></a> [target\_type](#input\_target\_type) | Target type of the backends. See https://kubernetes-sigs.github.io/aws-load-balancer-controller/guide/ingress/annotations/#target-type | `string` | `"ip"` | no |
| <a name="input_waf_fail_open"></a> [waf\_fail\_open](#input\_waf\_fail\_open) | Indicates whether to allow a WAF-enabled load balancer to route requests to targets if it is unable to forward the request to AWS WAF. The value is true or false. | `bool` | `true` | no |
| <a name="input_wafv2_arn"></a> [wafv2\_arn](#input\_wafv2\_arn) | WAFV2 ARN to attach to the ALB | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | DNS name of the Ingress Load Balancer |
