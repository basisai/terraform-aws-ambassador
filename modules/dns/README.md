# DNS Aliases from Kubernetes managed `LoadBalancer`

This is a utility module to create Route53 alias records from Load Balancers created by
Kubernetes. This can be a `Service` of type `LoadBalancer` or an `Ingress`.

Usually, when you create these resources, the controller only returns the DNS name of the
Load Balancer created in the `status` of the resources. The name of the Load Balancer is encoded
in the DNS name.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.28 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.28 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_lb.lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_dns_records"></a> [create\_dns\_records](#input\_create\_dns\_records) | Create DNS records | `bool` | `true` | no |
| <a name="input_dns_names"></a> [dns\_names](#input\_dns\_names) | Map of DNS names to create records for. Key is DNS name, value is the Zone ID | `map(string)` | `{}` | no |
| <a name="input_lb_dns_name"></a> [lb\_dns\_name](#input\_lb\_dns\_name) | LoadBalancer DNS name | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lb"></a> [lb](#output\_lb) | LB Object |
| <a name="output_lb_arn"></a> [lb\_arn](#output\_lb\_arn) | ARN of LB |
