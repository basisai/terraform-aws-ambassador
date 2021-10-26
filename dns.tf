module "dns" {
  source = "./modules/dns"

  create_dns_records = var.create_dns_records

  lb_dns_name = local.lb_dns_name
  dns_names   = var.dns_names

  enable_l7_load_balancing = var.enable_l7_load_balancing
  internet_facing          = var.internet_facing
}
