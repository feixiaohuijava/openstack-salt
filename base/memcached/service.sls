# controller*
include:
  - memcached.install

{% set ip = salt['network.interface_ip']('eth0') %}

memcached_service:
  file.managed:
    - name: /etc/sysconfig/memcached
    - source: salt://memcached/files/memcached
    - template: jinja
    - defaults:
        local_ip: {{ ip }}

  service.running:
    - name: memcached
    - enable: True
