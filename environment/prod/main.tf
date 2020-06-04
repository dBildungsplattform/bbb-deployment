module "bbb-setup" {
  source                 = "./../../modules/bbb-setup/"
  hpi_ionos_user         = var.hpi_ionos_user
  hpi_ionos_pw           = var.hpi_ionos_pw
  domainname             = var.domainname
  prefix                 = var.prefix
  datacenter             = var.datacenter
  location               = var.location
  turnServerUrl          = var.turnServerUrl
  turnServerPw           = var.turnServerPw
  bbbEmail               = var.bbbEmail
  ubuntu                 = var.ubuntu
  public_key_path        = var.public_key_path
  private_key_path       = var.private_key_path
  bbb_server_count       = var.bbb_server_count
  bbb_server_memory      = var.bbb_server_memory
  scalelite_server_count = var.scalelite_server_count
  scalite_secret         = var.scalite_secret
  scalite_secret_lb      = var.scalite_secret_lb
  scalite_pg_pw          = var.scalite_pg_pw
  scalite_pg_ip          = var.scalite_pg_ip
  scalite_redisurl       = var.scalite_redisurl
  //scalite_reddis_ip      = var.scalite_reddis_ip
  bbb_reserved_ips       = var.bbb_reserved_ips
  scalelite_reserved_ips  = var.scalelite_reserved_ips
  autoscaler_min_active_machines = var.autoscaler_min_active_machines
  autoscaler_waitingtime  =var.autoscaler_waitingtime # 3min
  autoscaler_max_allowed_workload=var.autoscaler_max_allowed_workload
  autoscaler_min_allowed_workload=var.autoscaler_min_allowed_workload
  autoscaler_max_worker_memory=var.autoscaler_max_worker_memory
  autoscaler_grafana_token=var.autoscaler_grafana_token

}
