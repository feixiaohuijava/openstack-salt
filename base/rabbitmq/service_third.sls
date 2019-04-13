# controller*
{% set rabbitmq_master_ip = pillar['openstack_cluster_info']['rabbitmq_master'] ['ip'] %}
{% set rabbitmq_slave_one_ip = pillar['openstack_cluster_info']['rabbitmq_slave_one'] ['ip'] %}
{% set rabbitmq_slave_two_ip = pillar['openstack_cluster_info']['rabbitmq_slave_two'] ['ip'] %}
{% set ip = salt['network.interface_ip']('eth0') %}

{% if pillar['openstack_cluster_info']['rabbitmq_cluster']  == True and  ip in [ rabbitmq_master_ip,rabbitmq_slave_one_ip,rabbitmq_slave_two_ip] %}
cp_rabbitmq_config:
  file.managed:
      - name: /etc/rabbitmq/rabbitmq.config
      - source: salt://rabbitmq/files/rabbitmq.config
      - mode: 644
#optimization_rabbitmq_config:
#  file.uncomment:
#     - name: /etc/rabbitmq/rabbitmq.config
#     - regex: ^{hipe_compile, true},

#cp_rabbitmq_config_from_master:
#  cmd.run:
#     - name: |
#          scp /etc/rabbitmq/rabbitmq.config root@{{ rabbitmq_slave_one_ip }}:/etc/rabbitmq/rabbitmq.config
#          scp /etc/rabbitmq/rabbitmq.config root@{{ rabbitmq_slave_two_ip }}:/etc/rabbitmq/rabbitmq.config
{% endif %}

