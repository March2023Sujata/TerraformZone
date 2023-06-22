
output "dataAboutVM" {
  value = "IP OF VM is:-${data.template_file.dataAboutVM.rendered}"
}
