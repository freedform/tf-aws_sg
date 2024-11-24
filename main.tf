locals {
  egress_rules = length(var.sg_egress_rules) > 0 ? {
    for rule in var.sg_egress_rules : md5(jsonencode(rule)) => rule
  } : {}
  ingress_rules = length(var.sg_ingress_rules) > 0 ? {
    for rule in var.sg_ingress_rules : md5(jsonencode(rule)) => rule
  } : {}
}

resource "aws_security_group" "this" {
  count       = var.create_sg ? 1 : 0
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.sg_vpc
}

resource "aws_security_group_rule" "egress_rules" {
  for_each          = local.egress_rules
  type              = "egress"
  from_port         = each.value.from_port
  protocol          = each.value.protocol
  to_port           = each.value.to_port
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = aws_security_group.this[0].id
}

resource "aws_security_group_rule" "ingress_rules" {
  for_each          = local.ingress_rules
  type              = "ingress"
  from_port         = each.value.from_port
  protocol          = each.value.protocol
  to_port           = each.value.to_port
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = aws_security_group.this[0].id
}