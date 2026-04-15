resource "aws_instance" "bastion" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.bastion_sg_id]
  subnet_id = local.public_subnet_ids
  iam_instance_profile = aws_iam_instance_profile.bastion.name
  
  # need more volume for terraform
  root_block_device {
    volume_size = 50
    volume_type = "gp3"  # or "gp2" , gp3 is better and cheaper than gp2 ,depending on the region or preferences
  }

  user_data = file("bastion.sh")
  tags = merge (
    local.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-bastion"
    }
  )
}

resource "aws_iam_instance_profile" "bastion" {
  name = "bastion" #bastion
  role = "BastionTerraformAdmin" # this role has permission to read SSM parameters, which is required for the bastion instance to read the database password from SSM parameter store
}