locals {
  lb_dns_name = var.enable_l7_load_balancing ? module.ingress[0].alb_dns_name : data.kubernetes_service.ambassador[0].status[0].load_balancer[0].ingress[0].hostname
}

data "kubernetes_service" "ambassador" {
  depends_on = [module.helm]
  count      = var.enable_l7_load_balancing ? 0 : 1

  metadata {
    name      = var.release_name
    namespace = var.chart_namespace
  }
}
