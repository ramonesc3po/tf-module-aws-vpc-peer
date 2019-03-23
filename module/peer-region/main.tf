locals {
  peer-region = "${var.is_peer-region == true ? 1 : 0}"
}

variable "is_peer-region" {
  type    = "string"
  default = false
}

variable "peer_vpc_id" {
  type = "string"
}

variable "peer_owner_id" {
  type = "string"
}

variable "peer_region" {
  type = "string"
}

variable "auto_accept" {
  type = "string"
}

variable "accepter_allow_remote_vpc_dns_resolution" {
  default = true
}

variable "requester_allow_remote_vpc_dns_resolution" {
  default = true
}

variable "vpc_id" {
  type    = "string"
  default = ""
}

variable "tags" {
  type    = "map"
  default = {}
}

provider "aws" {
  alias = "accepter"
}

provider "aws" {
  alias = "requester"
}

resource "aws_vpc_peering_connection" "this" {
  provider      = "aws.requester"
  count         = "${local.peer-region == true}"
  peer_vpc_id   = "${var.peer_vpc_id}"
  peer_owner_id = "${var.peer_owner_id}"
  peer_region   = "${var.peer_region}"
  auto_accept   = "${var.auto_accept}"
  vpc_id        = "${var.vpc_id}"

  tags = "${var.tags}"
}

resource "aws_vpc_peering_connection_options" "requester" {
  provider                  = "aws.requester"
  count                     = "${local.peer-region == true}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.this.id}"

  requester {
    allow_remote_vpc_dns_resolution = "${var.accepter_allow_remote_vpc_dns_resolution}"
  }
}

resource "aws_vpc_peering_connection_options" "accepter" {
  provider                  = "aws.accepter"
  count                     = "${local.peer-region == true}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.this.id}"

  accepter {
    allow_remote_vpc_dns_resolution = "${var.requester_allow_remote_vpc_dns_resolution}"
  }
}

resource "aws_vpc_peering_connection_accepter" "this" {
  provider                  = "aws.accepter"
  count                     = "${local.peer-region == true}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.this.id}"
}
