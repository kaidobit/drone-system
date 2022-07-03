data "aws_iam_policy_document" "greengrass_provision_policy_document" {
  version = "2012-10-17"

  statement {
    sid = "CreateTokenExchangeRole"
    effect = "Allow"
    actions = [
      "iam:AttachRolePolicy",
      "iam:CreatePolicy",
      "iam:CreateRole",
      "iam:GetPolicy",
      "iam:GetRole",
      "iam:PassRole"
    ]
    resources = ["*"]
  }
  statement {
    sid = "CreateIoTResources"
    effect = "Allow"
    actions = [
      "iot:AddThingToThingGroup",
      "iot:AttachPolicy",
      "iot:AttachThingPrincipal",
      "iot:CreateKeysAndCertificate",
      "iot:CreatePolicy",
      "iot:CreateRoleAlias",
      "iot:CreateThing",
      "iot:CreateThingGroup",
      "iot:DescribeEndpoint",
      "iot:DescribeRoleAlias",
      "iot:DescribeThingGroup",
      "iot:GetPolicy"
    ]
    resources = ["*"]
  }
  statement {
    sid = "DeployDevTools"
    effect = "Allow"
    actions = [
      "greengrass:CreateDeployment",
      "iot:CancelJob",
      "iot:CreateJob",
      "iot:DeleteThingShadow",
      "iot:DescribeJob",
      "iot:DescribeThing",
      "iot:DescribeThingGroup",
      "iot:GetThingShadow",
      "iot:UpdateJob",
      "iot:UpdateThingShadow"
    ]
    resources = ["*"]
  }
  statement {
    sid = "ProvisionDevice"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
      "s3:GetBucketLocation",
    ]
    resources = ["*"]
  }
  statement {
    sid = "DeployArtifacts"
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = [module.artifact_bucket.s3_bucket_arn]
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
        #aws_iam_group.developers.arn # TODO
      ]
    }
  }
}

resource "aws_iam_user" "greengrass_user" {
  name                 = "GreengrassProvisioningUser"
  force_destroy        = var.iam_force_destroy_provision_user
}

resource "aws_iam_access_key" "greengrass_user_access_key" {
  user = aws_iam_user.greengrass_user.name
}

resource "aws_iam_policy" "greengrass_provision_policy" {
  name        = var.greengrass_provision_policy_name
  description = "Greengrass V2 Token Exchange Policy."

  policy = data.aws_iam_policy_document.greengrass_provision_policy_document.json
}

resource "aws_iam_policy_attachment" "greengrass_provision_policy_attachment" {
  name       = format("%s-attachment", var.greengrass_provision_policy_name)
  roles      = [aws_iam_role.greengrass_provision_role.name]
  policy_arn = aws_iam_policy.greengrass_provision_policy.arn
}

resource "aws_iam_role" "greengrass_provision_role" {
  name = var.greengrass_provision_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_greengrass_provision_role_policy_document.json
}

resource "aws_iot_role_alias" "greengrass_provision_role_alias" {
  alias    = var.greengrass_provision_role_alias
  role_arn = aws_iam_role.greengrass_provision_role.arn
}