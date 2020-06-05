//Scalelite Server
resource "profitbricks_server" "scalelite_server" {
  count             = var.scalelite_server_count
  name              = "scalelite-server${count.index}"
  datacenter_id     = var.datacenter
  cores             = 2
  ram               = 4096
  availability_zone = count.index % 2 == 1 ? "ZONE_1" : "ZONE_2"
  cpu_family        = "INTEL_XEON"
  volume {
    name         = "scalelite-hdd-${count.index}"
    image_name   = var.ubuntu
    size         = 32
    disk_type    = "HDD"
    ssh_key_path = ["${var.public_key_path}"]
  }
  nic {
    lan             = profitbricks_lan.bbb_server_lan.id
    dhcp            = true
    ip              = var.scalelite_reserved_ips[count.index]
    firewall_active = true
    name            = "public"
  }

}

resource "null_resource" "provisioner_scale" {
  count = var.scalelite_server_count

  triggers = {
    master_id = element(profitbricks_firewall.scalelite_server_ssh.*.id, count.index)
  }

  connection {
    host        = element(profitbricks_server.scalelite_server.*.primary_ip, count.index)
    type        = "ssh"
    user        = "root"
    private_key = file("${var.private_key_path}")
  }

  provisioner "file" {
    source      = "./../../files/scalelite-files/"
    destination = "/tmp"
  }

  # set hostname
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get dist-upgrade -q -y",
      "sudo apt install docker.io docker-ce docker-ce-cli containerd.iocertbot python3-psycopg2 python-psycopg2 python-ipaddress python-ipaddr python-docker python3-docker postgresql postgresql-contrib redis-server acl -q -y",
      "sudo apt-get update",
      "sudo apt-get dist-upgrade -q -y",
      "sudo update-locale LANG=en_US.UTF-8",
      "sudo systemctl set-environment LANG=en_US.UTF-8",
      "chmod a+x /tmp/install-requirements.sh",
      "sudo /tmp/install-requirements.sh",

      //change hostname
      "sudo hostname scalelite${var.prefix}.${var.domainname}",
      "sudo sed -i 's/127.0.1.1	ubuntu/element(profitbricks_server.scalelite_server.*.primary_ip, count.index) scalelite${var.prefix}.${var.domainname}/g' /etc/hosts",

      # Setting up directory structure and permissions
      # Create the spool directory for recording transfer from BigBlueButton
      "mkdir -p /mnt/scalelite-recordings/var/bigbluebutton/spool",
      "chown 1000:2000 /mnt/scalelite-recordings/var/bigbluebutton/spool",
      "chmod 0775 /mnt/scalelite-recordings/var/bigbluebutton/spool",

      # Create the temporary (working) directory for recording import
      "mkdir -p /mnt/scalelite-recordings/var/bigbluebutton/recording/scalelite",
      "chown 1000:1000 /mnt/scalelite-recordings/var/bigbluebutton/recording/scalelite",
      "chmod 0775 /mnt/scalelite-recordings/var/bigbluebutton/recording/scalelite",

      # Create the directory for published recordings
      "mkdir -p /mnt/scalelite-recordings/var/bigbluebutton/published",
      "chown 1000:1000 /mnt/scalelite-recordings/var/bigbluebutton/published",
      "chmod 0775 /mnt/scalelite-recordings/var/bigbluebutton/published",

      # Create the directory for unpublished recordings
      "mkdir -p /mnt/scalelite-recordings/var/bigbluebutton/unpublished",
      "mkdir -p /var/bigbluebutton",
      "chown 1000:1000 /mnt/scalelite-recordings/var/bigbluebutton/unpublished",
      "chmod 0775 /mnt/scalelite-recordings/var/bigbluebutton/unpublished",

      "mkdir /etc/docker/compose",
      "mkdir /etc/docker/compose/scalelite",

      "sudo mv /tmp/docker-compose.yaml ~/",
      "sudo mv /tmp/docker-vars.env ~/.env",

      // adjust config
      "sudo sed -i 's/###hostname###/scalelite${var.prefix}.${var.domainname}/g' ~/.env",
      "sudo sed -i 's/###scalelite_secret_key_base###/${var.scalite_secret}/g' ~/.env",
      "sudo sed -i 's/###scalelite_loadbalancer_secret###/${var.scalite_secret_lb}/g' ~/.env",
      "sudo sed -i 's/###scalelite_pg_password###/${var.scalite_pg_pw}/g' ~/.env",
      "sudo sed -i 's/###scalelite_secondaryip###/${var.scalite_pg_ip}/g' ~/.env",
      "sudo sed -i 's/###scalelite_redisurl###/${var.scalite_redisurl}/g' ~/.env",
      "sudo sed -i 's/###email_contanct###/${var.bbbEmail}/g' ~/.env",
      "sudo sed -i 's/###datacenter###/${var.datacenter}/g' ~/.env",
      "sudo sed -i 's/###ionos_user###/${var.hpi_ionos_user}/g' ~/.env",
      "sudo sed -i 's/###ionos_pw###/${var.hpi_ionos_pw}/g' ~/.env",
      "sudo sed -i 's/###min_active_machines###/${var.autoscaler_min_active_machines}/g' ~/.env",
      "sudo sed -i 's/###waitingtime###/${var.autoscaler_waitingtime}/g' ~/.env",
      "sudo sed -i 's/###max_allowed_memory_workload###/${var.autoscaler_max_allowed_memory_workload}/g' ~/.env",
      "sudo sed -i 's/###min_allowed_memory_workload###/${var.autoscaler_min_allowed_memory_workload}/g' ~/.env",
      "sudo sed -i 's/###max_allowed_cpu_workload###/${var.autoscaler_max_allowed_cpu_workload}/g' ~/.env",
      "sudo sed -i 's/###min_allowed_cpu_workload###/${var.autoscaler_min_allowed_cpu_workload}/g' ~/.env",
      "sudo sed -i 's/###max_worker_memory###/${var.autoscaler_max_worker_memory}/g' ~/.env",
      "sudo sed -i 's/###max_worker_cpu###/${var.autoscaler_max_worker_cpu}/g' ~/.env",
      "sudo sed -i 's/###default_worker_memory###/${var.bbb_server_memory}/g' ~/.env",
      "sudo sed -i 's/###default_worker_cpu###/${var.bbb_server_cpu}/g' ~/.env",
      "sudo sed -i 's/###grafana_token###/${var.autoscaler_grafana_token}/g' ~/.env",
      "sudo sed -i 's/###ne_basic_auth_user###/${var.ne_user}/g' ~/.env",
      "sudo sed -i 's/###ne_basic_auth_pass###/${var.ne_pw}/g' ~/.env",
      
      // move data certificates and nginx files
      "sudo mv -f /tmp/data/ ~/",
      "sudo mv -f ~/data/cert/live/scalelite.bbb.messenger.schule/ ~/data/cert/live/scalelite${var.prefix}.${var.domainname}/",

      // start services
      "cd ~",
      "docker-compose build",
      "docker-compose up -d",

      // start db-setup
      "docker exec -it scalelite-api bin/rake db:setup",

      # install node exporter
      # create basic auth user + passwort
      "sudo apt install apache2-utils -q -y",
      #htpasswd -nBC 10 "" | tr -d ':\n'
      "htpasswd -b -B -C 10 -c password.dat ${var.ne_user} ${var.ne_pw}",

      "sudo mv /tmp/nodeexporter_webconfig.yml /usr/local/bin/nodeExporter_webconfig.yml",
      "sudo mv /tmp/installNodeExporter.sh ~",
      "sudo chmod a+x ~/installNodeExporter.sh",
      "sudo ~/installNodeExporter.sh ~/password.dat",
      "sudo chown node_exporter:node_exporter /usr/local/bin/nodeExporter_webconfig.yml",
      "sudo mkdir -p /etc/node_exporter",
      "sudo chown node_exporter:node_exporter /etc/node_exporter",
      "sudo chmod 700 /etc/node_exporter",
      "sudo cp ~/data/cert/live/scalelite${var.prefix}.${var.domainname}/fullchain.pem /etc/node_exporter/fullchain.pem",
      "sudo cp ~/data/cert/live/scalelite${var.prefix}.${var.domainname}/privkey.pem /etc/node_exporter/privkey.pem",
      "sudo chown node_exporter:node_exporter /etc/node_exporter/*.pem",
      "sudo systemctl enable node_exporter",
      "sudo systemctl start node_exporter",

      # cleanup
      "rm password.dat"
    ]
  }
}
