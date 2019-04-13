# controller01, controller02,controller03
{% set rabbitmq_master_ip = pillar['openstack_cluster_info']['rabbitmq_master'] ['ip'] %}
{% set rabbitmq_master_hostname = pillar['openstack_cluster_info']['rabbitmq_master'] ['hostname'] %}
{% set rabbitmq_slave_one_ip = pillar['openstack_cluster_info']['rabbitmq_slave_one'] ['ip'] %}
{% set rabbitmq_slave_two_ip = pillar['openstack_cluster_info']['rabbitmq_slave_two'] ['ip'] %}
{% set ip = salt['network.interface_ip']('eth0') %}

{% if  pillar['openstack_cluster_info']['rabbitmq_cluster']  == True and  ip ==  rabbitmq_master_ip  %}
cp_erlang_cookie_from_master:
  cmd.run:
     - name: |
         scp /var/lib/rabbitmq/.erlang.cookie root@{{ rabbitmq_slave_one_ip }}:/var/lib/rabbitmq
         scp /var/lib/rabbitmq/.erlang.cookie root@{{ rabbitmq_slave_two_ip }}:/var/lib/rabbitmq

{% endif %}


{% if pillar['openstack_cluster_info']['rabbitmq_cluster']  == True and  ip in [ rabbitmq_slave_one_ip,rabbitmq_slave_two_ip] %}
rabbitmq_cluster_joined:
   cmd.run:
      - name: |
            systemctl restart rabbitmq-server
            rabbitmqctl stop_app
            rabbitmqctl join_cluster --ram rabbit@{{ rabbitmq_master_hostname }}
            rabbitmqctl start_app
            rabbitmqctl cluster_status
{% endif %}