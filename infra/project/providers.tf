provider "aws" {
  default_tags {
    tags = {
      "terraform" = true
      "project"   = var.projectname
    }
  }
}