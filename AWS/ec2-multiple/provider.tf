terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.25.0"
    }
  }
}
provider "aws" {                 # Defining the Provider Amazon as we need to run this on AWS   
  region = "us-west-2"
}
