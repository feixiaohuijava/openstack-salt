{% set ip = salt['network.interface_ip']('eth0') %}
{% set controller01 = pillar['openstack_cluster_info']['controller01']['ip'] %}
{% set controller02 = pillar['openstack_cluster_info']['controller02']['ip'] %}
{% set controller03 = pillar['openstack_cluster_info']['controller03']['ip'] %}

{% if ip == controller01 %}
kill_process_mysql:
   cmd.run:
      - name: ps -ef | grep mysql | grep -v grep | awk '{print $2}'| xargs kill -9

start_serivce_mariadb:
   service.running:
      - name: mariadb

{% endif %}

{% if ip in [controller01,controller02,controller03] %}
see_status_mariadb:
   cmd.run:
      - name: |
          mysql -uroot -popenstack -e "show status like 'wsrep_cluster_size%';"
          mysql -uroot -popenstack -e "show variables like 'wsrep_sst_meth%';"
          mysql -uroot -popenstack -e "show variables like 'max_connections';"
{% endif %}