variable "project_name" {
    default = "roboshop"
}

variable "environment" {
    default = "dev"
}

variable "sg_names" {
    default = [
        #databases
        "mongodb", "redis", "rabbitmq", "mysql",
        #backend
        "catalogue", "cart", "user", "payment", "shipping",
        #frontend
        "frontend",
        #bastion
        "bastion",
        #frontend alb
        "frontend-alb",
        #backend alb
        "backend-alb"
    ]
}

variable "zone_id" {
  default = "Z1003128U2OCSI7JICC9"
}

variable "domain_name" {
  default = "srini.store"
}