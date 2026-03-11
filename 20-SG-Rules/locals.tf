locals {
  # Use chomp to remove any trailing newlines
  my_public_ip = "${chomp(data.http.my_public_ip.response_body)}/32"
}
