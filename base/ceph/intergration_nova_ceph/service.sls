{% set ip = salt['network.interface_ip']('eth0') %}
{% set controller01 = pillar['openstack_cluster_info']['controller01']['ip'] %}

{% if ip == controller01 %}
authorization_
{% endif %}