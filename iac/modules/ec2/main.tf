resource "aws_instance" "this" {
  ami = "ami-02801556a781a4499"

  instance_type = var.instance_type
  subnet_id     = element(var.subnet_ids, 0)

  tags = {
    Environment = var.environment
    Iac         = true
  }
}
