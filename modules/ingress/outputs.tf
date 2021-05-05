output "alb_dns_name" {
  description = "DNS name of the Ingress Load Balancer"
  value       = kubernetes_ingress.ambassador.status[0].load_balancer[0].ingress[0].hostname
}
