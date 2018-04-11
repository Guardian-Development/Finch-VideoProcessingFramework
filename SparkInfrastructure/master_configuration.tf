# SSH configuration file 
data "template_file" "spark-ssh-configuration" {
    template = "${file("./spark_configuration/ssh_configuration.tpl")}"
}

# Spark Slaves Config File
data "template_file" "spark-slaves-configuration" {
    template = "${file("./spark_configuration/spark_slaves_config.tpl")}"
    vars {
        spark_worker_1_ip = "${aws_instance.spark-worker-1.private_ip}"
        spark_worker_2_ip = "${aws_instance.spark-worker-2.private_ip}"
    }
}

# Setup Spark Master 1
resource "null_resource" "spark-master-1-configure" {

    # Trigger when the Spark Master has been built
    triggers {
        worker_id = "${null_resource.spark-worker-1-configure.id}, ${null_resource.spark-worker-2-configure.id}"
    }

    # Load both parts of SSH key to Master Node, with SSH configuration
    provisioner "file" {
        source = "${var.spark_rsa_public_key_file_path}"
        destination = "~/.ssh/id_rsa.pub"
        
        connection {
            type = "ssh"
            timeout = "5m"
            user = "ubuntu"
            private_key = "${file(var.ec2_secret_key_file_path)}"
            host = "${aws_instance.spark-master-1.public_ip}"
        }
    }
    provisioner "file" {
        source = "${var.spark_rsa_private_key_file_path}"
        destination = "~/.ssh/id_rsa"
        
        connection {
            type = "ssh"
            timeout = "5m"
            user = "ubuntu"
            private_key = "${file(var.ec2_secret_key_file_path)}"
            host = "${aws_instance.spark-master-1.public_ip}"
        }
    }
    provisioner "file" {
        content = "${data.template_file.spark-ssh-configuration.rendered}"
        destination = "~/.ssh/config"
        
        connection {
            type = "ssh"
            timeout = "5m"
            user = "ubuntu"
            private_key = "${file(var.ec2_secret_key_file_path)}"
            host = "${aws_instance.spark-master-1.public_ip}"
        }
    }

    provisioner "file" {
        content = "${data.template_file.spark-slaves-configuration.rendered}"
        destination = "~/slaves"
        
        connection {
            type = "ssh"
            timeout = "5m"
            user = "ubuntu"
            private_key = "${file(var.ec2_secret_key_file_path)}"
            host = "${aws_instance.spark-master-1.public_ip}"
        }
    }

    provisioner "remote-exec" {
        inline = [
            "sudo apt-get update -y",
            "sudo apt-get install default-jre -y",
            "sleep 5s",
            "chmod 700 ~/.ssh/id_rsa",
            "wget http://www.mirrorservice.org/sites/ftp.apache.org/spark/spark-2.3.0/spark-2.3.0-bin-hadoop2.7.tgz",
            "tar -xzf spark-2.3.0-bin-hadoop2.7.tgz",
            "export SPARK_MASTER_HOST=\"${aws_instance.spark-master-1.public_dns}\"",
            "sleep 5s",
            "mv ~/slaves ~/spark-2.3.0-bin-hadoop2.7/conf/slaves",
            "nohup spark-2.3.0-bin-hadoop2.7/sbin/start-master.sh > ~/spark-logs &",
            "sleep 10s",
            "nohup spark-2.3.0-bin-hadoop2.7/sbin/start-slaves.sh > ~/spark-slaves-logs &",
            "sleep 10s",
            "echo 'Complete Setup'"
        ]
        
        connection {
            type = "ssh"
            timeout = "5m"
            user = "ubuntu"
            private_key = "${file(var.ec2_secret_key_file_path)}"
            host = "${aws_instance.spark-master-1.public_ip}"
        }
    }
}