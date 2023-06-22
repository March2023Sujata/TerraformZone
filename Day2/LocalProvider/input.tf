variable "file_info" {
  type = object({
    filename = string,
    content  = string
  })
  default = {
    content  = "Hello!.."
    filename = "C:/Repos/joip/Day2/test1.txt"
  }
}

