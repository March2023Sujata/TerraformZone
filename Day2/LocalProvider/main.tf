resource "local_file" "file1" {
  content  = var.file_info.content
  filename = var.file_info.filename
}