
{% set ip = salt['network.interface_ip']('eth0') %}
{% set controller01 = pillar['openstack_cluster_info']['controller01']['ip'] %}
{% set controller02 = pillar['openstack_cluster_info']['controller02']['ip'] %}
{% set controller03 = pillar['openstack_cluster_info']['controller03']['ip'] %}

kill_process_mysql:
   cmd.run:
      - name: ps -ef | grep mysql | grep -v grep | awk '{print $2}'| xargs kill -9

remove_mariadb_yum:
      pkg.removed:
         - pkgs:
            - MariaDB-server
            - MariaDB-client
            - galera
            - percona-xtrabackup
            - bash-completion
            - xinetd
            - rsync
            - ntp
            - ntpdate
            - socat
            - gcc
            - gcc-c++


rm_rabbitmq_file:
      cmd.run:
         - name:
             rm -rf /etc/my.cnf
             rm -rf /etc/my.cnf.d/
             rm -rf /var/lib/mysql/

touch_file:
  cmd.run:
    - name: |
        touch /etc/my.cnf
        touch /etc/my.cnf.d/client.cnf
        chmod 644 /etc/my.cnf
        chmod 644 /etc/my.cnf.d/client.cnf

cp_my.cnf:
  file.managed:
    - name: /etc/my.cnf
    - source: salt://mariadb/files/my.cnf
