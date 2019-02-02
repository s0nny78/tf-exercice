provider "aws" {
  region = "${var.region}"
}

resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc-cidr}"
  enable_dns_hostnames = true
}

resource "aws_subnet" "public-subnet1" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.subnet-cidr-public1}"
  availability_zone = "${var.region}a"
}

resource "aws_subnet" "public-subnet2" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.subnet-cidr-public2}"
  availability_zone = "${var.region}b"
}

resource "aws_route_table" "public-subnet-route-table1" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route_table" "public-subnet-route-table2" {
  vpc_id = "${aws_vpc.vpc.id}"
}


resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route" "public-subnet-route1" {
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = "${aws_internet_gateway.igw.id}"
  route_table_id          = "${aws_route_table.public-subnet-route-table1.id}"
}

resource "aws_route" "public-subnet-route2" {
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = "${aws_internet_gateway.igw.id}"
  route_table_id          = "${aws_route_table.public-subnet-route-table2.id}"
}

resource "aws_route_table_association" "public-subnet-route-table-association1" {
  subnet_id      = "${aws_subnet.public-subnet1.id}"
  route_table_id = "${aws_route_table.public-subnet-route-table1.id}"
}

resource "aws_route_table_association" "public-subnet-route-table-association2" {
  subnet_id      = "${aws_subnet.public-subnet2.id}"
  route_table_id = "${aws_route_table.public-subnet-route-table2.id}"
}

resource "aws_key_pair" "web" {
  public_key = "${file(pathexpand(var.public_key))}"
}

resource "aws_instance" "web-instance1" {
  ami           = "${var.ami}"
  availability_zone = "${var.region}a"
  instance_type = "t2.small"
  vpc_security_group_ids      = [ "${aws_security_group.web-instance-security-group.id}" ]
  subnet_id                   = "${aws_subnet.public-subnet1.id}"
  associate_public_ip_address = true
  key_name                    = "${aws_key_pair.web.key_name}"
  user_data                   = <<EOF
#!/bin/sh
yum install -y nginx
service nginx start
EOF
}

resource "aws_instance" "web-instance2" {
  ami           = "${var.ami}"
  availability_zone = "${var.region}b"
  instance_type = "t2.small"
  vpc_security_group_ids      = [ "${aws_security_group.web-instance-security-group.id}" ]
  subnet_id                   = "${aws_subnet.public-subnet2.id}"
  associate_public_ip_address = true
  key_name                    = "${aws_key_pair.web.key_name}"
  user_data                   = <<EOF
#!/bin/sh
yum install -y nginx
service nginx start
EOF
}

# Create a new load balancer
resource "aws_elb" "bar" {
  name               = "foobar-terraform-elb"
  security_groups      = [ "${aws_security_group.web-elb-security-group.id}" ]
  subnets = ["${aws_subnet.public-subnet1.id}", "${aws_subnet.public-subnet2.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = ["${aws_instance.web-instance1.id}", "${aws_instance.web-instance2.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "foobar-terraform-elb"
  }
}

resource "aws_security_group" "web-elb-security-group" {
  name = "elb-sg"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "web-instance-security-group" {
  depends_on = ["aws_security_group.web-elb-security-group"]
  name = "ec2-sg"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      # prefix_list_ids = ["${aws_security_group.web-elb-security-group.id}"]
      # Error authorizing security group ingress rules: InvalidGroup.NotFound: The security group '' does not exist. While it exists...
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



# output "web_domain" {
#   value = "${aws_instance.web-instance.public_dns}"
# }

output "web_domain" {
  value = "${aws_elb.bar.dns_name}"
}
