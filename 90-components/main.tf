module "component"{
    for_each = var.components
    source = "git::https://github.com/ravitejakajjamdevops-prog/Roboshop-terraform-component.git"
    component = each.key
    rule_priority = each.value.rule_priority

}