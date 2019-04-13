openstack_cluster_info:

  salt_master_path: /srv/salt/openstack-salt/base

  mysql_cluster: True

  rabbitmq_cluster: True

  memcache_cluster: True

  haproxy_cluster: True

  keeplived_cluster: True

  interface: eth0

  cluster_ip:
    ip: 192.168.111.252

  public_network: 192.168.111

  saltstack:
     ip: 192.168.111.66
     underlying_network_if: eth0
     time_zone: Asia/Shanghai
     cluster_master: false

  controller01:
    ip: 192.168.111.67
    underlying_network_if: eth0
    time_zone: Asia/Shanghai
    cluster_master: false

  controller02:
    ip: 192.168.111.68
    underlying_network_if: eth0
    time_zone: Asia/Shanghai
    cluster_master: false

  controller03:
    ip: 192.168.111.69
    underlying_network_if: eth0
    time_zone: Asia/Shanghai
    cluster_master: false

  compute01:
    ip: 192.168.111.70
    underlying_network_if: eth0
    time_zone: Asia/Shanghai
    cluster_master: false

  compute02:
    ip: 192.168.111.71
    underlying_network_if: eth0
    time_zone: Asia/Shanghai
    cluster_master: false

  mariadb_master:
    ip: 192.168.111.67
    underlying_network_if: eth0
    time_zone: Asia/Shanghai
    cluster_master: false
    hostname: controller01

  mariadb_slave_one:
    ip: 192.168.111.68
    underlying_network_if: eth0
    time_zone: Asia/Shanghai
    cluster_master: false
    hostname: controller02

  mariadb_slave_two:
    ip: 192.168.111.69
    underlying_network_if: eth0
    time_zone: Asia/Shanghai
    cluster_master: false
    hostname: controller03

  rabbitmq_passwd:
    rabbit_userid: openstack
    rabbit_password: openstack

  rabbitmq_master:
    ip: 192.168.111.67
    underlying_network_if: eth0
    time_zone: Asia/Shanghai
    cluster_master: false
    hostname: controller01

  rabbitmq_slave_one:
    ip: 192.168.111.68
    underlying_network_if: eth0
    time_zone: Asia/Shanghai
    cluster_master: false
    hostname: controller02

  rabbitmq_slave_two:
    ip: 192.168.111.69
    underlying_network_if: eth0
    time_zone: Asia/Shanghai
    cluster_master: false
    hostname: controller03


  keepalived_master:
    ip: 192.168.111.67
    underlying_network_if: eth0
    time_zone: Asia/Shanghai
    cluster_master: false
    hostname: controller01

  keepalived_slave_one:
    ip: 192.168.111.68
    underlying_network_if: eth0
    time_zone: Asia/Shanghai
    cluster_master: false
    hostname: controller02

  keepalived_slave_two:
    ip: 192.168.111.69
    underlying_network_if: eth0
    time_zone: Asia/Shanghai
    cluster_master: false
    hostname: controller03