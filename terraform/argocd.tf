provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "kubernetes_namespace" "argocd_app" {
  metadata {
    name = "argocd-app"
  }
}

resource "helm_release" "argocd_app" {
  name       = "argocd-app"
  namespace  = kubernetes_namespace.argocd_app.metadata[0].name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "4.5.4" 

  depends_on = [kubernetes_namespace.argocd_app]
}

resource "kubernetes_manifest" "argocd_metrics" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "argocd-metrics"
      namespace = "argocd-app"  # Updated namespace to argocd-app
      labels = {
        release = "prometheus"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          "app.kubernetes.io/name" = "argocd-metrics"
        }
      }
      namespaceSelector = {
        any = true
      }
      endpoints = [
        {
          port = "metrics"
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "argocd_server_metrics" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "argocd-server-metrics"
      namespace = "argocd-app"  # Updated namespace to argocd-app
      labels = {
        release = "prometheus"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          "app.kubernetes.io/name" = "argocd-server-metrics"
        }
      }
      namespaceSelector = {
        any = true
      }
      endpoints = [
        {
          port = "metrics"
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "argocd_repo_server_metrics" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "argocd-repo-server-metrics"
      namespace = "argocd-app"  # Updated namespace to argocd-app
      labels = {
        release = "prometheus"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          "app.kubernetes.io/name" = "argocd-repo-server"
        }
      }
      namespaceSelector = {
        any = true
      }
      endpoints = [
        {
          port = "metrics"
        }
      ]
    }
  }
}