resource "aws_iot_thing_group" "companion_computer" {
  name = "companion-computer"

  properties {
    description = "A companion computer has a hardwired connection to a UAVs flight controller."
  }
}

resource "aws_iot_thing_group" "development_companion_computer" {
  name = "dev-companion-computer"

  parent_group_name = aws_iot_thing_group.companion_computer.name

  properties {
    description = "Companion computer including packages for development."
  }
}