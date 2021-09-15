## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.49.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_develop"></a> [develop](#module\_develop) | ./modules/develop | n/a |
| <a name="module_latest"></a> [latest](#module\_latest) | ./modules/latest | n/a |
| <a name="module_production"></a> [production](#module\_production) | ./modules/production | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_cloudwatch_log_group.ecs_tasks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apps"></a> [apps](#input\_apps) | Application names and their domain associations | <pre>list(object({<br>  name = string<br>  domain = string<br> }))</pre> | n/a | yes |
| <a name="input_domains"></a> [domains](#input\_domains) | Domain names list (without subdomain) | `list` | n/a | yes |
| <a name="input_environments"></a> [environments](#input\_environments) | referral environments | `list` | n/a | yes |
| <a name="input_iam_instance_role_name"></a> [iam\_instance\_role\_name](#input\_iam\_instance\_role\_name) | IAM instance role name | `string` | n/a | yes |
| <a name="input_platform_name"></a> [platform\_name](#input\_platform\_name) | Platform name | `string` | n/a | yes |
| <a name="input_profile"></a> [profile](#input\_profile) | AWS IAM user credentials | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS deployment region | `string` | `"eu-south-1"` | no |
| <a name="input_subnets_newbits"></a> [subnets\_newbits](#input\_subnets\_newbits) | the difference between subnet mask and network mask | `number` | n/a | yes |
| <a name="input_task_execution_role_arn"></a> [task\_execution\_role\_arn](#input\_task\_execution\_role\_arn) | ECS Tasks Execution role arn | `string` | n/a | yes |
| <a name="input_task_port"></a> [task\_port](#input\_task\_port) | Application Container exposed port | `number` | n/a | yes |
| <a name="input_task_role_arn"></a> [task\_role\_arn](#input\_task\_role\_arn) | ECS Tasks Execution role arn | `string` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR VPC block | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_production_alb_name"></a> [production\_alb\_name](#output\_production\_alb\_name) | Production ALB Name |
| <a name="output_production_ecr_repositories_urls"></a> [production\_ecr\_repositories\_urls](#output\_production\_ecr\_repositories\_urls) | ECR Production repositories names |
| <a name="output_staging_alb_name"></a> [staging\_alb\_name](#output\_staging\_alb\_name) | Staging ALB Name |
| <a name="output_staging_ecr_repositories_urls"></a> [staging\_ecr\_repositories\_urls](#output\_staging\_ecr\_repositories\_urls) | ECR Staging repositories names |