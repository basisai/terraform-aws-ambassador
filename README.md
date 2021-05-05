# Terraform Ambassador on AWS

An opinionated module to deploy [Ambassador](https://www.getambassador.io/) on AWS, specifically
EKS. This might work on self-managed Kubernetes clusters, but it's not tested.

This module makes a set of assumptions:

- Ambassador is deployed behind either a Network or Application Load Balancer
- TLS is enabled
- HTTP/2 is enabled both in front and behind the load balancer

If the assumptions do not hold, you can look at the source code of the root module and make use of
the individual modules.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.28 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0, >= 2.0.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.0, >= 2.0.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dns"></a> [dns](#module\_dns) | ./modules/dns |  |
| <a name="module_helm"></a> [helm](#module\_helm) | basisai/ambassador/helm | ~> 0.1.0, >= 0.1.1 |
| <a name="module_ingress"></a> [ingress](#module\_ingress) | ./modules/ingress |  |
| <a name="module_ingress_logging"></a> [ingress\_logging](#module\_ingress\_logging) | ./modules/logging |  |

## Resources

| Name | Type |
|------|------|
| [kubernetes_service.ambassador](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_control"></a> [access\_control](#input\_access\_control) | Either specify CIDR ranges or list of security groups. Both name or ID of securityGroups are supported. Name matches a Name tag, not the groupName attribute. | <pre>object({<br>    cidrs           = optional(list(string))<br>    security_groups = optional(list(string))<br>  })</pre> | <pre>{<br>  "cidrs": [<br>    "0.0.0.0/0"<br>  ]<br>}</pre> | no |
| <a name="input_access_log"></a> [access\_log](#input\_access\_log) | Enable access logging for L7 Load Balancer | `bool` | `false` | no |
| <a name="input_admin_service_annotations"></a> [admin\_service\_annotations](#input\_admin\_service\_annotations) | Annotations for the admin service | `map(string)` | <pre>{<br>  "prometheus.io/scrape": "true"<br>}</pre> | no |
| <a name="input_affinity"></a> [affinity](#input\_affinity) | Pod Affinity | `any` | `{}` | no |
| <a name="input_ambassador_configurations"></a> [ambassador\_configurations](#input\_ambassador\_configurations) | Configuration options for Ambassador. See https://www.getambassador.io/docs/edge-stack/latest/topics/running/ambassador/ | `any` | <pre>{<br>  "diagnostics": {<br>    "enabled": false<br>  }<br>}</pre> | no |
| <a name="input_ambassador_id"></a> [ambassador\_id](#input\_ambassador\_id) | Ambassador ID | `string` | `"default"` | no |
| <a name="input_auth_service_config"></a> [auth\_service\_config](#input\_auth\_service\_config) | Configuration for AuthService | `map` | `{}` | no |
| <a name="input_auth_service_create"></a> [auth\_service\_create](#input\_auth\_service\_create) | Deploy AuthService | `bool` | `true` | no |
| <a name="input_certificates"></a> [certificates](#input\_certificates) | ARN of certificates in ACM to use | `list(string)` | `[]` | no |
| <a name="input_chart_namespace"></a> [chart\_namespace](#input\_chart\_namespace) | Namespace to run the chart in | `string` | `"ambassador"` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Version of Chart to install. Set to empty to install the latest version | `string` | `"6.6.3"` | no |
| <a name="input_crds_create"></a> [crds\_create](#input\_crds\_create) | Create CRDs | `bool` | `true` | no |
| <a name="input_crds_enable"></a> [crds\_enable](#input\_crds\_enable) | Enable CRDs | `bool` | `true` | no |
| <a name="input_crds_keep"></a> [crds\_keep](#input\_crds\_keep) | Keep CRDs | `bool` | `true` | no |
| <a name="input_create_access_log_bucket"></a> [create\_access\_log\_bucket](#input\_create\_access\_log\_bucket) | Create Access Log bucket. Set to false if you want to use an existing bucket. You will have to set the IAM permissions yourself. | `bool` | `false` | no |
| <a name="input_create_dev_portal_mappings"></a> [create\_dev\_portal\_mappings](#input\_create\_dev\_portal\_mappings) | # The DevPortal is exposed at /docs/ endpoint in the AES container. Setting this to true will automatically create routes for the DevPortal. | `bool` | `true` | no |
| <a name="input_desync_mitigation_mode"></a> [desync\_mitigation\_mode](#input\_desync\_mitigation\_mode) | Determines how the load balancer handles requests that might pose a security risk to your application. The possible values are monitor, defensive, and strictest. The default is defensive. | `string` | `"defensive"` | no |
| <a name="input_dns_names"></a> [dns\_names](#input\_dns\_names) | Map of DNS names to create records for. Key is DNS name, value is the Zone ID | `map(string)` | `{}` | no |
| <a name="input_drop_invalid_header_fields"></a> [drop\_invalid\_header\_fields](#input\_drop\_invalid\_header\_fields) | Indicates whether HTTP headers with invalid header fields are removed by the load balancer (true) or routed to targets (false). The default is false. | `bool` | `false` | no |
| <a name="input_enable_aes"></a> [enable\_aes](#input\_enable\_aes) | Enable Edge Stack | `bool` | `true` | no |
| <a name="input_enable_http2"></a> [enable\_http2](#input\_enable\_http2) | Enable HTTP/2 on the ELB | `bool` | `true` | no |
| <a name="input_enable_l7_load_balancing"></a> [enable\_l7\_load\_balancing](#input\_enable\_l7\_load\_balancing) | Use L7 (ALB) for load balancing. Otherwise, L4 (NLB) is used | `bool` | `true` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment variables for container | `map(string)` | `{}` | no |
| <a name="input_env_raw"></a> [env\_raw](#input\_env\_raw) | Raw environment variables for container | `list(any)` | `[]` | no |
| <a name="input_external_traffic_policy"></a> [external\_traffic\_policy](#input\_external\_traffic\_policy) | External traffic policy for L4 Load balancing | `string` | `"Local"` | no |
| <a name="input_hpa_enabled"></a> [hpa\_enabled](#input\_hpa\_enabled) | Enable HPA | `bool` | `true` | no |
| <a name="input_hpa_max_replica"></a> [hpa\_max\_replica](#input\_hpa\_max\_replica) | Max Number of replica | `number` | `3` | no |
| <a name="input_hpa_metrics"></a> [hpa\_metrics](#input\_hpa\_metrics) | Metrics for HPA Scaling | `any` | <pre>[<br>  {<br>    "resource": {<br>      "name": "cpu",<br>      "target": {<br>        "averageUtilization": 80,<br>        "type": "Utilization"<br>      }<br>    },<br>    "type": "Resource"<br>  },<br>  {<br>    "resource": {<br>      "name": "memory",<br>      "target": {<br>        "averageUtilization": 80,<br>        "type": "Utilization"<br>      }<br>    },<br>    "type": "Resource"<br>  }<br>]</pre> | no |
| <a name="input_hpa_min_replica"></a> [hpa\_min\_replica](#input\_hpa\_min\_replica) | Minimum Number of replica | `number` | `2` | no |
| <a name="input_image_repository"></a> [image\_repository](#input\_image\_repository) | Image repository for Ambassador image | `string` | `"quay.io/datawire/ambassador"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | Image tag for Ambassador image | `string` | `"1.13.3"` | no |
| <a name="input_internet_facing"></a> [internet\_facing](#input\_internet\_facing) | Whether the Load Balancer, L7 or L4 is internet facing | `bool` | `true` | no |
| <a name="input_l7_addiitonal_logging_prefixes"></a> [l7\_addiitonal\_logging\_prefixes](#input\_l7\_addiitonal\_logging\_prefixes) | Additional prefixes you want to include in the resource policy for the bucket | `list(string)` | `[]` | no |
| <a name="input_l7_logging_bucket"></a> [l7\_logging\_bucket](#input\_l7\_logging\_bucket) | Name of L7 Access Logging bucket to use or create | `string` | `""` | no |
| <a name="input_l7_logging_bucket_policy"></a> [l7\_logging\_bucket\_policy](#input\_l7\_logging\_bucket\_policy) | Bucket policy document, if any | `string` | `""` | no |
| <a name="input_l7_logging_expiration"></a> [l7\_logging\_expiration](#input\_l7\_logging\_expiration) | Expiration lifecycle rules for access logging bucket | <pre>list(object({<br>    enabled = bool<br><br>    date = optional(string) # Specifies the date after which you want the corresponding action to take effect.<br>    days = optional(number) # Specifies the number of days after object creation when the specific rule action takes effect.<br>    id   = optional(string)<br>  }))</pre> | <pre>[<br>  {<br>    "days": 730,<br>    "enabled": true,<br>    "id": "Delete2Years"<br>  }<br>]</pre> | no |
| <a name="input_l7_logging_prefix"></a> [l7\_logging\_prefix](#input\_l7\_logging\_prefix) | Prefix to create log objects. Defaults to var.name | `string` | `""` | no |
| <a name="input_l7_logging_transition"></a> [l7\_logging\_transition](#input\_l7\_logging\_transition) | L7 Logging class storage transitions | <pre>list(object({<br>    enabled       = bool<br>    storage_class = string<br><br>    date = optional(string) # Specifies the date after which you want the corresponding action to take effect.<br>    days = optional(number) # Specifies the number of days after object creation when the specific rule action takes effect.<br>    id   = optional(string)<br>  }))</pre> | <pre>[<br>  {<br>    "days": 30,<br>    "enabled": true,<br>    "id": "IA",<br>    "storage_class": "STANDARD_IA"<br>  },<br>  {<br>    "days": 365,<br>    "enabled": true,<br>    "id": "Glacier",<br>    "storage_class": "GLACIER"<br>  }<br>]</pre> | no |
| <a name="input_l7_object_default_retention"></a> [l7\_object\_default\_retention](#input\_l7\_object\_default\_retention) | Object lock default retention configuration. See https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lock-overview.html | <pre>object({<br>    mode  = string<br>    days  = optional(number)<br>    years = optional(number)<br>  })</pre> | <pre>{<br>  "mode": "GOVERNANCE",<br>  "years": 2<br>}</pre> | no |
| <a name="input_l7_object_lock_enabled"></a> [l7\_object\_lock\_enabled](#input\_l7\_object\_lock\_enabled) | Enable Object Lock on the bucket. See https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lock.html | `bool` | `false` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels for resources | `map(string)` | <pre>{<br>  "app.kubernetes.io/managed-by": "Terraform"<br>}</pre> | no |
| <a name="input_license_key"></a> [license\_key](#input\_license\_key) | License key for AES | `string` | `""` | no |
| <a name="input_license_key_create_secret"></a> [license\_key\_create\_secret](#input\_license\_key\_create\_secret) | Create secret for license key | `bool` | `true` | no |
| <a name="input_license_key_secret_annotations"></a> [license\_key\_secret\_annotations](#input\_license\_key\_secret\_annotations) | License key secret annotations | `map` | `{}` | no |
| <a name="input_license_key_secret_name"></a> [license\_key\_secret\_name](#input\_license\_key\_secret\_name) | Secret name for license | `string` | `""` | no |
| <a name="input_load_balancer_source_ranges"></a> [load\_balancer\_source\_ranges](#input\_load\_balancer\_source\_ranges) | Load balancer source range for L4 Load balancing | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_pod_disruption_budget"></a> [pod\_disruption\_budget](#input\_pod\_disruption\_budget) | PDB values | `any` | <pre>{<br>  "minAvailable": 1<br>}</pre> | no |
| <a name="input_priority_class_name"></a> [priority\_class\_name](#input\_priority\_class\_name) | Priority class names | `string` | `""` | no |
| <a name="input_rate_limit_create"></a> [rate\_limit\_create](#input\_rate\_limit\_create) | Create the RateLimitService | `bool` | `true` | no |
| <a name="input_redis_affinity"></a> [redis\_affinity](#input\_redis\_affinity) | Affinity for redis pods | `map` | `{}` | no |
| <a name="input_redis_create"></a> [redis\_create](#input\_redis\_create) | Create Redis | `bool` | `true` | no |
| <a name="input_redis_deployment_annotations"></a> [redis\_deployment\_annotations](#input\_redis\_deployment\_annotations) | Redis deployment annotations | `map` | `{}` | no |
| <a name="input_redis_image"></a> [redis\_image](#input\_redis\_image) | Redis image | `string` | `"redis"` | no |
| <a name="input_redis_resources"></a> [redis\_resources](#input\_redis\_resources) | Redis resources | `map` | `{}` | no |
| <a name="input_redis_service_annotations"></a> [redis\_service\_annotations](#input\_redis\_service\_annotations) | Redis service annotations | `map` | `{}` | no |
| <a name="input_redis_tag"></a> [redis\_tag](#input\_redis\_tag) | Redis image tag | `string` | `"5.0.1"` | no |
| <a name="input_redis_tolerations"></a> [redis\_tolerations](#input\_redis\_tolerations) | Redis tolerations | `list` | `[]` | no |
| <a name="input_redis_url"></a> [redis\_url](#input\_redis\_url) | Custom Redis URL | `string` | `""` | no |
| <a name="input_registry_create"></a> [registry\_create](#input\_registry\_create) | Enable Projects beta feature | `bool` | `false` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | Chart release name | `string` | `"ambassador"` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | Number of replicas | `number` | `3` | no |
| <a name="input_resources"></a> [resources](#input\_resources) | Pod resources | `any` | <pre>{<br>  "limits": {<br>    "cpu": "1000m",<br>    "memory": "1500Mi"<br>  },<br>  "requests": {<br>    "cpu": "200m",<br>    "memory": "1500Mi"<br>  }<br>}</pre> | no |
| <a name="input_service_annotations"></a> [service\_annotations](#input\_service\_annotations) | Additional annotations for the service | `map(string)` | `{}` | no |
| <a name="input_shield_advanced_protect"></a> [shield\_advanced\_protect](#input\_shield\_advanced\_protect) | Enable AWS Shield Advanced protection for the load balancer. Requires a subscription | `bool` | `false` | no |
| <a name="input_ssl_policy"></a> [ssl\_policy](#input\_ssl\_policy) | SSL Policy for L7 Load Balancer. See https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html#describe-ssl-policies | `string` | `"ELBSecurityPolicy-FS-1-2-2019-08"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of subnets for ALB to route traffic to. See https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-subnets.html | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for AWS resources where supported | `map(string)` | <pre>{<br>  "Terraform": "true"<br>}</pre> | no |
| <a name="input_tolerations"></a> [tolerations](#input\_tolerations) | Pod Tolerations | `list(any)` | `[]` | no |
| <a name="input_volume_mounts"></a> [volume\_mounts](#input\_volume\_mounts) | Volunes mounts for container | `list(any)` | `[]` | no |
| <a name="input_volumes"></a> [volumes](#input\_volumes) | Volunes for containers | `list(any)` | `[]` | no |
| <a name="input_waf_fail_open"></a> [waf\_fail\_open](#input\_waf\_fail\_open) | Indicates whether to allow a WAF-enabled load balancer to route requests to targets if it is unable to forward the request to AWS WAF. The value is true or false. | `bool` | `true` | no |
| <a name="input_wafv2_arn"></a> [wafv2\_arn](#input\_wafv2\_arn) | WAFV2 ARN to attach to the ALB | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ambassador_id"></a> [ambassador\_id](#output\_ambassador\_id) | Ambassador ID |
| <a name="output_lb_arn"></a> [lb\_arn](#output\_lb\_arn) | ARN of the LB |
| <a name="output_lb_dns_name"></a> [lb\_dns\_name](#output\_lb\_dns\_name) | DNS name of the LB |
