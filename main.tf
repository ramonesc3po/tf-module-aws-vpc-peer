terraform {
  required_version = "<= 0.11.13"
}

locals {
  peer_region_name = "${var.peer_name}-${var.organization}-${var.tier}"
}

variable "is_peer-region" {
  default = false
}

variable "peer_name" {}

variable "tier" {}

variable "organization" {
  default = ""
}

variable "tags" {}

variable "peer_owner_id" {}

variable "peer_vpc_id" {}

variable "peer_region" {}

variable "vpc_id" {}

variable "auto_accept" {}

variable "peer_dns_resolution" {}

module "peer_same_region" {
  source = "module/peer-region"

  is_peer-region = "${var.is_peer-region}"

  peer_owner_id = "${var.peer_owner_id}"
  peer_region   = "${var.peer_region}"
  peer_vpc_id   = "${var.peer_vpc_id}"
  vpc_id        = "${var.vpc_id}"
  auto_accept   = "${var.auto_accept}"

  accepter_allow_remote_vpc_dns_resolution  = "${var.peer_dns_resolution}"
  requester_allow_remote_vpc_dns_resolution = "${var.peer_dns_resolution}"

  tags = "${concat(var.tags,
  map("Name", local.peer_region_name),
  map("Tier", var.tier),
  map("Organization", var.organization)
  )}"
}
