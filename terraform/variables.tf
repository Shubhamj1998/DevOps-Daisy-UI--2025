variable "ec2_instance_type" {
    default = "m7i-flex.large"
    type = string
  }
variable "root_storage_size" {
  default = 20
  type = number
}
 
variable "ec2_ami_id" {
  default = "ami-020cba7c55df1f615"
  type = string
}

variable "env" {
    default = "prd"
    type = string
  
}