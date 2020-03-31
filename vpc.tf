
module "us-east-1" {
  source    = "./vpc"
  providers = { aws = "aws.virginia" }
}