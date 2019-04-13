# compute01, compute02
include:
  - openstack.nova-compute.install

{% set ip = salt['network.interface_ip']('eth0') %}
{% set cluster_ip = pillar['openstack_cluster_info']['cluster_ip']['ip'] %}
{% set compute02 = pillar['openstack_cluster_info']['compute02']['ip'] %}
{% set virt_type = 'qemu' %}

backup_nova.conf:
   cmd.run:
      - name: cp /etc/nova/nova.conf /etc/nova/nova.conf_bak$(date +%Y%m%d)



cp_nova.conf:
   file.managed:
      - name: /etc/nova/nova.conf
      - source: salt://openstack/nova-compute/files/nova.conf
      - template: jinja
      - defaults:
           local_ip: {{ ip }}
           cluster_ip: {{ cluster_ip }}
           virt_type: {{ virt_type }}


{% if ip == compute02 %}
cp_libvirtd.conf:
   file.managed:
      - name: /etc/libvirt/libvirtd.conf
      - source: salt://openstack/nova-compute/files/libvirtd.conf

cp_qemu.conf:
   file.managed:
      - name: /etc/libvirt/qemu.conf
      - source: salt://openstack/nova-compute/files/qemu.conf


{% endif %}

start_service_libvirtd_firsttime:
   cmd.run:
       - names:
           - systemctl enable libvirtd
           - systemctl start libvirtd

start_service_openstack-nova-compute:
   cmd.run:
       - names:
            - systemctl enable openstack-nova-compute
            - systemctl start openstack-nova-compute

