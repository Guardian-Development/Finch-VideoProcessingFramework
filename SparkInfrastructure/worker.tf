# Spark Worker 1
resource "aws_instance" "spark-worker-1" {
    # 16.04 LTS, amd64, hvm:ebs-ssd 
    ami = "ami-c1167eb8"
    instance_type = "t2.medium"
    vpc_security_group_ids = [
        "${aws_security_group.ec2-ssh.id}",
        "${aws_security_group.ec2-incoming-traffic.id}", 
        "${aws_security_group.ec2-outgoing-traffic.id}"]

    key_name = "${var.ec2_key_pair_name}"

    tags {
        Name = "Spark-Worker-1"
    }
}

# Spark Worker 2
resource "aws_instance" "spark-worker-2" {
    # 16.04 LTS, amd64, hvm:ebs-ssd 
    ami = "ami-c1167eb8"
    instance_type = "t2.medium"
    vpc_security_group_ids = [
        "${aws_security_group.ec2-ssh.id}",
        "${aws_security_group.ec2-incoming-traffic.id}", 
        "${aws_security_group.ec2-outgoing-traffic.id}"]

    key_name = "${var.ec2_key_pair_name}"

    tags {
        Name = "Spark-Worker-2"
    }
}