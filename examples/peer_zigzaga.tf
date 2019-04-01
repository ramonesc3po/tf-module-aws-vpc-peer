module "peer-same_region_api_wallet" {
  source = "../"

  providers = {
    aws.accepter = aws.accepter
    aws.requester = aws.requester
  }

  name_vpc_peer = "api_wallet"
  tier = "production"
  organization = "zigzaga"

  vpc_id = ""
  peer_owner_id = ""
  peer_vpc_id = ""
  peer_region = ""
  auto_accept = "true"
}


