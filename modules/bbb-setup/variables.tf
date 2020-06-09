#
# AUTOSCALER
#

variable "autoscaler_min_active_machines" {
  type        = number
  description = "minimum number of nodes which will not be stopped from autoscaler"
}
variable "autoscaler_waitingtime" {
  type        = number
  description = "timeframe which autoscaler will check cluster"
}

## memory
variable "autoscaler_max_allowed_memory_workload" {
  type        = number
  description = "percentage at which new machines will be started or scaled up"
}

variable "autoscaler_min_allowed_memory_workload" {
  type        = number
  description = "percentage at which existing machines will be stopped or scaled down"
}

variable "autoscaler_max_worker_memory" {
  type        = number
  description = "max amount of memory autoscaler is able to increase"
}

## cpu
variable "autoscaler_max_allowed_cpu_workload" {
  type        = number
  description = "percentage at which new machines will be started or scaled up"
}

variable "autoscaler_min_allowed_cpu_workload" {
  type        = number
  description = "percentage at which existing machines will be stopped or scaled down"
}

variable "autoscaler_max_worker_cpu" {
  type        = number
  description = "max amount of cpu autoscaler is able to increase"
}

variable "autoscaler_grafana_token" {
  type    = string
  description = "generated grafana token for access to prometheus api"
}

variable "autoscaler_grafana_endpoint" {
  type    = string
  description = "Grafana endpoint for access to prometheus api"
}


#
# IONOS LOGIN
#
# from secrets.tfvars
variable "hpi_ionos_user" {
  type    = string
}

# from secrets.tfvars
variable "hpi_ionos_pw" {
  type    = string
}

#
# GENERAL
#
variable "domainname" {
  type    = string
}

variable "location" {
  type    = string
}

variable "bbbEmail" {
  type    = string
}

variable "prefix" {
  type    = string
}


# from secrets.tfvars
variable "datacenter" {
  type        = string
 description = "[DEV] HPI Datacenter BBB"
}

variable "ubuntu" {
  description = "Ubuntu Server"
}

#
# TURNSERVER
#
variable "turnServerUrl" {
  type    = string
}

# from secrets.tfvars
variable "turnServerPw" {
  type    = string
}

#
# SCALING
#
variable "bbb_server_count" {
  type        = number
  description = "number of bbb-servers"
}

variable "bbb_server_memory" {
  type        = number
  description = "memory of bbb server"
}

variable "bbb_server_cpu" {
  type        = number
  description = "cpu of bbb server"
}


variable "scalelite_server_count" {
  type        = number
  description = "number of scalelite-servers"
}

#
# SCALELITE
#
# from secrets.tfvars
variable "scalite_secret" {
  type    = string
}

# from secrets.tfvars
variable "scalite_secret_lb" {
  type    = string
}

# from secrets.tfvars
variable "bbb_reserved_ips" {
  type    = list(string)
}

# from secrets.tfvars
variable "scalelite_reserved_ips" {
  type    = list(string)
}

# from secrets.tfvars
variable "ne_user" {
  type    = string
}

# from secrets.tfvars
variable "ne_pw" {
  type    = string
}


#
# MIDDLEWEAR
#
# from secrets.tfvars
variable "scalite_pg_pw" {
  type    = string
}

# from secrets.tfvars
variable "scalite_pg_ip" {
  type    = string
}

# from secrets.tfvars
variable "scalite_redisurl" {
  type    = string
}

#
# KEY SETTINGS
#
variable "public_key_path" {
  type    = string
}
variable "private_key_path" {
  description = "Path to file containing private key"
}
