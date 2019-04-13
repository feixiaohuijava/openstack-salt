{% set ip = salt['network.interface_ip']('eth0') %}
{% set ceph01 = pillar['openstack_cluster_info']['ceph01']['ip'] %}
{% set ceph02 = pillar['openstack_cluster_info']['ceph02']['ip'] %}
{% set ceph03 = pillar['openstack_cluster_info']['ceph03']['ip'] %}
{% set public_network = pillar['openstack_cluster_info']['public_network'] %}

{% if ip == pillar['openstack_cluster_info']['ceph01']['ip'] %}
ceph01_install:
  pkg.installed:
    - pkgs:
      - ceph-deploy
      - python-rbd
      - ceph-common
{% endif %}


include:
  - ceph.ceph-mon.install

{% if ip == pillar['openstack_cluster_info']['ceph01']['ip'] %}
create_ceph_cluster:
    cmd.run:
      - name: |
         mkdir /etc/ceph
         cd /etc/ceph
         ceph-deploy new ceph01 ceph02 cep03

create_ceph_monitor:
    cmd.run:
      - name: ceph-deploy mon create-initial

create_ceph_admin_config:
    cmd.run:
      - name: ceph-deploy admin  ceph01 ceph02 ceph03

create_ceph_mgr:
    cmd.run:
      - name: ceph-deploy mgr create  ceph01  ceph02  ceph03

{% endif %}

cp_ceph.conf:
    file.managed:
       - name: /etc/ceph.conf/ceph.conf
       - source: salt://ceph/ceph-mon/files/ceph.conf
       - template: jinja
       - defaults:
            ceph01: {{ ceph01 }}
            ceph02: {{ ceph02 }}
            ceph03: {{ ceph03 }}
            public_network: {{ public_network }}

{% if ip == pillar['openstack_cluster_info']['ceph01']['ip'] %}
sync_config:
   cmd.run:
      - name: ceph-deploy --overwrite-conf admin  ceph01 ceph02 ceph03

start_server_mgr_ceph01:
   cmd.run:
      - name: ceph mgr module enable dashboard
{% endif %}

start_server_mgr_all:
   cmd.run:
      - name: |
         ceph config-key put mgr/dashboard/server_addr  0.0.0.0
         ceph config-key put mgr/dashboard/server_port 7000
         systemctl restart ceph-mgr@ceph01
         systemctl restart ceph-mgr@ceph02
         systemctl restart ceph-mgr@ceph03
