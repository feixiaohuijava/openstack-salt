{% set cluster_ip = pillar['openstack_cluster_info']['cluster_ip']['ip'] %}

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

cp_serviceexist.sh:
     file.managed:
         - name: /etc/zabbix/scripts/serviceexist.sh
         - source: salt://zabbix-agent/files/scripts/serviceexist.sh


chmod_etc_zabbix_scripts:
    cmd.run:
       - name: chmod +x /etc/zabbix/scripts/*

cp_zabbix_openstack_services.conf:
    file.managed:
        - name: /etc/zabbix/zabbix_agentd.d/userparameter_openstack_services.conf
        - source: salt://zabbix-agent/files/zabbix_agentd.d/userparameter_openstack_services.conf

cp_zabbix_services.conf:
    file.managed:
        - name: /etc/zabbix/zabbix_agentd.d/userparameter_services.conf
        - source: salt://zabbix-agent/files/zabbix_agentd.d/userparameter_services.conf

zabbix_in_ceph_group:
    cmd.run:
        - name: usermod -G zabbix,ceph zabbix

restart_zabbix_agent:
     service.running:
         - name: zabbix-agent
         - reload: True