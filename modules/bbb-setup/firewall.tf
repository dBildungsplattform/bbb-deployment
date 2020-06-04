

resource "profitbricks_firewall" "bbb_server_ssh" {
  count            = var.bbb_server_count
  datacenter_id    = var.datacenter
  server_id        = element(profitbricks_server.bbb_server.*.id, count.index)
  nic_id           = element(profitbricks_server.bbb_server.*.primary_nic, count.index)
  protocol         = "TCP"
  name             = "SSH"
  port_range_start = 22
  port_range_end   = 22
}

resource "profitbricks_firewall" "bbb_server_udp" {
  count            = var.bbb_server_count
  datacenter_id    = var.datacenter
  server_id        = element(profitbricks_server.bbb_server.*.id, count.index)
  nic_id           = element(profitbricks_server.bbb_server.*.primary_nic, count.index)
  protocol         = "UDP"
  name             = "UDP-Ports"
  port_range_start = 16384
  port_range_end   = 32768
}


resource "profitbricks_firewall" "bbb_server_https" {
  count            = var.bbb_server_count
  datacenter_id    = var.datacenter
  server_id        = element(profitbricks_server.bbb_server.*.id, count.index)
  nic_id           = element(profitbricks_server.bbb_server.*.primary_nic, count.index)
  protocol         = "TCP"
  name             = "HTTPS"
  port_range_start = 443
  port_range_end   = 443
}

resource "profitbricks_firewall" "bbb_server_http" {
  count            = var.bbb_server_count
  datacenter_id    = var.datacenter
  server_id        = element(profitbricks_server.bbb_server.*.id, count.index)
  nic_id           = element(profitbricks_server.bbb_server.*.primary_nic, count.index)
  protocol         = "TCP"
  name             = "HTTP"
  port_range_start = 80
  port_range_end   = 80
}


resource "profitbricks_firewall" "bbb_server_turn" {
  count            = var.bbb_server_count
  datacenter_id    = var.datacenter
  server_id        = element(profitbricks_server.bbb_server.*.id, count.index)
  nic_id           = element(profitbricks_server.bbb_server.*.primary_nic, count.index)
  protocol         = "TCP"
  name             = "TURN"
  port_range_start = 3478
  port_range_end   = 3478
}

resource "profitbricks_firewall" "bbb_server_RTMP" {
  count            = var.bbb_server_count
  datacenter_id    = var.datacenter
  server_id        = element(profitbricks_server.bbb_server.*.id, count.index)
  nic_id           = element(profitbricks_server.bbb_server.*.primary_nic, count.index)
  protocol         = "TCP"
  name             = "RTMP"
  port_range_start = 1935
  port_range_end   = 1935
}


resource "profitbricks_firewall" "bbb_server_freeswitch" {
  count            = var.bbb_server_count
  datacenter_id    = var.datacenter
  server_id        = element(profitbricks_server.bbb_server.*.id, count.index)
  nic_id           = element(profitbricks_server.bbb_server.*.primary_nic, count.index)
  protocol         = "TCP"
  name             = "RTMP"
  port_range_start = 7443
  port_range_end   = 7443
}


resource "profitbricks_firewall" "bbb_server_nodeexporter" {
  count            = var.bbb_server_count
  datacenter_id    = var.datacenter
  server_id        = element(profitbricks_server.bbb_server.*.id, count.index)
  nic_id           = element(profitbricks_server.bbb_server.*.primary_nic, count.index)
  protocol         = "TCP"
  name             = "NodeExporter"
  port_range_start = 9100
  port_range_end   = 9100
}
/*
resource "profitbricks_firewall" "bbb_server_internal_nodeexporter" {
  count            = var.bbb_server_count
  datacenter_id    = var.datacenter
  server_id        = element(profitbricks_server.bbb_server.*.id, count.index)
  nic_id           = element(profitbricks_nic.bbb_server_interal.*.id, count.index)
  protocol         = "TCP"
  name             = "NodeExporter"
  port_range_start = 9100
  port_range_end   = 9100
}
*/

resource "profitbricks_firewall" "scalelite_server_ssh" {
  count            = var.scalelite_server_count
  datacenter_id    = var.datacenter
  server_id        = element(profitbricks_server.scalelite_server.*.id, count.index)
  nic_id           = element(profitbricks_server.scalelite_server.*.primary_nic, count.index)
  protocol         = "TCP"
  name             = "SSH"
  port_range_start = 22
  port_range_end   = 22
}

resource "profitbricks_firewall" "scalelite_server" {
  count            = var.scalelite_server_count
  datacenter_id    = var.datacenter
  server_id        = element(profitbricks_server.scalelite_server.*.id, count.index)
  nic_id           = element(profitbricks_server.scalelite_server.*.primary_nic, count.index)
  protocol         = "TCP"
  name             = "Scalelite Server"
  port_range_start = 3000
  port_range_end   = 3000
}


resource "profitbricks_firewall" "scalelite_server_https" {
  count            = var.scalelite_server_count
  datacenter_id    = var.datacenter
  server_id        = element(profitbricks_server.scalelite_server.*.id, count.index)
  nic_id           = element(profitbricks_server.scalelite_server.*.primary_nic, count.index)
  protocol         = "TCP"
  name             = "HTTPS"
  port_range_start = 443
  port_range_end   = 443
}

resource "profitbricks_firewall" "scalelite_server_nodeexporter" {
  count            = var.scalelite_server_count
  datacenter_id    = var.datacenter
  server_id        = element(profitbricks_server.scalelite_server.*.id, count.index)
  nic_id           = element(profitbricks_server.scalelite_server.*.primary_nic, count.index)
  protocol         = "TCP"
  name             = "NodeExporter"
  port_range_start = 9100
  port_range_end   = 9100
}

/*
resource "profitbricks_firewall" "scalelite_internal_nodeexporter" {
  count            = var.scalelite_server_count
  datacenter_id    = var.datacenter
  server_id        = element(profitbricks_server.scalelite_server.*.id, count.index)
  nic_id           = element(profitbricks_nic.scalelite_interal.*.id, count.index)
  protocol         = "TCP"
  name             = "NodeExporter"
  port_range_start = 9100
  port_range_end   = 9100
}
*/
