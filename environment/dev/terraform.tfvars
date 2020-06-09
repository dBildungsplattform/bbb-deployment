#
# AUTOSCALER
#
autoscaler_min_active_machines=2
autoscaler_waitingtime=300000 # 3min
autoscaler_max_allowed_memory_workload=0.85
autoscaler_min_allowed_memory_workload=0.32
autoscaler_max_worker_memory=16384
autoscaler_max_allowed_cpu_workload=0.70
autoscaler_min_allowed_cpu_workload=0.005
autoscaler_max_worker_cpu=4


#
# SCALING
#
bbb_server_count = 4
bbb_server_memory=12288
bbb_server_cpu=2
scalelite_server_count = 1

#
# GENERAL
#
domainname  = "bbb.messenger.schule"
location = "de/fra"
bbbEmail = "jan.renz@hpi.de"
prefix = "-dev"
ubuntu = "ubuntu-16.04"
turnServerUrl = "turn.hpi.de"

#
# KEY SETTINGS
#
public_key_path = "./../../keys/hpi-dev-pubkey"
private_key_path = "./../../keys/hpi-dev-pk"

