# This file defines the security group rules for the Roboshop application components.

### MongoDB SG rules ###
#to allow MongoDB service to connect to bastion
resource "aws_security_group_rule" "mongodb_bastion" {
    type = "ingress"
    security_group_id = local.mongodb_sg_id
    source_security_group_id = local.bastion_sg_id # allow from MongoDB SG
    from_port = 22
    protocol = "tcp"
    to_port = 22
}

#to allow catalogue service to connect to MongoDB
resource "aws_security_group_rule" "mongodb_catalogue" {
    type = "ingress"
    security_group_id = local.mongodb_sg_id
    source_security_group_id = local.catalogue_sg_id # allow from Catalogue SG
    from_port = 27017
    protocol = "tcp"
    to_port = 27017
}

#to allow user service to connect to MongoDB
resource "aws_security_group_rule" "mongodb_user" {
    type = "ingress"
    security_group_id = local.mongodb_sg_id
    source_security_group_id = local.user_sg_id # allow from User SG
    from_port = 27017
    protocol = "tcp"
    to_port = 27017
}

### redis SG rules ###
#to allow redis service to connect to bastion
resource "aws_security_group_rule" "redis_bastion" {
    type = "ingress"
    security_group_id = local.redis_sg_id
    source_security_group_id = local.bastion_sg_id # allow from Redis SG
    from_port = 22
    protocol = "tcp"
    to_port = 22
}

#to allow redis service to connect to user
resource "aws_security_group_rule" "redis_user" {
    type = "ingress"
    security_group_id = local.redis_sg_id
    source_security_group_id = local.user_sg_id # allow from User SG
    from_port = 6379
    protocol = "tcp"
    to_port = 6379
}
#to allow redis service to connect to cart
resource "aws_security_group_rule" "redis_cart" {
    type = "ingress"
    security_group_id = local.redis_sg_id
    source_security_group_id = local.cart_sg_id # allow from Cart SG
    from_port = 6379
    protocol = "tcp"
    to_port = 6379
}

### mysql SG rules ###
#to allow mysql service to connect to bastion
resource "aws_security_group_rule" "mysql_bastion" {
    type = "ingress"
    security_group_id = local.mysql_sg_id
    source_security_group_id = local.bastion_sg_id # allow from MySQL SG
    from_port = 22
    protocol = "tcp"
    to_port = 22
}

#to allow mysql service to connect to shipping
resource "aws_security_group_rule" "mysql_shipping" {
    type = "ingress"
    security_group_id = local.mysql_sg_id
    source_security_group_id = local.shipping_sg_id # allow from Shipping SG
    from_port = 3306
    protocol = "tcp"
    to_port = 3306
}

### rabbitmq SG rules ###
#to allow rabbitmq service to connect to bastion
resource "aws_security_group_rule" "rabbitmq_bastion" {
    type = "ingress"
    security_group_id = local.rabbitmq_sg_id
    source_security_group_id = local.bastion_sg_id # allow from RabbitMQ SG
    from_port = 22
    protocol = "tcp"
    to_port = 22
}

#to allow rabbitmq service to connect to payment
resource "aws_security_group_rule" "rabbitmq_payment" {
    type = "ingress"
    security_group_id = local.rabbitmq_sg_id
    source_security_group_id = local.payment_sg_id # allow from Payment SG
    from_port = 5672
    protocol = "tcp"
    to_port = 5672
}

#### catalogue SG rules ####
#catalogue service to connect to bastion for login and check
resource "aws_security_group_rule" "catalogue_bastion" {
    type = "ingress"
    security_group_id = local.catalogue_sg_id
    source_security_group_id = local.bastion_sg_id # allow from Catalogue SG
    from_port = 22
    protocol = "tcp"
    to_port = 22
}

#catalogue service to connect to backend ALB
resource "aws_security_group_rule" "catalogue_backend_alb" {
    type = "ingress"
    security_group_id = local.catalogue_sg_id
    source_security_group_id = local.backend_alb_sg_id # allow from Backend ALB SG
    from_port = 8080
    protocol = "tcp"
    to_port = 8080
}

### user SG rules ###
#user service to connect to bastion for login and check
resource "aws_security_group_rule" "user_bastion" {
    type = "ingress"
    security_group_id = local.user_sg_id
    source_security_group_id = local.bastion_sg_id # allow from Bastion SG
    from_port = 22
    protocol = "tcp"
    to_port = 22
}

#user service to connect to backend ALB
resource "aws_security_group_rule" "user_backend_alb" {
    type = "ingress"
    security_group_id = local.user_sg_id
    source_security_group_id = local.backend_alb_sg_id # allow from Backend ALB SG
    from_port = 8080
    protocol = "tcp"
    to_port = 8080
}

### cart SG rules ###
#cart service to connect to bastion for login and check
resource "aws_security_group_rule" "cart_bastion" {
    type = "ingress"
    security_group_id = local.cart_sg_id
    source_security_group_id = local.bastion_sg_id # allow from Bastion SG
    from_port = 22
    protocol = "tcp"
    to_port = 22
}

#cart service to connect to backend ALB
resource "aws_security_group_rule" "cart_backend_alb" {
    type = "ingress"
    security_group_id = local.cart_sg_id
    source_security_group_id = local.backend_alb_sg_id # allow from Backend ALB SG
    from_port = 8080
    protocol = "tcp"
    to_port = 8080
}

### shipping SG rules ###
#shipping service to connect to bastion for login and check
resource "aws_security_group_rule" "shipping_bastion" {
    type = "ingress"
    security_group_id = local.shipping_sg_id
    source_security_group_id = local.bastion_sg_id # allow from Bastion SG
    from_port = 22
    protocol = "tcp"
    to_port = 22
}

