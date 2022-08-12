output "ec2_machines" {
  value = aws_instance.my-machine.*.arn       # Here * indicates that there are more than one arn as we used count as 4   
}
