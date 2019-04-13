# controller*, compute*
config_dns:
   file.managed:
      - name: /etc/resolv.conf
      - source: salt://dns_hosts_ssh/files/resolv.conf