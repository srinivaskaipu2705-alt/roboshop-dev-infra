data "aws_ami" "joindevops" {
    owners = ["973714476881"] # Red Hat's AWS account ID
    most_recent = true

    filter {
        name = "name"
        values = ["Redhat-9-DevOps-Practice*"]
    }


    filter {
        name = "root-device-type"
        values = ["ebs"]
    }

    filter {
      name = "virtualization-type"
      values = ["hvm"]
    }
}
