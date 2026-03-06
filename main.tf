terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.5.0"
    }
  }
}

provider "docker" {}

resource "docker_network" "app_network" {
  name = "application_net"
  driver = "bridge"
}

resource "docker_image" "nginx" {
  name         = var.image_name
  keep_locally = true
}

resource "docker_container" "nginx" {
  name  = var.container_name
  image = docker_image.nginx.image_id
  ports {
    internal = var.internal_port
    external = var.external_port
  }
  networks_advanced {
    name = docker_network.app_network.name
  }
  provisioner "local-exec" {
    command = "curl -s http://localhost:${var.external_port} | grep -q 'Welcome'"
  }
}

resource "docker_image" "client" {
  name = var.image_curl
  keep_locally = true
}

resource "docker_container" "client" {
  //count = var.client-count
  //name  = "${var.container_curl}-${count.index}"

  for_each = toset(var.client-names)
  name = "server-${each.key}"
  
  image = docker_image.client.image_id
  depends_on = [ docker_container.nginx ]

  networks_advanced {
    name = docker_network.app_network.name
  }
    command = [
    "sh", "-c",
    "curl -s http://${var.container_name}:${var.internal_port} && sleep 3500"
  ]
}