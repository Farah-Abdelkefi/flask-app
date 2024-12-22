provider "kubernetes" {
  config_path = "~/.kube/config" # Path to your kubeconfig file
}

resource "kubernetes_manifest" "flask_app_deployment" {
  manifest = yamldecode(file("${path.module}/../k8s/deployment.yaml"))
}

# Deploy the Service resource using kubernetes_manifest
resource "kubernetes_manifest" "flask_app_service" {
  manifest = yamldecode(file("${path.module}/../k8s/service.yaml"))
}