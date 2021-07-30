resource "aws_subnet" "gateway_utility" {
  count = local.num_availability_zones

  vpc_id = aws_vpc.vpc.id

  cidr_block = local.subnet_cidr_blocks.gateway_utility[local.availability_zones[count.index]]
  availability_zone = local.availability_zones[count.index]


  tags = merge({
    Name = "${local.vpc_name}-gateway_utility-${local.availability_zones[count.index]}"
    Tier = "gateway_utility"
    AvailabilityZone = "ap-southeast-1a"
  }, local.common_tags)
}

