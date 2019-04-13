# controller01, controller02/03

include:
  - openstack.glance.install

{% set ip = salt['network.interface_ip']('eth0') %}
{% set cluster_ip = pillar['openstack_cluster_info']['cluster_ip']['ip'] %}

{% if ip == pillar['openstack_cluster_info']['controller01']['ip'] %}
create_glance_db:
   cmd.run:
     - name: |
         mysql -uroot -popenstack -e "create database glance;"
         mysql -uroot -popenstack -e "grant all privileges on glance.* to 'glance'@'localhost' identified by 'openstack';"
         mysql -uroot -popenstack -e "grant all privileges on glance.* to 'glance'@'%' identified by 'openstack';"

create_glance_user:
   cmd.run:
     - name: |
         source /root/admin-openrc
         openstack user create --domain default glance --password openstack
         openstack role add --project service --user glance admin

create_image_glance_endpoint:
   cmd.run:
     - name: |
         source /root/admin-openrc
         openstack service create --name glance --description "OpenStack Image" image
         openstack endpoint create --region RegionOne image public http://{{ cluster_ip }}:9292
         openstack endpoint create --region RegionOne image internal http://{{ cluster_ip }}:9292
         openstack endpoint create --region RegionOne image admin http://{{ cluster_ip }}:9292
         openstack user list
         openstack service list
         openstack endpoint list
{% endif %}




backup_glance_api_registry:
  cmd.run:
    - name: |
        cp /etc/glance/glance-api.conf /etc/glance/glance-api.conf_bak$(date +%Y%m%d)
        cp /etc/glance/glance-registry.conf /etc/glance/glance-registry.conf_bak$(date +%Y%m%d)

cp_glance_api.conf:
  file.managed:
     - name: /etc/glance/glance-api.conf
     - source: salt://openstack/glance/files/glance-api.conf
     - template: jinja
     - defaults:
          local_ip: {{ ip }}
          cluster_ip: {{ cluster_ip }}


cp_glance_registry.conf:
  file.managed:
     - name: /etc/glance/glance-registry.conf
     - source: salt://openstack/glance/files/glance-registry.conf
     - template: jinja
     - defaults:
          local_ip: {{ ip }}
          cluster_ip: {{ cluster_ip }}

