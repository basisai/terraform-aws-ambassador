module "dns" {
  source = "./modules/dns"

  create_dns_records = var.create_dns_records

  lb_dns_name = local.lb_dns_name
  dns_names   = var.dns_names
}
