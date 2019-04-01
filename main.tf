terraform {
  required_version = "<= 0.11.13"
}

locals {
  vpc_peer = "${var.enabled_vpc_peer == true ? 1 : 0}"

  name_vpc_peer = "${var.organization}-${var.name_vpc_peer}-${var.peer_region}-${var.tier}"
}

variable "enabled_vpc_peer" {
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

variable "name_vpc_peer" {
  type = "string"
}

variable "vpc_id" {
  type    = "string"
  default = ""
}

variable "organization" {
  type    = "string"
  default = ""
}

variable "tier" {
  type = "string"
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
  count         = "${local.vpc_peer == true}"
  peer_vpc_id   = "${var.peer_vpc_id}"
  peer_owner_id = "${var.peer_owner_id}"
  peer_region   = "${var.peer_region}"
  auto_accept   = "${var.auto_accept}"
  vpc_id        = "${var.vpc_id}"

  tags = "${concat(var.tags,
  map("Name", local.name_vpc_peer),
  map("Tier", var.tier),
  map("Terrafor", "True")
  )}"
}

resource "aws_vpc_peering_connection_options" "requester" {
  provider                  = "aws.requester"
  count                     = "${local.vpc_peer == true}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.this.id}"

  requester {
    allow_remote_vpc_dns_resolution = "${var.accepter_allow_remote_vpc_dns_resolution}"
  }
}

resource "aws_vpc_peering_connection_options" "accepter" {
  provider                  = "aws.accepter"
  count                     = "${local.vpc_peer == true}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.this.id}"

  accepter {
    allow_remote_vpc_dns_resolution = "${var.requester_allow_remote_vpc_dns_resolution}"
  }
}

resource "aws_vpc_peering_connection_accepter" "this" {
  provider                  = "aws.accepter"
  count                     = "${local.vpc_peer == true}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.this.id}"
}
