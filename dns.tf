module "dns" {
  source = "./modules/dns"

  lb_dns_name = local.lb_dns_name
  dns_names   = var.dns_names
}
