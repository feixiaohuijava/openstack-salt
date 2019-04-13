include:
    - zabbix-agent.install

{% set hostname = grains['id'] %}
{% set zabbix_server_ip = pillar['zabbix']['zabbix_ip'] %}

start_server_zabbix-agent:
    service.running:
        - name: zabbix-agent
        - enable: True

cp_zabbix_agentd.conf:
    file.managed:
        - name: /etc/zabbix/zabbix_agentd.conf
        - source: salt://zabbix-agent/files/zabbix_agentd.conf
        - mode: 644
        - template: jinja
        - defaults:
             zabbix_server_ip: {{ zabbix_server_ip }}
             agent_hostname: {{ hostname }}


restart_zabbix_agent:
     service.running:
         - name: zabbix-agent
         - reload: True

