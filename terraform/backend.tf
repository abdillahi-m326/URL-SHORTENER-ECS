terraform {
  backend "s3" {
    bucket = "terraform-url-shortener-project-tfstate"
    key    = "ecs-fargate/terraform.tfstate"
    region = "us-east-1"
  }
}
