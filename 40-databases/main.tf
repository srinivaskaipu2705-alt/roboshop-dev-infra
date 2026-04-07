resource "aws_instance" "redis" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.redis_sg_id]
  subnet_id = local.database_subnet_ids

  tags = merge (
    local.common_tags,
    {
        Name = "${local.common_name_suffix}-redis" # roboshop-dev-redis
    }
  )
}

resource "terraform_data" "redis" {
    triggers_replace = [
        aws_instance.redis.id,
    ]

    connection {
        type = "ssh"
        user = "ec2-user"
        password = "DevOps321"
        host = aws_instance.redis.private_ip
    }

    # terraform copies this file to redis instance and then executes it
    provisioner "file" {
      source = "bootstrap.sh"
      destination = "/tmp/bootstrap.sh"
    }

    provisioner "remote-exec" {
      inline = [ 
        "chmod +x /tmp/bootstrap.sh",
        #"sudo sh /tmp/bootstrap.sh"
        "sudo sh /tmp/bootstrap.sh mongodb"
       ]
    }
  
}

resource "aws_instance" "redis" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.redis_sg_id]
  subnet_id = local.database_subnet_ids

  tags = merge (
    local.common_tags,
    {
        Name = "${local.common_name_suffix}-redis" # roboshop-dev-redis
    }
  )
}

resource "terraform_data" "redis" {
    triggers_replace = [
        aws_instance.redis.id,
    ]

    connection {
        type = "ssh"
        user = "ec2-user"
        password = "DevOps321"
        host = aws_instance.redis.private_ip
    }

    # terraform copies this file to redis instance and then executes it
    provisioner "file" {
      source = "bootstrap.sh"
      destination = "/tmp/bootstrap.sh"
    }

    provisioner "remote-exec" {
      inline = [ 
        "chmod +x /tmp/bootstrap.sh",
        "sudo sh /tmp/bootstrap.sh redis"
       ]
    }
  
}