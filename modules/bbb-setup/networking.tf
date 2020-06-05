
//Public lan
resource "profitbricks_lan" "bbb_server_lan" {
  datacenter_id = var.datacenter
  public        = true
  name          = "public"
}