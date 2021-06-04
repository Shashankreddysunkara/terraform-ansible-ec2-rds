#WORDPRESS_DB_USER (Username)
variable "rdsusername" {
  type = string
  default = "admin"
  description = "Username for database"
}
#WORDPRESS_DB_PASSWORD (Password)
variable "rdspasswd" {
  type = string
  default = "admin12345"
  description = "Password for AWS-RDS MySQL Database"
}
# #WORDPRESS_DB_NAME(Database Name)
# variable "rdsdbname" {
#   type = string
#   default = "mysqldb"
#   description = "Name of AWS-RDS MySQL Database"
# }