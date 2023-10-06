variable "aws_access_key" {
  description = "AWS Access Key"
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
}

variable "aws_region" {
  description = "AWS Region"
}

variable "s3_bucket_name" {
    default = "de-atilla-covid-data"
}

variable "s3_bucket_name_athena" {
    default = "de-atilla-athena-metadata"
}

variable "s3_bucket_name_staging" {
    default = "de-atilla-staging"
}

variable "s3_base_folder" {
    default = "covid_data"
}

variable "local_directory" {
    default     = ".\\data\\covid_data"
}

variable "crawler_name"{
    default = "enigma_jhud"
}

variable "glue_role"{
    default = "arn:aws:iam::750431063106:role/covid_project_role"
}

variable "glue_database_name"{
    default = "covid_19"
}

