# controller01, controller02/03
{% set ip = salt['network.interface_ip']('eth0') %}
{% if ip == pillar['openstack_cluster_info']['controller01']['ip'] %}


#each sync db operation need more time sleep when it happens
sync_db_first:
   cmd.run:
     - name: |
         source /root/admin-openrc
         su -s /bin/sh -c "nova-manage api_db sync" nova

sync_sleep_first:
   cmd.run:
      - name: sleep 1

sync_db_second:
   cmd.run:
     - name: |
         source /root/admin-openrc
         su -s /bin/sh -c "nova-manage db sync" nova

sync_sleep_second:
   cmd.run:
      - name: sleep 1

sync_db_third:
   cmd.run:
     - name: |
         source /root/admin-openrc
         su -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova

sync_sleep_third:
   cmd.run:
      - name: sleep 1

sync_db_fourth:
   cmd.run:
     - name: |
         source /root/admin-openrc
         su -s /bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova

sync_sleep_fourth:
   cmd.run:
      - name: sleep 1


verify_cell0_and_cell1:
   cmd.run:
     - name: |
         source /root/admin-openrc
         nova-manage cell_v2 list_cells

{% endif %}

cp_00-nova-placement-api.conf:
   file.managed:
       - name: /etc/httpd/conf.d/00-nova-placement-api.conf
       - source: salt://openstack/nova/files/00-nova-placement-api.conf

restart_service_httpd:
   cmd.run:
       - names:
           - systemctl restart httpd
           - systemctl status httpd

start_service_openstack-nova-api:
   service.running:
       - name: openstack-nova-api
       - enable: True

start_service_openstack-nova-consoleauth:
   service.running:
       - name: openstack-nova-consoleauth
       - enable: True

start_service_openstack-nova-scheduler:
   service.running:
       - name: openstack-nova-scheduler
       - enable: True

start_service_openstack-nova-conductor:
   service.running:
       - name: openstack-nova-conductor
       - enable: True

start_service_openstack-nova-novncproxy:
   service.running:
       - name: openstack-nova-novncproxy
       - enable: True

test_nova_service:
   cmd.run:
     - name: |
          source /root/admin-openrc
          nova service-list
