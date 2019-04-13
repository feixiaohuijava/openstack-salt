# controller01, controller02/03
include:
  - openstack.nova.install

{% set ip = salt['network.interface_ip']('eth0') %}
{% set cluster_ip = pillar['openstack_cluster_info']['cluster_ip']['ip'] %}
{% if ip == pillar['openstack_cluster_info']['controller01']['ip'] %}
create_nova_db:
   cmd.run:
     - names:
         - mysql -uroot -popenstack -e "create database nova;"
         - mysql -uroot -popenstack -e "create database nova_api;"
         - mysql -uroot -popenstack -e "create database nova_cell0;"
         - mysql -uroot -popenstack -e "grant all privileges on nova.* to 'nova'@'localhost' identified by 'openstack';"
         - mysql -uroot -popenstack -e "grant all privileges on nova.* to 'nova'@'%' identified by 'openstack';"
         - mysql -uroot -popenstack -e "grant all privileges on nova_api.* to 'nova'@'localhost' identified by 'openstack';"
         - mysql -uroot -popenstack -e "grant all privileges on nova_api.* to 'nova'@'%' identified by 'openstack';"
         - mysql -uroot -popenstack -e "grant all privileges on nova_cell0.* to 'nova'@'localhost' identified by 'openstack';"
         - mysql -uroot -popenstack -e "grant all privileges on nova_cell0.* to 'nova'@'%' identified by 'openstack';"

create_nova_user:
   cmd.run:
     - name: |
         source /root/admin-openrc
         openstack user create --domain default nova --password openstack
         openstack role add --project service --user nova admin

create_nova_endpoint:
   cmd.run:
     - name: |
         source /root/admin-openrc
         openstack service create --name nova --description "OpenStack Compute" compute
         openstack endpoint create --region RegionOne compute public http://{{ cluster_ip }}:8774/v2.1
         openstack endpoint create --region RegionOne compute internal http://{{ cluster_ip }}:8774/v2.1
         openstack endpoint create --region RegionOne compute admin http://{{ cluster_ip }}:8774/v2.1

create_placement_user:
   cmd.run:
      - name: |
          source /root/admin-openrc
          openstack user create --domain default placement --password placement
          openstack role add --project service --user placement admin

create_placement_service_and_endpoint:
   cmd.run:
      - name: |
          source /root/admin-openrc
          openstack service create --name placement --description "Placement API" placement
          openstack endpoint create --region RegionOne placement public http://{{ cluster_ip }}:8778
          openstack endpoint create --region RegionOne placement internal http://{{ cluster_ip }}:8778
          openstack endpoint create --region RegionOne placement admin http://{{ cluster_ip }}:8778

verification_user:
   cmd.run:
      - name: |
         source /root/admin-openrc
         openstack user list
         openstack service list
         openstack endpoint list
{% endif %}


backup_nova_conf:
   cmd.run:
      - name: cp /etc/nova/nova.conf /etc/nova/nova.conf_bak$(date +%Y%m%d)

cp_nova_conf:
   file.managed:
     - name: /etc/nova/nova.conf
     - source: salt://openstack/nova/files/nova.conf
     - template: jinja
     - defaults:
         local_ip: {{ ip }}
         cluster_ip: {{ cluster_ip }}

