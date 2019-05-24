variable "project" {
  type = "string"
  default = "crm-ecenter"
}

variable "gke_node_type" {
  type = "string"
  default = "n1-standard-2"
}

variable "environment" {
  type = "string"
  default = "dev"
}

variable "database_version" {
  type = "string"
  default = "MYSQL_5_7"
}

variable "gke_version" {
  type = "string"
  default = "1.12.7-gke.10"
}


variable "min_nodes" {
  type = "string"
  default = "1"
}

variable "max_nodes" {
  type = "string"
  default = "2"
}

variable "mysql_node_type" {
  type = "string"
  default = "db-n1-standard-1"
}

variable "region" {
  type = "string"
  default = "europe-west2"
}

//variable "domain" {
//  type = "string"
//  default = "augnetmq.com"
//}