#Alb SECURITY GROUP
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "alb-sg"
  }
}

# Allow HTTP (80) from anywhere
resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb_sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "10.0.0.0/24"

  description = "Allow HTTP traffic to ALB"
}

# Allow HTTPS (443) from anywhere
resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb_sg.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "10.0.0.0/24"

  description = "Allow HTTP traffic to ALBS"

}

# Allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "alb_all_out" {
  security_group_id = aws_security_group.alb_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "10.0.0.0/24"

  description = "Allow outbound traffic from ALB"
}

#Create Alb
resource "aws_lb" "app_alb" {
  name               = "app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets = [
    aws_subnet.subnet1.id,
    aws_subnet.subnet2.id
  ]

  enable_deletion_protection = true
  drop_invalid_header_fields = true

  access_logs {
    bucket  = var.alb_logs_bucket_id
    prefix  = "alb-logs"
    enabled = true
  }

  tags = {
    Name = "app-alb"
  }
}

resource "aws_wafv2_web_acl" "alb_waf" {
  name        = "${var.project_name}-${var.environment}-alb-waf"
  description = "WAF for ALB"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "${var.project_name}-${var.environment}-alb-waf"
    sampled_requests_enabled   = false
  }
}

resource "aws_wafv2_web_acl_association" "alb_waf_assoc" {
  resource_arn = aws_lb.app_alb.arn
  web_acl_arn  = aws_wafv2_web_acl.alb_waf.arn
}

#target group
resource "aws_lb_target_group" "app_tg" {
  name     = "app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# HTTP Listener (80) → Redirect to HTTPS
resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# HTTPS Listener (443) → Forward to target group
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 443
  protocol          = "HTTPS"
  # CKV_AWS_103: Ensure ALB Listener uses secure SSL/TLS protocols (TLS 1.2+)
  ssl_policy      = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn = var.alb_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}


