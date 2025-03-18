variable "sid" {
  description = "value"
  type        = string
  sensitive   = true
}

variable "rname" {
  description = "value of reasource group"
  type        = string
  sensitive   = false

}

variable "region" {
  type = string

}

variable "security_rule" {
  type = list(map(any))
  default = [{ "name" = "sshrule", "priority" = "100", "protocol" = "Tcp", "dport" = "22" },
    { "name" = "hhtpsrule", "priority" = "101", "protocol" = "Tcp", "dport" = "443" },
    { "name" = "dbrule", "priority" = "102", "protocol" = "Tcp", "dport" = "3306" },
    { "name" = "smtprule", "priority" = "103", "protocol" = "Tcp", "dport" = "25" },
    { "name" = "httprule", "priority" = "104", "protocol" = "Tcp", "dport" = "80" }
  ]

}
variable "numberofvms" {
  type = number
}