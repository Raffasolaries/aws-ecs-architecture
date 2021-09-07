region = "eu-west-3"
profile = "default"
platform_name = "laravel-applications"
apps = [{
 name: "gowelfare",
 domain: "tantosvago.it"
}]
environments = ["develop","latest","production"]
vpc_cidr = "10.0.0.0/22"
subnets_newbits = 3
domains = ["tantosvago.it"]
task_port = 8080
task_execution_role_arn = "arn:aws:iam::255994201635:role/ecsTaskExecutionRole"
task_role_arn = "arn:aws:iam::255994201635:role/ecsTaskExecutionRole"
// service_role = "arn:aws:iam::255994201635:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
iam_instance_role_name = "ecsInstanceRole"