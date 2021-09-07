# Creating referred repositories
resource "aws_ecr_repository" "production" {
 count = contains(var.environments, "production") ? length(var.app_names) : 0
 name  = join("-", ["prod", var.app_names[count.index], "ecr-repository"])
 image_tag_mutability = "MUTABLE"

 image_scanning_configuration {
  scan_on_push = true
 }

 encryption_configuration {
  encryption_type = "AES256"
 }

 tags = {
  Name = join("-", ["prod", var.app_names[count.index], "ecr-repository"])
  Environment = "production"
 }
}