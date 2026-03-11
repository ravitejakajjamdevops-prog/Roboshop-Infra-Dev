variable "project" {
    type = string
    default = "Roboshop"
}
variable "environment" {
    type = string
    default = "dev"
}
variable "sg_names"{
    type = list
    default = [
        #Databases
        "mongodb","redis","mysql","rabbitmq",
        #Backend
        "catalogue","user","cart","shipping","payment",
        # Bakend ALB
        "backend-alb",
        #Frontend
        "frontend",
        #Frontend ALB
        "frontend-alb",
        #Bastion
        "bastion"
    ] 
}