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
    name = "${var.project}-${var.environment}-catalogue"
    source_instance_id = aws_instance.catalogue.id
    depends_on = [aws_ec2_instance_state.catalogue]
}
