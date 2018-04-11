# Setup Spark Worker 1
resource "null_resource" "spark-worker-1-configure" {

    # Trigger when the Spark Worker has been created
    triggers {
        worker_id = "${aws_instance.spark-worker-1.id}"
    }

    provisioner "file" {
        source = "${var.spark_rsa_public_key_file_path}"
        destination = "~/.ssh/id_rsa.pub"
        
        connection {
            type = "ssh"
            timeout = "5m"
            user = "ubuntu"
            private_key = "${file(var.ec2_secret_key_file_path)}"
            host = "${aws_instance.spark-worker-1.public_ip}"
        }
    }

    provisioner "remote-exec" {
        inline = [
            "sudo apt-get -y update",
            "sudo apt-get -y install default-jre",
            "chmod 700 ~/.ssh/",
            "chmod 644 ~/.ssh/authorized_keys",
            "cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys",
            "wget http://www.mirrorservice.org/sites/ftp.apache.org/spark/spark-2.3.0/spark-2.3.0-bin-hadoop2.7.tgz",
            "tar -xzf spark-2.3.0-bin-hadoop2.7.tgz",
            "echo 'Complete Setup'"
        ]
        
        connection {
            type = "ssh"
            timeout = "5m"
            user = "ubuntu"
            private_key = "${file(var.ec2_secret_key_file_path)}"
            host = "${aws_instance.spark-worker-1.public_ip}"
        }
    }
}

# Setup Spark Worker 2
resource "null_resource" "spark-worker-2-configure" {

    # Trigger when the Spark Worker has been created
    triggers {
        spark_id = "${aws_instance.spark-worker-2.id}"
    }

    provisioner "file" {
        source = "${var.spark_rsa_public_key_file_path}"
        destination = "~/.ssh/id_rsa.pub"
        
        connection {
            type = "ssh"
            timeout = "5m"
            user = "ubuntu"
            private_key = "${file(var.ec2_secret_key_file_path)}"
            host = "${aws_instance.spark-worker-2.public_ip}"
        }
    }

    provisioner "remote-exec" {
        inline = [
            "sudo apt-get -y update",
            "sudo apt-get -y install default-jre",
            "chmod 700 ~/.ssh/",
            "chmod 644 ~/.ssh/authorized_keys",
            "cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys",
            "wget http://www.mirrorservice.org/sites/ftp.apache.org/spark/spark-2.3.0/spark-2.3.0-bin-hadoop2.7.tgz",
            "tar -xzf spark-2.3.0-bin-hadoop2.7.tgz",
            "echo 'Complete Setup'"
        ]
        
        connection {
            type = "ssh"
            timeout = "5m"
            user = "ubuntu"
            private_key = "${file(var.ec2_secret_key_file_path)}"
            host = "${aws_instance.spark-worker-2.public_ip}"
        }
    }
}