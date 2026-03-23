resource "aws_lb" "test" {
  name               = "${var.project}-${var.environment}-frontend"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [local.frontend-alb_sg_id]
  subnets            = local.Public_subnet_ids

  enable_deletion_protection = false

  
  tags = merge (
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}"
        }
  )
}
resource "aws_lb_listener" "frontend-alb" {
  load_balancer_arn = aws_lb.test.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = local.frotnend-alb_certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hi, This is for Frontend ALB </h1>"
      status_code  = "200"
    }
  }
}

resource "aws_route53_record" "Robo" {
  zone_id = var.zone_id
  name    = "*.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.test.dns_name
    zone_id                = aws_lb.test.zone_id
    evaluate_target_health = true
  }
  allow_overwrite = true
}