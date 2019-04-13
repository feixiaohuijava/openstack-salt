{% set ip = salt['network.interface_ip']('eth0') %}

{% set controller01 = pillar['openstack_cluster_info']['controller01']['ip'] %}
{% set controller02 = pillar['openstack_cluster_info']['controller02']['ip'] %}
{% set controller03 = pillar['openstack_cluster_info']['controller03']['ip'] %}

{% if ip in [controller01, controller02, controller03] %}
deploy_httpd.conf:
    cmd.run:
        - name: sed -i "s/Listen 8080/Listen 80/" /etc/httpd/conf/httpd.conf

restart_sevice_httpd:
    service.dead:
       - name: httpd
       - enable: True

{% endif %}

{%  if ip == controller01 %}
drop_database_keystone:
    cmd.run:
         - name: mysql -uroot -popenstack -e "drop database keystone;"
{% endif %}