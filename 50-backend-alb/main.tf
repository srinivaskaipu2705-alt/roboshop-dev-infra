resource "aws_alb" "backend_alb" {
  name               = "${local.common_name_suffix}-backend-alb" # roboshop-dev-backend-alb
  internal           = true
  load_balancer_type = "application"
  security_groups    = [local.backend_alb_sg_id]
  #subnets should be private subnets as this is internal ALB and we don't want to expose it to the internet
  subnets            = local.private_subnet_ids
  
  enable_deletion_protection = false # we can enable this in production environment to prevent accidental deletion of ALB


  tags = merge(
    local.common_tags,
    {
      Name = "${local.common_name_suffix}-backend-alb" # roboshop-dev-backend-alb
    }
  )
}

# backend alb listening on port 80
resource "aws_alb_listener" "backend_alb_listener" {
  load_balancer_arn = aws_alb.backend_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Hi , I am from backend ALB HTTP listener"
      status_code  = "200"
    }
  }
}

# creating a record in route53 to point to our backend ALB
resource "aws_route53_record" "backend_alb" {
  zone_id = var.zone_id
  name = "*.backend-alb-${var.environment}.${var.domain_name}" # *.backend-alb-{environment}.roboshop.com
  type = "A"

  alias {
    # this are ALB details,not our domain details, we are pointing our domain to ALB DNS name and zone id
    name = aws_lb.backend_alb.dns_name # ALB DNS name
    zone_id = aws_lb.backend_alb.zone_id
    evaluate_target_health = true
  }
}