# Declaring Variables
variable "rdspasswd" {}
variable "rdsusername" {}
# variable "rdsdbname" {}
# Logging into AWS using IAM role
provider "aws" {
  region                  = "eu-central-1"
  profile                 = "sunny"
}
# Using Default VPC
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}
# Creating a Security Group for our DB Instance
resource "aws_security_group" "sg" {
  name        = "db-wizard"
  description = "Allow Database inbound traffic"
  vpc_id      = aws_default_vpc.default.id
  ingress {
    description = "MYSQL/Aurora"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg-for-db"
  }
}
# Creating DB Instance in RDS
resource "aws_db_instance" "default" {
  identifier           = "wpdatabase"
  engine               = "mysql"
  engine_version       = "5.7.21"
  name                 = "mysqldb"
  username             = var.rdsusername
  password             = var.rdspasswd
  allocated_storage    = 20
  max_allocated_storage = 25
  storage_type         = "gp2"
  availability_zone    = "eu-central-1b"
  instance_class       = "db.t2.micro"
  port                 = 3306
  publicly_accessible  = true
  skip_final_snapshot = true
  vpc_security_group_ids = [ "${aws_security_group.sg.id}" ]
  tags = {
    Name = "awsrds"
  }
  depends_on = [
    aws_security_group.sg,
  ]
}
#WORDPRESS_DB_HOST (Database Host)
output "rds_dbhost" {
  value = aws_db_instance.default.endpoint
}
#WORDPRESS_DB_NAME(Database Name)
output "rds_dbname" {
  value = aws_db_instance.default.name
}
# Creating a Local file, which contains details of our Login Details #in Wordpress
resource "local_file" "credentials" {
  content = "WORDPRESS_DB_HOST => ${aws_db_instance.default.endpoint}\n WORDPRESS_DB_USER ${aws_db_instance.default.username}\n WORDPRESS_DB_PASSWORD ${aws_db_instance.default.password}\n WORDPRESS_DB_NAME ${aws_db_instance.default.name}"
  filename = "details"
}