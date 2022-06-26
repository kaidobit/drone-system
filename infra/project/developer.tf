resource "aws_iam_group" "developers" {
  name = format("%s-developers",var.projectname)
}
