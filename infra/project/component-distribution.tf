data "aws_iam_policy_document" "artifact_bucket_policy" {
  statement {
    sid = "2012-10-17"

    actions = [
      "s3:GetObject"
    ]

    resources = [
      format("%s/*", module.artifact_bucket.s3_bucket_arn)
    ]

    principals {
      type = "AWS"
      identifiers = [aws_iam_role.greengrass_provision_role.arn]
    }
  }
}

module "artifact_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket                   = format("%s-artifact-origin",var.projectname)
  force_destroy            = var.s3_destroy_artifact_origin

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  attach_policy           = true
  policy                  = data.aws_iam_policy_document.artifact_bucket_policy.json
}