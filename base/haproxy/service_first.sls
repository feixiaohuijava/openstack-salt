# controller*
include:
  - haproxy.install


haproxy_backup_file:
  cmd.run:
     - name: cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg_bak$(date +%Y%m%d)

{% set ip = salt['network.interface_ip']('eth0') %}
{% set cluster_ip = pillar['openstack_cluster_info']['cluster_ip']['ip'] %}

{% set controller01 = pillar['openstack_cluster_info']['controller01']['ip'] %}
{% set controller02 = pillar['openstack_cluster_info']['controller02']['ip'] %}
{% set controller03 = pillar['openstack_cluster_info']['controller03']['ip'] %}

cp_chk_haproxy.sh:
   file.managed:
      - name: /etc/haproxy/chk_haproxy.sh
      - source: salt://haproxy/files/chk_haproxy.sh
      - mode: 644

chmod_chk_haproxy:
   cmd.run:
      - name: chmod +x /etc/haproxy/chk_haproxy.sh

backup_haproxy.cfg:
   cmd.run:
      - name: cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg_bak$(date +%Y%m%d)

cp_haproxy_cfg:
  file.managed:
    - name: /etc/haproxy/haproxy.cfg
    - source: salt://haproxy/files/haproxy.cfg
    - mode: 644
    - template: jinja
    - defaults:
       local_ip: {{ ip }}
       cluster_ip: {{ cluster_ip }}
       controller01: {{ controller01 }}
       controller02: {{ controller02 }}
       controller03: {{ controller03 }}

cp_haproxy.conf:
  file.managed:
    - name: /etc/rsyslog.d/haproxy.conf
    - source: salt://haproxy/files/haproxy.conf

restart_syslog_service:
   cmd.run:
        - name: systemctl restart rsyslog






