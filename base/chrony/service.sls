# controller01, controller02/controller03/compute01/compute02
include:
  - chrony.install

{% set ip = salt['network.interface_ip']('eth0') %}

{% set controller01 = pillar['openstack_cluster_info']['controller01']['ip'] %}
{% set controller02 = pillar['openstack_cluster_info']['controller02']['ip'] %}
{% set controller03 = pillar['openstack_cluster_info']['controller03']['ip'] %}
{% set compute01 = pillar['info']['compute01']['ip'] %}
{% set compute02 = pillar['info']['compute02']['ip'] %}

{% if ip == controller01 %}
backup_chrony_conf:
     cmd.run:
        - name: |
            cp /etc/chrony.conf /etc/chrony.conf_bak`date +%Y%m%d`
            sed -i 's/^server \(.*\)/#server \1/g' /etc/chrony.conf
            sed -i '/#server 3.centos.pool.ntp.org iburst/a\server time.windows.com iburst' /etc/chrony.conf

cp_chrony_conf:
     cmd.run:
        - name: |
           scp -p /etc/chrony.conf root@{{ controller02 }}:/etc/chrony.conf
           scp -p /etc/chrony.conf root@{{ controller03 }}:/etc/chrony.conf
           scp -p /etc/chrony.conf root@{{ compute01 }}:/etc/chrony.conf
           scp -p /etc/chrony.conf root@{{ compute02 }}:/etc/chrony.conf

{% endif %}

{% if ip in [controller01, controller02, controller03, compute01, compute02] %}

chrony_service:
   service.running:
      - name: chronyd
      - enable: True

chronyc_sources:
     cmd.run:
        - name: chronyc sources
{% endif %}

{#
#{% if ip == controller01 %}
#
#backup_chrony_conf:
#     cmd.run:
#        - name: |
#            cp /etc/chrony.conf /etc/chrony.conf_bak`date +%Y%m%d`
#            sed -i 's/^server \(.*\)/#server \1/g' /etc/chrony.conf
#            sed -i '/#server 3.centos.pool.ntp.org iburst/a\server time.windows.com iburst' /etc/chrony.conf
#
#chrony_service:
#     service.running:
#        - name: chronyd
#        - enable: True
#
#chronyc_sources:
#     cmd.run:
#        - name: chronyc sources
#
#{% endif %}
#
#{% if ip == controller02 %}
#backup_chrony_conf:
#     cmd.run:
#        - name: |
#           cp /etc/chrony.conf /etc/chrony.conf_bak`date +%Y%m%d`
#           sed -i 's/^server \(.*\)/#server \1/g' /etc/chrony.conf
#           sed -i '/#server 3.centos.pool.ntp.org iburst/a\server {{ controller01}} iburst' /etc/chrony.conf
#
#chrony_service:
#   service.running:
#      - name: chronyd
#      - enable: True
#
#cp_chrony_conf:
#     cmd.run:
#        - name: |
#           scp -p /etc/chrony.conf root@{{ controller03 }}:/etc/chrony.conf
#           scp -p /etc/chrony.conf root@{{ compute01 }}:/etc/chrony.conf
#           scp -p /etc/chrony.conf root@{{ compute02 }}:/etc/chrony.conf
#           chronyc sources
#{% endif %}
#
#{% if ip in [controller03,compute01,compute02] %}
#chrony_service:
#     service.running:
#        - name: chronyd
#        - enable: True
#
#chronyc_sources:
#     cmd.run:
#        - name: chronyc sources
#{% endif %}
#}