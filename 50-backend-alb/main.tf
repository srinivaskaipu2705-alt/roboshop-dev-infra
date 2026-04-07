resource "aws_alb" "backend_alb" {
  name               = "${local.common_name_suffix}-backend-alb" # roboshop-dev-backend-alb
  internal           = true
  load_balancer_type = "application"
  security_groups    = [local.backend_alb_sg_id]
  subnets            = local.private_subnet_ids

  # enable_deletion_protection = true # to prevent accidental deletion of ALB

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