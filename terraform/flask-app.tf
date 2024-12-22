
provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Namespace for the Spring Boot application
resource "kubernetes_namespace" "flask_app" {
  metadata {
    name = "flask-app"
  }
}

resource "kubernetes_manifest" "argocd_application" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "flask-app"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL = "https://github.com/Farah-Abdelkefi/flask-app.git"
        path    = "k8s"
        targetRevision = "HEAD"
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = kubernetes_namespace.flask_app.metadata[0].name
      }
      syncPolicy = {
        automated = {
          prune = true
          selfHeal = true
        }
      }
    }
  }
}