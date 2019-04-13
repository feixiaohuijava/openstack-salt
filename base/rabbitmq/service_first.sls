# controller*
include:
  - rabbitmq.install

rabbitmq_service:
  service.running:
    - name: rabbitmq-server
    - enable: True

{% set rabbitmq_user = pillar['user_info']['rabbitmq'] ['rabbitmq_user'] %}
{% set rabbitmq_passwd = pillar['user_info']['rabbitmq'] ['rabbitmq_passwd'] %}

{% set rabbitmq_master_ip = pillar['openstack_cluster_info']['rabbitmq_master'] ['ip'] %}
{% set rabbitmq_slave_one_ip = pillar['openstack_cluster_info']['rabbitmq_slave_one'] ['ip'] %}
{% set rabbitmq_slave_two_ip = pillar['openstack_cluster_info']['rabbitmq_slave_two'] ['ip'] %}
{% set ip = salt['network.interface_ip']('eth0') %}


{% if  pillar['openstack_cluster_info']['rabbitmq_cluster']  == True and  ip in [rabbitmq_master_ip,rabbitmq_slave_one_ip,rabbitmq_slave_two_ip]  %}
add_user:
  cmd.run:
     - names:
        - rabbitmqctl add_user {{ rabbitmq_user }}  {{ rabbitmq_passwd }}
        - rabbitmqctl set_permissions {{ rabbitmq_user }} ".*" ".*" ".*"
        - rabbitmqctl set_user_tags {{ rabbitmq_user }} administrator
        - rabbitmqctl list_users

open_rabbitmq_plugin:
  cmd.run:
     - name: |
         export HOME=/root
         rabbitmq-plugins enable rabbitmq_management mochiweb webmachine rabbitmq_web_dispatch amqp_client rabbitmq_management_agent
         rabbitmq-plugins list


reload_rabbitmq_service:
  service.running:
    - name: rabbitmq-server
    - enable: True
    - reload: True
{% endif %}


