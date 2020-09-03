//BBB Server
resource "profitbricks_server" "bbb_server" {
  count             = var.bbb_server_count
  name              = "bbb${var.prefix}-server${count.index + 1}"
  datacenter_id     = var.datacenter
  cores             = var.bbb_server_cpu
  ram               = var.bbb_server_memory
  availability_zone = count.index % 2 == 1 ? "ZONE_1" : "ZONE_2"
  cpu_family        = "INTEL_XEON"
  volume {
    name         = "hdd-${var.prefix}-${count.index + 1}"
    image_name   = var.ubuntu
    size         = 50
    disk_type    = "HDD"
    ssh_key_path = ["${var.public_key_path}"]
  }
  nic {
    lan             = profitbricks_lan.bbb_server_lan.id
    dhcp            = true
    ip              = var.bbb_reserved_ips[count.index]
    name            = "public"
    firewall_active = true
  }

  depends_on = [null_resource.provisioner_scale]
}


resource "null_resource" "provisioner-bbb" {
  count = var.bbb_server_count

  triggers = {
    master_id = element(profitbricks_firewall.bbb_server_ssh.*.id, count.index)
  }

  connection {
    host        = element(profitbricks_server.bbb_server.*.primary_ip, count.index)
    type        = "ssh"
    user        = "root"
    private_key = file("${var.private_key_path}")
  }

  provisioner "file" {
    source      = "./../../files/bbb-files/"
    destination = "/tmp/"
  }

  provisioner "file" {
    source      = "./../../keys/"
    destination = "/root/.ssh/"
  }

  # set hostname
  provisioner "remote-exec" {
    inline = [
      //update server
      "sudo chmod 400 /root/.ssh/*",
      "sudo apt-get update",
      "sudo apt-get dist-upgrade -q -y",
      // Systen Requirements
      "sudo apt-get install language-pack-en",
      "sudo update-locale LANG=en_US.UTF-8",
      "sudo systemctl set-environment LANG=en_US.UTF-8",
      //necessary for bbb
      "sudo apt-get install haveged fail2ban vim apt-transport-https software-properties-common net-tools python3-apt openssh-server pwgen xinetd -q -y",
      "sudo apt-get update",
      "sudo apt-get dist-upgrade -q -y",

      //preinstall steps
      //change hostname
      "sudo hostname bbb${var.prefix}-${count.index + 1}.${var.domainname}",
      "sudo sed -i 's/127.0.1.1	ubuntu/element(profitbricks_server.bbb_server.*.primary_ip, count.index) bbb${var.prefix}-${count.index + 1}.${var.domainname}/g' /etc/hosts",

      //Install bigbluebutton
      "sudo wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh > bbb-install.sh",
      "sudo chmod a+x bbb-install.sh",

      "sudo ./bbb-install.sh -v xenial-22 -s bbb${var.prefix}-${count.index + 1}.${var.domainname} -e ${var.bbbEmail} -c ${var.turnServerUrl}:${var.turnServerPw} > bbb-install.log",

      // Setup Nginx
      "sudo cp -r /tmp/cert/* /etc/letsencrypt/",
      // change default presentation
      "sudo mv /tmp/BBB-default-presentation-2.pdf /var/www/bigbluebutton-default/default.pdf",

      "sudo mv /tmp/bigbluebutton /etc/nginx/sites-available/bigbluebutton",
      "sudo sed -e 's|###bbb_subdomain###|bbb${var.prefix}-${count.index + 1}.${var.domainname}|g' -i /etc/nginx/sites-available/bigbluebutton",

      "sudo sed -e 's|http://|https://|g' -i /var/www/bigbluebutton/client/conf/config.xml",
      "sudo sed -e 's|http://|https://|g' -i /usr/share/red5/webapps/screenshare/WEB-INF/screenshare.properties",
      "sudo sed -e 's|wsUrl: ws://|wsUrl: wss://|g' -i /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml",
      "sudo sed -e 's|url: http://|url: https://|g' -i /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml",
      "sudo sed -e 's|playback_protocol: http|playback_protocol: https|g' -i /usr/local/bigbluebutton/core/scripts/bigbluebutton.yml",
      "sudo sed -e 's|http://|https://|g' -i /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties",
      "sudo sed -e 's|disableRecordingDefault=false|disableRecordingDefault=true|g' -i /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties",
      "sudo sed -e 's|breakoutRoomsRecord=true|breakoutRoomsRecord=false|g' -i /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties",
      "sudo sed -e 's|http://|https://|g' -i /etc/bigbluebutton/nginx/sip.nginx",
      "sudo sed -e 's|5066|7443|g' -i /etc/bigbluebutton/nginx/sip.nginx",

      "sudo ufw allow 7443",
      "sudo ufw allow 6379",

      "sudo systemctl restart nginx.service",

      // Configure bbb
      "mv /tmp/apply-config.sh /etc/bigbluebutton/bbb-conf/apply-config.sh",
      "chmod a+x /etc/bigbluebutton/bbb-conf/apply-config.sh",
      "sudo /etc/bigbluebutton/bbb-conf/apply-config.sh",

      "sudo bbb-conf --check",
      "sudo bbb-conf --setsecret ${var.scalite_secret_lb}",
      "sudo bbb-conf --restart",

      # Create a new group with GID 2000
      "groupadd -g 2000 scalelite-spool",
      # Add the bigbluebutton user to the group
      "usermod -a -G scalelite-spool bigbluebutton",

      # add server to scalelite
      "sudo mv /tmp/register-bbb.sh ~",
      "sudo chmod a+x ~/register-bbb.sh",
      "sudo ./register-bbb.sh ${var.domainname} scalelite${var.prefix} ~/.ssh/hpi${var.prefix}-pk",

      # install node exporter
      "sudo apt install apache2-utils -q -y",
      "sudo ufw allow 9100",

      # create basic auth user + passwort
      "htpasswd -b -B -C 10 -c ~/password.dat ${var.ne_user} ${var.ne_pw}",

      "sudo mv /tmp/nodeexporter_webconfig.yml /usr/local/bin/nodeExporter_webconfig.yml",
      "sudo mv /tmp/installNodeExporter.sh ~",
      "sudo chmod a+x ~/installNodeExporter.sh",
      "sudo ~/installNodeExporter.sh ~/password.dat",
      "sudo chown node_exporter:node_exporter /usr/local/bin/nodeExporter_webconfig.yml",
      "sudo mkdir -p /etc/node_exporter",
      "sudo chown node_exporter:node_exporter /etc/node_exporter",
      "sudo chmod 700 /etc/node_exporter",
      "sudo cp /etc/letsencrypt/live/bbb.messenger.schule/fullchain.pem /etc/node_exporter/fullchain.pem",
      "sudo cp /etc/letsencrypt/live/bbb.messenger.schule/privkey.pem /etc/node_exporter/privkey.pem",
      "sudo chown node_exporter:node_exporter /etc/node_exporter/*.pem",
      "sudo systemctl enable node_exporter",
      "sudo systemctl start node_exporter",
      
      # cleanup
      "rm password.dat"
    ]
  }
}
