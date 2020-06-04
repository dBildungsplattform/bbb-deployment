#
# AUTOSCALER
#
autoscaler_min_active_machines=3
autoscaler_waitingtime=300000 # 5min
autoscaler_max_allowed_workload=0.80
autoscaler_min_allowed_workload=0.22
autoscaler_max_worker_memory=16384

#
# SCALING
#
bbb_server_count = 25
bbb_server_memory=12288
scalelite_server_count = 1

#
# GENERAL
#
domainname  = "bbb.messenger.schule"
location = "de/fra"
bbbEmail = "jan.renz@hpi.de"
prefix = ""
ubuntu = "ubuntu-16.04"
turnServerUrl = "turn.hpi.de"

#
# KEY SETTINGS
#
public_key_path = "./../../keys/hpi-pubkey"
private_key_path = "./../../keys/hpi-pk"
