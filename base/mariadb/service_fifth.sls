{% set ip = salt['network.interface_ip']('eth0') %}
{% set controller01 = pillar['openstack_cluster_info']['controller01']['ip'] %}
{% set controller02 = pillar['openstack_cluster_info']['controller02']['ip'] %}
{% set controller03 = pillar['openstack_cluster_info']['controller03']['ip'] %}


{% if ip == controller01 %}

mysql_install_db:
   cmd.run:
      - name: mysql_install_db --defaults-file=/etc/my.cnf --user=mysql

wsrep-new-cluster:
   cmd.run:
      - name: /usr/sbin/mysqld --wsrep-new-cluster --user=root &

#supervisor_install:
#  pkg.installed:
#    - pkgs:
#      - supervisor
#
#cp_supervisord.conf:
#   file.managed:
#       - name: /etc/supervisord.conf
#       - source: salt://mariadb/files/supervisord.conf
#       - mode: 644
#
#cp_supervisord_mariadb.conf:
#   file.managed:
#       - name: /etc/supervisord.d/mariadb.conf
#       - source: salt://mariadb/files/mariadb.conf
#       - mode: 644
#
#start_mariadb_master_service:
#    cmd.run:
#       - name: |
#          supervisord
#          supervisorctl status mariadb-cluster
{% endif %}

{% if ip in [controller02,controller03] %}
start_mariadb_slave_service:
    service.running:
       - name: mariadb
       - enalbe: True
{% endif %}