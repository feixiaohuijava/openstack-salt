#controller01, controller02/03

{% set ip = salt['network.interface_ip']('eth0') %}
{% if ip == pillar['openstack_cluster_info']['controller01']['ip'] %}
db_sync:
  cmd.run:
    - name: su -s /bin/sh -c "glance-manage db_sync" glance

wait_db_sync:
  cmd.run:
      - name: sleep 5
{% endif %}


start_glance_api_sercie:
      service.running:
          - name: openstack-glance-api
          - enable: True


start_glance_registry_sercie:
      service.running:
          - name: openstack-glance-registry
          - enable: True
