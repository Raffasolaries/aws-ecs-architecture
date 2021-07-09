## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_develop"></a> [develop](#module\_develop) | ./modules/develop | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Application name | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | referral environment | `string` | n/a | yes |
| <a name="input_platform_name"></a> [platform\_name](#input\_platform\_name) | Platform name | `string` | n/a | yes |
| <a name="input_profile"></a> [profile](#input\_profile) | AWS IAM user credentials | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS deployment region | `string` | `"eu-south-1"` | no |
| <a name="input_subnets_newbits"></a> [subnets\_newbits](#input\_subnets\_newbits) | the difference between subnet mask and network mask | `number` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR VPC block | `string` | n/a | yes |

## Outputs

No outputs.