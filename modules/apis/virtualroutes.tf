resource "null_resource" "virtualroute-ingress" {

  provisioner "local-exec" {
    command = "kubectl apply -f  ${path.module}/virtualroute-crd/"
  }
   depends_on = [kubernetes_service.weather-service, kubernetes_service.echo-service, kubernetes_service.swapi-service]
}

/** NSM
nginx-meshctl deploy --registry-server docker-registry.nginx.com/nsm
**/
resource "null_resource" "deploy_nsm" {

  provisioner "local-exec" {
    command = "/Users/yacobucci/dev/nginx-plus-kic-nsm-terraform/nginx-meshctl deploy --disable-auto-inject --enabled-namespaces=\"bookinfo,microservice-namespace\" --mtls-mode strict --registry-server docker-registry.nginx.com/nsm --image-tag 1.0.1 --deploy-grafana=false --prometheus-address prometheus-service.monitoring:8080"
   #command = "nginx-meshctl deploy --enabled-namespaces=\"bookinfo,microservice-namespace\" --mtls-mode strict --registry-server docker-registry.nginx.com/nsm --image-tag 1.0.0 --deploy-grafana false"
  }
  depends_on = [kubernetes_namespace.microservice-namespace]
}

