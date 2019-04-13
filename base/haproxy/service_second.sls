# controller01, controller02,controller03

{% set ip = salt['network.interface_ip']('eth0') %}

{% if  pillar['openstack_cluster_info']['mysql_cluster']  == True and ip ==  pillar['openstack_cluster_info']['mariadb_master'] ['ip'] %}
create_clustercheckuser:
   cmd.run:
      - name: |
          mysql -uroot -popenstack -e "grant process on *.* to 'clustercheckuser'@'localhost' identified by 'clustercheckpassword!';"
          mysql -uroot -popenstack -e "flush privileges;"
{% endif %}


{% set mysql_username = pillar['user_info']['mariadb']['mysql_username'] %}
{% set mysql_password = pillar['user_info']['mariadb']['mysql_password'] %}
{% set mysql_host = pillar['user_info']['mariadb']['mysql_host'] %}

cp_etc_sysconfig_clustercheck:
  file.managed:
     - name: /etc/sysconfig/clustercheck
     - source: salt://haproxy/files/etc_sysconfig/clustercheck
     - mode: 644
     - template: jinja
     - defaults:
         clustercheckuser: {{ mysql_username }}
         clustercheckpassword: {{ mysql_password }}

cp_usr_bin_clustercheck:
  file.managed:
     - name: /usr/bin/clustercheck
     - source: salt://haproxy/files/usr_bin/clustercheck


start_service_clustercheck:
   cmd.run:
      - name: |
          chmod +x /usr/bin/clustercheck
          clustercheck