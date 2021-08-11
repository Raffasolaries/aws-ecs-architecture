terraform {
 backend "s3" {
  bucket = "tantosvago-terraform-states"
  key    = "ecs/laravel-applications/terraform.tfstate"
  region = "eu-south-1"
 }
}