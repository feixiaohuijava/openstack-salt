# controller01

{% set ip = salt['network.interface_ip']('eth0') %}

{% if ip == pillar['openstack_cluster_info']['controller01']['ip']%}

sync_db:
  cmd.run:
     - name: su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova

wait_sync_db_done:
  cmd.run:
     - name: sleep 1

test_nova-compute:
   cmd.run:
       - name: |
          source /root/admin-openrc
          nova service-list
{% endif %}