variable "server_port" {
    description = "Port the web server will listen on"
    type = number
    default = 8080
}

variable "instance_count" {
    description = "Number of web server instances"
    type = number
    default = 3
}