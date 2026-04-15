#create an EC2 instance to host the catalogue service
resource "aws_instance" "catalogue" {
    ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.catalogue_sg_id]
  subnet_id = local.private_subnet_id

  tags = merge (
    local.common_tags,
    {
        Name = "${local.common_name_suffix}-catalogue" # roboshop-dev-catalogue
    }
  )
}

#connect to instance using remote-exec provisioner through terraform_data
resource "terraform_data" "catalogue" {
    triggers_replace = [
        aws_instance.catalogue.id,
    ]


    connection {
        type = "ssh"
        user = "ec2-user"
        password = "DevOps321"
        host = aws_instance.catalogue.private_ip
    }

    # terraform copies this file to catalogue instance and then executes it
    provisioner "file" {
      source = "catalogue.sh"
      destination = "/tmp/catalogue.sh"
    }

    provisioner "remote-exec" {
      inline = [ 
        "chmod +x /tmp/catalogue.sh",
        #"sudo sh /tmp/bootstrap.sh"
        "sudo sh /tmp/catalogue.sh catalogue ${var.environment}"
       ]
    }
}

#stop the instance to take AMI image
resource "aws_ec2_instance_state" "catalogue" {
    instance_id = aws_instance.catalogue.id
    state = "stopped"
    depends_on = [ terraform_data.catalogue ]
}

resource "aws_ami_from_instance" "catalogue" {
    name = "${local.common_name_suffix}-catalogue-ami" # roboshop-dev-catalogue-ami
     description = "AMI for catalogue service"
    source_instance_id = aws_instance.catalogue.id
    depends_on = [ aws_ec2_instance_state.catalogue ]
    tags = merge (
        local.common_tags,
        {
            Name = "${local.common_name_suffix}-catalogue-ami" # roboshop-dev-catalogue-ami
        }
    )
}

#target group for catalogue service
resource "aws_lb_target_group" "catalogue" {
    name = "${local.common_name_suffix}-catalogue-tg" # roboshop-dev-catalogue-tg
    port = 8080
    protocol = "HTTP"
    vpc_id = local.vpc_id
    deregistration_delay = 60 #waiting period before deleting the target from the target group, this is required to ensure that the existing connections are not dropped immediately when the target is deleted from the target group, this is especially important for stateful applications like catalogue service which may have long running connections.
    
    health_check {
        healthy_threshold = 2
        unhealthy_threshold = 2
        interval = 10
        timeout = 2
        path = "/health"
        protocol = "HTTP"
        matcher = "200-299"
    }
    tags = merge (
        local.common_tags,
        {
            Name = "${local.common_name_suffix}-catalogue-tg" # roboshop-dev-catalogue-tg
        }
    )
} 

# aws launch template for catalogue service
resource "aws_launch_template" "catalogue" {
    name = "${local.common_name_suffix}-catalogue-lt" # roboshop-dev-catalogue-lt
    image_id = aws_ami_from_instance.catalogue.id
    instance_initiated_shutdown_behavior = "terminate"
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.catalogue_sg_id]
    # key_name = "roboshop-dev-key" # replace with your key pair name
    # user_data = file("catalogue.sh")


    #tags attached to the instance created by the launch template
    tag_specifications {
      resource_type = "instance"
        tags = merge (
          local.common_tags,
          {
              Name = "${local.common_name_suffix}-catalogue" # roboshop-dev-catalogue
          }
      )
    }

    # tags attached to the volume created by instance
     tag_specifications {
       resource_type = "volume"     
     tags = merge (
        local.common_tags,
        {
            Name = "${local.common_name_suffix}-catalogue-lt" # roboshop-dev-catalogue-lt
        }
      )
    }

    # tags attached to the launch template
    tags = merge (
        local.common_tags,
        {
            Name = "${local.common_name_suffix}-catalogue-lt" # roboshop-dev-catalogue-lt
        }
    )
}

# auto scaling group for catalogue service
resource "aws_autoscaling_group" "catalogue" {
    name = "${local.common_name_suffix}-catalogue-asg" # roboshop-dev-catalogue-asg
    max_size = 10
    min_size = 1
    health_check_grace_period = 100
    health_check_type = "ELB"
    desired_capacity = 1
    force_delete = false 
    launch_template {
        id = aws_launch_template.catalogue.id
        version = aws_launch_template.catalogue.latest_version
    }
    vpc_zone_identifier = local.private_subnet_ids
    target_group_arns = [aws_lb_target_group.catalogue.arn]
    dynamic "tag" { #we will get the iterator with name as value
      for_each = merge(
        local.common_tags,
        {
            Name = "${local.common_name_suffix}-catalogue" # roboshop-dev-catalogue
        }
      )
      content {
        key = tag.key
        value = tag.value
        propagate_at_launch = true
      }
    }

    timeouts {
      delete = "15m"
    }
}

#auto scaling policy for catalogue service
resource "aws_autoscaling_policy" "catalogue" {
    name = "${local.common_name_suffix}-catalogue-cpu-policy" # roboshop-dev-catalogue-cpu-policy
    autoscaling_group_name = aws_autoscaling_group.catalogue.name
    policy_type = "TargetTrackingScaling"
    target_tracking_configuration {
        predefined_metric_specification {
            predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 75.0
    }
}

#listener rule to forward traffic to catalogue target group
resource "aws_lb_listener_rule" "catalogue" {
    listener_arn = local.backend_alb_listener_arn
    priority = 10

    action {
        type = "forward"
        target_group_arn = aws_lb_target_group.catalogue.arn
    }

    condition {
        host_header {
            values = ["catalogue.backend-alb-${var.environment}.${var.domain_name}"] # catalogue.backend-alb-{environment}.srini.store
        }
    }
}

resource "terraform_data" "catalogue_local" {
    triggers_replace = [
        aws_instance.catalogue.id,
    ]

    depends_on = [aws_autoscaling_policy.catalogue]
    
    provisioner "local-exec" {
      command = "aws ec2 terminate-instances --instance-ids ${aws_instance.catalogue.id}"
    }
}