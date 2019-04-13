
{% set rabbitmq_master_ip = pillar['openstack_cluster_info']['rabbitmq_master'] ['ip'] %}
{% set rabbitmq_slave_one_ip = pillar['openstack_cluster_info']['rabbitmq_slave_one'] ['ip'] %}
{% set rabbitmq_slave_two_ip = pillar['openstack_cluster_info']['rabbitmq_slave_two'] ['ip'] %}
{% set ip = salt['network.interface_ip']('eth0') %}

#suspect that if this should be work on?
{% if  pillar['openstack_cluster_info']['rabbitmq_cluster']  == True and  ip in [rabbitmq_master_ip,rabbitmq_slave_one_ip,rabbitmq_slave_two_ip]  %}
reboot_all_node:
   cmd.run:
      - name: reboot
{% endif %}