# Creating referred repositories
resource "aws_ecr_repository" "staging" {
 count = contains(var.environments, "develop") || contains(var.environments, "latest") ? length(var.apps) : 0
 name  = join("-", ["staging", var.apps[count.index].name, "ecr-repository"])
 image_tag_mutability = "MUTABLE"

 image_scanning_configuration {
  scan_on_push = true
 }

 encryption_configuration {
  encryption_type = "AES256"
 }

 tags = {
  Name = join("-", ["staging", var.apps[count.index].name, "ecr-repository"])
  Environment = "staging"
 }
}