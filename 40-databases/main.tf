resource "aws_instance" "mongodb" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.mongodb_sg_id]
  subnet_id = local.database_subnet_ids

  tags = merge (
    local.common_tags,
    {
        Name = "${local.common_name_suffix}-mongodb" # roboshop-dev-mongodb
    }
  )
}

resource "terraform_data" "mongodb" {
    triggers_replace = [
        aws_instance.mongodb.id,
    ]

    connection {
        type = "ssh"
        user = "ec2-user"
        password = "DevOps321"
        host = aws_instance.mongodb.private_ip
    }

    # terraform copies this file to mongodb instance and then executes it
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

resource "aws_instance" "rabbitmq" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.rabbitmq_sg_id]
  subnet_id = local.database_subnet_ids

  tags = merge (
    local.common_tags,
    {
        Name = "${local.common_name_suffix}-rabbitmq" # roboshop-dev-rabbitmq
    }
  )
}

resource "terraform_data" "rabbitmq" {
    triggers_replace = [
        aws_instance.rabbitmq.id,
    ]

    connection {
        type = "ssh"
        user = "ec2-user"
        password = "DevOps321"
        host = aws_instance.rabbitmq.private_ip
    }

    # terraform copies this file to rabbitmq instance and then executes it
    provisioner "file" {
      source = "bootstrap.sh"
      destination = "/tmp/bootstrap.sh"
    }

    provisioner "remote-exec" {
      inline = [ 
        "chmod +x /tmp/bootstrap.sh",
        "sudo sh /tmp/bootstrap.sh rabbitmq"
       ]
    }
  
}

resource "aws_instance" "mysql" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.mysql_sg_id]
  subnet_id = local.database_subnet_ids
  iam_instance_profile = aws_iam_instance_profile.msql.name

  tags = merge (
    local.common_tags,
    {
        Name = "${local.common_name_suffix}-mysql" # roboshop-dev-mysql     
    }
  )
}

resource "aws_iam_instance_profile" "msql" {
  name = "${local.common_name_suffix}-mysql-iam-profile" # roboshop-dev-mysql-iam-profile
  role = "EC2SSMParameterRead" # this role has permission to read SSM parameters, which is required for the mysql instance to read the database password from SSM parameter store
}

resource "terraform_data" "mysql" {
    triggers_replace = [
        aws_instance.mysql.id,
    ]

    connection {
        type = "ssh"
        user = "ec2-user"
        password = "DevOps321"
        host = aws_instance.mysql.private_ip
    }

    # terraform copies this file to mysql instance and then executes it
    provisioner "file" {
      source = "${path.module}/bootstrap.sh"
      destination = "/tmp/bootstrap.sh"
    }

    provisioner "remote-exec" {
      inline = [ 
        "chmod +x /tmp/bootstrap.sh",
        "sudo sh -x /tmp/bootstrap.sh mysql dev ${var.environment}" #_-x is used to print the commands being executed, which is helpful for debugging
       ]
    }
  
}

resource "aws_route53_record" "mongodb" {
  zone_id = var.zone_id
  name    = "mongodb-${var.environment}.${var.domain_name}" # mongodb-dev.srini.store
  type    = "A"
  ttl     = 1
  records = [aws_instance.mongodb.private_ip]
}

resource "aws_route53_record" "redis" {
  zone_id = var.zone_id
  name    = "redis-${var.environment}.${var.domain_name}" # redis-dev.srini.store
  type    = "A"
  ttl     = 1
  records = [aws_instance.redis.private_ip]
  allow_overwrite = true
}

resource "aws_route53_record" "rabbitmq" {
  zone_id = var.zone_id
  name    = "rabbitmq-${var.environment}.${var.domain_name}" # rabbitmq-dev.srini.store
  type    = "A"
  ttl     = 1
  records = [aws_instance.rabbitmq.private_ip]
  allow_overwrite = true
}

resource "aws_route53_record" "mysql" {
  zone_id = var.zone_id
  name    = "mysql-${var.environment}.${var.domain_name}" # mysql-dev.srini.store
  type    = "A"
  ttl     = 1
  records = [aws_instance.mysql.private_ip]
  allow_overwrite = true
}
