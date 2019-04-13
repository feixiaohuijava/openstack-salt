#controller*

{% set ip = salt['network.interface_ip']('eth0') %}
{% set master_ip = pillar['openstack_cluster_info']['mariadb_master']['ip'] %}
{% set slave_one_ip = pillar['openstack_cluster_info']['mariadb_slave_one']['ip'] %}
{% set slave_two_ip = pillar['openstack_cluster_info']['mariadb_slave_two']['ip'] %}
{% set password = 'openstack' %}


{% if ip == master_ip %}
{% set hostname = pillar['openstack_cluster_info']['mariadb_master']['hostname'] %}
{% endif %}

{% if ip == slave_one_ip %}
{% set hostname = pillar['openstack_cluster_info']['mariadb_slave_one']['hostname'] %}
{% endif %}

{% if ip == slave_two_ip %}
{% set hostname = pillar['openstack_cluster_info']['mariadb_slave_two']['hostname'] %}
{% endif %}



{% if ip in [master_ip,slave_one_ip,slave_two_ip] %}
# this step need may be not toatolly correct
#mysql_secure_installation:
#   cmd.run:
#     - name: |
#          mysql -e "GRANT ALL PRIVILEGES ON *.* to 'root'@'localhost' identified BY 'openstack';"
#          mysql -uroot -popenstack -e "DROP DATABASE test;"

create_sst_user:
   cmd.run:
     - name: |
          mysql -uroot -popenstack -e "grant all privileges on *.* to 'sst'@'localhost' identified by 'openstack';"
          mysql -uroot -popenstack -e "flush privileges;"

cp_client.cnf:
  file.managed:
    - name: /etc/my.cnf.d/client.cnf
    - source: salt://mariadb/files/client.cnf
    - mode: 644

cp_mysql-clients.cnf:
  file.managed:
    - name: /etc/my.cnf.d/mysql-clients.cnf
    - source: salt://mariadb/files/mysql-clients.cnf
    - mode: 644



cp_server.cnf:
  file.managed:
    - name: /etc/my.cnf.d/server.cnf
    - source: salt://mariadb/files/server.cnf
    - template: jinja
    - mode: 644
    - defaults:
      my_ip: {{ salt['network.interface_ip']('eth0') }}
      master_ip: {{ master_ip }}
      slave_one_ip: {{ slave_one_ip }}
      slave_two_ip: {{ slave_two_ip }}
      hostname: {{ hostname }}
      password: {{ password }}

cp_mariadb.service:
  file.managed:
     - name: /usr/lib/systemd/system/mariadb.service
     - source: salt://mariadb/files/mariadb.service
     - mode: 644


{% endif %}
