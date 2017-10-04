resource "aws_security_group" "allow_all_outbound" {
    name_prefix = "all-outbound-"
    description = "Allow all outbound traffic"

    egress = {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "allow_all_inbound" {
    name_prefix = "all-inbound-"
    description = "Allow all inbound traffic"
    ingress = {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "allow_cluster" {
    name_prefix = "allow-cluster-"
    description = "Allow all traffic within cluster"

    ingress = {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        self = true
    }

    egress = {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        self = true
    }
}