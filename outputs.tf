output "elb_dns_name" {
	value = "${aws_elb.elbexample.dns_name}"
}