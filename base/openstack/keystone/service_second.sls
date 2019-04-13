# controller01, controller02/03

{% set ip = salt['network.interface_ip']('eth0') %}


{% if pillar['openstack_cluster_info']['mysql_cluster'] == True and ip == pillar['openstack_cluster_info']['controller01']['ip'] %}
sync_keystone_db:
   cmd.run:
      - name: su -s /bin/sh -c "keystone-manage db_sync" keystone

sync_sleep:
   cmd.run:
      - name: sleep 1
{% endif %}

init_fernet:
   cmd.run:
      - name: |
         keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
         keystone-manage credential_setup --keystone-user keystone --keystone-group keystone