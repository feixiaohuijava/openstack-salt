# controller01 controller02/controller03
{% set ip = salt['network.interface_ip']('eth0') %}
{% if pillar['openstack_cluster_info']['mysql_cluster'] == True and ip == pillar['openstack_cluster_info']['controller01']['ip'] %}
sync_db:
   cmd.run:
      - name: |
          source /root/admin-openrc
          su -s /bin/sh -c "cinder-manage db sync" cinder

wait_sync_db:
   cmd.run:
      - name: sleep 2
{% endif %}




restart_service_openstack-nova-api:
   cmd.run:
      - name: systemctl restart openstack-nova-api

restart_service_openstack-cinder-api:
   cmd.run:
      - name: systemctl restart openstack-cinder-api

restart_service_openstack-cinder-scheduler:
   cmd.run:
      - name: systemctl restart openstack-cinder-scheduler

restart_service_openstack-cinder-volume:
   cmd.run:
      - name: systemctl restart openstack-cinder-volume

restart_service_openstack-cinder-backup:
   cmd.run:
      - name: systemctl restart openstack-cinder-backup

wait_restart_service:
   cmd.run:
      - name: sleep 5

test_cinder:
   cmd.run:
      - name: |
         source /root/admin-openrc
         cinder service-list