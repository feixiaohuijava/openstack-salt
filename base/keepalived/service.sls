# controller*

include:
  - keepalived.install


{% set ip = salt['network.interface_ip']('eth0') %}
{% set cluster_ip = pillar['openstack_cluster_info']['cluster_ip']['ip'] %}
{% set keepalived_master_ip = pillar['openstack_cluster_info']['keepalived_master'] ['ip'] %}
{% set keepalived_slave_one_ip = pillar['openstack_cluster_info']['keepalived_slave_one'] ['ip'] %}
{% set keepalived_slave_two_ip = pillar['openstack_cluster_info']['keepalived_slave_two'] ['ip'] %}
{% set interface = pillar['openstack_cluster_info']['interface'] %}
{% set router_id = 201 %}

{% if  pillar['openstack_cluster_info']['keeplived_cluster']  == True and ip ==  keepalived_master_ip %}
{% set priority = 201 %}
{% set state = 'MASTER' %}
{% set hostname = pillar['openstack_cluster_info']['keepalived_master'] ['hostname'] %}
{% elif  pillar['openstack_cluster_info']['keeplived_cluster']  == True and ip ==  keepalived_slave_one_ip %}
{% set priority = 151 %}
{% set state = 'BACKUP' %}
{% set hostname = pillar['openstack_cluster_info']['keepalived_slave_one'] ['hostname'] %}
{% elif pillar['openstack_cluster_info']['keeplived_cluster']  == True and ip ==  keepalived_slave_two_ip %}
{% set priority = 101 %}
{% set state = 'BACKUP' %}
{% set hostname = pillar['openstack_cluster_info']['keepalived_slave_two'] ['hostname'] %}
{% endif %}


{% if ip in [keepalived_master_ip,keepalived_slave_one_ip,keepalived_slave_two_ip] %}
keepalived_backup_file:
  cmd.run:
     - name: cp /etc/keepalived/keepalived.conf /etc/keepalived/keepalived.conf_bak$(date +%Y%m%d)

cp_keepalived_conf:
  file.managed:
    - name: /etc/keepalived/keepalived.conf
    - source: salt://keepalived/files/keepalived.conf
    - mode: 644
    - template: jinja
    - defaults:
          local_ip: {{ ip }}
          interface: {{ interface }}
          cluster_ip: {{ cluster_ip }}
          priority: {{ priority }}
          hostname: {{ hostname }}
          router_id: {{ router_id }}
          state: {{ state }}

{% endif %}