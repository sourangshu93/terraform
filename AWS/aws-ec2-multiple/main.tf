resource "aws_instance" "my-machine" {
  count = var.ec2_count     # Here we are creating identical for numver of machines.
  
  ami = var.ami
  instance_type = var.instance_type
  key_name = "aws_key"
  tags = {
    Name = "my-machine-${count.index}"
         }
}
