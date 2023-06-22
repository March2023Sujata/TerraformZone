variable "user_info" {
  type = object({
    name = string,
    dept = string,
    mail = string,
    pwd  = string
  })
  default = {
    dept = "IT"
    mail = "ram@joshisujatavgmail.onmicrosoft.com"
    name = "ram"
    pwd  = "india@12345"
  }
}

