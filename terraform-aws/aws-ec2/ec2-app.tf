provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "myec2" {
  ami = "ami-01e36b7901e884a10"
  instance_type = var.instance_type
  key_name = "aws_key"

tags={
    Name= var.vm_name
  }


provisioner "remote-exec" {
    inline = ["sudo yum -y install httpd"]

    connection {
      type = "ssh"
      host = self.public_ip
      user = "centos"
      private_key = file("aws_key")
    }

  }
}

