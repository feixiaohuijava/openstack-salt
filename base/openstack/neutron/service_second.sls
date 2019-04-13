# controller01, controller02,controller03
{% set ip = salt['network.interface_ip']('eth0') %}
{% if pillar['openstack_cluster_info']['mysql_cluster'] == True and ip == pillar['openstack_cluster_info']['controller01']['ip'] %}
sync_db:
   cmd.run:
      - name: |
          source /root/admin-openrc
          su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron

sync_db_sleep:
   cmd.run:
      - name: sleep 1
{% endif %}



restart_service_nova-api:
    cmd.run:
       - names:
            - systemctl restart openstack-nova-api
            - systemctl status openstack-nova-api

start_service_neutron-server:
    service.running:
       - name: neutron-server
       - enable: True

start_service_neutron-linuxbridge-agent:
    service.running:
       - name: neutron-linuxbridge-agent
       - enable: True

start_service_neutron-dhcp-agent:
    service.running:
       - name: neutron-dhcp-agent
       - enable: True

start_service_neutron-metadata-agent:
    service.running:
       - name: neutron-metadata-agent
       - enable: True

restart_all_service:
    cmd.run:
       - names:
           - systemctl restart neutron-server neutron-linuxbridge-agent neutron-dhcp-agent neutron-metadata-agent
           - systemctl status neutron-server neutron-linuxbridge-agent neutron-dhcp-agent neutron-metadata-agent

wait_restart_all_service:
    cmd.run:
       - name: sleep 5

test_neutron:
    cmd.run:
       - name: |
           source /root/admin-openrc
           openstack network agent list