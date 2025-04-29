locals {
  common_tags = {
    Environment = var.environment
    Project     = "S3-KMS"
    ManagedBy   = "Terraform"
  }
}

module "kms" {
  source = "../../modules/kms"

  environment = var.environment
  common_tags = local.common_tags
}

module "s3" {
  source = "../../modules/s3"

  bucket_name        = var.bucket_name
  environment        = var.environment
  kms_key_arn       = module.kms.key_arn
  versioning_enabled = true
  common_tags       = local.common_tags
}
