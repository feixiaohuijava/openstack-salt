# *

{% set controller01 = pillar['openstack_cluster_info']['controller01'] ['ip'] %}
{% set controller02 = pillar['openstack_cluster_info']['controller02'] ['ip'] %}
{% set controller03 = pillar['openstack_cluster_info']['controller03'] ['ip'] %}
{% set cluster_ip = pillar['openstack_cluster_info']['cluster_ip'] ['ip'] %}
{% set saltstack = pillar['openstack_cluster_info']['saltstack'] ['ip'] %}
{% set compute01 = pillar['openstack_cluster_info']['compute01'] ['ip'] %}
{% set compute02 = pillar['openstack_cluster_info']['compute02'] ['ip'] %}

{% set ip = salt['network.interface_ip']('eth0') %}
{% if ip == controller01 %}
{% set hostname = 'controller01' %}
{% elif ip == controller02 %}
{% set hostname = 'controller02' %}
{% elif ip == controller03 %}
{% set hostname = 'controller03' %}
{% elif ip == saltstack %}
{% set hostname = 'saltstack' %}
{% elif ip == compute01 %}
{% set hostname = 'compute01' %}
{% elif ip == compute02 %}
{% set hostname = 'compute02' %}
{% endif %}
config_hosts:
   file.managed:
      - name: /etc/hosts
      - source: salt://dns_hosts_ssh/files/hosts
      - template: jinja
      - defaults:
           controller01: {{ controller01 }}
           controller02: {{ controller02 }}
           controller03: {{ controller03 }}
           cluster_ip: {{ cluster_ip }}
           saltstack: {{ saltstack }}
           compute02: {{ compute02 }}
           compute01: {{ compute01 }}



update_hostname:
    cmd.run:
      - name: hostnamectl set-hostname {{ hostname }}

see_hostname:
   cmd.run:
     - name: hostname
