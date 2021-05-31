
variable "weather-api-image" {
  description = "Enter your name of the weather api docker iamge from dockerhub.io"
}
variable "echo-api-image" {
  description = "Enter your name of the weather api docker iamge from dockerhub.io"
}
variable "swapi-image" {}
variable depends_on_nginx_plus {}
variable nginx_service_mesh_version {}
variable nginx_service_mesh_registry_name {}
variable  host {}
variable  token  {}
variable  cluster_ca_certificate {}
variable load_config_file  {}
variable  client_key  {}
variable client_certificate {}
variable tls_crt {}
variable tls_key {}
variable image {}