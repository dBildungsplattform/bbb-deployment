// Create Key Pair for Server
resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "public_key_openssh" {
  depends_on = [tls_private_key.pk]
  content    = tls_private_key.pk.public_key_openssh
  filename   = var.public_key_path
}

resource "local_file" "private_key_pem" {
  depends_on = [tls_private_key.pk]
  content    = tls_private_key.pk.private_key_pem
  filename   = var.private_key_path
}

resource "null_resource" "private_key_permissions" {
  depends_on = [local_file.private_key_pem]

  provisioner "local-exec" {
    command     = "chmod 400 ${var.private_key_path}"
    interpreter = ["bash", "-c"]
    on_failure  = continue
  }
}
