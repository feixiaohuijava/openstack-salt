#controller01

{% set ip = salt['network.interface_ip']('eth0') %}

{% if ip == pillar['openstack_cluster_info']['controller01']['ip'] %}
scp_keystone_fernet-keys:
   cmd.run:
      - name: |
         scp -p /etc/keystone/fernet-keys/* root@controller02:/etc/keystone/fernet-keys/
         scp -p /etc/keystone/fernet-keys/* root@controller03:/etc/keystone/fernet-keys/
{% endif %}