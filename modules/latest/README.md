## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecs_service.services](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.tasks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_lb_listener_rule.host_based_routing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.instances](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_listener_https_default_arn"></a> [alb\_listener\_https\_default\_arn](#input\_alb\_listener\_https\_default\_arn) | Staging ALB HTTPS default listener ARN | `string` | n/a | yes |
| <a name="input_alb_target_groups_instances_arns"></a> [alb\_target\_groups\_instances\_arns](#input\_alb\_target\_groups\_instances\_arns) | Staging ALB Instances Target Groups ARNs | `list` | n/a | yes |
| <a name="input_app_names"></a> [app\_names](#input\_app\_names) | Application name | `list` | n/a | yes |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Selected region Availability Zones | `list` | n/a | yes |
| <a name="input_cloudwatch_groups"></a> [cloudwatch\_groups](#input\_cloudwatch\_groups) | CloudWatch Logs Group for ECS Task containers | `list` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | Base domain of the app (without subdomain) | `string` | n/a | yes |
| <a name="input_ecr_repositories_urls"></a> [ecr\_repositories\_urls](#input\_ecr\_repositories\_urls) | Staging ECR Repositories URLs | `list` | n/a | yes |
| <a name="input_ecs_cluster_id"></a> [ecs\_cluster\_id](#input\_ecs\_cluster\_id) | Staging ECS Cluster ID | `string` | n/a | yes |
| <a name="input_environments"></a> [environments](#input\_environments) | referral environments | `list` | n/a | yes |
| <a name="input_instances_security_group_id"></a> [instances\_security\_group\_id](#input\_instances\_security\_group\_id) | Staging Instances Security Group ID | `string` | n/a | yes |
| <a name="input_platform_name"></a> [platform\_name](#input\_platform\_name) | Platform name | `string` | n/a | yes |
| <a name="input_private_subnets_ids"></a> [private\_subnets\_ids](#input\_private\_subnets\_ids) | Staging Private Subnets IDs | `list` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS deployment region | `string` | `"eu-south-1"` | no |
| <a name="input_task_execution_role_arn"></a> [task\_execution\_role\_arn](#input\_task\_execution\_role\_arn) | ECS Tasks Execution role arn | `string` | n/a | yes |
| <a name="input_task_port"></a> [task\_port](#input\_task\_port) | Application exposed port to Load Balancer | `number` | n/a | yes |
| <a name="input_task_role_arn"></a> [task\_role\_arn](#input\_task\_role\_arn) | ECS Tasks Execution role arn | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Staging VPC ID | `string` | n/a | yes |

## Outputs

No outputs.