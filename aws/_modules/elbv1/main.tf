

# ---------------------------------------------------------------------
# ELBv1
# ---------------------------------------------------------------------
resource "aws_elb" "TerraFailELB" {
  # Drata: Configure [aws_elb.tags] to ensure that organization-wide tagging conventions are followed.
  # Drata: Configure [aws_elb.access_logs.enabled] to ensure that security-relevant events are logged to detect malicious activity
  # Drata: Default network security groups allow broader access than required. Specify [aws_elb.security_groups] to configure more granular access control
  name     = "TerraFailELB"
  subnets  = [aws_subnet.TerraFailELB_subnet.id]
  # Drata: Configure [aws_elb.subnets] to improve infrastructure availability and resilience. Define at least 2 subnets or availability zones on your load balancer to enable zone redundancy
  internal = true

  listener {
    instance_port     = 8000
    instance_protocol = "HTTPS"
    lb_port           = 80
    lb_protocol       = "HTTPS"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}

# ---------------------------------------------------------------------
# Network
# ---------------------------------------------------------------------
resource "aws_security_group" "TerraFailELB_security_group" {
  # Drata: Configure [aws_security_group.tags] to ensure that organization-wide tagging conventions are followed.
  name                   = "TerraFailELB_security_group"
  description            = "Allow TLS inbound traffic"
  vpc_id                 = aws_vpc.TerraFailELB_vpc.id
  revoke_rules_on_delete = false

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  # Drata: Ensure that [aws_security_group.egress.cidr_blocks] is explicitly defined and narrowly scoped to only allow traffic to trusted sources
  }
}

resource "aws_subnet" "TerraFailELB_subnet" {
  vpc_id            = aws_vpc.TerraFailELB_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "TerraFailELB_subnet"
  }
}

resource "aws_vpc" "TerraFailELB_vpc" {
  # Drata: Configure [aws_vpc.tags] to ensure that organization-wide tagging conventions are followed.
  cidr_block = "10.0.0.0/16"
}
