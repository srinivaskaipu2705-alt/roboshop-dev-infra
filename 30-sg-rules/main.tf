resource "aws_security_group_rule" "backend_alb_bastion" {
    type = "ingress"
    security_group_id = local.backend_alb_sg_id
    source_security_group_id = local.bastion_sg_id # bastion SG ID
    from_port = 80
    protocol = "tcp"
    to_port = 80
}

resource "aws_security_group_rule" "bastion_laptop" {
    type = "ingress"
    security_group_id = local.bastion_sg_id
    cidr_blocks = ["0.0.0.0/0"] # allow from anywhere, can be restricted to specific IPs or CIDR blocks
    from_port = 22
    protocol = "tcp"
    to_port = 22
}

resource "aws_security_group_rule" "mongodb_bastion" {
    type = "ingress"
    security_group_id = local.mongodb_sg_id
    source_security_group_id = local.bastion_sg_id # allow from MongoDB SG
    from_port = 22
    protocol = "tcp"
    to_port = 22
}

resource "aws_security_group_rule" "redis_bastion" {
    type = "ingress"
    security_group_id = local.redis_sg_id
    source_security_group_id = local.bastion_sg_id # allow from Redis SG
    from_port = 22
    protocol = "tcp"
    to_port = 22
}

resource "aws_security_group_rule" "rabbitmq_bastion" {
    type = "ingress"
    security_group_id = local.rabbitmq_sg_id
    source_security_group_id = local.bastion_sg_id # allow from RabbitMQ SG
    from_port = 22
    protocol = "tcp"
    to_port = 22
}

resource "aws_security_group_rule" "mysql_bastion" {
    type = "ingress"
    security_group_id = local.mysql_sg_id
    source_security_group_id = local.bastion_sg_id # allow from MySQL SG
    from_port = 22
    protocol = "tcp"
    to_port = 22
}

resource "aws_security_group_rule" "catalogue_bastion" {
    type = "ingress"
    security_group_id = local.catalogue_sg_id
    source_security_group_id = local.bastion_sg_id # allow from Catalogue SG
    from_port = 22
    protocol = "tcp"
    to_port = 22
}

resource "aws_security_group_rule" "mongodb_catalogue" {
    type = "ingress"
    security_group_id = local.mongodb_sg_id
    source_security_group_id = local.catalogue_sg_id # allow from Catalogue SG
    from_port = 27017
    protocol = "tcp"
    to_port = 27017
}