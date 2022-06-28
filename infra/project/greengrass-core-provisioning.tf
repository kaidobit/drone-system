data "aws_iam_policy_document" "greengrass_v2_token_exchange_policy" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
      "s3:GetBucketLocation"
    ]
    resources = ["*"] # TODO
  }
}

data "aws_iam_policy_document" "assume_greengrass_v2_token_exchange_role_policy" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type =  "AWS"
      identifiers = [
        aws_iam_user.greengrass_user.arn,
        #aws_iam_group.developers.arn
      ]
    }
  }
}

resource "aws_iam_user" "greengrass_user" {
  name                 = "GreengrassProvisioningUser"
  force_destroy        = var.force_destroy_stack
}

resource "aws_iam_access_key" "greengrass_user_access_key" {
  user = aws_iam_user.greengrass_user.name
}

resource "aws_iam_role" "greengrass_v2_token_exchange_role" {
  name = var.greengrass_v2_token_exchange_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_greengrass_v2_token_exchange_role_policy.json
  inline_policy {
    name   = var.greengrass_v2_token_exchange_policy_name
    policy = data.aws_iam_policy_document.greengrass_v2_token_exchange_policy.json
  }
}

resource "aws_iot_role_alias" "alias" {
  alias    = var.greengrass_v2_token_exchange_role_alias
  role_arn = aws_iam_role.greengrass_v2_token_exchange_role.arn
}