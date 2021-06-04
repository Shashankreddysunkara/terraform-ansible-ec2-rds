# Initializing Module
module "rds" {
  source = "./rds"
  rdsusername = var.rdsusername
  rdspasswd = var.rdspasswd
  # rdsdbname = var.rdsdbname
}