#controller01, controller02/03
include:
  - openstack.keystone.install

{% set ip = salt['network.interface_ip']('eth0') %}

{% if  pillar['openstack_cluster_info']['mysql_cluster']  == True  %}
   {% set rabbit_ha_queues = 'True' %}
{% else %}
   {% set rabbit_ha_queues = 'False' %}
{% endif %}


{% if pillar['openstack_cluster_info']['mysql_cluster'] == True and ip == pillar['openstack_cluster_info']['controller01']['ip'] %}
create_keystone_db:
   cmd.run:
     - name: |
        mysql -uroot -popenstack -e "create database keystone;"
        mysql -uroot -popenstack -e "grant all privileges on keystone.* to 'keystone'@'localhost' identified by 'openstack';"
        mysql -uroot -popenstack -e "grant all privileges on keystone.* to 'keystone'@'%' identified by 'openstack';"
{% endif %}

backup_keystone_conf:
  cmd.run:
    - name: /usr/bin/cp /etc/keystone/keystone.conf /etc/keystone/keystone.conf_bak$(date +%Y%m%d)

cp_keystone_conf:
  file.managed:
    - name: /etc/keystone/keystone.conf
    - source: salt://openstack/keystone/files/keystone.conf
    - template: jinja
    - defaults:
      passwd: {{ pillar['databases']['keystone']['password'] }}
      local_ip: ip
      rabbit_ha_queues: rabbit_ha_queues
      cluster_ip: {{ pillar['openstack_cluster_info']['cluster_ip']['ip'] }}
      rabbit_userid: {{ pillar['openstack_cluster_info']['rabbitmq_passwd']['rabbit_userid'] }}
      rabbit_password: {{ pillar['openstack_cluster_info']['rabbitmq_passwd']['rabbit_password'] }}

