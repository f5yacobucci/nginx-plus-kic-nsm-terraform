resource "kubernetes_service" "target-service" {
  depends_on = [kubernetes_namespace.microservice-namespace,null_resource.deploy_nsm]
  metadata {
    name      = "target-svc"
    namespace = "microservice-namespace"
  }
  spec {
    selector = {
      app = "target"
    }
    session_affinity = "None"
    port {
      name        = "http"
      port        = 80
      target_port = 80
    }
  }
}

resource "kubernetes_config_map" "target_v1_0_configmap" {
depends_on = [kubernetes_namespace.microservice-namespace,null_resource.deploy_nsm]
  metadata {
    name      = "target-v1-0"
    namespace = "microservice-namespace"
  }
  data = {
    "nginx.conf" = file("${path.module}/target_v1_0_config.conf")
  }
}

resource "kubernetes_service" "target_service_v1" {
  depends_on = [kubernetes_namespace.microservice-namespace,null_resource.deploy_nsm, kubernetes_config_map.target_v1_0_configmap]
  metadata {
    name      = "target-v1-0"
    namespace = "microservice-namespace"
  }

  spec {
    selector = {
      app = "target"
      version = "1.0"
    }
    session_affinity = "None"
    port {
      name        = "http"
      port        = 80
      target_port = 80
    }
  }
}

resource "kubernetes_deployment" "target_api_deployment_v1" {
  depends_on = [kubernetes_namespace.microservice-namespace,null_resource.deploy_nsm, kubernetes_config_map.target_v1_0_configmap]
  metadata {
    name = "target-api-deployment-v1"
    namespace = "microservice-namespace"
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "target"
        version = "1.0"
      }
    }
    template {
      metadata {
        labels = {
          app = "target"
          version = "1.0"
        }
      }
      spec {
          volume {
            name = "nginx-config"
            config_map {
              name = "target-v1-0"
            }
          }
          container {
            image = "nginx"
            name  = "target-v1-0"
          port {
            container_port = 80
            name = "http"
          }
          volume_mount {
            name       = "nginx-config"
            mount_path = "/etc/nginx"
          }
        }
      }
    }
  }
}


