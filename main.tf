resource "aws_launch_configuration" "asgexample" {
	image_id = "${var.my_ami_id}"
	instance_type = "${var.my_instance_type}"
    security_groups = ["${aws_security_group.myinstance.id}"]


	user_data = <<-EOF
				#!/bin/bash
				echo "Welcome to my world, Yomi you rock..!" > index.html
				nohup busybox httpd -f -p "${var.server_port}" &
				EOF
	lifecycle {
		create_before_destroy = true
	}
}
resource "aws_security_group" "myinstance" {
	name = "myterraform-example-myinstance"

	ingress {
		from_port = "${var.server_port}"
		to_port	= "${var.server_port}"
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	tags	{
		Name = "${var.my_sg_name_tg}"
	}

	lifecycle {
		create_before_destroy = true
	}
}
resource "aws_autoscaling_group" "asgexample" {
	launch_configuration = "${aws_launch_configuration.asgexample.id}"
	availability_zones = ["${data.aws_availability_zones.all.names}"]

	min_size =	2
	max_size = 	10

	load_balancers = ["${aws_elb.elbexample.name}"]
	health_check_type = "ELB"

	tag {
		key = "Name"
		value =	"terraform-asg-example"
		propagate_at_launch = true
	}
}
resource "aws_elb" "elbexample" {
	name = "terraform-asg-example"
	security_groups = ["${aws_security_group.myelb.id}"]
	availability_zones = ["${data.aws_availability_zones.all.names}"]

	health_check {
		healthy_threshold = 2
		unhealthy_threshold = 2
		timeout = 3
		interval = 30
		target = "HTTP:${var.server_port}/"
	}

	listener {
		lb_port = 80
		lb_protocol = "http"
		instance_port = "${var.server_port}"
		instance_protocol = "http"
	}
}
resource "aws_security_group" "myelb" {
	name = "terraform-example-elb"

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
	ingress	{
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
}