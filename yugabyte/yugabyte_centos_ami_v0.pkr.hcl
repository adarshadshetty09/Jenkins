variable "region" {

  default = "ap-south-1"

}

variable "instance_type" {

  default = "t2.2xlarge"

}

variable "source_ami" {

  default = "ami-02ddb77f8f93ca4ca" # Replace with a valid RedHat AMI ID 

}

variable "ssh_username" {

  default = "ec2-user"

}

# variable "ssh_keypair_name" { 

#   default = "Yugabyte" 

# } 

# variable "ssh_private_key_file" { 

#   default = "/home/Yugabyte.pem" 

# } 

packer {

  required_plugins {

    amazon = {

      version = ">= 1.2.8"

      source = "github.com/hashicorp/amazon"

    }

  }

}



source "amazon-ebs" "yugabytedb" {

  region = var.region

  #   ssh_keypair_name        = var.ssh_keypair_name 

  #   ssh_private_key_file    = var.ssh_private_key_file 

  instance_type = var.instance_type

  ssh_username = var.ssh_username

  ami_name = "yugabytedb-ami-{{timestamp}}"

  source_ami = var.source_ami

  associate_public_ip_address = true



  tags = {

    Name = "YugabyteDB_AMI_V0"

  }

}



build {

  sources = ["source.amazon-ebs.yugabytedb"]



  provisioner "shell" {

    inline = [

      "set -e", # Exit immediately if any command fails 

      "start_time=$(date +%s)", # Capture the start time 

      "echo 'Starting YugabyteDB installation...'",

      "sudo yum update -y",

      "sudo yum install -y wget", # Install wget 

      "wget https://downloads.yugabyte.com/releases/2.25.0.0/yugabyte-2.25.0.0-b489-linux-x86_64.tar.gz",

      "tar xvfz yugabyte-2.25.0.0-b489-linux-x86_64.tar.gz",

      "cd yugabyte-2.25.0.0/",

      "sudo ./bin/post_install.sh",

      "sudo chown -R ec2-user:ec2-user /home/ec2-user/yugabyte-2.25.0.0/openssl-config",

      "chmod u+w /home/ec2-user/yugabyte-2.25.0.0/openssl-config",

      "./bin/yugabyted start",

      "./bin/yugabyted status || { echo -e '\\033[0;31mSetup failed. Please check logs.\\033[0m'; exit 1; }",

      "end_time=$(date +%s)", # Capture the end time 

      "execution_time=$((end_time - start_time))", # Calculate the execution time 

      "echo 'Setup completed successfully!'",

      "echo 'Total execution time: $execution_time seconds'"

    ]

  }

}

// try