include:
  - mariadb.service

{% set ip = salt['network.ip_addrs']('eth0') %}

mariadb_init:
  file.managed:
    - name: /etc/init.d/script
    - source: salt://script/script
    - mode: 755
    - template: jinja
    - defaults:
      controller_ip: {{ pillar['openstack_cluster_info']['cluster_ip']['ip'] }}
      db_root_passwd: {{ pillar['databases']['root']['password'] }}
      db_openstack_passwd: {{ pillar['databases']['openstack']['password'] }}
      db_keystone_passwd: {{ pillar['databases']['keystone']['password'] }}
      db_glance_passwd: {{ pillar['databases']['glance']['password'] }}
      db_nova_passwd: {{ pillar['databases']['nova']['password'] }}
      db_neutron_passwd: {{ pillar['databases']['neutron']['password'] }}
      db_cinder_passwd: {{ pillar['databases']['cinder']['password'] }}


{% if  pillar['openstack_cluster_info']['mysql_cluster']  == True and ip ==  pillar['openstack_cluster_info']['mariadb_master'] ['ip'] %}
mariadb_master_init:
     cmd.run:
      - name: /etc/init.d/script mysql_passwd
{% elif pillar['openstack_cluster_info']['mysql_cluster'] == True and ip ==  pillar['openstack_cluster_info']['mariadb_slave_one'] ['ip']%}
mariadb_slave_init:
     cmd.run:
       - name: /etc/init.d/script mysql_passwd
{% elif pillar['openstack_cluster_info']['mysql_cluster'] == True and ip ==  pillar['openstack_cluster_info']['mariadb_slave_two']['ip'] %}
mariadb_slave_init:
     cmd.run:
       - name: /etc/init.d/script mysql_passwd
{% elif  pillar['openstack_cluster_info']['mysql_cluster'] == 'flase' %}
mariadb_single_init:
     cmd.run:
        - name: /etc/init.d/script mysql_passwd
{% else %}
mariadb_single_init:
     cmd.run:
        - name: /etc/init.d/script mysql_passwd
{% endif %}
