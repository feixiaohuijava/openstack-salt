# compute* ,controller01
{% set ip = salt['network.interface_ip']('eth0') %}

{% set compute01 = pillar['openstack_cluster_info']['compute01']['ip']%}
{% set compute02 = pillar['openstack_cluster_info']['compute02']['ip']%}
{% set cluster_ip = pillar['openstack_cluster_info']['cluster_ip']['ip']%}

{% if ip in [compute01,compute02] %}

include:
  - openstack.neutron-linuxbridge.install

backup_neutron.conf:
   cmd.run:
       - name: cp /etc/neutron/neutron.conf /etc/neutron/neutron.conf_bak$(date +%Y%m%d)


cp_neutron.conf:
   file.managed:
      - name: /etc/neutron/neutron.conf
      - source: salt://openstack/neutron-linuxbridge/files/neutron.conf
      - template: jinja
      - defaults:
          cluster_ip: {{ cluster_ip }}

backup_linuxbridge_agent.ini:
   cmd.run:
       - name: cp /etc/neutron/plugins/ml2/linuxbridge_agent.ini /etc/neutron/plugins/ml2/linuxbridge_agent.ini_bak$(date +%Y%m%d)

cp_linuxbridge_agent.ini:
   file.managed:
       - name: /etc/neutron/plugins/ml2/linuxbridge_agent.ini
       - source: salt://openstack/neutron-linuxbridge/files/linuxbridge_agent.ini

start_service_neutron-linuxbridge-agent:
   service.running:
       - name: neutron-linuxbridge-agent
       - enable: True

{% endif %}

{% if ip == pillar['openstack_cluster_info']['controller01']['ip'] %}
test_neutron-linuxbridge:
   cmd.run:
       - name: |
          source /root/admin-openrc
          neutron agent-list
{% endif %}