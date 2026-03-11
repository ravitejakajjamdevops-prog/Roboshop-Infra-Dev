resource "aws_instance" "bastionEC2"{
    ami = data.aws_ami.RetreiveInstanceID.id
    instance_type = "t3.micro"
    subnet_id = local.Public_subnet_ids
    vpc_security_group_ids = [local.bastion_sg_id]
    iam_instance_profile = aws_iam_instance_profile.bastion_profile.name 
    tags = merge (
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-bastion"
        }
        )    
}
resource "aws_iam_role" "bastion_role" {
    name = "RoboshopDevBastionRole"
    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "RoboshopDevBastionRole"
  }
}

# Attach permission to role

resource "aws_iam_policy_attachment" "Robo-attach" {
  
  name = "Bastiiian"
  roles      = [aws_iam_role.bastion_role.name]
 
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Create the IAM Instance Profile resource

resource "aws_iam_instance_profile" "bastion_profile" {
  name = "${var.project}-${var.environment}-bastion1"
  role = aws_iam_role.bastion_role.name
}
