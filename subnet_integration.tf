resource "aws_subnet" "integration" {
  count = local.num_availability_zones

  vpc_id = aws_vpc.vpc.id

  cidr_block = local.subnet_cidr_blocks.integration[local.availability_zones[count.index]]
  availability_zone = local.availability_zones[count.index]


  tags = merge({
    Name = "${local.vpc_name}-integration-${local.availability_zones[count.index]}"
    Tier = "integration"
    AvailabilityZone = "ap-southeast-1a"
  }, local.common_tags)
}

