resource "aws_security_group_rule" "ssh_bastion_local" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [local.my_public_ip]
  security_group_id = data.aws_ssm_parameter.bastion_sg_id.value
}
resource "aws_security_group_rule" "mongodb-bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = data.aws_ssm_parameter.bastion_sg_id.value
  security_group_id = data.aws_ssm_parameter.mongodb_sg_id.value
}
resource "aws_security_group_rule" "mongodb-catalogue" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = data.aws_ssm_parameter.catalogue_sg_id.value
  security_group_id = data.aws_ssm_parameter.mongodb_sg_id.value
}
resource "aws_security_group_rule" "mongodb-user" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = data.aws_ssm_parameter.user_sg_id.value
  security_group_id = data.aws_ssm_parameter.mongodb_sg_id.value
}
resource "aws_security_group_rule" "redis-bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = data.aws_ssm_parameter.bastion_sg_id.value
  security_group_id = data.aws_ssm_parameter.redis_sg_id.value
}

resource "aws_security_group_rule" "redis_user" {
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.user_sg_id
  security_group_id = local.redis_sg_id
}

resource "aws_security_group_rule" "redis_cart" {
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.cart_sg_id
  security_group_id = local.redis_sg_id
}

# MySQL
resource "aws_security_group_rule" "mysql_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.bastion_sg_id
  security_group_id = local.mysql_sg_id
}

resource "aws_security_group_rule" "mysql_shipping" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.shipping_sg_id
  security_group_id = local.mysql_sg_id
}

# RabbitMQ
resource "aws_security_group_rule" "rabbitmq_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.bastion_sg_id
  security_group_id = local.rabbitmq_sg_id
}

resource "aws_security_group_rule" "rabbitmq_payment" {
  type              = "ingress"
  from_port         = 5672
  to_port           = 5672
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.payment_sg_id
  security_group_id = local.rabbitmq_sg_id
}


#Backend-alb accepting connection from bastion

resource "aws_security_group_rule" "Backend-alb_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.bastion_sg_id
  security_group_id = local.backend-alb_sg_id
}
#Catalogue accepting connection from bastion
resource "aws_security_group_rule" "Catalogue_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.bastion_sg_id
  security_group_id = local.catalogue_sg_id
}
#Catalogue accepting connection from backend-alb
resource "aws_security_group_rule" "Catalogue_backend-alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.backend-alb_sg_id
  security_group_id = local.catalogue_sg_id
}
resource "aws_security_group_rule" "frontend-alb_user" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  # Where traffic is coming from
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = local.frontend-alb_sg_id
}



