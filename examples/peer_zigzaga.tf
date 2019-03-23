module "peer-same_region_api_wallet" {
  source = "../"

  peer_name = "api_wallet"
  tier = "production"
  organization = "zigzaga"

  vpc_id = ""
  peer_vpc_id = ""
  peer_owner_id = ""
  peer_region = ""
  peer_dns_resolution = ""
  auto_accept = "false"

  tags = ""
}


