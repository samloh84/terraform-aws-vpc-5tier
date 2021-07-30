resource "aws_network_acl" "gateway_utility" {
  vpc_id = aws_vpc.vpc.id

  subnet_ids = aws_subnet.gateway_utility.*.id

  tags = merge({
    Name = "${local.vpc_name}-gateway_utility"
    Tier = "gateway_utility"
    AvailabilityZone = "ap-southeast-1a"
  }, local.common_tags)
}


locals {
  network_acl_gateway_utility_ingress_rules = {for tier, tier_traffic_rules in local.network_acl_traffic_rules: tier=>lookup(tier_traffic_rules, "gateway_utility", null) if lookup(tier_traffic_rules, "gateway_utility", null)!=null}

  network_acl_gateway_utility_ingress_rules_list = flatten(flatten([for tier, services in local.network_acl_gateway_utility_ingress_rules: [for service in services:[for cidr_block in local.network_acl_cidr_blocks[tier]:{

    from_port = lookup(lookup(local.service_port_numbers, service, {
    }), "from_port", service)
    to_port = lookup(lookup(local.service_port_numbers, service, {
    }), "to_port", service)
    protocol = lookup(lookup(local.service_port_numbers, service, {
    }), "protocol", "-1")
    cidr_block = cidr_block
  }]]]))

  network_acl_gateway_utility_egress_rules = local.network_acl_traffic_rules.gateway_utility

  network_acl_gateway_utility_egress_rules_list = flatten(flatten([for tier, services in local.network_acl_gateway_utility_egress_rules: [for service in services:[for cidr_block in local.network_acl_cidr_blocks[tier]:{
    from_port = lookup(lookup(local.service_port_numbers, service, {
    }), "from_port", service)
    to_port = lookup(lookup(local.service_port_numbers, service, {
    }), "to_port", service)
    protocol = lookup(lookup(local.service_port_numbers, service, {
    }), "protocol", "-1")
    cidr_block = cidr_block
  }]]]))
}




resource "aws_network_acl_rule" "gateway_utility_ingress" {
  count = length(local.network_acl_gateway_utility_ingress_rules_list)
  network_acl_id = aws_network_acl.gateway_utility.id

  rule_action = "allow"
  rule_number = 100 + (count.index * 10)

  egress = false
  protocol = lookup(local.network_acl_gateway_utility_ingress_rules_list[count.index], "protocol", null)
  from_port = lookup(local.network_acl_gateway_utility_ingress_rules_list[count.index], "from_port", null)
  to_port = lookup(local.network_acl_gateway_utility_ingress_rules_list[count.index], "to_port", null)
  cidr_block = lookup(local.network_acl_gateway_utility_ingress_rules_list[count.index], "cidr_block", null)
}

resource "aws_network_acl_rule" "gateway_utility_egress" {
  count = length(local.network_acl_gateway_utility_egress_rules_list)
  network_acl_id = aws_network_acl.gateway_utility.id

  rule_action = "allow"
  rule_number = 100 + (count.index * 10)

  egress = true
  protocol = lookup(local.network_acl_gateway_utility_egress_rules_list[count.index], "protocol", null)
  from_port = lookup(local.network_acl_gateway_utility_egress_rules_list[count.index], "from_port", null)
  to_port = lookup(local.network_acl_gateway_utility_egress_rules_list[count.index], "to_port", null)
  cidr_block = lookup(local.network_acl_gateway_utility_egress_rules_list[count.index], "cidr_block", null)
}
