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
  name       = format("%sAttachment", var.greengrass_provision_policy_name)
  roles      = [aws_iam_role.greengrass_provision_role.name]
  policy_arn = aws_iam_policy.greengrass_provision_policy.arn
}

resource "aws_iam_role" "greengrass_provision_role" {
  name = var.greengrass_provision_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_greengrass_provision_role_policy_document.json
}