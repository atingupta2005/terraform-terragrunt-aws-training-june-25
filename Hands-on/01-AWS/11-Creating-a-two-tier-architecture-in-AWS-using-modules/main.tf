# --- root/main.tf ---

module "networking" {
  source        = "./networking"
  vpc_cidr      = "10.0.0.0/16"
  access_ip     = var.access_ip
  public_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_cidrs = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}

module "compute" {
  source         = "./compute"
  public_sg      = module.networking.public_sg
  private_sg     = module.networking.private_sg
  private_subnet = module.networking.private_subnet
  public_subnet  = module.networking.public_subnet
  elb            = module.loadbalancing.elb
  alb_tg         = module.loadbalancing.alb_tg
  key_name       = "project"
}

module "loadbalancing" {
  source         = "./loadbalancing"
  public_subnet = module.networking.public_subnet
  vpc_id         = module.networking.vpc_id
  web_sg         = module.networking.web_sg
  database_asg   = module.compute.database_asg
}
