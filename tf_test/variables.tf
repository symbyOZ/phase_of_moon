#variable "count" {
#  default = 1
#}
variable "region" {
  description = "AWS region"
  default     = "us-east-2"
}

variable "key_name" {
  description = "AWS ssh key"
  default     = "Test_AWS"
}

