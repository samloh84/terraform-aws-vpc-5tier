locals {

  network_acl_traffic_rules = {
    web = {
      app = [
        "http",
        "https",
        "ssh",
        "rdp"]
      out_internet = [
        "http",
        "https"]
      management = [
        "ephemeral"]
      in_internet = [
        "ephemeral"]
      web = [
        "all"]
    }

    app = {
      db = [
        "http",
        "https",
        "ssh",
        "rdp",
        "mysql",
        "mssql",
        "oracledb",
        "postgresql",
        "mongodb",
        "memcached",
        "redis"]
      integration = [
        "http",
        "https",
        "ssh",
        "rdp"]
      web = [
        "ephemeral"]
      app = [
        "all"]
    }
    db = {
      app = [
        "ephemeral"]
      db = [
        "all"]
    }

    management = {
      web = [
        "http",
        "https",
        "ssh",
        "rdp"]
    }

    gateway_utility = {
      out_internet = [
        "http",
        "https"]
      integration = [
        "ephemeral"
      ]
    }


    integration = {
      gateway_utility = [
        "http",
        "https",
        "ssh",
        "rdp"
      ]
      app = [
        "ephemeral"
      ]
    }

    out_internet = {
      web = [
        "ephemeral"]
      gateway_utility = [
        "ephemeral"]
    }
    in_internet = {
      web = [
        "http",
        "https"]
    }

  }


  network_acl_cidr_blocks = {
    web = [
      local.tier_cidr_blocks.web]
    app = [
      local.tier_cidr_blocks.app]
    db = [
      local.tier_cidr_blocks.db]
    out_internet = local.whitelist_outgoing_http_request_cidr_blocks
    in_internet = local.whitelist_incoming_http_request_cidr_blocks
    management = local.management_network_cidr_blocks
  }


}

