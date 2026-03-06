variable "container_name" {
  type        = string
  default     = "nginx-terraform"
  description = "container name"
}

variable "image_name" {
  type        = string
  default     = "nginx:latest"
  description = "docker image name"
}

variable "image_curl" {
  type = string
  default = "appropriate/curl"
}

variable "container_curl" {
  type = string
  default = "client"
}

variable "external_port" {
  type    = number
  default = 8082
}

variable "internal_port" {
  type    = number
  default = 80
}

variable "client-count" {
  type = number
  default = 3
}

variable "client-names" {
  type = list(string)
  default = [ "fraise", "kiwi", "banane" ]
}

variable "machines" {
  type = list(object({
    name = string
    vcpu = number
    disk_size = number
    region = string
  }))
  description = "Liste des machines à déployer"
  validation {
    condition = alltrue([
        for m in var.machines:
        m.vcpu >= 2 && m.vcpu <= 64
    ])
    error_message = "Chaque machine doit avoir entre 2 et 64 vCPU."
  }

  validation {
    condition = alltrue([
      for m in var.machines :
      m.disk_size >= 20
    ])
    error_message = "Chaque machine doit avoir un disque d'au moins 20 Go."
  }

  validation {
    condition = alltrue([
      for m in var.machines :
      contains(["eu-west-1", "us-east-1", "ap-southeast-1"], m.region)
    ])
    error_message = "La région doit être l'une des suivantes : eu-west-1, us-east-1, ap-southeast-1."
  }
  default = [
    {
        name: "mazchnie1"
        vcpu = 60
        disk_size = 20
        region = "eu-west-1"
    }
  ]
}
