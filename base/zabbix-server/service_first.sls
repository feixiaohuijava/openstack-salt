stop_disable_firewalld:
    service.dead:
       - name: firewalld
       - enalbe: False

shutdown_selinux:
    cmd.run:
       - name: sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config

update_hostname:
    cmd.run:
       - name: echo "zabbix-server" > /etc/hostname


include:
    - zabbix-server.install

