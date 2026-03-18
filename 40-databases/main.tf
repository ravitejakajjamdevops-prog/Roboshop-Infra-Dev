resource "aws_instance" "MongoDBEC2"{
    ami = data.aws_ami.RetreiveInstanceID.id
    instance_type = "t3.micro"
    subnet_id = local.database_subnet_ids
    vpc_security_group_ids = [local.mongodb_sg_id]
    
    tags = merge (
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-mongodb"
        }
        )    
}
resource "terraform_data" "bootstrap_mongodb"{

    triggers_replace = [aws_instance.MongoDBEC2.id]

 connection {

    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
    host = aws_instance.MongoDBEC2.private_ip
 }

 provisioner "file" {
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
 }
 
 provisioner "remote-exec"{
    inline= [
        "chmod +x /tmp/bootstrap.sh",
        "sudo sh /tmp/bootstrap.sh mongodb"
    ]
 }
}
# Redis
resource "aws_instance" "RedisEC2"{
    ami = data.aws_ami.RetreiveInstanceID.id
    instance_type = "t3.micro"
    subnet_id = local.database_subnet_ids
    vpc_security_group_ids = [local.redis_sg_id]
    
    tags = merge (
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-redis"
        }
        )    
}
resource "terraform_data" "bootstrap_redis"{

    triggers_replace = [aws_instance.RedisEC2.id]

 connection {

    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
    host = aws_instance.RedisEC2.private_ip
 }

 provisioner "file" {
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
 }
 
 provisioner "remote-exec"{
    inline= [
        "chmod +x /tmp/bootstrap.sh",
        "sudo sh /tmp/bootstrap.sh redis"
    ]
 }
}

