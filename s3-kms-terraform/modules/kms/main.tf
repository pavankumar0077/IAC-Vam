resource "aws_kms_key" "s3_key" {
  description             = "KMS key for S3 bucket encryption"
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = true
  policy                 = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action   = "kms:*"
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:PrincipalOrgID": data.aws_organizations_organization.current.id
          }
        }
      }
    ]
  })

  tags = merge(
    var.common_tags,
    {
      Name = "s3-kms-key-${var.environment}"
    }
  )
}

resource "aws_kms_alias" "s3_key_alias" {
  name          = "alias/s3-key-${var.environment}"
  target_key_id = aws_kms_key.s3_key.key_id
}

data "aws_organizations_organization" "current" {}
