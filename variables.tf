provider "aws" {
	region = "eu-central-1"
}
data "aws_availability_zones" "all" {}
variable "server_port" {
	description = "The port the server will use for HTTP requests"
	default = 8080
}
variable "my_ami_id" {
	description = "The AMI to use"
	default = "ami-751fd51a"
}
variable "my_instance_type"	{
	description = "The instance type to use"
	default = "t2.micro"
}
variable "my_instance_name_tg" {
	description = "Name Tag"
	default = "myTerraform-example"
}
variable "my_instance_app_tg" {
	description = "Application Tag"
	default = "websvr"
}
variable "my_instance_domain_tg" {
	description = "Domain Tag"
	default = "Jagho.biz"
}
variable "my_sg_name_tg" {
	description = "Name Tag"
	default = "tfwbSvrSG"
}