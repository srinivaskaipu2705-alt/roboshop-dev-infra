resource "aws_lb" "frontend_alb" {
  name               = "${local.common_name_suffix}-frontend-alb" # roboshop-dev-frontend-alb
  internal           = false
  load_balancer_type = "application"
  security_groups    = [local.frontend_alb_sg_id]
  #subnets should be private subnets as this is internal ALB and we don't want to expose it to the internet
  subnets            = local.public_subnet_ids
  
  enable_deletion_protection = false # we can enable this in production environment to prevent accidental deletion of ALB


  tags = merge(
    local.common_tags,
    {
      Name = "${local.common_name_suffix}-frontend-alb" # roboshop-dev-frontend-alb
    }
  )
}

# frontend alb listening on port 443
resource "aws_lb_listener" "frontend_alb" {
  load_balancer_arn = aws_lb.frontend_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-3-2021-06"
  certificate_arn   = local.frontend_alb_certificate_arn

  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/html"
      message_body = "<html><body><h1>Hi , I am from frontend ALB HTTPS listener</h1></body></html>"
      status_code  = "200"
    }
  }
}

# creating a record in route53 to point to our frontend ALB
resource "aws_route53_record" "frontend_alb" {
  zone_id = var.zone_id
  name = "roboshop-${var.environment}.${var.domain_name}" # roboshop-dev.srini.store
  type = "A"
  allow_overwrite = true

  alias {
    # this are ALB details,not our domain details, we are pointing our domain to ALB DNS name and zone id
    name = aws_lb.frontend_alb.dns_name # ALB DNS name
    zone_id = aws_lb.frontend_alb.zone_id
    evaluate_target_health = true
  }
}