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

  instance_type = var.instance_type

  ssh_username = var.ssh_username

  ami_name = "yugabytedb-ami-{{timestamp}}"

  source_ami = var.source_ami

  associate_public_ip_address = true



  tags = {

    Name = "YugabyteDB_AMI_V1"

  }

}



build {

  sources = ["source.amazon-ebs.yugabytedb"]



provisioner "shell" {
  inline = [
    "set -e",
    "start_time=$(date +%s)",
    "echo 'Starting YugabyteDB installation...'",

    # Skip full yum update for faster build
    "sudo yum install -y wget",
    
    # Pre-download YugabyteDB or use an S3 bucket
    "wget https://downloads.yugabyte.com/releases/2.25.0.0/yugabyte-2.25.0.0-b489-linux-x86_64.tar.gz",
    
    "tar xvfz yugabyte-2.25.0.0-b489-linux-x86_64.tar.gz",
    "cd yugabyte-2.25.0.0/",
    
    "sudo ./bin/post_install.sh",
    "sudo chown -R ec2-user:ec2-user /home/ec2-user/yugabyte-2.25.0.0/openssl-config",
    
    # Start YugabyteDB and check status
    "./bin/yugabyted start",
    "./bin/yugabyted status || { echo 'Setup failed.'; exit 1; }",
    
    "end_time=$(date +%s)",
    "execution_time=$((end_time - start_time))",
    "echo 'Setup completed successfully!'",
    "echo 'Total execution time: $execution_time seconds'"
  ]
}
}

// try