#shipping service to connect to backend ALB
resource "aws_security_group_rule" "shipping_backend_alb" {
    type = "ingress"
    security_group_id = local.shipping_sg_id
    source_security_group_id = local.backend_alb_sg_id # allow from Backend ALB SG
    from_port = 8080
    protocol = "tcp"
    to_port = 8080
}

### payment SG rules ###
#payment service to connect to bastion for login and check
resource "aws_security_group_rule" "payment_bastion" {
    type = "ingress"
    security_group_id = local.payment_sg_id
    source_security_group_id = local.bastion_sg_id # allow from Bastion SG
    from_port = 22
    protocol = "tcp"
    to_port = 22
}

#payment service to connect to backend ALB
resource "aws_security_group_rule" "payment_backend_alb" {
    type = "ingress"
    security_group_id = local.payment_sg_id
    source_security_group_id = local.backend_alb_sg_id # allow from Backend ALB SG
    from_port = 8080
    protocol = "tcp"
    to_port = 8080
}

###backend ALB SG rules ###
#to allow backend ALB to connect to bastion service
resource "aws_security_group_rule" "backend_alb_bastion" {
    type = "ingress"
    security_group_id = local.backend_alb_sg_id
    source_security_group_id = local.bastion_sg_id # bastion SG ID
    from_port = 80
    protocol = "tcp"
    to_port = 80
}

#to allow backend ALB to connect to frontend ALB
resource "aws_security_group_rule" "backend_alb_frontend" {
    type = "ingress"
    security_group_id = local.backend_alb_sg_id
    source_security_group_id = local.frontend_alb_sg_id # allow from Frontend ALB SG
    from_port = 80
    protocol = "tcp"
    to_port = 80
}

# to allow backend ALB to connect to cart service
resource "aws_security_group_rule" "backend_alb_cart" {
    type = "ingress"
    security_group_id = local.backend_alb_sg_id
    source_security_group_id = local.cart_sg_id # allow from Cart SG
    from_port = 80
    protocol = "tcp"
    to_port = 80
}

# to allow backend ALB to connect to shipping service
resource "aws_security_group_rule" "backend_alb_shipping" {
    type = "ingress"
    security_group_id = local.backend_alb_sg_id
    source_security_group_id = local.shipping_sg_id # allow from Shipping SG
    from_port = 80
    protocol = "tcp"
    to_port = 80
}

# to allow backend ALB to connect to payment service
resource "aws_security_group_rule" "backend_alb_payment" {
    type = "ingress"
    security_group_id = local.backend_alb_sg_id
    source_security_group_id = local.payment_sg_id # allow from Payment SG
    from_port = 80
    protocol = "tcp"
    to_port = 80
}

### frontend ALB SG rules ###
#to allow frontend ALB to connect to bastion service
resource "aws_security_group_rule" "frontend_bastion" {
    type = "ingress"
    security_group_id = local.frontend_sg_id
    source_security_group_id = local.bastion_sg_id # allow from Bastion SG
    from_port = 80
    protocol = "tcp"
    to_port = 80
}

#to allow frontend to connect to frontend ALB
resource "aws_security_group_rule" "frontend_frontend_alb" {
    type = "ingress"
    security_group_id = local.frontend_sg_id
    source_security_group_id = local.frontend_alb_sg_id # allow from Frontend ALB SG
    from_port = 80
    protocol = "tcp"
    to_port = 80
}

#to allow frontend ALB to connect publicly on port 443
resource "aws_security_group_rule" "frontend_alb_public" {
    type = "ingress"
    security_group_id = local.frontend_alb_sg_id
    cidr_blocks = ["0.0.0.0/0"] # allow from anywhere, can be restricted to specific IPs or CIDR blocks
    from_port = 443
    protocol = "tcp"
    to_port = 443
}

### bastion SG rules ###
#to allow bastion to connect to anywhere on port 22
resource "aws_security_group_rule" "bastion_laptop" {
    type = "ingress"
    security_group_id = local.bastion_sg_id
    cidr_blocks = ["0.0.0.0/0"] # allow from anywhere, can be restricted to specific IPs or CIDR blocks
    from_port = 22
    protocol = "tcp"
    to_port = 22
}

#this is the mistake I did, one component should not connect to another component directly, it should connect through ALB.
#catalogue service to connect to cart service  (but cart cannot connect to catalogue service directly, it can connect only through backend ALB)
# resource "aws_security_group_rule" "catalogue_cart" {
#     type = "ingress"
#     security_group_id = local.catalogue_sg_id
#     source_security_group_id = local.cart_sg_id # allow from Cart SG
#     from_port = 8080
#     protocol = "tcp"
#     to_port = 8080
# }

#cart service to connect to shipping service
# resource "aws_security_group_rule" "cart_shipping" {
#     type = "ingress"
#     security_group_id = local.cart_sg_id
#     source_security_group_id = local.shipping_sg_id # allow from Shipping SG
#     from_port = 8080
#     protocol = "tcp"
#     to_port = 8080
# }

#user service to connect to payment service
# resource "aws_security_group_rule" "user_payment" {
#     type = "ingress"
#     security_group_id = local.user_sg_id
#     source_security_group_id = local.payment_sg_id # allow from Payment SG
#     from_port = 8080
#     protocol = "tcp"
#     to_port = 8080
# }

#cart service to connect to payment service
# resource "aws_security_group_rule" "cart_payment" {
#     type = "ingress"
#     security_group_id = local.cart_sg_id
#     source_security_group_id = local.payment_sg_id # allow from Payment SG
#     from_port = 8080
#     protocol = "tcp"
#     to_port = 8080  
# }
