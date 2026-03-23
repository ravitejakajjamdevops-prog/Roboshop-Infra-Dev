module "component"{
    for_each = var.components
    source = "::https://github.com/ravitejakajjamdevops-prog/Roboshop-terraform-component.git"
    component = each.key
    rule_priority = each.value.rule_priority

}