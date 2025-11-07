terraform {
  backend "s3" {
    bucket = "hichamazeroual"
    key    = "ec2/terraform.tfstate"
    region = "us-east-1"
  }
}
