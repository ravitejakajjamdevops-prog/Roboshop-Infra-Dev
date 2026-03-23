resource "aws_instance" "catalogue"{
    ami = data.aws_ami.RetreiveInstanceID.id
    instance_type = "t3.micro"
    subnet_id = local.Private_subnet_id
    vpc_security_group_ids = [local.catalogue_sg_id]
    
    tags = merge (
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-catalogue"
        }
        )    
}
resource "terraform_data" "bootstrap_catalogue"{

    triggers_replace = [aws_instance.catalogue.id]

 connection {

    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
    host = aws_instance.catalogue.private_ip
 }

 provisioner "file" {
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
 }
 
 provisioner "remote-exec"{
    inline= [
        "chmod +x /tmp/bootstrap.sh",
        "sudo sh /tmp/bootstrap.sh catalogue"
    ]
 }
}
resource "aws_ec2_instance_state" "catalogue" {
    instance_id = aws_instance.catalogue.id
    state = "stopped"
    depends_on = [terraform_data.bootstrap_catalogue]
}
resource "aws_ami_from_instance" "amiCatalogue"{
    name = "${var.project}-${var.environment}-catalogue-${var.app_version}-${aws_instance.catalogue.id}"
    source_instance_id = aws_instance.catalogue.id
    depends_on = [aws_ec2_instance_state.catalogue]
}
resource "aws_lb_target_group" "main" {
  name     = "${var.project}-${var.environment}-catalogue"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  deregistration_delay = 60

  health_check {
    healthy_threshold = 2
    interval = 10
    matcher = "200-299"
    path = "/health"
    port = 8080
    protocol = "HTTP"
    timeout = 2
    unhealthy_threshold = 2
  }
}
resource "aws_launch_template" "main" {
  name = "${var.project}-${var.environment}-catalogue"

  update_default_version = true
  
  image_id = aws_ami_from_instance.amiCatalogue.id

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t3.micro"

  vpc_security_group_ids = [local.catalogue_sg_id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.project}-${var.environment}-catalogue"
    }
  }
}

resource "aws_autoscaling_group" "main" {
  name                      = "${var.project}-${var.environment}-catalogue"
  max_size                  = 5
  min_size                  = 1
  health_check_grace_period = 120
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }
  vpc_zone_identifier       = [local.Private_subnet_id]

  target_group_arns = [aws_lb_target_group.main.arn]

  instance_refresh{

    strategy = "Rolling"
    preferences {
        min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }

  tag {
    key                 = "Name"
    value               = "${var.project}-${var.environment}-catalogue"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }
}

resource "aws_autoscaling_policy" "main" {
  autoscaling_group_name = aws_autoscaling_group.main.name
  name                   = "${var.project}-${var.environment}-catalogue"
  policy_type            = "TargetTrackingScaling"
  estimated_instance_warmup = 120

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70.0
  }
}
resource "aws_lb_listener_rule" "main" {
  listener_arn = local.backend-alb_listener_arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  condition {
    host_header {
      values = ["catalogue.backend-alb.${var.domain_name}"]
    }
  }
}

resource "terraform_data" "main" {
  triggers_replace = [
    aws_instance.catalogue.id
  ]
  depends_on = [aws_autoscaling_policy.main]
  
  # it executes in bastion
  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.catalogue.id} "
  }
}