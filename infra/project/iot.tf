data "aws_iam_policy_document" "thing_policy_document" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "iot:Connect",
      "iot:Publish",
      "iot:Subscribe",
      "iot:Receive",
      "greengrass:*"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "certificate_policy_document" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "iot:AssumeRoleWithCertificate"
    ]
    resources = [aws_iot_role_alias.greengrass_provision_role_alias.arn]
  }
}

data "aws_iam_policy_document" "greengrass_service_policy_document" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      identifiers = ["greengrass.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "greengrass_ressource_access_policy_document" {
  version = "2012-10-17"

  statement {
    sid = "AllowGreengrassAccessToShadows"
    actions = [
      "iot:DeleteThingShadow",
      "iot:GetThingShadow",
      "iot:UpdateThingShadow"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:iot:*:*:thing/GG_*",
      "arn:aws:iot:*:*:thing/*-gcm",
      "arn:aws:iot:*:*:thing/*-gda",
      "arn:aws:iot:*:*:thing/*-gci"
    ]
  }
  statement {
    sid = "AllowGreengrassToDescribeThings"
    actions = [
       "iot:DescribeThing"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:iot:*:*:thing/*"
    ]
  }
  statement {
    sid = "AllowGreengrassToDescribeCertificates"
    actions = [
      "iot:DescribeCertificate"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:iot:*:*:cert/*"
    ]
  }
  statement {
    sid = "AllowGreengrassToCallGreengrassServices"
    actions = [
      "greengrass:*"
    ]
    effect = "Allow"
    resources = [
      "*"
    ]
  }
  statement {
      sid = "AllowGreengrassToGetLambdaFunctions"
      actions = [
        "lambda:GetFunction",
        "lambda:GetFunctionConfiguration"
      ]
    effect = "Allow"
    resources = [
      "*"
    ]
  }
  statement {
    sid = "AllowGreengrassToGetGreengrassSecrets"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:secretsmanager:*:*:secret:greengrass-*"
    ]
  }
  statement {
    sid = "AllowGreengrassAccessToS3Objects"
    actions = [
      "s3:GetObject"
    ]
    effect = "Allow"
    resources = [
      format("%s/*", module.artifact_bucket.s3_bucket_arn)
#      "arn:aws:s3:::*Greengrass*",
#      "arn:aws:s3:::*GreenGrass*",
#      "arn:aws:s3:::*greengrass*",
#      "arn:aws:s3:::*Sagemaker*",
#      "arn:aws:s3:::*SageMaker*",
#      "arn:aws:s3:::*sagemaker*"
    ]
  }
  statement {
    sid = "AllowGreengrassAccessToS3BucketLocation"
    actions = [
      "s3:GetBucketLocation"
    ]
    effect = "Allow"
    resources = [
      "*"
    ]
  }
  statement {
    sid = "AllowGreengrassAccessToSageMakerTrainingJobs"
    actions = [
      "sagemaker:DescribeTrainingJob"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:sagemaker:*:*:training-job/*"
    ]
  }
}

resource "aws_iam_policy" "greengrass_ressource_access_policy" {
  name        = "GreengrassResourceAccessPolicy"
  policy = data.aws_iam_policy_document.greengrass_ressource_access_policy_document.json
}

resource "aws_iam_role" "greengrass_service_role" {
  name = "GreengrassServiceRole"
  assume_role_policy = data.aws_iam_policy_document.greengrass_service_policy_document.json
}

resource "aws_iam_policy_attachment" "greengrass_ressource_access_policy_attachment" {
  name       = "GreengrassResourceAccessPolicyAttachment"
  roles      = [aws_iam_role.greengrass_service_role.name]
  policy_arn = aws_iam_policy.greengrass_ressource_access_policy.arn
}

resource "aws_iot_role_alias" "greengrass_provision_role_alias" {
  alias    = var.greengrass_provision_role_alias
  role_arn = aws_iam_role.greengrass_provision_role.arn
}

resource "aws_iot_policy" "thing_policy" {
  name = var.iot_thing_policy_name
  policy = data.aws_iam_policy_document.thing_policy_document.json
}

resource "aws_iot_policy" "certificate_policy" {
  name = format("GreengrassTESCertificatePolicy%s", var.greengrass_provision_role_alias)
  policy = data.aws_iam_policy_document.certificate_policy_document.json
}

resource "aws_iot_thing_group" "companion_computer" {
  name = "companion-computer"
}