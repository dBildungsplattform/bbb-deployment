# Bigbluebutton ansible playbook

Ansible playbook for various BBB tasks.
Groups:
- dev
- prod
- bbb
- scalelite

Tags:
- update: perform an update of BBB to the latest version
- turn_server: replaces turn server configuration on hosts with roles/bbb/files/turn-stun-servers.xml (for more information see: https://docs.bigbluebutton.org/2.2/setup-turn-server.html#enabling-the-coturn-service)
- set_secret: changes the secret to the bbb_secret value set in group_vars for dev or prod
