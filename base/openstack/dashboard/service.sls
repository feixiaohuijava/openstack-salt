# controller*
include:
  - openstack.dashboard.install

{% set cluster_ip = pillar['openstack_cluster_info']['cluster_ip']['ip'] %}


cp_openstack-dashboard_local_settings:
  file.managed:
    - name: /etc/openstack-dashboard/local_settings
    - source: salt://openstack/dashboard/files/local_settings
    - template: jinja
    - defaults:
       cluster_ip: {{ cluster_ip }}

restart_service_httpd:
  cmd.run:
     - name: systemctl restart httpd

restart_service_memcached:
  cmd.run:
     - name: systemctl restart memcached
