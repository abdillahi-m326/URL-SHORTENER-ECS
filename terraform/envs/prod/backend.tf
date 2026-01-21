terraform {
  backend "s3" {
    bucket         = "abdillahi-m326-urlshortener-tfstate"
    key            = "url-shortener/prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}



