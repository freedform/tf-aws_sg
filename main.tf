locals {
  egress_cidr_rules = {
    for rule in var.sg_egress_rules : md5(jsonencode(rule)) => rule if rule["cidr_blocks"] != null
  }
  ingress_cidr_rules = {
    for rule in var.sg_ingress_rules : md5(jsonencode(rule)) => rule if rule["cidr_blocks"] != null
  }
  egress_sg_id_rules = {
    for rule in var.sg_egress_rules : md5(jsonencode(rule)) => rule if rule["sg_id"] != null
  }
  ingress_sg_id_rules = {
    for rule in var.sg_ingress_rules : md5(jsonencode(rule)) => rule if rule["sg_id"] != null
  }
  egress_self_rules = {
    for rule in var.sg_egress_rules : md5(jsonencode(rule)) => rule if rule["self"] != null
  }
  ingress_self_rules = {
    for rule in var.sg_ingress_rules : md5(jsonencode(rule)) => rule if rule["self"] != null
  }
}

resource "aws_security_group" "this" {
  count       = var.create_sg ? 1 : 0
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.sg_vpc
  tags = merge({
    Name = var.sg_name
  }, var.tags)
}

locals {
  sg_id = var.create_sg ? aws_security_group.this[0].id : var.sg_id
}

resource "aws_security_group_rule" "egress_cidr_rules" {
  for_each          = local.egress_cidr_rules
  type              = "egress"
  from_port         = each.value["from_port"]
  protocol          = each.value["protocol"]
  to_port           = each.value["to_port"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = local.sg_id
}

resource "aws_security_group_rule" "ingress_cidr_rules" {
  for_each          = local.ingress_cidr_rules
  type              = "ingress"
  from_port         = each.value["from_port"]
  protocol          = each.value["protocol"]
  to_port           = each.value["to_port"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = local.sg_id
}

resource "aws_security_group_rule" "egress_sg_id_rules" {
  for_each                 = local.egress_sg_id_rules
  type                     = "egress"
  from_port                = each.value["from_port"]
  protocol                 = each.value["protocol"]
  to_port                  = each.value["to_port"]
  source_security_group_id = each.value["sg_id"]
  security_group_id        = local.sg_id
}

resource "aws_security_group_rule" "ingress_sg_id_rules" {
  for_each                 = local.ingress_sg_id_rules
  type                     = "ingress"
  from_port                = each.value["from_port"]
  protocol                 = each.value["protocol"]
  to_port                  = each.value["to_port"]
  source_security_group_id = each.value["sg_id"]
  security_group_id        = local.sg_id
}

resource "aws_security_group_rule" "egress_self_rules" {
  for_each          = local.egress_self_rules
  type              = "egress"
  from_port         = each.value["from_port"]
  protocol          = each.value["protocol"]
  to_port           = each.value["to_port"]
  self              = each.value["self"]
  security_group_id = local.sg_id
}

resource "aws_security_group_rule" "ingress_self_rules" {
  for_each          = local.ingress_self_rules
  type              = "ingress"
  from_port         = each.value["from_port"]
  protocol          = each.value["protocol"]
  to_port           = each.value["to_port"]
  self              = each.value["self"]
  security_group_id = local.sg_id
}