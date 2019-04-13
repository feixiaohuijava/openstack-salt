{% set ip = salt['network.interface_ip']('eth0') %}
{% set controller01 = pillar['openstack_cluster_info']['controller01']['ip'] %}
{% set controller02 = pillar['openstack_cluster_info']['controller02']['ip'] %}
{% set controller03 = pillar['openstack_cluster_info']['controller03']['ip'] %}
{% set cluster_ip = pillar['openstack_cluster_info']['cluster_ip']['ip'] %}

{% if ip in [controller01,controller02,controller03] %}
create_folder:
    cmd.run:
       - name: mkdir -p /etc/zabbix/scripts

cp_check-process-status-openstack:
    file.managed:
         - name: /etc/zabbix/scripts/check-process-status-openstack.sh
         - source: salt://zabbix-agent/files/scripts/check-process-status-openstack.sh
         - mode: 644
         - template: jinja
         - defaults:
             cluster_ip: {{ cluster_ip }}

cp_chk_mysql:
    file.managed:
         - name: /etc/zabbix/scripts/chk_mysql.sh
         - source: salt://zabbix-agent/files/scripts/chk_mysql.sh

cp_chk_rabbitmq:
    file.managed:
         - name: /etc/zabbix/scripts/chk_rabbitmq.sh
         - source: salt://zabbix-agent/files/scripts/chk_rabbitmq.sh

cp_serviceexist.sh:
     file.managed:
         - name: /etc/zabbix/scripts/serviceexist.sh
         - source: salt://zabbix-agent/files/scripts/serviceexist.sh

chmod_etc_zabbix_scripts:
    cmd.run:
       - name: chmod +x /etc/zabbix/scripts/*

cp_zabbix_memcached.conf:
    file.managed:
        - name: /etc/zabbix/zabbix_agentd.d/userparameter_memcached.conf
        - source: salt://zabbix-agent/files/zabbix_agentd.d/userparameter_memcached.conf

cp_zabbix_mysql.conf:
    file.managed:
        - name: /etc/zabbix/zabbix_agentd.d/userparameter_mysql.conf
        - source: salt://zabbix-agent/files/zabbix_agentd.d/userparameter_mysql.conf

cp_zabbix_openstack_services.conf:
    file.managed:
        - name: /etc/zabbix/zabbix_agentd.d/userparameter_openstack_services.conf
        - source: salt://zabbix-agent/files/zabbix_agentd.d/userparameter_openstack_services.conf

cp_zabbix_rabbitmq.conf:
    file.managed:
        - name: /etc/zabbix/zabbix_agentd.d/userparameter_rabbitmq.conf
        - source: salt://zabbix-agent/files/zabbix_agentd.d/userparameter_rabbitmq.conf

cp_zabbix_services.conf:
    file.managed:
        - name: /etc/zabbix/zabbix_agentd.d/userparameter_services.conf
        - source: salt://zabbix-agent/files/zabbix_agentd.d/userparameter_services.conf

{% endif %}