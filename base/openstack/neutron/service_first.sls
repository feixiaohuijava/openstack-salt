# controller01, controller02/controller03
include:
  - openstack.neutron.install

{% set ip = salt['network.interface_ip']('eth0') %}
{% set cluster_ip = pillar['openstack_cluster_info']['cluster_ip']['ip'] %}
{% if ip == pillar['openstack_cluster_info']['controller01']['ip'] %}
create_neutron_db:
   cmd.run:
      - names:
          - mysql -uroot -popenstack -e "create database neutron;"
          - mysql -uroot -popenstack -e "grant all privileges on neutron.* to 'neutron'@'localhost' identified by 'openstack';"
          - mysql -uroot -popenstack -e "grant all privileges on neutron.* to 'neutron'@'%' identified by 'openstack';"

create_neutron_user:
   cmd.run:
       - name: |
          source /root/admin-openrc
          openstack user create --domain default neutron --password openstack
          openstack role add --project service --user neutron admin

create_neutron_service:
   cmd.run:
       - name: |
          source /root/admin-openrc
          openstack service create --name neutron --description "OpenStack Networking" network
          openstack endpoint create --region RegionOne network public http://{{ cluster_ip }}:9696
          openstack endpoint create --region RegionOne network internal http://{{ cluster_ip }}:9696
          openstack endpoint create --region RegionOne network admin http://{{ cluster_ip }}:9696
          openstack user list
          openstack service list
          openstack endpoint list
{% endif %}

backup_neutron.conf:
   cmd.run:
       - name: cp /etc/neutron/neutron.conf /etc/neutron/neutron.conf_bak$(date +%Y%m%d)


cp_neutron.conf:
   file.managed:
       - name: /etc/neutron/neutron.conf
       - source: salt://openstack/neutron/files/neutron.conf
       - template: jinja
       - defaults:
           local_ip: {{ ip }}
           cluster_ip: {{ cluster_ip }}

cp_neutron_ml2_conf.ini:
   file.managed:
      - name: /etc/neutron/plugins/ml2/ml2_conf.ini
      - source: salt://openstack/neutron/files/ml2_conf.ini

create_soft_link:
   cmd.run:
      - name: ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini


backup_neutron_linuxbridge_agent.ini:
    cmd.run:
       - name: cp /etc/neutron/plugins/ml2/linuxbridge_agent.ini /etc/neutron/plugins/ml2/linuxbridge_agent.ini_bak$(date +%Y%m%d)

cp_neutron_linuxbridge_agent.ini:
    file.managed:
       - name: /etc/neutron/plugins/ml2/linuxbridge_agent.ini
       - source: salt://openstack/neutron/files/linuxbridge_agent.ini


backup_neutron_dhcp_agent.ini:
    cmd.run:
       - name: cp /etc/neutron/dhcp_agent.ini /etc/neutron/dhcp_agent.ini_bak$(date +%Y%m%d)

cp_neutron_dhcp_agent.ini:
    file.managed:
       - name: /etc/neutron/dhcp_agent.ini
       - source: salt://openstack/neutron/files/dhcp_agent.ini


backup_neutron_metadata_agent.ini:
    cmd.run:
       - name: cp /etc/neutron/metadata_agent.ini /etc/neutron/metadata_agent.ini_bak$(date +%Y%m%d)

cp_neutron_metadata_agent.ini:
    file.managed:
       - name: /etc/neutron/metadata_agent.ini
       - source: salt://openstack/neutron/files/metadata_agent.ini
       - template: jinja
       - defaults:
           cluster_ip: {{ cluster_ip }}
