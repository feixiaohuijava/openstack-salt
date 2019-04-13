#controller*

{% set ip = salt['network.interface_ip']('eth0') %}
{% set controller01 = pillar['openstack_cluster_info']['controller01']['ip'] %}
{% set controller02 = pillar['openstack_cluster_info']['controller02']['ip'] %}
{% set controller03 = pillar['openstack_cluster_info']['controller03']['ip'] %}



{% if ip in [controller01,controller02,controller03] %}
systemctl_daemon-reload:
   cmd.run:
      - name: systemctl daemon-reload


{% endif %}