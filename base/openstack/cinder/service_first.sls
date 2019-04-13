# controller*
{% set ip = salt['network.interface_ip']('eth0') %}
{% set cluster_ip = pillar['openstack_cluster_info']['cluster_ip']['ip'] %}
{% if pillar['openstack_cluster_info']['mysql_cluster'] == True and ip == pillar['openstack_cluster_info']['controller01']['ip'] %}
create_cinder_db:
    cmd.run:
       - names:
          - mysql -uroot -popenstack -e "create database cinder;"
          - mysql -uroot -popenstack -e "grant all privileges on cinder.* to 'cinder'@'localhost' identified by 'openstack';"
          - mysql -uroot -popenstack -e "grant all privileges on cinder.* to 'cinder'@'%' identified by 'openstack';"

create_cinder_user:
    cmd.run:
       - name: |
          source /root/admin-openrc
          openstack user create --domain default cinder --password openstack
          openstack role add --project service --user cinder admin

create_service_endpoint_cinder_and_cinderv2:
    cmd.run:
       - name: |
          source /root/admin-openrc
          openstack service create --name cinderv2 --description "OpenStack Block Storage" volumev2
          openstack service create --name cinderv3 --description "OpenStack Block Storage" volumev3
          openstack endpoint create --region RegionOne volumev2 public http://{{ cluster_ip }}:8776/v2/%\(tenant_id\)s
          openstack endpoint create --region RegionOne volumev2 internal http://{{ cluster_ip }}:8776/v2/%\(tenant_id\)s
          openstack endpoint create --region RegionOne volumev2 admin http://{{ cluster_ip }}:8776/v2/%\(tenant_id\)s
          openstack endpoint create --region RegionOne volumev3 public http://{{ cluster_ip }}:8776/v3/%\(project_id\)s
          openstack endpoint create --region RegionOne  volumev3 internal http://{{ cluster_ip }}:8776/v3/%\(project_id\)s
          openstack endpoint create --region RegionOne  volumev3 admin http://{{ cluster_ip }}:8776/v3/%\(project_id\)s
          openstack user list
          openstack service list
          openstack endpoint list
{% endif %}

include:
  - openstack.cinder.install


backup_cinder.conf:
    cmd.run:
      - name: cp /etc/cinder/cinder.conf /etc/cinder/cinder.conf_bak$(date +%Y%m%d)

cp_cinder.conf:
    file.managed:
      - name: /etc/cinder/cinder.conf
      - source: salt://openstack/cinder/files/cinder.conf
      - template: jinja
      - defaults:
         local_ip: {{ ip }}
         cluster_ip: {{ cluster_ip }}




