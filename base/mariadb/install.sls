mariadb_install:
  pkg.installed:
    - pkgs:
      - MariaDB-server 
      - MariaDB-client
      - python2-PyMySQL
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
      - perl-Digest-MD5 
      - perl-DBD-MySQL

#openstack.cnf:
#  file.managed:
#    - name: /etc/my.cnf.d/openstack.cnf
#    - source: salt://mariadb/files/openstack.cnf
#    - template: jinja
#    - defaults:
#      my_ip: {{ salt['network.ip_addrs']('br-mgr') }}
#
#server.cnf:
#  file.managed:
#    - name: /etc/my.cnf.d/server.cnf
#    - source: salt://mariadb/files/server.cnf
#    - template: jinja
#    - defaults:
#      my_ip: {{ salt['network.ip_addrs']('eth0') }}
#      master_ip: {{ pillar['openstack_cluster_info']['mariadb_master']['ip'] }}
#      slave_one_ip: {{ pillar['openstack_cluster_info']['mariadb_slave_one']['ip'] }}
#      slave_two_ip: {{ pillar['openstack_cluster_info']['mariadb_slave_two']['ip'] }}
#      hostname: {{  grains['id'] }}
#
#mysql-clients.cnf:
#  file.managed:
#    - name: /etc/my.cnf.d/mysql-clients.cnf
#    - source: salt://mariadb/files/mysql-clients.cnf
#
#client.cnf:
#  file.managed:
#    - name: /etc/my.cnf.d/client.cnf
#    - source: salt://mariadb/files/client.cnf