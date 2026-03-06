output "nginx_container_id" {
  value       = docker_container.nginx.id
  description = "afficher l'id du conteneur nginx"
}

# output "curl_container_id" {
#   value = docker_container.client.id
#   description = "afficher l'id du conteneur client"
# }