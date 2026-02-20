
# Security group for the Application Load Balancer
resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-alb-sg"
  vpc_id      = var.vpc_id
  description = "Security group for the Application Load Balancer"
  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}

# Allow HTTP traffic to the ALB
resource "aws_vpc_security_group_ingress_rule" "alb_http_ingress" {
  security_group_id = aws_security_group.alb_sg.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "${var.project_name}-alb-http-ingress"
  }
}

# Allow HTTPS traffic to the ALB
resource "aws_vpc_security_group_ingress_rule" "alb_https_ingress" {
  security_group_id = aws_security_group.alb_sg.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "${var.project_name}-alb-https-ingress"
  }
}

# Allow all outbound traffic from the ALB
resource "aws_vpc_security_group_egress_rule" "alb_egress" {
  security_group_id = aws_security_group.alb_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "${var.project_name}-alb-egress"
  }
}

# Security Group for the Bastion Host
resource "aws_security_group" "bastion_sg" {
  name        = "${var.project_name}-bastion-sg"
  vpc_id      = var.vpc_id
  description = "Security group for the Bastion Host"

  tags = {
    Name = "${var.project_name}-bastion-sg"
  }
}

# Allow SSH access to the Bastion Host from own IP
resource "aws_vpc_security_group_ingress_rule" "bastion_ssh_ingress" {
  security_group_id = aws_security_group.bastion_sg.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "${var.project_name}-bastion-ssh-ingress"
  }
}

# Allow all outbound traffic from the Bastion Host
resource "aws_vpc_security_group_egress_rule" "bastion_egress" {
  security_group_id = aws_security_group.bastion_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "${var.project_name}-bastion-egress"
  }
}

# Security Group for the EC2 Instances
resource "aws_security_group" "ec2_sg" {
  name        = "${var.project_name}-ec2-sg"
  vpc_id      = var.vpc_id
  description = "Security group for the EC2 Instances"

  tags = {
    Name = "${var.project_name}-ec2-sg"
  }
}

# Allow HTTP traffic from the ALB to the EC2 Instances
resource "aws_vpc_security_group_ingress_rule" "ec2_http_ingress" {
  security_group_id            = aws_security_group.ec2_sg.id
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
  referenced_security_group_id = aws_security_group.alb_sg.id

  tags = {
    Name = "${var.project_name}-ec2-http-ingress"
  }
}

# Allow all outbound traffic from the EC2 Instances
resource "aws_vpc_security_group_egress_rule" "ec2_egress" {
  security_group_id = aws_security_group.ec2_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "${var.project_name}-ec2-egress"
  }
}

# Security Group for the RDS Instance
resource "aws_security_group" "rds_sg" {
  name        = "${var.project_name}-rds-sg"
  vpc_id      = var.vpc_id
  description = "Security group for the RDS Instance"

  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}

# Allow PostgreSQL traffic from the EC2 Instances to the RDS Instance
resource "aws_vpc_security_group_ingress_rule" "rds_postgres_ingress" {
  security_group_id            = aws_security_group.rds_sg.id
  ip_protocol                  = "tcp"
  from_port                    = 5432
  to_port                      = 5432
  referenced_security_group_id = aws_security_group.ec2_sg.id

  tags = {
    Name = "${var.project_name}-rds-postgres-ingress"
  }
}

# Allow all outbound traffic from the RDS Instance
resource "aws_vpc_security_group_egress_rule" "rds_egress" {
  security_group_id = aws_security_group.rds_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "${var.project_name}-rds-egress"
  }
}



