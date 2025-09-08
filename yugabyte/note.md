### Install git

sudo yum install git -y

### Install wget

sudo yum install wget -y

### Install unzip

sudo yum install unzip -y

### Install Packer on Centos

```
wget https://releases.hashicorp.com/packer/1.2.5/packer_1.2.5_linux_amd64.zip
unzip packer_1.2.5_linux_amd64.zip
rm -f packer_1.2.5_linux_amd64.zip
mv packer /usr/local/bin
cd
packer --version

[ec2-user@ip-172-31-46-4 yugabyte]$ packer --version
1.2.5
[ec2-user@ip-172-31-46-4 yugabyte]$
```

### Install aws-cli

```
wget https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
unzip awscli-exe-linux-x86_64.zip
sudo ./aws/install
aws --version

[ec2-user@ip-172-31-46-4 ~]$ aws --version
aws-cli/2.24.23 Python/3.12.9 Linux/5.14.0-503.15.1.el9_5.x86_64 exe/x86_64.rhel.9
[ec2-user@ip-172-31-46-4 ~]$

```


### Packer Installation and SetUp


```
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install packer

packer
```


```
[ec2-user@ip-172-31-46-4 yugabyte]$ /usr/bin/packer validate yugabyte_centos_ami.pkr.hcl
Error: Missing plugins

The following plugins are required, but not installed:

* github.com/hashicorp/amazon >= 1.2.8

Did you run packer init for this project ?


[ec2-user@ip-172-31-46-4 yugabyte]$ /usr/bin/packer init
Usage: packer init [options] TEMPLATE

  Install all the missing plugins required in a Packer config. Note that Packer
  does not have a state.

  This is the first command that should be executed when working with a new
  or existing template.

  This command is always safe to run multiple times. Though subsequent runs may
  give errors, this command will never delete anything.

Options:
  -upgrade                     On top of installing missing plugins, update
                               installed plugins to the latest available
                               version, if there is a new higher one. Note that
                               this still takes into consideration the version
                               constraint of the config.
  -force                       Forces reinstallation of plugins, even if already
                               installed.
[ec2-user@ip-172-31-46-4 yugabyte]$ /usr/bin/packer init yugabyte_centos_ami.pkr.hcl
Installed plugin github.com/hashicorp/amazon v1.3.4 in "/home/ec2-user/.packer.d/plugins/github.com/hashicorp/amazon/packer-plugin-amazon_v1.3.4_x5.0_linux_amd64"
[ec2-user@ip-172-31-46-4 yugabyte]$ /usr/bin/packer validate yugabyte_centos_ami.pkr.hcl
The configuration is valid.
[ec2-user@ip-172-31-46-4 yugabyte]$ /usr/bin/packer fmt yugabyte_centos_ami.pkr.hcl
yugabyte_centos_ami.pkr.hcl
[ec2-user@ip-172-31-46-4 yugabyte]$
```

### To packer available on systemwide add packer executable folder to a  ' /usr/local/bin/ path '
