resource "aws_iam_group" "developers" {
  name = format("%s-developers",var.projectname)
}

resource "aws_iot_thing_group" "development_companion_computer_thing_group" {
  name = "development-companion-computer"

  parent_group_name = aws_iot_thing_group.companion_computer.name

  properties {
    description = "Thing group for developer devices."
  }
}