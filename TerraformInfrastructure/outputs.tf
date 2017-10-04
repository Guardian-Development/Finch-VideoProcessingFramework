output "client-service-elb-dns" {
    value = "${aws_elb.client-service-elb.dns_name}"
}