data "aws_iam_policy_document" "greengrass_provision_policy_document" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
      "s3:GetBucketLocation",
      "s3:GetObject"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "assume_greengrass_provision_role_policy_document" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type =  "AWS"
      identifiers = [
        aws_iam_user.greengrass_user.arn
      ]
    }
  }
}

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

resource "aws_iam_user" "greengrass_user" {
  name                 = "GreengrassProvisioningUser"
  force_destroy        = var.iam_force_destroy_provision_user
}

resource "aws_iam_policy" "greengrass_provision_policy" {
  name        = var.greengrass_provision_policy_name
  description = "Greengrass V2 Token Exchange Policy."

  policy = data.aws_iam_policy_document.greengrass_provision_policy_document.json
}

resource "aws_iam_role" "greengrass_provision_role" {
  name = var.greengrass_provision_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_greengrass_provision_role_policy_document.json
}

module "artifact_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket                   = format("%s-artifact-origin", var.projectname)
  force_destroy            = var.s3_destroy_artifact_origin

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  attach_policy           = true
  policy                  = data.aws_iam_policy_document.artifact_bucket_policy.json
}